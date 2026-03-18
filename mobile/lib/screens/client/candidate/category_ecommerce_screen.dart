import 'package:flutter/material.dart';
import 'category_page_widget.dart';

class CategoryEcommerceScreen extends StatelessWidget {
  const CategoryEcommerceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const CategoryPageScreen(
      color: Color(0xFF2196F3),
      icon: Icons.shopping_cart,
      title: 'E-commerce',
      description:
          'E-commerce is the buying and selling of goods and services online. From marketplaces like Amazon and eBay '
          'to direct-to-consumer (DTC) brands, dropshipping businesses, and SaaS platforms for online stores.\n\n'
          'The global e-commerce market surpassed \$6 trillion in 2024. The industry needs developers, designers, '
          'marketers, logistics specialists, and data analysts.\n\n'
          'E-commerce offers roles at every level -- from small startups to global tech giants. '
          'Key trends: AI personalization, social commerce, and cross-border trade.',
      roles: [
        'Full-Stack Developer (Shopify, WooCommerce)',
        'Digital Marketing Manager',
        'Product Manager (Marketplace)',
        'UX/UI Designer',
        'Supply Chain & Logistics',
        'SEO / PPC Specialist',
        'Customer Experience Manager',
        'Data Analyst (Revenue)',
      ],
      skills: ['Shopify', 'WooCommerce', 'Google Ads', 'SEO', 'Logistics', 'CRM Systems'],
      stats: [
        {'value': '\$6.3T', 'label': 'Market Size'},
        {'value': '9%', 'label': 'Annual Growth'},
        {'value': '2M+', 'label': 'Jobs Worldwide'},
      ],
      jobs: [
        {'title': 'Senior Shopify Developer', 'company': 'Shopify Plus', 'location': 'Remote', 'type': 'Full-time', 'salary': '\u20AC55-75K'},
        {'title': 'Digital Marketing Manager', 'company': 'Zalando', 'location': 'Berlin', 'type': 'Full-time', 'salary': '\u20AC50-65K'},
        {'title': 'Marketplace Product Manager', 'company': 'Allegro', 'location': 'Warsaw', 'type': 'Full-time', 'salary': '\u20AC45-60K'},
        {'title': 'Senior UX Designer', 'company': 'ASOS', 'location': 'Remote', 'type': 'Full-time', 'salary': '\u20AC50-65K'},
        {'title': 'PPC / Google Ads Specialist', 'company': 'eComTech', 'location': 'Remote', 'type': 'Full-time', 'salary': '\u20AC35-50K'},
        {'title': 'Supply Chain Manager', 'company': 'About You', 'location': 'Hamburg', 'type': 'Full-time', 'salary': '\u20AC45-60K'},
        {'title': 'SEO Lead', 'company': 'Wayfair', 'location': 'Remote', 'type': 'Full-time', 'salary': '\u20AC40-55K'},
        {'title': 'Revenue Data Analyst', 'company': 'Otto Group', 'location': 'Remote', 'type': 'Full-time', 'salary': '\u20AC45-60K'},
      ],
    );
  }
}
