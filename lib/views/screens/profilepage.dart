import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:auksion_app/views/screens/loginpage.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class Profilepage extends StatefulWidget {
  const Profilepage({super.key});

  @override
  State<Profilepage> createState() => _ProfilepageState();
}

class _ProfilepageState extends State<Profilepage> {
  bool isDark = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.tr('profile_page'),
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () async {
                final themeode = await AdaptiveTheme.getThemeMode();
                if (themeode == AdaptiveThemeMode.dark) {
                  isDark = !isDark;
                  AdaptiveTheme.of(context).setLight();
                } else {
                  isDark = !isDark;
                  AdaptiveTheme.of(context).setDark();
                }
              },
              icon: isDark ? Icon(Icons.dark_mode) : Icon(Icons.light_mode))
        ],
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(5),
            ),
            Column(
              children: [
                ZoomTapAnimation(
                  child: CircleAvatar(
                    radius: 80,
                    backgroundImage: NetworkImage('https://i.pravatar.cc/300'),
                  ),
                ),
                Gap(10),
                ElevatedButton(
                  onPressed: () {
                    // Navigator.pushReplacement(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) =>  EditProfilePage(
                    //     ),
                    //   ),
                    // );
                  },
                  child: Text(
                    context.tr('edit_profile'),
                  ),
                ),
                Gap(300),
                ZoomTapAnimation(
                  onTap: () async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    prefs.remove('token');
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Loginpage()));
                  },
                  child: Container(
                    width: 250,
                    height: 50,
                    decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10)),
                    child: Center(
                      child: Text(
                        'Logout',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
