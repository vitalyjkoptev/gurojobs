import 'package:flutter/material.dart';
import 'category_page_widget.dart';

class CategoryGamblingScreen extends StatelessWidget {
  const CategoryGamblingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const CategoryPageScreen(
      color: Color(0xFFC62828),
      icon: Icons.casino,
      title: 'Gambling',
      description:
          'Gambling (iGaming) -- one of the fastest-growing industries in the digital economy. '
          'It includes online casinos, slot machines, poker rooms, live dealer games, and other games of chance.\n\n'
          'The global online gambling market is valued at over \$90 billion and continues to grow year over year. '
          'Companies in this sector are constantly looking for specialists in development, marketing, compliance, '
          'customer support, and analytics.\n\n'
          'iGaming offers competitive salaries, remote work opportunities, and career growth in an international environment.',
      roles: [
        'Game Developer (Slots, Table Games)',
        'Casino Product Manager',
        'Compliance & Licensing Manager',
        'VIP Account Manager',
        'Anti-Fraud Analyst',
        'Casino Marketing Manager',
        'Live Dealer Operations',
        'Payment Systems Specialist',
      ],
      skills: ['RNG/RTP', 'KYC/AML', 'Responsible Gaming', 'Game Math', 'Payment Integration', 'SEO/ASO'],
      stats: [
        {'value': '\$92B', 'label': 'Market Size'},
        {'value': '12%', 'label': 'Annual Growth'},
        {'value': '500K+', 'label': 'Jobs Worldwide'},
      ],
      jobs: [
        {'title': 'Senior Casino Game Developer', 'company': 'Evolution Gaming', 'location': 'Malta', 'type': 'Full-time', 'salary': '\u20AC65-85K'},
        {'title': 'Slot Game Designer (UI/UX)', 'company': 'Pragmatic Play', 'location': 'Malta', 'type': 'Full-time', 'salary': '\u20AC40-55K'},
        {'title': 'Casino Product Manager', 'company': 'LeoVegas', 'location': 'Remote', 'type': 'Full-time', 'salary': '\u20AC55-70K'},
        {'title': 'iGaming Compliance Officer', 'company': 'Betway', 'location': 'Gibraltar', 'type': 'Full-time', 'salary': '\u20AC50-65K'},
        {'title': 'Senior Anti-Fraud Analyst', 'company': 'PokerStars', 'location': 'Remote', 'type': 'Full-time', 'salary': '\u20AC45-60K'},
        {'title': 'VIP Account Manager', 'company': '888 Holdings', 'location': 'Malta', 'type': 'Full-time', 'salary': '\u20AC35-50K'},
        {'title': 'Live Casino Operations Lead', 'company': 'Playtech', 'location': 'Latvia', 'type': 'Full-time', 'salary': '\u20AC40-55K'},
        {'title': 'Casino Marketing Manager', 'company': 'Yggdrasil', 'location': 'Remote', 'type': 'Full-time', 'salary': '\u20AC45-60K'},
      ],
    );
  }
}
