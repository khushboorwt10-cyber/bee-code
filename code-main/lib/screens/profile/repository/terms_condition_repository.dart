import 'package:beecode/screens/profile/model/terms_condition_model.dart';
import 'package:flutter/material.dart';

class TermsConditionRepository {
  Future<TermsConditionModel> fetchTerms() async {
    await Future.delayed(const Duration(milliseconds: 600));
    return const TermsConditionModel(
      lastUpdated: 'March 15, 2025',
      version: 'v1.0.0',
      contactEmail: 'support@becode.com',
      sections: [
        TermsSection(
          id: '1',
          icon: Icons.handshake_outlined,
          title: 'Acceptance of Terms',
          short: 'Agreement to our terms',
          content:
              'By accessing or using LearnApp, you agree to be bound by these Terms and Conditions.\n\n'
              '• You must be at least 13 years old to use this service\n'
              '• By using the app, you confirm you have read and accepted these terms\n'
              '• If you disagree with any part, you may not access the service\n'
              '• These terms apply to all users including visitors and registered members',
        ),
        TermsSection(
          id: '2',
          icon: Icons.account_circle_outlined,
          title: 'User Accounts',
          short: 'Account rules and responsibilities',
          content:
              'When you create an account, you are responsible for maintaining its security.\n\n'
              '• You must provide accurate and complete information\n'
              '• You are responsible for all activity under your account\n'
              '• Notify us immediately of any unauthorized access\n'
              '• We reserve the right to terminate accounts that violate these terms\n'
              '• One person may not maintain more than one free account',
        ),
        TermsSection(
          id: '3',
          icon: Icons.menu_book_outlined,
          title: 'Course & Content Usage',
          short: 'How you may use our content',
          content:
              'All course content is provided for personal, non-commercial educational use only.\n\n'
              '• You may not reproduce, distribute, or resell any course material\n'
              '• Screen recording or downloading content is strictly prohibited\n'
              '• Course access is granted per individual license only\n'
              '• Sharing account credentials with others is not permitted\n'
              '• Certificates are issued only upon full course completion',
        ),
        TermsSection(
          id: '4',
          icon: Icons.payment_outlined,
          title: 'Payments & Refunds',
          short: 'Billing terms and refund policy',
          content:
              'All purchases are processed securely through our payment partners.\n\n'
              '• Prices are listed in USD and may vary by region\n'
              '• Subscriptions auto-renew unless cancelled before the renewal date\n'
              '• Refund requests must be submitted within 7 days of purchase\n'
              '• Refunds are not available for partially completed courses\n'
              '• We reserve the right to change pricing with 30 days notice',
        ),
        TermsSection(
          id: '5',
          icon: Icons.gavel_rounded,
          title: 'Prohibited Conduct',
          short: 'What you must not do',
          content:
              'Users must not engage in any of the following activities:\n\n'
              '• Violating any applicable laws or regulations\n'
              '• Impersonating another person or entity\n'
              '• Uploading malicious code or interfering with the platform\n'
              '• Harassing, abusing, or threatening other users\n'
              '• Attempting to gain unauthorized access to any system\n'
              '• Using automated tools to scrape or extract content',
        ),
        TermsSection(
          id: '6',
          icon: Icons.verified_user_outlined,
          title: 'Intellectual Property',
          short: 'Ownership of content',
          content:
              'All content on LearnApp is the intellectual property of LearnApp or its licensors.\n\n'
              '• The LearnApp name, logo, and brand are registered trademarks\n'
              '• Course videos, materials, and assessments are fully copyrighted\n'
              '• User-submitted content grants us a non-exclusive license to use it\n'
              '• You retain ownership of content you create and submit\n'
              '• Reporting IP violations: legal@learnapp.com',
        ),
        TermsSection(
          id: '7',
          icon: Icons.warning_amber_rounded,
          title: 'Limitation of Liability',
          short: 'Our liability to you',
          content:
              'LearnApp shall not be liable for any indirect or consequential damages.\n\n'
              '• We do not guarantee uninterrupted or error-free service\n'
              '• Our total liability shall not exceed the amount paid in the last 12 months\n'
              '• We are not responsible for third-party content or links\n'
              '• Course outcomes and results may vary per individual\n'
              '• We provide services "as is" without warranties of any kind',
        ),
        TermsSection(
          id: '8',
          icon: Icons.update_rounded,
          title: 'Changes to Terms',
          short: 'How we update these terms',
          content:
              'We reserve the right to modify these Terms at any time.\n\n'
              '• Changes will be posted on this page with an updated date\n'
              '• Material changes will be communicated via email 14 days in advance\n'
              '• Continued use after changes constitutes acceptance\n'
              '• If you disagree with updated terms, you must stop using the service\n'
              '• Archived versions of previous terms are available on request',
        ),
      ],
    );
  }
}