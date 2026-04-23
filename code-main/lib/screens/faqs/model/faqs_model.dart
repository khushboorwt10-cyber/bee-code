class FaqCategory {
  final String title;
  final List<FaqItem> questions;
  const FaqCategory({required this.title, required this.questions});
}

class FaqItem {
  final String question;
  final String answer;
  const FaqItem({required this.question, required this.answer});
}