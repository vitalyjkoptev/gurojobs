import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme.dart';
import '../../../core/localization.dart';
import '../../../providers/lang_provider.dart';
import 'chat_screen.dart';

// ═══════════════════════════════════════════════════════════════
// MESSAGE MODEL
// ═══════════════════════════════════════════════════════════════
class ChatMessage {
  final String id;
  final String body;
  final String channel;
  final String time;
  final bool isMe;
  final String status; // sent, delivered, read

  const ChatMessage({required this.id, required this.body, required this.channel, required this.time, required this.isMe, this.status = 'read'});
}

// Demo messages per conversation
Map<String, List<ChatMessage>> _demoMessages = {
  '1': [
    const ChatMessage(id: 'm1', body: 'Hello! I saw your profile on GURO JOBS and I\'m interested in your experience with live casino solutions.', channel: 'telegram', time: '10:30', isMe: false),
    const ChatMessage(id: 'm2', body: 'Hi! Thank you for reaching out. Yes, I have 3+ years of experience with live dealer platforms.', channel: 'telegram', time: '10:33', isMe: true, status: 'read'),
    const ChatMessage(id: 'm3', body: 'We reviewed your CV and would like to schedule an interview. Are you available this week?', channel: 'telegram', time: '10:40', isMe: false),
    const ChatMessage(id: 'm4', body: 'We reviewed your CV and would like to schedule an interview', channel: 'telegram', time: '10:42', isMe: false),
  ],
  '2': [
    const ChatMessage(id: 'm1', body: 'Good morning! We have an exciting opportunity for a Product Manager role.', channel: 'whatsapp', time: '08:50', isMe: false),
    const ChatMessage(id: 'm2', body: 'Sounds interesting! Can you share more details about the role?', channel: 'whatsapp', time: '08:55', isMe: true, status: 'read'),
    const ChatMessage(id: 'm3', body: 'Of course! It\'s a remote position with competitive salary. Let me send you the job description.', channel: 'whatsapp', time: '09:00', isMe: false),
    const ChatMessage(id: 'm4', body: 'Hi! Are you still interested in the Product Manager position?', channel: 'whatsapp', time: '09:15', isMe: false),
  ],
  '3': [
    const ChatMessage(id: 'm1', body: 'Dear Candidate, we have found 5 new job matches for your profile.', channel: 'email', time: 'Mar 10', isMe: false),
    const ChatMessage(id: 'm2', body: 'Thank you! I\'ll review them today.', channel: 'email', time: 'Mar 10', isMe: true, status: 'delivered'),
    const ChatMessage(id: 'm3', body: 'New job matches for your profile are available', channel: 'email', time: 'Yesterday', isMe: false),
  ],
  '4': [
    const ChatMessage(id: 'm1', body: 'Thank you for applying to the Compliance Officer position at LeoVegas.', channel: 'portal', time: 'Mar 9', isMe: false),
    const ChatMessage(id: 'm2', body: 'Your application is currently under review by our hiring team.', channel: 'portal', time: 'Mar 10', isMe: false),
    const ChatMessage(id: 'm3', body: 'Your application status has been updated', channel: 'portal', time: 'Yesterday', isMe: false),
  ],
  '5': [
    const ChatMessage(id: 'm1', body: 'Welcome to GURO JOBS! We\'re here to help you find your dream iGaming career.', channel: 'portal', time: 'Mar 8', isMe: false),
    const ChatMessage(id: 'm2', body: 'You can connect your messengers in Settings > Connections to receive job alerts.', channel: 'portal', time: 'Mar 8', isMe: false),
    const ChatMessage(id: 'm3', body: 'Thank you! I just connected my Telegram.', channel: 'portal', time: 'Mar 9', isMe: true, status: 'read'),
    const ChatMessage(id: 'm4', body: 'Welcome to GURO JOBS! How can we help you today?', channel: 'portal', time: 'Mar 10', isMe: false),
  ],
};

// ═══════════════════════════════════════════════════════════════
// CHAT DETAIL SCREEN
// ═══════════════════════════════════════════════════════════════
class ChatDetailScreen extends StatefulWidget {
  final ChatConversation conversation;
  const ChatDetailScreen({super.key, required this.conversation});

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final _msgController = TextEditingController();
  final _scrollController = ScrollController();
  late List<ChatMessage> _messages;
  String _replyChannel = '';

