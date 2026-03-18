import 'package:flutter/material.dart';
import 'category_page_widget.dart';

class CategoryNutraScreen extends StatelessWidget {
  const CategoryNutraScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const CategoryPageScreen(
      color: Color(0xFF9C27B0),
      icon: Icons.favorite,
      title: 'Nutra',
      description:
          'Nutra (Nutraceuticals) -- the industry of dietary supplements, health products, beauty and wellness goods '
          'sold online. It is one of the most profitable verticals in digital marketing and affiliate marketing.\n\n'
          'Nutra companies rely heavily on performance marketing, funnel optimization, and creative production. '
          'The global nutraceuticals market exceeds \$400 billion and keeps growing with increasing health awareness.\n\n'
          'Careers in Nutra range from media buying and landing page design to product development and supply chain management.',
      roles: [
        'Media Buyer (Facebook, Google, TikTok)',
        'Affiliate Manager',
        'Landing Page Designer',
        'Copywriter / Creative Producer',
        'Product Manager (Supplements)',
        'Customer Support Specialist',
        'Supply Chain & Logistics',
        'Conversion Rate Optimizer',
      ],
      skills: ['Media Buying', 'CPA/CPI', 'Landing Pages', 'A/B Testing', 'Facebook Ads', 'Funnel Building'],
      stats: [
        {'value': '\$454B', 'label': 'Market Size'},
        {'value': '8%', 'label': 'Annual Growth'},
        {'value': '300K+', 'label': 'Jobs Worldwide'},
      ],
      jobs: [
        {'title': 'Senior Media Buyer', 'company': 'NutraHealth Group', 'location': 'Remote', 'type': 'Full-time', 'salary': '\u20AC45-70K'},
        {'title': 'Affiliate Manager', 'company': 'ClickDealer', 'location': 'Remote', 'type': 'Full-time', 'salary': '\u20AC40-55K'},
        {'title': 'Landing Page Designer', 'company': 'VitaBoost', 'location': 'Remote', 'type': 'Full-time', 'salary': '\u20AC35-50K'},
        {'title': 'Senior Copywriter (Health)', 'company': 'PharmaNutra', 'location': 'Remote', 'type': 'Full-time', 'salary': '\u20AC30-45K'},
        {'title': 'Performance Marketing Lead', 'company': 'NutraClick', 'location': 'Remote', 'type': 'Full-time', 'salary': '\u20AC50-70K'},
        {'title': 'Product Manager (Supplements)', 'company': 'GNC Digital', 'location': 'Malta', 'type': 'Full-time', 'salary': '\u20AC45-60K'},
        {'title': 'CRO Specialist', 'company': 'HealthTraffic', 'location': 'Remote', 'type': 'Full-time', 'salary': '\u20AC40-55K'},
        {'title': 'TikTok Ads Specialist', 'company': 'NutraWave', 'location': 'Remote', 'type': 'Full-time', 'salary': '\u20AC35-50K'},
      ],
    );
  }
}
