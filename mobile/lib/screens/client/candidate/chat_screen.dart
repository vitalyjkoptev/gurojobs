import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme.dart';
import '../../../core/localization.dart';
import '../../../providers/lang_provider.dart';
import '../../../services/api_service.dart';
import 'chat_detail_screen.dart';
import 'billing_screen.dart';

// ═══════════════════════════════════════════════════════════════
// CHANNEL DATA
// ═══════════════════════════════════════════════════════════════
class ChatChannel {
  final String id;
  final String name;
  final IconData icon;
  final Color color;
  const ChatChannel(this.id, this.name, this.icon, this.color);
}

final List<ChatChannel> chatChannels = [
  const ChatChannel('telegram', 'Telegram', Icons.send, Color(0xFF0088CC)),
  const ChatChannel('whatsapp', 'WhatsApp', Icons.chat_bubble, Color(0xFF25D366)),
  const ChatChannel('email', 'Email', Icons.email, Color(0xFF6C757D)),
  const ChatChannel('viber', 'Viber', Icons.phone_in_talk, Color(0xFF7360F2)),
  const ChatChannel('signal', 'Signal', Icons.security, Color(0xFF3A76F0)),
  const ChatChannel('facebook', 'Facebook', Icons.facebook, Color(0xFF1877F2)),
  const ChatChannel('instagram', 'Instagram', Icons.camera_alt, Color(0xFFE4405F)),
  const ChatChannel('discord', 'Discord', Icons.headphones, Color(0xFF5865F2)),
  const ChatChannel('skype', 'Skype', Icons.video_call, Color(0xFF00AFF0)),
  const ChatChannel('slack', 'Slack', Icons.tag, Color(0xFF4A154B)),
  const ChatChannel('wechat', 'WeChat', Icons.message, Color(0xFF07C160)),
  const ChatChannel('line', 'Line', Icons.chat, Color(0xFF00B900)),
];

ChatChannel chatChannelById(String id) => chatChannels.firstWhere((c) => c.id == id, orElse: () => chatChannels[4]);

// ═══════════════════════════════════════════════════════════════
// DEMO CONVERSATIONS
// ═══════════════════════════════════════════════════════════════
class ChatConversation {
  final String id;
  final String name;
  final String avatar;
  final String channel;
  final String lastMessage;
  final String time;
  final int unread;
  final bool isOnline;
  final String role; // employer, agency, support

  const ChatConversation({
    required this.id,
    required this.name,
    required this.avatar,
    required this.channel,
    required this.lastMessage,
    required this.time,
    this.unread = 0,
    this.isOnline = false,
    this.role = 'employer',
  });
}

final List<ChatConversation> _demoConversations = [
  ChatConversation(
    id: '1', name: 'Evolution Gaming HR', avatar: 'E', channel: 'telegram',
    lastMessage: 'We reviewed your CV and would like to schedule an interview',
    time: '10:42', unread: 2, isOnline: true, role: 'employer',
  ),
  ChatConversation(
    id: '2', name: 'Betsson Recruitment', avatar: 'B', channel: 'whatsapp',
    lastMessage: 'Hi! Are you still interested in the Product Manager position?',
    time: '09:15', unread: 1, isOnline: true, role: 'employer',
  ),
  ChatConversation(
    id: '3', name: 'iGaming Talents Agency', avatar: 'i', channel: 'email',
    lastMessage: 'New job matches for your profile are available',
    time: 'Yesterday', unread: 3, isOnline: false, role: 'agency',
  ),
  ChatConversation(
    id: '4', name: 'LeoVegas Team', avatar: 'L', channel: 'email',
    lastMessage: 'Your application status has been updated',
    time: 'Yesterday', unread: 0, isOnline: false, role: 'employer',
  ),
  ChatConversation(
    id: '5', name: 'GURO JOBS Support', avatar: 'G', channel: 'email',
    lastMessage: 'Welcome to GURO JOBS! How can we help you today?',
    time: 'Mar 10', unread: 0, isOnline: true, role: 'support',
  ),
  ChatConversation(
    id: '6', name: 'Pragmatic Play HR', avatar: 'P', channel: 'telegram',
    lastMessage: 'Thanks for your interest! Please send your portfolio',
    time: 'Mar 9', unread: 0, isOnline: false, role: 'employer',
  ),
  ChatConversation(
    id: '7', name: 'Pinnacle Careers', avatar: 'P', channel: 'facebook',
    lastMessage: 'We have new openings in Marketing. Check them out!',
    time: 'Mar 8', unread: 0, isOnline: false, role: 'employer',
  ),
  ChatConversation(
    id: '8', name: 'CasinoHR Agency', avatar: 'C', channel: 'viber',
    lastMessage: 'Salary range for this position is €50-65K',
    time: 'Mar 7', unread: 0, isOnline: false, role: 'agency',
  ),
];