  @override
  void initState() {
    super.initState();
    _messages = List<ChatMessage>.from(_demoMessages[widget.conversation.id] ?? []);
    _replyChannel = widget.conversation.channel;
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  @override
  void dispose() { _msgController.dispose(); _scrollController.dispose(); super.dispose(); }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(_scrollController.position.maxScrollExtent, duration: const Duration(milliseconds: 200), curve: Curves.easeOut);
    }
  }

  void _sendMessage() {
    final text = _msgController.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add(ChatMessage(
        id: 'new_${_messages.length}',
        body: text,
        channel: _replyChannel,
        time: 'Now',
        isMe: true,
        status: 'sent',
      ));
    });
    _msgController.clear();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  @override
  Widget build(BuildContext context) {
    context.watch<LangProvider>();

    final ch = chatChannels.firstWhere((c) => c.id == widget.conversation.channel, orElse: () => chatChannels[4]);

    Color roleColor() {
      switch (widget.conversation.role) {
        case 'agency': return GuroJobsTheme.accent;
        case 'support': return GuroJobsTheme.info;
        default: return GuroJobsTheme.primary;
      }
    }

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
          children: [
            // Avatar
            SizedBox(
              width: 40, height: 40,
              child: Stack(
                children: [
                  Container(
                    width: 38, height: 38,
                    decoration: BoxDecoration(color: roleColor().withOpacity(0.15), borderRadius: BorderRadius.circular(12)),
                    child: Center(child: Text(widget.conversation.avatar, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: roleColor()))),
                  ),
                  Positioned(
                    right: 0, bottom: 0,
                    child: Container(
                      width: 16, height: 16,
                      decoration: BoxDecoration(color: ch.color, borderRadius: BorderRadius.circular(5), border: Border.all(color: context.isDark ? GuroJobsTheme.darkBackground : Colors.white, width: 1.5)),
                      child: Icon(ch.icon, size: 8, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.conversation.name, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: context.textPrimaryC), maxLines: 1, overflow: TextOverflow.ellipsis),
                  Row(
                    children: [
                      Container(
                        width: 7, height: 7,
                        decoration: BoxDecoration(shape: BoxShape.circle, color: widget.conversation.isOnline ? GuroJobsTheme.success : context.textHintC),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        widget.conversation.isOnline ? AppStrings.t('online') : AppStrings.t('offline'),
                        style: TextStyle(fontSize: 11, color: widget.conversation.isOnline ? GuroJobsTheme.success : context.textHintC),
                      ),
                      Text('  ·  ${AppStrings.t('via')} ${ch.name}', style: TextStyle(fontSize: 11, color: context.textHintC)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(icon: Icon(Icons.more_vert, color: context.textSecondaryC), onPressed: () {}),
        ],
      ),

      body: Column(
        children: [
          // Messages
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                final prevMsg = index > 0 ? _messages[index - 1] : null;
                final showChannelSwitch = prevMsg != null && prevMsg.channel != msg.channel;

                return Column(
                  children: [
                    if (showChannelSwitch) _channelDivider(msg.channel),
                    _MessageBubble(message: msg),
                  ],
                );
              },
            ),
          ),

          // Channel selector + input
          Container(
            decoration: BoxDecoration(
              color: context.cardBg,
              boxShadow: [BoxShadow(color: context.shadowMedium, blurRadius: 8, offset: const Offset(0, -2))],
            ),
            child: SafeArea(
              top: false,
              child: Column(
                children: [
                  // Reply channel selector
                  Container(
                    height: 38,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: chatChannels.where((c) {
                        // Show channels that appeared in this conversation
                        final msgChannels = _messages.map((m) => m.channel).toSet();
                        return msgChannels.contains(c.id) || c.id == widget.conversation.channel;
                      }).map((c) {
                        final isActive = _replyChannel == c.id;
                        return GestureDetector(
                          onTap: () => setState(() => _replyChannel = c.id),
                          child: Container(
                            margin: const EdgeInsets.only(right: 6, top: 6, bottom: 4),
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              color: isActive ? c.color : c.color.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(c.icon, size: 12, color: isActive ? Colors.white : c.color),
                                const SizedBox(width: 4),
                                Text(c.name, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: isActive ? Colors.white : c.color)),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  // Input row
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 2, 10, 8),
                    child: Row(
                      children: [
                        // Attachment
                        GestureDetector(
                          onTap: () => _showAttachMenu(),
                          child: Container(
                            width: 40, height: 40,
                            decoration: BoxDecoration(color: context.surfaceBg, borderRadius: BorderRadius.circular(12)),
                            child: Icon(Icons.add, color: context.textSecondaryC, size: 22),
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Text field
                        Expanded(
                          child: Container(
                            constraints: const BoxConstraints(minHeight: 40, maxHeight: 100),
                            decoration: BoxDecoration(
                              color: context.surfaceBg,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: TextField(
                              controller: _msgController,
                              maxLines: null,
                              textInputAction: TextInputAction.newline,
                              decoration: InputDecoration(
                                hintText: AppStrings.t('type_message'),
                                hintStyle: TextStyle(color: context.textHintC, fontSize: 14),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Send button
                        GestureDetector(
                          onTap: _sendMessage,
                          child: Container(
                            width: 42, height: 42,
                            decoration: BoxDecoration(
                              color: GuroJobsTheme.primary,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Icon(Icons.send, color: Colors.white, size: 20),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _channelDivider(String channelId) {
    final ch = chatChannels.firstWhere((c) => c.id == channelId, orElse: () => chatChannels[4]);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Expanded(child: Divider(color: context.dividerC, height: 1)),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            decoration: BoxDecoration(color: ch.color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(ch.icon, size: 12, color: ch.color),
                const SizedBox(width: 5),
                Text('${AppStrings.t('via')} ${ch.name}', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: ch.color)),
              ],
            ),
          ),
          Expanded(child: Divider(color: context.dividerC, height: 1)),
        ],
      ),
    );
  }

  void _showAttachMenu() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 40, height: 4, decoration: BoxDecoration(color: context.dividerC, borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 20),
            Text(AppStrings.t('attachment'), style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: context.textPrimaryC)),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _AttachOption(icon: Icons.photo, label: AppStrings.t('photo'), color: GuroJobsTheme.primary, onTap: () => Navigator.pop(ctx)),
                _AttachOption(icon: Icons.insert_drive_file, label: AppStrings.t('document'), color: GuroJobsTheme.accent, onTap: () => Navigator.pop(ctx)),
                _AttachOption(icon: Icons.description_outlined, label: 'CV', color: GuroJobsTheme.success, onTap: () => Navigator.pop(ctx)),
              ],
            ),
            const SizedBox(height: 16),
            TextButton(onPressed: () => Navigator.pop(ctx), child: Text(AppStrings.t('cancel'), style: TextStyle(color: context.textSecondaryC))),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// MESSAGE BUBBLE
// ═══════════════════════════════════════════════════════════════
class _MessageBubble extends StatelessWidget {
  final ChatMessage message;
  const _MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final ch = chatChannels.firstWhere((c) => c.id == message.channel, orElse: () => chatChannels[4]);

    return Align(
      alignment: message.isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.78),
        margin: const EdgeInsets.only(bottom: 6),
        padding: const EdgeInsets.fromLTRB(14, 10, 14, 6),
        decoration: BoxDecoration(
          color: message.isMe
              ? GuroJobsTheme.primary.withOpacity(context.isDark ? 0.25 : 0.12)
              : context.cardBg,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(message.isMe ? 16 : 4),
            bottomRight: Radius.circular(message.isMe ? 4 : 16),
          ),
          border: message.isMe ? null : Border.all(color: context.dividerC, width: 0.5),
        ),
        child: Column(
          crossAxisAlignment: message.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(message.body, style: TextStyle(fontSize: 14, color: context.textPrimaryC, height: 1.4)),
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Channel badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                  decoration: BoxDecoration(color: ch.color.withOpacity(0.15), borderRadius: BorderRadius.circular(5)),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(ch.icon, size: 8, color: ch.color),
                      const SizedBox(width: 3),
                      Text(ch.name, style: TextStyle(fontSize: 8, fontWeight: FontWeight.w600, color: ch.color)),
                    ],
                  ),
                ),
                const SizedBox(width: 6),
                Text(message.time, style: TextStyle(fontSize: 10, color: context.textHintC)),
                if (message.isMe) ...[
                  const SizedBox(width: 4),
                  Icon(
                    message.status == 'read' ? Icons.done_all : (message.status == 'delivered' ? Icons.done_all : Icons.done),
                    size: 14,
                    color: message.status == 'read' ? GuroJobsTheme.primary : context.textHintC,
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// ATTACH OPTION
// ═══════════════════════════════════════════════════════════════
class _AttachOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _AttachOption({required this.icon, required this.label, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 56, height: 56,
            decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(16)),
            child: Icon(icon, color: color, size: 26),
          ),
          const SizedBox(height: 8),
          Text(label, style: TextStyle(fontSize: 12, color: context.textSecondaryC)),
        ],
      ),
    );
  }
}
