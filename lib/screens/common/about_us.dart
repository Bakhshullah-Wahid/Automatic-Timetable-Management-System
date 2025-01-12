import 'package:attms/provider/dashboard_provider.dart';
import 'package:attms/services/freeSlots/fetch_free_slots.dart';
import 'package:attms/utils/data/fetching_data.dart';
import 'package:attms/widget/title_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../provider/provider_dashboard.dart';
import '../../widget/coordinator/drawer_box.dart';
import '../../widget/manager/manager_drawer.dart';

class AboutUs extends StatefulWidget {
  const AboutUs({super.key});

  @override
  State<AboutUs> createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer(builder: (context, ref, child) {
        late bool isAdminPages = ref.watch(isAdmin);
        final bool mobileCheck = ref.watch(mobileDrawer);
        return Container(
          color: Colors.white,
          child: Stack(
            children: [
              Column(
                children: [
                  TitleContainer(
                    description: 'Decription about us',
                    pageTitle: 'About Us',
                  ),
                  Consumer(
                    builder: (context, ref, child) => ElevatedButton(
                        onPressed: () async {
                          await freeSlotAdding(ref);
                        },
                        child: Text('About Us')),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Container(
                        color: Colors
                            .white, // Light background color for readability
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
                              "We are Team Innovators, a group of passionate developers creating cutting-edge Windows and Mobile applications. "
                              "Our goal is to deliver robust, scalable, and user-friendly solutions that enhance productivity and solve real-world problems.",
                              style: TextStyle(
                                  fontSize: 16, color: Colors.grey[800]),
                              textAlign: TextAlign.justify,
                            ),
                            const SizedBox(height: 24),

                            // Mission Section
                            _buildSectionHeader("Our Mission"),
                            const SizedBox(height: 8),
                            Text(
                              "To innovate, inspire, and deliver excellence in technology solutions. We aim to empower individuals and organizations "
                              "by creating applications that meet their evolving needs.",
                              style: TextStyle(
                                  fontSize: 16, color: Colors.grey[800]),
                              textAlign: TextAlign.justify,
                            ),
                            const SizedBox(height: 24),

                            // Vision Section
                            _buildSectionHeader("Our Vision"),
                            const SizedBox(height: 8),
                            Text(
                              "To be a global leader in technology solutions by fostering creativity, embracing innovation, and maintaining a customer-centric approach.",
                              style: TextStyle(
                                  fontSize: 16, color: Colors.grey[800]),
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
                              "Developed over 2 successful Windows applications.",
                              "Awarded 'Emerging Team in Tech' 2024.",
                              "Partnered with University of Turbat for tech workshops.",
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
                              style: TextStyle(
                                  fontSize: 16, color: Colors.grey[800]),
                              textAlign: TextAlign.justify,
                            ),
                            const SizedBox(height: 8),
                            SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: _buildContactInfo()),
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
              mobileCheck
                  ? isAdminPages
                      ? ManagerDrawerBox()
                      : DrawerBox()
                  : SizedBox.shrink(),
            ],
          ),
        );
      }),
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
          "- Supervisor: Mamoon Rasheed(IT Specialist)",
          style: TextStyle(fontSize: 16, color: Colors.grey[800]),
        ),
        const SizedBox(height: 8),
        Text(
          "- Team Members:",
          style: TextStyle(fontSize: 16, color: Colors.grey[800]),
        ),
        const SizedBox(height: 8),
        _buildBulletPoints([
          "Bakhshullah Wahid (Team Lead)",
          "Abdul Wahab (Assistant Team Lead)",
          "Rahat Manzoor (Documentation Lead)",
          "Robina Mohd Karim(Documentation Assistant)",
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
            Icon(Icons.email, color: Colors.teal),
            SizedBox(width: 8),
            Text(
              "Email: bakhshullahwahid205@gmail.com",
              style: TextStyle(color: Colors.grey[800]),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(Icons.phone, color: Colors.teal),
            SizedBox(width: 8),
            Text(
              "Phone: 03202906160",
              style: TextStyle(color: Colors.grey[800]),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(Icons.location_on, color: Colors.teal),
            SizedBox(width: 8),
            Text(
              "Location: University of Turbat, Kech, Balochistan",
              style: TextStyle(color: Colors.grey[800]),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> freeSlotAdding(ref) async {
    List days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
    ];
    FreeSlotServices free = FreeSlotServices();
    FetchingDataCall f = FetchingDataCall();

    var bak = await f.classs(ref);
    for (var i = 0; i < bak.length; i++) {
      for (var j = 0; j < days.length; j++) {
        await free.addFreeSlot(
            bak[i]['class_id'], '9:30 AM', bak[i]['department_id'], days[j]);
        await free.addFreeSlot(
            bak[i]['class_id'], '11:30 AM', bak[i]['department_id'], days[j]);
        if (days[j] != 'Friday') {
          await free.addFreeSlot(
              bak[i]['class_id'], '1:30 PM', bak[i]['department_id'], days[j]);
        } else {
          await free.addFreeSlot(
              bak[i]['class_id'], '2:30 PM', bak[i]['department_id'], days[j]);
        }
      }
    }
  }
}
