
import 'package:flutter/material.dart';

class SubscriptionPlanModel {
  final int index;
  final String productId;
  final String title;
  final String subtitle;
  final String price;
  final String per;
  final IconData icon;
  final bool popular;
  final List<String> features;

  const SubscriptionPlanModel({
    required this.index,
    required this.productId,
    required this.title,
    required this.subtitle,
    required this.price,
    required this.per,
    required this.icon,
    required this.features,
    this.popular = false,
  });
}

class SubscriptionBenefitModel {
  final IconData icon;
  final String title;
  final String subtitle;

  const SubscriptionBenefitModel({
    required this.icon,
    required this.title,
    required this.subtitle,
  });
}

class SubscriptionData {
  static const List<SubscriptionPlanModel> plans = [
    SubscriptionPlanModel(
      index: 0,
      productId: 'premium_1_month',
      title: '1 Month',
      subtitle: 'Billed monthly',
      price: '₹999',
      per: '/month',
      icon: Icons.bolt_rounded,
      features: [
        'Ad-free learning experience',
        'HD video streaming',
      ],
    ),
    SubscriptionPlanModel(
      index: 1,
      productId: 'premium_6_months',
      title: '3 Months',
      subtitle: 'Save 33% vs monthly',
      price: '₹2499',
      per: '/3 months',
      icon: Icons.auto_awesome_rounded,
      popular: true,
      features: [
        'Ad-free learning experience',
        'HD video streaming',
        'Download & watch offline',
        'Multi-device support',
      ],
    ),
    SubscriptionPlanModel(
      index: 2,
      productId: 'premium_12_months',
      title: '6 Months',
      subtitle: 'Best value — save 50%',
      price: '₹4999',
      per: '/6 Months',
      icon: Icons.emoji_events_rounded,
      features: [
        'Ad-free learning experience',
        'HD video streaming',
        'Download & watch offline',
        'Multi-device support',
        'Exclusive premium content',
        'Priority support',
      ],
    ),
  ];

  static const List<SubscriptionBenefitModel> benefits = [
    SubscriptionBenefitModel(
      icon: Icons.verified_rounded,
      title: 'Verified Certificate',
      subtitle: 'Earn certificates for every course you complete',
    ),
    SubscriptionBenefitModel(
      icon: Icons.download_rounded,
      title: 'Download & Learn Offline',
      subtitle: 'Study anywhere without internet connection',
    ),
    SubscriptionBenefitModel(
      icon: Icons.devices_rounded,
      title: 'Multi-Device Access',
      subtitle: 'Learn seamlessly on phone, tablet or desktop',
    ),
    SubscriptionBenefitModel(
      icon: Icons.block_rounded,
      title: 'Ad-Free Experience',
      subtitle: 'No interruptions while you focus on learning',
    ),
    SubscriptionBenefitModel(
      icon: Icons.support_agent_rounded,
      title: 'Priority Support',
      subtitle: 'Get help faster with dedicated support access',
    ),
  ];
}
