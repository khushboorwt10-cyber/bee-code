import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CompanyLogosWidget extends StatefulWidget {
  const CompanyLogosWidget({super.key});

  @override
  State<CompanyLogosWidget> createState() => _CompanyLogosWidgetState();
}

class _CompanyLogosWidgetState extends State<CompanyLogosWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  final List<String> logos = [
"https://upload.wikimedia.org/wikipedia/commons/3/33/Figma-logo.svg",
"https://upload.wikimedia.org/wikipedia/commons/a/a7/React-icon.svg",
"https://upload.wikimedia.org/wikipedia/commons/6/64/Expressjs.png",
"https://upload.wikimedia.org/wikipedia/commons/4/47/React.svg",
"https://upload.wikimedia.org/wikipedia/commons/9/95/Vue.js_Logo_2.svg",
"https://upload.wikimedia.org/wikipedia/commons/d/d9/Node.js_logo.svg",
"https://upload.wikimedia.org/wikipedia/commons/2/27/PHP-logo.svg",
"https://upload.wikimedia.org/wikipedia/commons/2/29/Postgresql_elephant.svg",
"https://upload.wikimedia.org/wikipedia/commons/0/05/Go_Logo_Blue.svg",
"https://upload.wikimedia.org/wikipedia/commons/9/99/Unofficial_JavaScript_logo_2.svg",
"https://upload.wikimedia.org/wikipedia/commons/1/18/ISO_C%2B%2B_Logo.svg",
"https://upload.wikimedia.org/wikipedia/commons/4/4f/Dart_logo.svg",
"https://upload.wikimedia.org/wikipedia/commons/1/17/Google-flutter-logo.svg",
"https://upload.wikimedia.org/wikipedia/commons/7/74/Kotlin_Icon.png",
  ];

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 25),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final allLogos = [...logos, ...logos];

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: SizedBox(
        height: 50,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const NeverScrollableScrollPhysics(),
              child: Transform.translate(
                offset: Offset(-1100 * _controller.value, 0),
                child: Row(
                  children: allLogos.map((logo) {
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30.w),
                      child: SvgPicture.network(
                        logo,
                        height: 28.h,
                        // width: 50.w,
                        fit: BoxFit.contain
                      ),
                    );
                  }).toList(),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
