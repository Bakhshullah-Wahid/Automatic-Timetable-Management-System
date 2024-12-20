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
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            const TitleContainer(
              description: 'Decription about us',
              pageTitle: 'About Us',
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  color: Colors.white, // Light background color for readability
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Section
                      Center(
                        child: Column(
                          children: [
                            const Text(
                              "Who We Are",
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Empowering innovation through technology.",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // About Section
                      _buildSectionHeader("About Us"),
                      const SizedBox(height: 8),
                      Text(
                        "We are Team Innovators, a group of passionate developers creating cutting-edge Windows applications. "
                        "Our goal is to deliver robust, scalable, and user-friendly solutions that enhance productivity and solve real-world problems.",
                        style: TextStyle(fontSize: 16, color: Colors.grey[800]),
                        textAlign: TextAlign.justify,
                      ),
                      const SizedBox(height: 24),

                      // Mission Section
                      _buildSectionHeader("Our Mission"),
                      const SizedBox(height: 8),
                      Text(
                        "To innovate, inspire, and deliver excellence in technology solutions. We aim to empower individuals and organizations "
                        "by creating applications that meet their evolving needs.",
                        style: TextStyle(fontSize: 16, color: Colors.grey[800]),
                        textAlign: TextAlign.justify,
                      ),
                      const SizedBox(height: 24),

                      // Vision Section
                      _buildSectionHeader("Our Vision"),
                      const SizedBox(height: 8),
                      Text(
                        "To be a global leader in technology solutions by fostering creativity, embracing innovation, and maintaining a customer-centric approach.",
                        style: TextStyle(fontSize: 16, color: Colors.grey[800]),
                        textAlign: TextAlign.justify,
                      ),
                      const SizedBox(height: 24),

                      // Values Section
                      _buildSectionHeader("Our Values"),
                      const SizedBox(height: 8),
                      _buildBulletPoints([
                        "Innovation: Continuously pushing boundaries.",
                        "Integrity: Maintaining trust and transparency.",
                        "Collaboration: Working together for success.",
                        "Customer Focus: Prioritizing user satisfaction.",
                      ]),
                      const SizedBox(height: 24),

                      // Achievements Section
                      _buildSectionHeader("Our Achievements"),
                      const SizedBox(height: 8),
                      _buildBulletPoints([
                        "Developed over 50 successful Windows applications.",
                        "Awarded 'Best Emerging Team in Tech' 2023.",
                        "Partnered with top organizations for custom solutions.",
                      ]),
                      const SizedBox(height: 24),

                      // Team Section
                      _buildSectionHeader("Meet Our Team"),
                      const SizedBox(height: 8),
                      _buildTeamDetails(),
                      const SizedBox(height: 24),

                      // What We Do Section
                      _buildSectionHeader("What We Do"),
                      const SizedBox(height: 8),
                      _buildBulletPoints([
                        "Custom Windows App Development.",
                        "Productivity Tools and Solutions.",
                        "Cross-Platform Integration.",
                        "Business Intelligence Applications.",
                      ]),
                      const SizedBox(height: 24),

                      // Contact Section
                      _buildSectionHeader("Get in Touch"),
                      const SizedBox(height: 8),
                      Text(
                        "Do you have a project idea or a query? Reach out to us!",
                        style: TextStyle(fontSize: 16, color: Colors.grey[800]),
                        textAlign: TextAlign.justify,
                      ),
                      const SizedBox(height: 8),
                      _buildContactInfo(),
                      const SizedBox(height: 24),

                      // Footer Section
                      Center(
                        child: Text(
                          "© 2024 Team Innovators - All Rights Reserved.",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
  }

  Widget _buildBulletPoints(List<String> points) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: points
          .map(
            (point) => Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.check_circle, color: Colors.teal, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    point,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[800],
                    ),
                  ),
                ),
              ],
            ),
          )
          .toList(),
    );
  }

  Widget _buildTeamDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "- Supervisor: Mamoon Rasheed",
          style: TextStyle(fontSize: 16, color: Colors.grey[800]),
        ),
        const SizedBox(height: 8),
        Text(
          "- Team Members:",
          style: TextStyle(fontSize: 16, color: Colors.grey[800]),
        ),
        const SizedBox(height: 8),
        _buildBulletPoints([
          "Bakhshullah Wahid",
          "Abdul Wahab",
          "Rahat Manzoor",
          "Robina Mohd Karim",
        ]),
      ],
    );
  }

  Widget _buildContactInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.email, color: Colors.teal),
            const SizedBox(width: 8),
            Text(
              "Email: teaminnovators@example.com",
              style: TextStyle(color: Colors.grey[800]),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Icon(Icons.phone, color: Colors.teal),
            const SizedBox(width: 8),
            Text(
              "Phone: +123 456 7890",
              style: TextStyle(color: Colors.grey[800]),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Icon(Icons.location_on, color: Colors.teal),
            const SizedBox(width: 8),
            Text(
              "Location: Tech Hub, Innovation Street, City XYZ",
              style: TextStyle(color: Colors.grey[800]),
            ),
          ],
        ),
      ],
    );
  }
}