// ═══════════════════════════════════════════════════════════════
// CHAT LIST SCREEN
// ═══════════════════════════════════════════════════════════════
class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String _selectedChannel = 'all';
  final _searchController = TextEditingController();
  String _searchQuery = '';
  bool _hasPaidPlan = true; // default true, will check API

  @override
  void initState() {
    super.initState();
    _checkPaywall();
  }

  Future<void> _checkPaywall() async {
    try {
      final res = await ApiService.getPaywallStatus();
      if (res['success'] == true && mounted) {
        setState(() => _hasPaidPlan = res['data']?['can_send_messages'] ?? false);
      }
    } catch (_) {}
  }

  // User-selected messengers (Telegram is always default)
  final Set<String> _activeChannelIds = {'telegram'};

  /// Channels visible in the top bar: only user-selected ones
  List<ChatChannel> get _visibleChannels =>
      chatChannels.where((ch) => _activeChannelIds.contains(ch.id)).toList();

  List<ChatConversation> get _filteredConversations {
    var list = _demoConversations;
    if (_selectedChannel != 'all') {
      list = list.where((c) => c.channel == _selectedChannel).toList();
    }
    if (_searchQuery.isNotEmpty) {
      list = list.where((c) => c.name.toLowerCase().contains(_searchQuery.toLowerCase()) || c.lastMessage.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
    }
    return list;
  }

  int get _totalUnread => _demoConversations.fold(0, (sum, c) => sum + c.unread);

  void _showAddMessenger() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        decoration: BoxDecoration(
          color: context.cardBg,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: context.dividerC, borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 14),
            Text(AppStrings.t('add_messenger'), style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: context.textPrimaryC)),
            const SizedBox(height: 14),
            // Horizontal scrollable list of all messengers
            SizedBox(
              height: 80,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: chatChannels.map((ch) {
                  final isActive = _activeChannelIds.contains(ch.id);
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (isActive && ch.id != 'telegram') {
                          _activeChannelIds.remove(ch.id);
                          if (_selectedChannel == ch.id) _selectedChannel = 'all';
                        } else {
                          _activeChannelIds.add(ch.id);
                        }
                      });
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: 70,
                      margin: const EdgeInsets.only(right: 10),
                      child: Column(
                        children: [
                          Container(
                            width: 48, height: 48,
                            decoration: BoxDecoration(
                              color: isActive ? ch.color : ch.color.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(14),
                              border: isActive ? Border.all(color: ch.color, width: 2) : null,
                            ),
                            child: Stack(
                              children: [
                                Center(child: Icon(ch.icon, color: isActive ? Colors.white : ch.color, size: 22)),
                                if (isActive)
                                  Positioned(
                                    right: 2, top: 2,
                                    child: Container(
                                      width: 14, height: 14,
                                      decoration: BoxDecoration(color: GuroJobsTheme.success, shape: BoxShape.circle, border: Border.all(color: context.cardBg, width: 1.5)),
                                      child: const Icon(Icons.check, size: 8, color: Colors.white),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(ch.name, style: TextStyle(fontSize: 10, fontWeight: isActive ? FontWeight.w600 : FontWeight.w400, color: isActive ? context.textPrimaryC : context.textSecondaryC), maxLines: 1, overflow: TextOverflow.ellipsis),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() { _searchController.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    context.watch<LangProvider>();
    final conversations = _filteredConversations;

    return SafeArea(
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(AppStrings.t('chats'), style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: context.textPrimaryC)),
                    ),
                    if (_totalUnread > 0)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(color: GuroJobsTheme.error, borderRadius: BorderRadius.circular(12)),
                        child: Text('$_totalUnread ${AppStrings.t('unread_messages')}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.white)),
                      ),
                  ],
                ),
                const SizedBox(height: 14),

                // Paywall banner
                if (!_hasPaidPlan)
                  GestureDetector(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const BillingScreen())),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(colors: [Color(0xFFFF6B35), Color(0xFFFF8E53)]),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.lock, color: Colors.white, size: 20),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text('Messaging locked', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14)),
                                Text('Upgrade to send messages, share contacts & links', style: TextStyle(color: Colors.white70, fontSize: 12)),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                            child: const Text('Upgrade', style: TextStyle(color: Color(0xFFFF6B35), fontWeight: FontWeight.w700, fontSize: 12)),
                          ),
                        ],
                      ),
                    ),
                  ),

                // Search bar
                Container(
                  height: 44,
                  decoration: BoxDecoration(
                    color: context.cardBg,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: context.dividerC),
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (v) => setState(() => _searchQuery = v),
                    decoration: InputDecoration(
                      hintText: AppStrings.t('search_chats'),
                      hintStyle: TextStyle(color: context.textHintC, fontSize: 14),
                      prefixIcon: Icon(Icons.search, size: 20, color: context.textHintC),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 11),
                    ),
                  ),
                ),
                const SizedBox(height: 14),

                // Channel filter chips: only user-selected + "+"
                SizedBox(
                  height: 36,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      ..._visibleChannels.map((ch) =>
                        _ChannelChip(
                          label: ch.name,
                          icon: ch.icon,
                          color: ch.color,
                          isSelected: _selectedChannel == ch.id,
                          onTap: () => setState(() => _selectedChannel = _selectedChannel == ch.id ? 'all' : ch.id),
                        ),
                      ),
                      // Add messenger button
                      GestureDetector(
                        onTap: _showAddMessenger,
                        child: Container(
                          margin: const EdgeInsets.only(right: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: context.cardBg,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: context.dividerC),
                          ),
                          child: const Icon(Icons.add, size: 16, color: GuroJobsTheme.primary),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
              ],
            ),
          ),

          // Conversations list
          Expanded(
            child: conversations.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.chat_bubble_outline, size: 56, color: context.textHintC),
                        const SizedBox(height: 14),
                        Text(AppStrings.t('no_chats'), style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: context.textSecondaryC)),
                        const SizedBox(height: 6),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          child: Text(AppStrings.t('no_chats_desc'), textAlign: TextAlign.center, style: TextStyle(fontSize: 13, color: context.textHintC)),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    itemCount: conversations.length,
                    itemBuilder: (context, index) => _ConversationTile(conversation: conversations[index]),
                  ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// CHANNEL FILTER CHIP
