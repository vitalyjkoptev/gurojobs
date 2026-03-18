import 'package:flutter/material.dart';
import 'category_page_widget.dart';

class CategoryCryptoScreen extends StatelessWidget {
  const CategoryCryptoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const CategoryPageScreen(
      color: Color(0xFFF7931A),
      icon: Icons.currency_bitcoin,
      title: 'Crypto',
      description:
          'The Crypto & Blockchain industry encompasses cryptocurrency exchanges, DeFi protocols, NFT platforms, '
          'Web3 projects, and blockchain infrastructure.\n\n'
          'Since the Bitcoin revolution, this sector has created hundreds of thousands of jobs worldwide. '
          'From Solidity developers to community managers, from tokenomics experts to compliance officers -- '
          'the crypto industry needs diverse talent.\n\n'
          'The sector offers unique benefits: token-based compensation, decentralized work culture, '
          'and the opportunity to shape the future of finance and technology.',
      roles: [
        'Blockchain Developer (Solidity, Rust)',
        'Smart Contract Auditor',
        'DeFi Protocol Engineer',
        'Crypto Compliance Officer',
        'Tokenomics Analyst',
        'Community Manager (Web3)',
        'Crypto Marketing Manager',
        'NFT / GameFi Product Manager',
      ],
      skills: ['Solidity', 'Web3.js', 'DeFi', 'Smart Contracts', 'Tokenomics', 'Blockchain Security'],
      stats: [
        {'value': '\$2.5T', 'label': 'Market Cap'},
        {'value': '25%', 'label': 'Annual Growth'},
        {'value': '200K+', 'label': 'Jobs Worldwide'},
      ],
      jobs: [
        {'title': 'Senior Solidity Developer', 'company': 'Uniswap Labs', 'location': 'Remote', 'type': 'Full-time', 'salary': '\u20AC80-120K'},
        {'title': 'Smart Contract Auditor', 'company': 'OpenZeppelin', 'location': 'Remote', 'type': 'Full-time', 'salary': '\u20AC70-100K'},
        {'title': 'DeFi Protocol Engineer', 'company': 'Aave', 'location': 'Remote', 'type': 'Full-time', 'salary': '\u20AC75-95K'},
        {'title': 'Crypto Compliance Officer', 'company': 'Binance', 'location': 'Malta', 'type': 'Full-time', 'salary': '\u20AC55-70K'},
        {'title': 'Web3 Community Manager', 'company': 'Polygon', 'location': 'Remote', 'type': 'Full-time', 'salary': '\u20AC35-50K'},
        {'title': 'Blockchain Data Analyst', 'company': 'Chainalysis', 'location': 'Remote', 'type': 'Full-time', 'salary': '\u20AC60-80K'},
        {'title': 'NFT Product Manager', 'company': 'OpenSea', 'location': 'Remote', 'type': 'Full-time', 'salary': '\u20AC65-85K'},
        {'title': 'Senior Rust Developer', 'company': 'Solana Labs', 'location': 'Remote', 'type': 'Full-time', 'salary': '\u20AC85-110K'},
      ],
    );
  }
}
