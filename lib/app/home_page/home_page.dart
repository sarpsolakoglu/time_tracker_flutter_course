import 'package:flutter/material.dart';
import 'package:time_tracker_app/app/account/account_page.dart';
import 'package:time_tracker_app/app/home_page/cupertino_home_scaffold.dart';
import 'package:time_tracker_app/app/home_page/jobs/jobs_page.dart';
import 'package:time_tracker_app/app/home_page/tab_item.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TabItem _currentTab = TabItem.jobs;

  final Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys = {
    TabItem.jobs: GlobalKey<NavigatorState>(),
    TabItem.entries: GlobalKey<NavigatorState>(),
    TabItem.account: GlobalKey<NavigatorState>(),
  };

  final Map<TabItem, WidgetBuilder> widgetBuilders = {
    TabItem.jobs: (_) => JobsPage(),
    TabItem.entries: (_) => Container(),
    TabItem.account: (_) => AccountPage(),
  };

  void _select(TabItem tabItem) {
    if (tabItem == _currentTab) {
      navigatorKeys[tabItem]!.currentState!.popUntil((route) => route.isFirst);
    } else {
      setState(() {
        _currentTab = tabItem;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async =>
          !await navigatorKeys[_currentTab]!.currentState!.maybePop(),
      child: CupertinoHomeScaffold(
        currentTab: _currentTab,
        onSelectTab: _select,
        widgetBuilders: widgetBuilders,
        navigatorKeys: navigatorKeys,
      ),
    );
  }
}
