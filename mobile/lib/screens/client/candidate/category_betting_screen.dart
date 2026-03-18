import 'package:flutter/material.dart';
import 'category_page_widget.dart';

class CategoryBettingScreen extends StatelessWidget {
  const CategoryBettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const CategoryPageScreen(
      color: Color(0xFF4CAF50),
      icon: Icons.sports_soccer,
      title: 'Betting',
      description:
          'Betting (Sports Betting) -- the segment of iGaming focused on wagering on sports events, esports, '
          'and other competitive outcomes. It covers pre-match and live betting, fantasy sports, and prediction markets.\n\n'
          'The industry is booming with the global legalization wave, especially in the US, Europe, and Latin America. '
          'Betting companies use cutting-edge technology: AI-powered odds calculation, real-time data feeds, '
          'and sophisticated risk management systems.\n\n'
          'If you love sports and technology -- Betting is where both passions meet.',
      roles: [
        'Sports Trader / Odds Compiler',
        'Betting Product Manager',
        'Data Analyst / Scientist',
        'Sportsbook Operations Manager',
        'Risk Management Analyst',
        'Affiliate Marketing Manager',
        'Mobile App Developer',
        'Content Writer (Sports)',
      ],
      skills: ['Odds Trading', 'Data Analytics', 'Risk Management', 'API Integration', 'Live Streaming', 'Regulation'],
      stats: [
        {'value': '\$76B', 'label': 'Market Size'},
        {'value': '10%', 'label': 'Annual Growth'},
        {'value': '350K+', 'label': 'Jobs Worldwide'},
      ],
      jobs: [
        {'title': 'Sports Betting Product Manager', 'company': 'Betsson Group', 'location': 'Remote', 'type': 'Full-time', 'salary': '\u20AC55-70K'},
        {'title': 'Senior Sports Trader', 'company': 'Pinnacle', 'location': 'Curacao', 'type': 'Full-time', 'salary': '\u20AC50-65K'},
        {'title': 'Betting Data Scientist', 'company': 'bet365', 'location': 'Remote', 'type': 'Full-time', 'salary': '\u20AC60-80K'},
        {'title': 'Risk Management Analyst', 'company': 'Entain', 'location': 'Gibraltar', 'type': 'Full-time', 'salary': '\u20AC45-60K'},
        {'title': 'Senior Mobile Developer', 'company': 'DraftKings', 'location': 'Remote', 'type': 'Full-time', 'salary': '\u20AC65-85K'},
        {'title': 'Sportsbook Operations Manager', 'company': 'FanDuel', 'location': 'Malta', 'type': 'Full-time', 'salary': '\u20AC50-65K'},
        {'title': 'Betting Affiliate Manager', 'company': 'Betclic', 'location': 'Remote', 'type': 'Full-time', 'salary': '\u20AC35-50K'},
        {'title': 'eSports Betting Analyst', 'company': 'Rivalry', 'location': 'Remote', 'type': 'Full-time', 'salary': '\u20AC40-55K'},
      ],
    );
  }
}
