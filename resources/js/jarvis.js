/**
 * JARVIS - AI Voice-Controlled Master Agent
 * GURO JOBS iGaming Job Portal
 *
 * Web Speech API (STT) + TTS + AI Command Processing
 */

class Jarvis {
    constructor(options = {}) {
        this.apiUrl = options.apiUrl || '/api/v1/jarvis/command';
        this.csrfToken = document.querySelector('meta[name="csrf-token"]')?.content || '';
        this.authToken = options.authToken || localStorage.getItem('jarvis_token') || '';

        // Speech Recognition
        this.recognition = null;
        this.synthesis = window.speechSynthesis;
        this.isListening = false;
        this.isProcessing = false;
        this.isSpeaking = false;

        // UI Elements
        this.widget = null;
        this.panel = null;
        this.statusEl = null;
        this.historyEl = null;
        this.inputEl = null;
        this.waveformEl = null;
        this.toggleBtn = null;

        // Settings
        this.language = options.language || 'en-US';
        this.voiceName = options.voiceName || null;
        this.wakeWord = options.wakeWord || 'jarvis';
        this.continuousMode = options.continuousMode || false;

        // History
        this.commandHistory = [];

        this.init();
    }

    init() {
        this.initSpeechRecognition();
        this.createWidget();
        this.bindKeyboardShortcut();
        this.loadHistory();
    }

    // ── Speech Recognition Setup ──────────────────────────────
    initSpeechRecognition() {
        const SpeechRecognition = window.SpeechRecognition || window.webkitSpeechRecognition;
        if (!SpeechRecognition) {
            console.warn('Jarvis: Speech Recognition not supported in this browser.');
            return;
        }

        this.recognition = new SpeechRecognition();
        this.recognition.continuous = this.continuousMode;
        this.recognition.interimResults = true;
        this.recognition.lang = this.language;

        this.recognition.onstart = () => {
            this.isListening = true;
            this.setStatus('listening');
            this.showWaveform(true);
        };

        this.recognition.onresult = (event) => {
            let transcript = '';
            let isFinal = false;

            for (let i = event.resultIndex; i < event.results.length; i++) {
                transcript += event.results[i][0].transcript;
                if (event.results[i].isFinal) isFinal = true;
            }

            // Show interim results
            if (this.inputEl) {
                this.inputEl.value = transcript;
            }

            if (isFinal) {
                this.handleCommand(transcript.trim());
            }
        };

        this.recognition.onerror = (event) => {
            console.error('Jarvis STT Error:', event.error);
            this.isListening = false;
            this.setStatus('error');
            this.showWaveform(false);

            if (event.error === 'not-allowed') {
                this.addToHistory('system', 'Microphone access denied. Please allow microphone access.');
            }
        };

        this.recognition.onend = () => {
            this.isListening = false;
            if (!this.isProcessing) {
                this.setStatus('idle');
            }
            this.showWaveform(false);
        };
    }

