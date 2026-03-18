import 'package:flutter/material.dart';
import 'category_page_widget.dart';

class CategoryDatingScreen extends StatelessWidget {
  const CategoryDatingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const CategoryPageScreen(
      color: Color(0xFFFF5722),
      icon: Icons.people,
      title: 'Dating',
      description:
          'The Dating industry includes online dating platforms, matchmaking apps, social discovery services, '
          'and relationship-focused products.\n\n'
          'With hundreds of millions of users worldwide, dating apps generate billions in revenue through subscriptions, '
          'in-app purchases, and advertising. Tinder, Bumble, Hinge, Badoo -- these are just the tip of the iceberg.\n\n'
          'The industry needs specialists in mobile development, UX/UI design, AI/ML (matching algorithms), '
          'moderation, and growth marketing.',
      roles: [
        'Mobile Developer (iOS/Android)',
        'AI/ML Engineer (Matching)',
        'UX/UI Designer',
        'Trust & Safety / Moderation',
        'Growth Marketing Manager',
        'Data Analyst',
        'Content Moderator',
        'Monetization Manager',
      ],
      skills: ['Mobile Dev', 'ML/AI', 'User Moderation', 'Growth Hacking', 'Subscription Models', 'UX Research'],
      stats: [
        {'value': '\$10B', 'label': 'Market Size'},
        {'value': '6%', 'label': 'Annual Growth'},
        {'value': '150K+', 'label': 'Jobs Worldwide'},
      ],
      jobs: [
        {'title': 'Senior iOS Developer', 'company': 'Bumble', 'location': 'Remote', 'type': 'Full-time', 'salary': '\u20AC60-80K'},
        {'title': 'ML Engineer (Matching)', 'company': 'Tinder', 'location': 'Remote', 'type': 'Full-time', 'salary': '\u20AC70-90K'},
        {'title': 'UX Designer (Dating)', 'company': 'Badoo', 'location': 'Remote', 'type': 'Full-time', 'salary': '\u20AC45-60K'},
        {'title': 'Trust & Safety Manager', 'company': 'Hinge', 'location': 'Remote', 'type': 'Full-time', 'salary': '\u20AC50-65K'},
        {'title': 'Growth Marketing Manager', 'company': 'MeetGroup', 'location': 'Remote', 'type': 'Full-time', 'salary': '\u20AC45-60K'},
        {'title': 'Senior Android Developer', 'company': 'Mamba', 'location': 'Remote', 'type': 'Full-time', 'salary': '\u20AC55-75K'},
        {'title': 'Content Moderation Lead', 'company': 'Spark Networks', 'location': 'Malta', 'type': 'Full-time', 'salary': '\u20AC30-45K'},
        {'title': 'Monetization Product Manager', 'company': 'Grindr', 'location': 'Remote', 'type': 'Full-time', 'salary': '\u20AC55-70K'},
      ],
    );
  }
}
