import 'package:easy_home/constant/routes.dart';
import 'package:easy_home/views/property/advance_search.dart';
import 'package:easy_home/views/property/favourite_property_vew.dart';
import 'package:easy_home/views/property/home_page.dart';
// import 'package:easy_home/views/test_notification.dart';
import 'package:easy_home/views/user/user_dashboard.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class NavigationView extends StatefulWidget {
  const NavigationView({super.key});

  @override
  State<NavigationView> createState() => _NavigationViewState();
}

class _NavigationViewState extends State<NavigationView> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    const HomePage(),
    const AdvancedSearchPage(),
    const FavoritePropertiesPage(),
    const DashboardPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> notificationIneraction() async {
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      gotoNotification(initialMessage);
    }
    FirebaseMessaging.onMessageOpenedApp.listen(gotoNotification);
  }

  void gotoNotification(RemoteMessage message) {
    Navigator.pushNamed(context, notificationRoute);
  }

  @override
  void initState() {
    notificationIneraction();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 6.0,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.home),
              color: _selectedIndex == 0
                  ? Theme.of(context).primaryColor
                  : Theme.of(context).disabledColor,
              onPressed: () => _onItemTapped(0),
            ),
            IconButton(
              icon: const Icon(Icons.search),
              color: _selectedIndex == 1
                  ? Theme.of(context).primaryColor
                  : Theme.of(context).disabledColor,
              onPressed: () => _onItemTapped(1),
            ),
            const SizedBox(width: 40), // The dummy child for the notch space
            IconButton(
              icon: const Icon(Icons.favorite),
              color: _selectedIndex == 2
                  ? Theme.of(context).primaryColor
                  : Theme.of(context).disabledColor,
              onPressed: () => _onItemTapped(2),
            ),
            IconButton(
              icon: const Icon(Icons.dashboard),
              color: _selectedIndex == 3
                  ? Theme.of(context).primaryColor
                  : Theme.of(context).disabledColor,
              onPressed: () => _onItemTapped(3),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, addPropertyRoute),
        tooltip: 'Add Property',
        child: const Icon(Icons.add),
      ),
    );
  }
}