// ═══════════════════════════════════════════════════════════════
class _ChannelChip extends StatelessWidget {
  final String label;
  final IconData? icon;
  final Color? color;
  final bool isSelected;
  final VoidCallback onTap;

  const _ChannelChip({required this.label, this.icon, this.color, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: isSelected ? (color ?? GuroJobsTheme.primary) : context.cardBg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? (color ?? GuroJobsTheme.primary) : context.dividerC),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 14, color: isSelected ? Colors.white : (color ?? context.textSecondaryC)),
              const SizedBox(width: 5),
            ],
            Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: isSelected ? Colors.white : context.textSecondaryC)),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// CONVERSATION TILE
// ═══════════════════════════════════════════════════════════════
class _ConversationTile extends StatelessWidget {
  final ChatConversation conversation;
  const _ConversationTile({required this.conversation});

  @override
  Widget build(BuildContext context) {
    final ch = chatChannelById(conversation.channel);
    final hasUnread = conversation.unread > 0;

    Color roleColor() {
      switch (conversation.role) {
        case 'agency': return GuroJobsTheme.accent;
        case 'support': return GuroJobsTheme.info;
        default: return GuroJobsTheme.primary;
      }
    }

    String roleLabel() {
      switch (conversation.role) {
        case 'agency': return AppStrings.t('agency_chat');
        case 'support': return AppStrings.t('support_chat');
        default: return AppStrings.t('employer_chat');
      }
    }

    return InkWell(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ChatDetailScreen(conversation: conversation))),
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        margin: const EdgeInsets.only(bottom: 2),
        decoration: BoxDecoration(
          color: hasUnread ? (context.isDark ? const Color(0xFF1A2A3A) : const Color(0xFFF0F6FF)) : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            // Avatar with online indicator + channel badge
            SizedBox(
              width: 54, height: 54,
              child: Stack(
                children: [
                  Container(
                    width: 50, height: 50,
                    decoration: BoxDecoration(
                      color: roleColor().withOpacity(0.15),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Center(
                      child: Text(conversation.avatar, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: roleColor())),
                    ),
                  ),
                  // Channel badge
                  Positioned(
                    right: 0, bottom: 0,
                    child: Container(
                      width: 20, height: 20,
                      decoration: BoxDecoration(
                        color: ch.color,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: context.isDark ? GuroJobsTheme.darkBackground : Colors.white, width: 2),
                      ),
                      child: Icon(ch.icon, size: 10, color: Colors.white),
                    ),
                  ),
                  // Online dot
                  if (conversation.isOnline)
                    Positioned(
                      right: 0, top: 0,
                      child: Container(
                        width: 12, height: 12,
                        decoration: BoxDecoration(
                          color: GuroJobsTheme.success,
                          shape: BoxShape.circle,
                          border: Border.all(color: context.isDark ? GuroJobsTheme.darkBackground : Colors.white, width: 2),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 12),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Flexible(
                              child: Text(
                                conversation.name,
                                style: TextStyle(fontSize: 15, fontWeight: hasUnread ? FontWeight.w700 : FontWeight.w600, color: context.textPrimaryC),
                                maxLines: 1, overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                              decoration: BoxDecoration(color: roleColor().withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
                              child: Text(roleLabel(), style: TextStyle(fontSize: 9, fontWeight: FontWeight.w600, color: roleColor())),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(conversation.time, style: TextStyle(fontSize: 11, color: hasUnread ? GuroJobsTheme.primary : context.textHintC, fontWeight: hasUnread ? FontWeight.w600 : FontWeight.w400)),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          conversation.lastMessage,
                          style: TextStyle(fontSize: 13, color: hasUnread ? context.textPrimaryC : context.textSecondaryC, fontWeight: hasUnread ? FontWeight.w500 : FontWeight.w400),
                          maxLines: 1, overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (hasUnread) ...[
                        const SizedBox(width: 8),
                        Container(
                          width: 22, height: 22,
                          decoration: const BoxDecoration(color: GuroJobsTheme.primary, shape: BoxShape.circle),
                          child: Center(child: Text('${conversation.unread}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white))),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