    // ── Widget UI ─────────────────────────────────────────────
    createWidget() {
        // Main toggle button
        this.toggleBtn = document.createElement('button');
        this.toggleBtn.id = 'jarvis-toggle';
        this.toggleBtn.innerHTML = `
            <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <path d="M12 1a3 3 0 0 0-3 3v8a3 3 0 0 0 6 0V4a3 3 0 0 0-3-3z"/>
                <path d="M19 10v2a7 7 0 0 1-14 0v-2"/>
                <line x1="12" y1="19" x2="12" y2="23"/>
                <line x1="8" y1="23" x2="16" y2="23"/>
            </svg>
        `;
        this.toggleBtn.style.cssText = `
            position: fixed; bottom: 24px; right: 24px; z-index: 10000;
            width: 56px; height: 56px; border-radius: 50%;
            background: #015EA7; color: white; border: none;
            cursor: pointer; display: flex; align-items: center; justify-content: center;
            box-shadow: 0 4px 16px rgba(1,94,167,0.4);
            transition: all 0.3s ease;
        `;
        this.toggleBtn.addEventListener('click', () => this.togglePanel());

        // Panel
        this.panel = document.createElement('div');
        this.panel.id = 'jarvis-panel';
        this.panel.style.cssText = `
            position: fixed; bottom: 90px; right: 24px; z-index: 9999;
            width: 380px; max-height: 500px; border-radius: 16px;
            background: #1a1a2e; color: #e0e0e0;
            box-shadow: 0 8px 32px rgba(0,0,0,0.3);
            display: none; flex-direction: column; overflow: hidden;
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
            border: 1px solid rgba(1,94,167,0.3);
        `;

        this.panel.innerHTML = `
            <div style="padding: 16px 20px; background: linear-gradient(135deg, #015EA7, #0277BD); display: flex; align-items: center; justify-content: space-between;">
                <div style="display: flex; align-items: center; gap: 10px;">
                    <div id="jarvis-status-dot" style="width: 10px; height: 10px; border-radius: 50%; background: #4CAF50;"></div>
                    <span style="font-weight: 600; font-size: 16px; color: white;">JARVIS</span>
                    <span id="jarvis-status-text" style="font-size: 12px; color: rgba(255,255,255,0.7);">Ready</span>
                </div>
                <button id="jarvis-close" style="background: none; border: none; color: white; cursor: pointer; font-size: 18px;">&times;</button>
            </div>

            <div id="jarvis-waveform" style="height: 40px; background: #16213e; display: none; align-items: center; justify-content: center; gap: 3px; padding: 0 20px;">
                ${Array(20).fill('<div class="jarvis-wave-bar" style="width: 3px; height: 4px; background: #015EA7; border-radius: 2px; transition: height 0.1s;"></div>').join('')}
            </div>

            <div id="jarvis-history" style="flex: 1; overflow-y: auto; padding: 16px 20px; max-height: 300px; display: flex; flex-direction: column; gap: 12px;">
                <div style="text-align: center; color: rgba(255,255,255,0.4); font-size: 13px; padding: 20px 0;">
                    Say "Jarvis" or click the mic to start.<br>
                    Try: "Show today's stats"
                </div>
            </div>

            <div style="padding: 12px 16px; border-top: 1px solid rgba(255,255,255,0.1); display: flex; gap: 8px;">
                <input id="jarvis-input" type="text" placeholder="Type a command..."
                    style="flex: 1; background: #16213e; border: 1px solid rgba(255,255,255,0.15); border-radius: 8px; padding: 10px 14px; color: white; font-size: 14px; outline: none;"
                />
                <button id="jarvis-mic-btn" style="background: #015EA7; border: none; border-radius: 8px; padding: 10px 14px; color: white; cursor: pointer; display: flex; align-items: center;">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <path d="M12 1a3 3 0 0 0-3 3v8a3 3 0 0 0 6 0V4a3 3 0 0 0-3-3z"/>
                        <path d="M19 10v2a7 7 0 0 1-14 0v-2"/>
                    </svg>
                </button>
                <button id="jarvis-send-btn" style="background: #015EA7; border: none; border-radius: 8px; padding: 10px 14px; color: white; cursor: pointer;">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <line x1="22" y1="2" x2="11" y2="13"/><polygon points="22 2 15 22 11 13 2 9 22 2"/>
                    </svg>
                </button>
            </div>
        `;

        document.body.appendChild(this.toggleBtn);
        document.body.appendChild(this.panel);

        // Bind events
        this.statusEl = this.panel.querySelector('#jarvis-status-text');
        this.historyEl = this.panel.querySelector('#jarvis-history');
        this.inputEl = this.panel.querySelector('#jarvis-input');
        this.waveformEl = this.panel.querySelector('#jarvis-waveform');

        this.panel.querySelector('#jarvis-close').addEventListener('click', () => this.togglePanel());
        this.panel.querySelector('#jarvis-mic-btn').addEventListener('click', () => this.toggleListening());
        this.panel.querySelector('#jarvis-send-btn').addEventListener('click', () => this.sendTextCommand());
        this.inputEl.addEventListener('keydown', (e) => {
            if (e.key === 'Enter') this.sendTextCommand();
        });

        // Waveform animation
        this.waveBars = this.panel.querySelectorAll('.jarvis-wave-bar');
        this.animateWaveform();
    }

