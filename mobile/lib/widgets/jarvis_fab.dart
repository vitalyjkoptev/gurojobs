import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/localization.dart';
import '../core/theme.dart';
import '../providers/jarvis_provider.dart';

/// Jarvis Floating Action Button + Chat Panel overlay
class JarvisFab extends StatelessWidget {
  const JarvisFab({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<JarvisProvider>(
      builder: (context, jarvis, _) {
        if (!jarvis.isOpen) return const SizedBox.shrink();
        return Stack(
          children: [
            // Backdrop — tap to close
            Positioned.fill(
              child: GestureDetector(
                onTap: jarvis.closePanel,
                child: Container(color: Colors.black.withValues(alpha: 0.3)),
              ),
            ),
            // Panel
            _JarvisPanel(jarvis: jarvis),
          ],
        );
      },
    );
  }
}

// ─── Jarvis FAB Button ──────────────────────────────────────────
class _JarvisButton extends StatelessWidget {
  final JarvisProvider jarvis;
  const _JarvisButton({required this.jarvis});

  @override
  Widget build(BuildContext context) {
    final isActive = jarvis.isListening || jarvis.isProcessing;

    return GestureDetector(
      onTap: () => jarvis.togglePanel(),
      onLongPress: () {
        if (!jarvis.isOpen) jarvis.openPanel();
        jarvis.startListening();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: isActive
                ? [const Color(0xFF00BCD4), GuroJobsTheme.primary]
                : [GuroJobsTheme.primary, GuroJobsTheme.primaryDark],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: GuroJobsTheme.primary.withValues(alpha: 0.4),
              blurRadius: isActive ? 16 : 8,
              spreadRadius: isActive ? 2 : 0,
            ),
          ],
        ),
        child: Icon(
          jarvis.isOpen ? Icons.close : Icons.mic,
          color: Colors.white,
          size: 24,
        ),
      ),
    );
  }
}

// ─── Jarvis Chat Panel ──────────────────────────────────────────
class _JarvisPanel extends StatefulWidget {
  final JarvisProvider jarvis;
  const _JarvisPanel({required this.jarvis});

  @override
  State<_JarvisPanel> createState() => _JarvisPanelState();
}

