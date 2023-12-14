import 'package:flutter/material.dart';
import 'theme.dart';

//mainPage button
class MainButton extends StatelessWidget {
  const MainButton({super.key, required this.buttonName, required this.page});
  final String buttonName;
  final Widget page;
  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 17, 14, 158),
          padding: const EdgeInsets.all(50)),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => page,
          ),
        );
      },
      child: Text(
        buttonName,
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }
}

//speak_page theme button
class ThemeButton extends StatelessWidget {
  const ThemeButton({
    super.key,
    required this.setting,
    required this.firstText,
    required this.buttonName,
  });

  final Map setting;
  final String firstText;
  final String buttonName;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.7,
        child: TextButton(
          style: TextButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 17, 14, 158),
              padding: const EdgeInsets.all(25)),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ThemePage(
                    setting: setting,
                    firstText: firstText,
                    themeName: buttonName,
                  ),
                ));
          },
          child: Text(
            buttonName,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
