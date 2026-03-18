import 'package:flutter/material.dart';
import 'category_page_widget.dart';

class CategoryFintechScreen extends StatelessWidget {
  const CategoryFintechScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const CategoryPageScreen(
      color: Color(0xFF00BCD4),
      icon: Icons.account_balance,
      title: 'FinTech',
      description:
          'FinTech (Financial Technology) -- the intersection of finance and technology. It includes digital payments, '
          'neobanks, lending platforms, InsurTech, RegTech, and personal finance apps.\n\n'
          'Companies like Revolut, Stripe, and Wise have transformed how people manage money. '
          'FinTech is one of the most funded sectors in tech, attracting billions in venture capital.\n\n'
          'Careers span from backend engineering and data science to compliance, risk, and product management. '
          'The industry values security expertise, regulatory knowledge, and innovation.',
      roles: [
        'Backend Engineer (Payments)',
        'Data Scientist / ML Engineer',
        'Product Manager (Payments)',
        'Compliance & Regulatory Specialist',
        'Risk Analyst',
        'Mobile Developer (Banking App)',
        'Security Engineer',
        'Business Development Manager',
      ],
      skills: ['PCI DSS', 'Payment APIs', 'KYC/AML', 'Open Banking', 'Microservices', 'Cloud Security'],
      stats: [
        {'value': '\$305B', 'label': 'Market Size'},
        {'value': '15%', 'label': 'Annual Growth'},
        {'value': '400K+', 'label': 'Jobs Worldwide'},
      ],
      jobs: [
        {'title': 'Senior Backend Engineer', 'company': 'Revolut', 'location': 'Remote', 'type': 'Full-time', 'salary': '\u20AC70-90K'},
        {'title': 'Payment Systems Architect', 'company': 'Stripe', 'location': 'Remote', 'type': 'Full-time', 'salary': '\u20AC80-110K'},
        {'title': 'Data Scientist (Risk)', 'company': 'Wise', 'location': 'London', 'type': 'Full-time', 'salary': '\u20AC65-85K'},
        {'title': 'Compliance Specialist', 'company': 'N26', 'location': 'Berlin', 'type': 'Full-time', 'salary': '\u20AC50-65K'},
        {'title': 'Senior Mobile Developer', 'company': 'Monzo', 'location': 'Remote', 'type': 'Full-time', 'salary': '\u20AC60-80K'},
        {'title': 'Security Engineer', 'company': 'Adyen', 'location': 'Amsterdam', 'type': 'Full-time', 'salary': '\u20AC65-85K'},
        {'title': 'Product Manager (Lending)', 'company': 'Klarna', 'location': 'Remote', 'type': 'Full-time', 'salary': '\u20AC55-75K'},
        {'title': 'Risk Analyst', 'company': 'SumUp', 'location': 'Remote', 'type': 'Full-time', 'salary': '\u20AC40-55K'},
      ],
    );
  }
}
