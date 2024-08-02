import 'package:easy_home/utilities/ui/screen_size.dart';
import 'package:flutter/material.dart';

import '../constant/routes.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final size = Screen(MediaQuery.of(context).size);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(
                top: size.hp(7),
              ),
              child: Text('Redefining Your Home',
                  style: Theme.of(context).textTheme.headlineMedium!),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: size.hp(2)),
              child: Text('Search Experience',
                  style: Theme.of(context).textTheme.headlineMedium!),
            ),
            SizedBox(
              height: size.hp(5),
            ),
            Image.asset(
              'assets/landing_page.png',
              width: size.wp(100),
            ),
            SizedBox(
              height: size.hp(5),
            ),
            Text(
              'Welcome to Easy Home',
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium!
                  .copyWith(color: Theme.of(context).primaryColor),
            ),
            const SizedBox(
              height: 100,
            ),
            ElevatedButton(
              style: ButtonStyle(
                elevation: const WidgetStatePropertyAll(10.0),
                animationDuration: const Duration(seconds: 2),
                enableFeedback: true,
                padding: WidgetStatePropertyAll(
                  EdgeInsets.symmetric(
                    vertical: size.hp(2),
                    horizontal: size.wp(30),
                  ),
                ),
              ),
              onPressed: () async {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(loginRoute, (route) => false);
              },
              child: const Text('Login'),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              style: ButtonStyle(
                elevation: const WidgetStatePropertyAll(10.0),
                animationDuration: const Duration(seconds: 2),
                enableFeedback: true,
                padding: WidgetStatePropertyAll(
                  EdgeInsets.symmetric(
                    vertical: size.hp(2),
                    horizontal: size.wp(29),
                  ),
                ),
              ),
              onPressed: () async {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(registerRoute, (route) => false);
              },
              child: const Text('Register'),
            )
          ],
        ),
      ),
    );
  }
}