    togglePanel() {
        const isVisible = this.panel.style.display !== 'none';
        this.panel.style.display = isVisible ? 'none' : 'flex';
        this.toggleBtn.style.background = isVisible ? '#015EA7' : '#0277BD';
    }

    toggleListening() {
        if (this.isListening) {
            this.recognition?.stop();
        } else {
            this.startListening();
        }
    }

    startListening() {
        if (!this.recognition) {
            this.addToHistory('system', 'Voice recognition not available. Use text input instead.');
            return;
        }
        try {
            this.recognition.start();
        } catch (e) {
            console.error('Jarvis: Could not start recognition', e);
        }
    }

    // ── Command Processing ────────────────────────────────────
    async handleCommand(text) {
        if (!text) return;

        this.addToHistory('user', text);
        this.setStatus('processing');
        this.isProcessing = true;

        try {
            const response = await fetch(this.apiUrl, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'X-CSRF-TOKEN': this.csrfToken,
                    'Authorization': `Bearer ${this.authToken}`,
                    'Accept': 'application/json',
                },
                body: JSON.stringify({
                    command: text,
                    type: this.isListening ? 'voice' : 'text',
                }),
            });

            const data = await response.json();

            this.addToHistory('jarvis', data.response || 'Command processed.');

            // Handle navigation redirect
            if (data.data?.redirect) {
                this.addToHistory('system', `Navigating to ${data.data.redirect}...`);
                setTimeout(() => {
                    window.location.href = data.data.redirect;
                }, 1500);
            }

