import 'package:attms/widget/title_container.dart';
import 'package:flutter/material.dart';

class AboutUs extends StatefulWidget {
  const AboutUs({super.key});

  @override
  State<AboutUs> createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: TitleContainer(
      
      pageTitle: 'About Us',
      description:
          'An About Us page is a section on a website that provides information about a company, organization, or individual. It’s an opportunity to tell your brand’s story, share your vision, introduce team members, and outline your history, values, and achievements. This is where you build trust and credibility with customers.',
    ));
  }
}
