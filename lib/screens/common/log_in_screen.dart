import 'package:attms/provider/provider_dashboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../firebase_function.dart';
import '../../provider/department_provider.dart';
import '../../provider/manager_provider.dart';

class LogInPage extends StatefulWidget {
  const LogInPage({super.key});

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  User? user;
  List<Map<String, dynamic>> dataList = [];
  @override
  void initState() {
    super.initState();
    // Trigger retrieval of departments and manager data
    Future.microtask(() {
      final ref = ProviderScope.containerOf(context, listen: false);
      ref.read(departmentProvider.notifier).retrieveDepartments();
      ref.read(managerProvider.notifier).retrieveManager();
    });
  }

  bool isShow = true;
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (_, WidgetRef ref, __) {
      bool switchCheck = ref.watch(isAdmin);
      final department = ref.watch(departmentProvider);
      final userss = ref.watch(managerProvider);

      // Format department and manager data after loading
      List<Map<String, dynamic>> formattedDepartments = department.map((dept) {
        return {
          'department_name': dept.departmentName,
          'department_id': dept.departmentId,
        };
      }).toList();

      List<Map<String, dynamic>> formattedManager = userss.map((dept) {
        return {
          "user_id": dept.userId,
          "user_name": dept.userName,
          "user_type": dept.userType,
          "email": dept.email,
          "password": dept.password,
          "department_id": dept.departmentId
        };
      }).toList();

      // Match departments to managers
      for (var i in formattedDepartments) {
        for (var j in formattedManager) {
          if (i['department_id'] == j['department_id']) {
            j['department_name'] = i['department_name'];
          }
        }
      }

      return Scaffold(
          body: Stack(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Text('Switch to Admin',
                style: TextStyle(color: Colors.black)),
            Transform.scale(
              scale: 0.8,
              child: Switch(
                  activeColor: Colors.blue,
                  inactiveThumbColor: Colors.black,
                  activeTrackColor: Colors.white,
                  value: switchCheck,
                  onChanged: (value) {
                    setState(() {
                      ref.read(isAdmin.notifier).adminTime();
                    });
                  }),
            ),
          ],
        ),
        Center(
          child: Opacity(
            opacity: 0.3,
            child: Image.asset(
              'assets/images/uot.png',
              scale: 1,
            ),
          ),
        ),
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Opacity(
                opacity: 0.8,
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                      border: Border.all(width: 1, color: Colors.black)),
                  width: MediaQuery.of(context).size.width * 0.6,
                  height: MediaQuery.of(context).size.height * 0.8,
                  child: Form(
                    key: formkey,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Container(
                                height: 20,
                                width: 100,
                                decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(5)),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 4.0, top: 8),
                              child: Container(
                                height: 20,
                                width: 20,
                                decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(25)),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Image.asset(
                          'assets/images/uot.png',
                          scale: 4,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        switchCheck
                            ? const Text('Welcome Admin',
                                style: TextStyle(color: Colors.black))
                            : const Text('Welcome Coordinator',
                                style: TextStyle(color: Colors.black)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: switchCheck
                              ? const Text(
                                  'Only the Admin should be using this login page with login credentials',
                                  textAlign: TextAlign.justify,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 10,
                                      fontWeight: FontWeight.normal))
                              : const Text(
                                  'Only the Coordinator should be using this login page with login credentials',
                                  textAlign: TextAlign.justify,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 10,
                                      fontWeight: FontWeight.normal)),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.18,
                          child: TextFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Email Required';
                              } else {
                                return null;
                              }
                            },
                            controller: email,
                            cursorHeight: 20,
                            style: const TextStyle(
                                fontSize: 15, color: Colors.black),
                            decoration: InputDecoration(
                              labelText: 'Username',
                              labelStyle: const TextStyle(
                                  fontSize: 10, color: Colors.black),
                              hintStyle: const TextStyle(fontSize: 10),
                              prefixIcon:
                                  const Icon(Icons.person, color: Colors.black),
                              prefixStyle: const TextStyle(fontSize: 10),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                                borderSide:
                                    const BorderSide(color: Colors.blue),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.18,
                          child: TextFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Password is required';
                              } else {
                                return null;
                              }
                            },
                            controller: password,
                            cursorHeight: 20,
                            style: const TextStyle(
                                fontSize: 15, color: Colors.black),
                            decoration: InputDecoration(
                              suffixIcon: IconButton(
                                  icon: Icon(isShow
                                          ? Icons.visibility_off
                                          : Icons.visibility
                                      // Change icon based on _obscureText state
                                      ),
                                  onPressed: () {
                                    setState(() {
                                      isShow =
                                          !isShow; // Toggle the password visibility
                                    });
                                  }),
                              labelText: 'Password',
                              labelStyle: const TextStyle(
                                  fontSize: 10, color: Colors.black),
                              hintStyle: const TextStyle(
                                fontSize: 10,
                              ),
                              prefixIcon: const Icon(Icons.password,
                                  color: Colors.black),
                              prefixStyle: const TextStyle(fontSize: 10),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                                borderSide:
                                    const BorderSide(color: Colors.blue),
                              ),
                            ),
                            obscureText: isShow ? true : false,
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        ElevatedButton(
                            onPressed: () async {
                              if (formkey.currentState!.validate() &&
                                  email.text.isNotEmpty &&
                                  password.text.isNotEmpty) {
                                var prefs2 =
                                    await SharedPreferences.getInstance();
                                if (ref.watch(isAdmin)) {
                                  // ignore: use_build_context_synchronously
                                  user = await signInWithEmailAndPassword(
                                      email.text,
                                      password.text,
                                      context,
                                      prefs2,
                                      ref);

                                  if (user != null) {
                                  } else {
                                    // ignore: use_build_context_synchronously
                                    await showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: const Text('Login Failed'),
                                          content: const Text(
                                              'Invalid email or password.'),
                                          actions: [
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              child: const Text('OK'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  }
                                } else {
                                  if (formattedManager.isNotEmpty) {
                                    for (var i in formattedManager) {
                                      if (i['email'] == email.text.toString() &&
                                          i['password'] ==
                                              password.text.toString()) {
                                        var prefsDepartment =
                                            await SharedPreferences
                                                .getInstance();
                                        prefsDepartment.setString(
                                            'department', i['department_name']);
                                        prefs2.setString('Email', email.text);

                                        ref
                                            .read(isLoginProvider.notifier)
                                            .loginTime();
                                      }
                                    }
                                  }
                                  // ignore: use_build_context_synchronously
                                  await showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text('Login Failed'),
                                        content: const Text(
                                            'Invalid email or password.'),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            child: const Text('OK'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                }
                              } else {}
                            },
                            child: const Text('Login'))
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ]));
    });
  }
}