            // Speak response
            if (data.response) {
                this.speak(data.response);
            }
        } catch (error) {
            console.error('Jarvis API Error:', error);
            this.addToHistory('jarvis', 'Sorry, I encountered an error. Please try again.');
        }

        this.isProcessing = false;
        this.setStatus('idle');
    }

    sendTextCommand() {
        const text = this.inputEl.value.trim();
        if (text) {
            this.inputEl.value = '';
            this.handleCommand(text);
        }
    }

    // ── Text-to-Speech ────────────────────────────────────────
    speak(text) {
        if (!this.synthesis) return;

        this.synthesis.cancel();

        const utterance = new SpeechSynthesisUtterance(text);
        utterance.rate = 1.0;
        utterance.pitch = 1.0;
        utterance.volume = 0.8;
        utterance.lang = this.language;

        // Select voice
        const voices = this.synthesis.getVoices();
        if (this.voiceName) {
            const voice = voices.find(v => v.name.includes(this.voiceName));
            if (voice) utterance.voice = voice;
        } else {
            const preferred = voices.find(v => v.lang.startsWith('en') && v.name.includes('Google'));
            if (preferred) utterance.voice = preferred;
        }

        utterance.onstart = () => {
            this.isSpeaking = true;
            this.setStatus('speaking');
        };

        utterance.onend = () => {
            this.isSpeaking = false;
            this.setStatus('idle');
        };

        this.synthesis.speak(utterance);
    }

    // ── UI Helpers ────────────────────────────────────────────
    setStatus(status) {
        const dot = this.panel.querySelector('#jarvis-status-dot');
        const statusMap = {
            idle: { color: '#4CAF50', text: 'Ready' },
            listening: { color: '#FF5722', text: 'Listening...' },
            processing: { color: '#FFC107', text: 'Processing...' },
            speaking: { color: '#2196F3', text: 'Speaking...' },
            error: { color: '#f44336', text: 'Error' },
        };

        const s = statusMap[status] || statusMap.idle;
        if (dot) dot.style.background = s.color;
        if (this.statusEl) this.statusEl.textContent = s.text;

        // Animate toggle button
        if (status === 'listening') {
            this.toggleBtn.style.background = '#FF5722';
            this.toggleBtn.style.animation = 'jarvis-pulse 1.5s infinite';
        } else {
            this.toggleBtn.style.background = '#015EA7';
            this.toggleBtn.style.animation = 'none';
        }
    }

    addToHistory(type, text) {
        const isFirst = this.historyEl.querySelector('div[style*="text-align: center"]');
        if (isFirst) isFirst.remove();

        const msg = document.createElement('div');
        const styles = {
            user: 'background: rgba(1,94,167,0.2); border-radius: 12px 12px 4px 12px; padding: 10px 14px; align-self: flex-end; max-width: 85%;',
            jarvis: 'background: rgba(255,255,255,0.08); border-radius: 12px 12px 12px 4px; padding: 10px 14px; align-self: flex-start; max-width: 85%;',
            system: 'background: rgba(255,193,7,0.1); border-radius: 8px; padding: 8px 12px; font-size: 12px; color: #FFC107; text-align: center;',
        };

        msg.style.cssText = styles[type] || styles.system;
        msg.style.fontSize = '14px';
        msg.style.lineHeight = '1.4';

        if (type === 'user') {
            msg.innerHTML = `<span style="color: rgba(255,255,255,0.5); font-size: 11px;">You</span><br>${this.escapeHtml(text)}`;
        } else if (type === 'jarvis') {
            msg.innerHTML = `<span style="color: #015EA7; font-size: 11px; font-weight: 600;">JARVIS</span><br>${this.escapeHtml(text)}`;
        } else {
            msg.textContent = text;
        }

        this.historyEl.appendChild(msg);
        this.historyEl.scrollTop = this.historyEl.scrollHeight;

        this.commandHistory.push({ type, text, timestamp: Date.now() });
    }

    showWaveform(show) {
        if (this.waveformEl) {
            this.waveformEl.style.display = show ? 'flex' : 'none';
        }
    }

    animateWaveform() {
        const animate = () => {
            if (this.isListening && this.waveBars) {
                this.waveBars.forEach(bar => {
                    const height = Math.random() * 30 + 4;
                    bar.style.height = height + 'px';
                });
            }
            requestAnimationFrame(animate);
        };
        animate();
    }

    bindKeyboardShortcut() {
        document.addEventListener('keydown', (e) => {
            // Ctrl+J or Cmd+J to toggle Jarvis
            if ((e.ctrlKey || e.metaKey) && e.key === 'j') {
                e.preventDefault();
                this.togglePanel();
            }
            // Ctrl+Shift+J to start/stop listening
            if ((e.ctrlKey || e.metaKey) && e.shiftKey && e.key === 'J') {
                e.preventDefault();
                this.toggleListening();
            }
        });
    }

    loadHistory() {
        // Could load from API
    }

    escapeHtml(text) {
        const div = document.createElement('div');
        div.textContent = text;
        return div.innerHTML;
    }

    // ── Public API ────────────────────────────────────────────
    destroy() {
        this.recognition?.stop();
        this.synthesis?.cancel();
        this.toggleBtn?.remove();
        this.panel?.remove();
    }
}

// Auto-init with CSS animation
const style = document.createElement('style');
style.textContent = `
    @keyframes jarvis-pulse {
        0% { box-shadow: 0 0 0 0 rgba(255,87,34,0.7); }
        70% { box-shadow: 0 0 0 12px rgba(255,87,34,0); }
        100% { box-shadow: 0 0 0 0 rgba(255,87,34,0); }
    }
    #jarvis-panel::-webkit-scrollbar { width: 4px; }
    #jarvis-panel::-webkit-scrollbar-track { background: transparent; }
    #jarvis-panel::-webkit-scrollbar-thumb { background: rgba(255,255,255,0.2); border-radius: 2px; }
    #jarvis-input:focus { border-color: #015EA7 !important; }
`;
document.head.appendChild(style);

// Export
window.Jarvis = Jarvis;
