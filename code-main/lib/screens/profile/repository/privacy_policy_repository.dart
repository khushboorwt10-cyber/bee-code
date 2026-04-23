
import 'package:beecode/screens/profile/model/privacy_policy_model.dart';
import 'package:flutter/material.dart';

class PrivacyPolicyRepository {
  Future<PrivacyPolicyModel> fetchPolicy() async {
    await Future.delayed(const Duration(milliseconds: 600));
    return const PrivacyPolicyModel(
      lastUpdated: 'March 15, 2025',
      version: 'v1.0.0',
      contactEmail: 'support@beecode.com',
      sections: [
        PrivacyPolicySection(
          id: '1',
          icon: Icons.info_outline_rounded,
          title: 'Information We Collect',
          short: 'What data we gather from you',
          content:
              'We collect information you provide directly to us, such as when you create an account, enroll in a course, or contact us for support.\n\n'
              '• Account Information: name, email address, password\n'
              '• Profile Data: photo, bio, learning preferences\n'
              '• Payment Information: billing details (processed securely via third-party)\n'
              '• Usage Data: courses viewed, progress, quiz results\n'
              '• Device Information: IP address, browser type, OS version',
        ),
        PrivacyPolicySection(
          id: '2',
          icon: Icons.manage_search_rounded,
          title: 'How We Use Your Data',
          short: 'Purpose of data collection',
          content:
              'We use the information we collect to provide, maintain, and improve our services.\n\n'
              '• Deliver and personalize your learning experience\n'
              '• Process transactions and send related information\n'
              '• Send technical notices and support messages\n'
              '• Respond to your comments and questions\n'
              '• Monitor and analyze usage trends\n'
              '• Detect and prevent fraudulent activity',
        ),
        PrivacyPolicySection(
          id: '3',
          icon: Icons.share_outlined,
          title: 'Sharing of Information',
          short: 'Who we share your data with',
          content:
              'We do not sell, trade, or rent your personal information to third parties.\n\n'
              'We may share your information in the following circumstances:\n\n'
              '• With service providers who assist in our operations\n'
              '• To comply with legal obligations or court orders\n'
              '• To protect the rights and safety of our users\n'
              '• With your consent for any other purpose',
        ),
        PrivacyPolicySection(
          id: '4',
          icon: Icons.cookie_outlined,
          title: 'Cookies & Tracking',
          short: 'How we use cookies',
          content:
              'We use cookies and similar tracking technologies to track activity on our platform.\n\n'
              '• Essential Cookies: required for the platform to function\n'
              '• Analytics Cookies: help us understand how you use the app\n'
              '• Preference Cookies: remember your settings and choices\n\n'
              'You can instruct your browser to refuse all cookies. However, some features may not function properly without them.',
        ),
        PrivacyPolicySection(
          id: '5',
          icon: Icons.lock_outline_rounded,
          title: 'Data Security',
          short: 'How we protect your information',
          content:
              'We implement appropriate technical and organizational measures to protect your personal information.\n\n'
              '• All data is encrypted in transit using TLS 1.3\n'
              '• Passwords are hashed using bcrypt\n'
              '• Regular security audits and penetration testing\n'
              '• Access to personal data is strictly limited to authorized personnel\n\n'
              'No method of transmission over the internet is 100% secure. We strive to use commercially acceptable means to protect your data.',
        ),
        PrivacyPolicySection(
          id: '6',
          icon: Icons.child_care_rounded,
          title: "Children's Privacy",
          short: 'Policy for users under 13',
          content:
              'Our service is not directed to children under the age of 13.\n\n'
              'We do not knowingly collect personal information from children under 13. If we become aware that a child under 13 has provided us with personal information, we will take steps to delete such information.\n\n'
              'If you are a parent and believe your child has provided us information, please contact us immediately.',
        ),
        PrivacyPolicySection(
          id: '7',
          icon: Icons.tune_rounded,
          title: 'Your Rights & Choices',
          short: 'Control over your personal data',
          content:
              'You have certain rights regarding your personal information.\n\n'
              '• Access: request a copy of the data we hold about you\n'
              '• Correction: update inaccurate or incomplete information\n'
              '• Deletion: request we delete your personal data\n'
              '• Portability: receive your data in a portable format\n'
              '• Opt-out: unsubscribe from marketing communications at any time\n\n'
              'To exercise these rights, contact us at privacy@learnapp.com',
        ),
        PrivacyPolicySection(
          id: '8',
          icon: Icons.update_rounded,
          title: 'Changes to This Policy',
          short: 'How we notify you of updates',
          content:
              'We may update this Privacy Policy from time to time to reflect changes in our practices or for legal reasons.\n\n'
              'When we make material changes, we will:\n\n'
              '• Notify you via email at least 14 days before changes take effect\n'
              '• Display a prominent notice within the app\n'
              '• Update the "Last Updated" date at the top of this policy\n\n'
              'Continued use of the app after changes constitutes acceptance of the revised policy.',
        ),
      ],
    );
  }
}