class _JarvisPanelState extends State<_JarvisPanel> {
  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _sendText() {
    final text = _textController.text.trim();
    if (text.isEmpty) return;
    widget.jarvis.sendCommand(text);
    _textController.clear();
    _focusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? GuroJobsTheme.jarvisBg : Colors.white;
    final textColor = isDark ? GuroJobsTheme.darkTextPrimary : GuroJobsTheme.textPrimary;

    return Positioned(
      left: 16,
      right: 16,
      bottom: 80 + bottom,
      child: Material(
        borderRadius: BorderRadius.circular(20),
        elevation: 12,
        color: bgColor,
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.55,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: GuroJobsTheme.primary.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              _buildHeader(textColor),
              const Divider(height: 1),
              // Status indicator
              _buildStatus(),
              // Messages
              Flexible(child: _buildMessages(textColor, isDark)),
              // Input
              _buildInput(textColor, isDark),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [GuroJobsTheme.primary, Color(0xFF00BCD4)],
              ),
            ),
            child: const Icon(Icons.smart_toy, color: Colors.white, size: 18),
          ),
          const SizedBox(width: 10),
          Text(
            AppStrings.t('jarvis'),
            style: TextStyle(
              color: textColor,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const Spacer(),
          if (widget.jarvis.messages.isNotEmpty)
            GestureDetector(
              onTap: widget.jarvis.clearMessages,
              child: Icon(Icons.delete_outline, color: textColor.withValues(alpha: 0.5), size: 20),
            ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: widget.jarvis.closePanel,
            child: Icon(Icons.close, color: textColor.withValues(alpha: 0.6), size: 22),
          ),
        ],
      ),
    );
  }

  Widget _buildStatus() {
    final status = widget.jarvis.status;
    if (status == JarvisStatus.idle) return const SizedBox.shrink();

    final config = switch (status) {
      JarvisStatus.listening => (
        icon: Icons.mic,
        text: widget.jarvis.partialText.isEmpty ? AppStrings.t('jarvis_listening') : widget.jarvis.partialText,
        color: const Color(0xFF00BCD4),
      ),
      JarvisStatus.processing => (
        icon: Icons.hourglass_top,
        text: AppStrings.t('jarvis_processing'),
        color: GuroJobsTheme.warning,
      ),
      JarvisStatus.speaking => (
        icon: Icons.volume_up,
        text: AppStrings.t('jarvis_speaking'),
        color: GuroJobsTheme.success,
      ),
      JarvisStatus.error => (
        icon: Icons.error_outline,
        text: AppStrings.t('jarvis_error'),
        color: GuroJobsTheme.error,
      ),
      _ => (icon: Icons.circle, text: '', color: Colors.grey),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          if (status == JarvisStatus.processing)
            SizedBox(
              width: 14,
              height: 14,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: config.color,
              ),
            )
          else
            Icon(config.icon, color: config.color, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              config.text,
              style: TextStyle(color: config.color, fontSize: 13),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (status == JarvisStatus.listening)
            GestureDetector(
              onTap: widget.jarvis.stopListening,
              child: const Icon(Icons.stop_circle, color: Color(0xFF00BCD4), size: 20),
            ),
          if (status == JarvisStatus.speaking)
            GestureDetector(
              onTap: widget.jarvis.stopSpeaking,
              child: const Icon(Icons.stop_circle, color: Color(0xFF4CAF50), size: 20),
            ),
        ],
      ),
    );
  }

  Widget _buildMessages(Color textColor, bool isDark) {
    if (widget.jarvis.messages.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.smart_toy_outlined, size: 48, color: GuroJobsTheme.primary.withValues(alpha: 0.5)),
            const SizedBox(height: 12),
            Text(
              AppStrings.t('jarvis_hello'),
              style: TextStyle(color: textColor, fontSize: 15, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              AppStrings.t('jarvis_hint'),
              style: TextStyle(color: textColor.withValues(alpha: 0.6), fontSize: 13),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      reverse: true,
      shrinkWrap: true,
      itemCount: widget.jarvis.messages.length,
      itemBuilder: (context, index) {
        final msg = widget.jarvis.messages[index];
        return _MessageBubble(message: msg, isDark: isDark);
      },
    );
  }

  Widget _buildInput(Color textColor, bool isDark) {
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 4, 8, 8),
      child: Row(
        children: [
          // Mic button
          GestureDetector(
            onTap: () {
              if (widget.jarvis.isListening) {
                widget.jarvis.stopListening();
              } else {
                widget.jarvis.startListening();
              }
            },
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: widget.jarvis.isListening
                    ? const Color(0xFF00BCD4).withValues(alpha: 0.2)
                    : GuroJobsTheme.primary.withValues(alpha: 0.1),
              ),
              child: Icon(
                widget.jarvis.isListening ? Icons.mic : Icons.mic_none,
                color: widget.jarvis.isListening ? const Color(0xFF00BCD4) : GuroJobsTheme.primary,
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 4),
          // Text input
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: isDark ? GuroJobsTheme.darkInputFill : const Color(0xFFF5F7FA),
                borderRadius: BorderRadius.circular(24),
              ),
              child: TextField(
                controller: _textController,
                focusNode: _focusNode,
                style: TextStyle(color: textColor, fontSize: 14),
                decoration: InputDecoration(
                  hintText: AppStrings.t('jarvis_ask'),
                  hintStyle: TextStyle(color: textColor.withValues(alpha: 0.4)),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                ),
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _sendText(),
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Send button
          GestureDetector(
            onTap: _sendText,
            child: Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [GuroJobsTheme.primary, Color(0xFF00BCD4)],
                ),
              ),
              child: const Icon(Icons.send, color: Colors.white, size: 18),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Message Bubble ─────────────────────────────────────────────
class _MessageBubble extends StatelessWidget {
  final JarvisMessage message;
  final bool isDark;
  const _MessageBubble({required this.message, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final isUser = message.isUser;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        decoration: BoxDecoration(
          color: isUser
              ? GuroJobsTheme.primary
              : (isDark ? const Color(0xFF252540) : const Color(0xFFF0F2F5)),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isUser ? 16 : 4),
            bottomRight: Radius.circular(isUser ? 4 : 16),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.text,
              style: TextStyle(
                color: isUser
                    ? Colors.white
                    : (isDark ? GuroJobsTheme.darkTextPrimary : GuroJobsTheme.textPrimary),
                fontSize: 14,
                height: 1.4,
              ),
            ),
            if (!isUser && !message.success)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Icon(Icons.warning_amber, size: 14, color: GuroJobsTheme.warning),
              ),
          ],
        ),
      ),
    );
  }
}
