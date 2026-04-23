import 'package:beecode/screens/faqs/model/faqs_model.dart';

final List<FaqCategory> faqCategories = [
  FaqCategory(
    title: 'General FAQs',
    questions: [
      FaqItem(
        question: 'What is the Executive Diploma in ML & AI?',
        answer: 'The Executive Diploma in Machine Learning & AI is a comprehensive 12-month program designed for working professionals who want to master AI and ML concepts and apply them in real-world scenarios.',
      ),
      FaqItem(
        question: 'Who is this program designed for?',
        answer: 'This program is ideal for software engineers, data analysts, product managers, and any professional looking to transition into or advance in the AI/ML field.',
      ),
      FaqItem(
        question: 'What are the prerequisites?',
        answer: 'Basic knowledge of programming (preferably Python) and high school level mathematics is recommended. No prior ML experience is required.',
      ),
    ],
  ),
  FaqCategory(
    title: 'Enrollment & Access',
    questions: [
      FaqItem(
        question: 'How do I enroll in the program?',
        answer: 'Click "Start Application" and complete the registration form. Our admissions team will reach out within 24 hours to guide you through the process.',
      ),
      FaqItem(
        question: 'Is there an application deadline?',
        answer: 'The current batch deadline is 30-Dec-2025. We recommend applying early as seats are limited.',
      ),
      FaqItem(
        question: 'Can I access course material after completion?',
        answer: 'Yes, you get lifetime access to all course materials, recorded sessions, and future updates to the curriculum.',
      ),
    ],
  ),
  FaqCategory(
    title: 'Course Details & Career Outcomes',
    questions: [
      FaqItem(
        question: 'What kind of projects will I work on?',
        answer: 'You will work on 30+ industry-grade projects across domains like finance, healthcare, e-commerce, and more. The capstone project is entirely your choice.',
      ),
      FaqItem(
        question: 'Will I get placement support?',
        answer: 'Yes, we provide dedicated career support including resume reviews, mock interviews, LinkedIn optimization, and access to our hiring partner network.',
      ),
      FaqItem(
        question: 'What companies have hired our alumni?',
        answer: 'Our alumni work at Amazon, Microsoft, HSBC, ICICI, Kotak, Jio Digital, Lenskart, Swiggy, and 500+ other top companies.',
      ),
    ],
  ),
  FaqCategory(
    title: 'Concept-Based FAQs',
    questions: [
      FaqItem(
        question: 'What is the difference between AI and ML?',
        answer: 'AI (Artificial Intelligence) is the broader concept of machines simulating human intelligence. ML (Machine Learning) is a subset of AI where systems learn from data to improve their performance without being explicitly programmed.',
      ),
      FaqItem(
        question: 'Do I need to know deep learning before joining?',
        answer: 'No. The program starts from the fundamentals and progressively builds up to advanced deep learning, LLMs, and generative AI topics.',
      ),
      FaqItem(
        question: 'What is MLOps and why does it matter?',
        answer: 'MLOps (Machine Learning Operations) is the practice of deploying, monitoring, and maintaining ML models in production. It bridges the gap between data science and engineering, which is critical for real-world AI applications.',
      ),
    ],
  ),
];
