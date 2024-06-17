import 'package:auksion_app/controllers/authcontroller.dart';
import 'package:auksion_app/views/screens/adminpage.dart';
import 'package:auksion_app/views/screens/homepage.dart';
import 'package:auksion_app/views/screens/registerpage.dart';
import 'package:auksion_app/views/screens/sellerpage.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class Loginpage extends StatefulWidget {
  const Loginpage({super.key});

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  final authcontroller = Authcontroller();
  final emailcontroller = TextEditingController();
  final passwordcontroller = TextEditingController();
  final formkey = GlobalKey<FormState>();
  bool isLoading = false;
  bool obscureChange = true;
  List admins = ['admin'];
  int selectedRole = 0;

  void changeobscure() {
    setState(() {
      obscureChange = !obscureChange;
    });
  }

  Future<void> submit() async {
    if (formkey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      try {
        final email = emailcontroller.text.trim();
        await authcontroller.login(email, passwordcontroller.text.trim());

        print('Logged in with email: $email');

        if (admins.contains(email)) {
          SharedPreferences sharedPreferences =
              await SharedPreferences.getInstance();
          sharedPreferences.setString('userData', 'email');

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (ctx) => Adminpage(),
            ),
          );
        } else if (selectedRole == 0) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (ctx) => Homepage(),
            ),
          );
        } else {
          await authcontroller.changepass(email);
          showDialog(
            context: context,
            builder: (context) {
              return const AlertDialog(
                content: Text('Password reset email sent!'),
              );
            },
          );
          Navigator.pop(context);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (ctx) => Sellerpage(),
            ),
          );
        }

        emailcontroller.clear();
        passwordcontroller.clear();
      } catch (e) {
        showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              title: Text(context.tr('error')),
              content: Text(e.toString()),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );

        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Form(
        key: formkey,
        child: Container(
          decoration: const BoxDecoration(
            color: Color(0xFF236EAC),
          ),
          width: double.infinity,
          height: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Text(
                    context.tr('auksion'),
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          blurRadius: 10.0,
                          color: Colors.black,
                          offset: Offset(5.0, 5.0),
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    DropdownButton(
                        value: context.locale,
                        items: const [
                          DropdownMenuItem(
                            value: Locale('uz'),
                            child: Text('🇺🇿'),
                          ),
                          DropdownMenuItem(
                            value: Locale('en'),
                            child: Text('🇺🇸'),
                          ),
                          DropdownMenuItem(
                            value: Locale('ru'),
                            child: Text('🇷🇺'),
                          )
                        ],
                        onChanged: (value) {
                          context.setLocale(value!);
                          setState(() {});
                        })
                  ],
                ),
                const SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      children: [
                        Radio<int>(
                          value: 0,
                          fillColor: MaterialStateProperty.all(Colors.yellow),
                          groupValue: selectedRole,
                          onChanged: (int? value) {
                            setState(() {
                              selectedRole = value!;
                            });
                          },
                        ),
                        Text(
                          context.tr('user'),
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Radio<int>(
                          value: 1,
                          fillColor: MaterialStateProperty.all(Colors.red),
                          groupValue: selectedRole,
                          onChanged: (int? value) {
                            setState(() {
                              selectedRole = value!;
                            });
                          },
                        ),
                        Text(
                          context.tr('seller'),
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return context.tr('email_no_input');
                    }
                    return null;
                  },
                  controller: emailcontroller,
                  decoration: InputDecoration(
                    fillColor: Colors.black26,
                    focusColor: Colors.blue.shade300,
                    filled: true,
                    labelText: context.tr('email'),
                    hintText: 'Input your email',
                    labelStyle: const TextStyle(color: Colors.grey),
                    prefixIcon: const Icon(Icons.email_outlined),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  obscureText: obscureChange,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return context.tr('password_no_input');
                    }
                    return null;
                  },
                  controller: passwordcontroller,
                  decoration: InputDecoration(
                    suffixIcon: ZoomTapAnimation(
                      onTap: changeobscure,
                      child: obscureChange
                          ? const Icon(Icons.remove_red_eye_outlined)
                          : const Icon(CupertinoIcons.eye_slash_fill),
                    ),
                    focusColor: Colors.blue.shade300,
                    prefixIcon: const Icon(Icons.password_outlined),
                    fillColor: Colors.black26,
                    filled: true,
                    labelText: context.tr('password'),
                    labelStyle: const TextStyle(color: Colors.grey),
                    hintText: 'Input your password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                isLoading
                    ? const CircularProgressIndicator()
                    : Column(
                        children: [
                          InkWell(
                            onTap: submit,
                            child: Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.all(10),
                              width: 200,
                              height: 55,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.blue),
                              child: Text(
                                context.tr('sign_in'),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 40,
                                height: 1,
                                color: Colors.black,
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (ctx) {
                                        return const Registerpage();
                                      },
                                    ),
                                  );
                                },
                                child: Text(
                                  context.tr('sign_up'),
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                              ),
                              Container(
                                width: 40,
                                height: 1,
                                color: Colors.black,
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 30,
                                height: 1,
                                color: Colors.black,
                              ),
                              TextButton(
                                onPressed: () async {
                                  try {
                                    print(emailcontroller.text);
                                    await authcontroller
                                        .changepass(emailcontroller.text);
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          content: const Text(
                                              'Emailinigiz tekshirib, o`z parolingizni almashtrish uchun'),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text('OK'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  } catch (e) {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: const Text("Error"),
                                          content: Text(e.toString()),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text('OK'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  }
                                },
                                child: Text(context.tr('reset_password'),
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    )),
                              ),
                              Container(
                                width: 30,
                                height: 1,
                                color: Colors.black,
                              ),
                            ],
                          ),
                        ],
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
