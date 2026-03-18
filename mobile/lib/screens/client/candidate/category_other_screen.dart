import 'package:flutter/material.dart';
import 'category_page_widget.dart';

class CategoryOtherScreen extends StatelessWidget {
  const CategoryOtherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const CategoryPageScreen(
      color: Color(0xFF607D8B),
      icon: Icons.apps,
      title: 'Other',
      description:
          'Beyond the major iGaming and digital marketing verticals, there are many other exciting industries '
          'that are actively hiring tech talent.\n\n'
          'This includes SaaS, EdTech, HealthTech, TravelTech, FoodTech, PropTech, HR Tech, Gaming, Esports, and more. '
          'Each of these sectors leverages technology to disrupt traditional industries.\n\n'
          'Whether you are a developer, marketer, designer, or manager -- there is a place for you. '
          'Find an industry that matches your interests and build specialized expertise.',
      roles: [
        'Software Engineer',
        'Product Manager',
        'Digital Marketing Specialist',
        'UX/UI Designer',
        'Data Analyst',
        'Project Manager',
        'DevOps Engineer',
        'Content Manager',
      ],
      skills: ['Programming', 'Data Analysis', 'Cloud', 'Agile', 'Marketing', 'Design Thinking'],
      stats: [
        {'value': '\$5T+', 'label': 'Tech Market'},
        {'value': '11%', 'label': 'Annual Growth'},
        {'value': '10M+', 'label': 'Tech Jobs'},
      ],
      jobs: [
        {'title': 'Senior Full-Stack Developer', 'company': 'TechStartup EU', 'location': 'Remote', 'type': 'Full-time', 'salary': '\u20AC55-75K'},
        {'title': 'Product Manager (SaaS)', 'company': 'CloudTech', 'location': 'Remote', 'type': 'Full-time', 'salary': '\u20AC50-70K'},
        {'title': 'Digital Marketing Lead', 'company': 'EdTech Pro', 'location': 'Remote', 'type': 'Full-time', 'salary': '\u20AC40-55K'},
        {'title': 'Senior UX Researcher', 'company': 'HealthTech AI', 'location': 'Remote', 'type': 'Full-time', 'salary': '\u20AC45-60K'},
        {'title': 'DevOps Engineer', 'company': 'TravelSoft', 'location': 'Remote', 'type': 'Full-time', 'salary': '\u20AC55-70K'},
        {'title': 'Data Analyst', 'company': 'FoodTech Hub', 'location': 'Warsaw', 'type': 'Full-time', 'salary': '\u20AC35-50K'},
        {'title': 'Project Manager (Agile)', 'company': 'PropTech Group', 'location': 'Remote', 'type': 'Full-time', 'salary': '\u20AC45-60K'},
        {'title': 'Content Marketing Manager', 'company': 'HR Tech Solutions', 'location': 'Remote', 'type': 'Full-time', 'salary': '\u20AC35-50K'},
      ],
    );
  }
}
