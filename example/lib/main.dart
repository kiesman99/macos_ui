import 'package:example/pages/buttons.dart';
import 'package:example/pages/colors_page.dart';
import 'package:example/pages/context_menu_page.dart';
import 'package:example/pages/dialogs_page.dart';
import 'package:example/pages/fields.dart';
import 'package:example/pages/indicators.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:macos_ui/src/library.dart';
import 'package:provider/provider.dart';

import 'theme.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppTheme(),
      builder: (context, _) {
        final appTheme = context.watch<AppTheme>();
        return MacosApp(
          title: 'macos_ui example',
          theme: MacosThemeData.light(),
          darkTheme: MacosThemeData.dark(),
          themeMode: appTheme.mode,
          debugShowCheckedModeBanner: false,
          home: Demo(),
        );
      },
    );
  }
}

class Demo extends StatefulWidget {
  @override
  _DemoState createState() => _DemoState();
}

class _DemoState extends State<Demo> {
  double ratingValue = 0;
  double sliderValue = 0;
  bool value = false;

  int pageIndex = 0;

  final List<Widget> pages = [
    ContextMenuPage(),
    CupertinoTabView(
      builder: (_) => ButtonsPage(),
    ),
    IndicatorsPage(),
    FieldsPage(),
    ColorsPage(),
    Center(child: Text('Disclosure item 2')),
    Center(child: Text('Disclosure item 3')),
    DialogsPage(),
  ];

  Color textLuminance(Color backgroundColor) {
    return backgroundColor.computeLuminance() > 0.5
        ? Colors.black
        : Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    return MacosWindow(
      child: IndexedStack(
        index: pageIndex,
        children: pages,
      ),
      sidebar: Sidebar(
        minWidth: 200,
        bottom: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(CupertinoIcons.profile_circled),
              const SizedBox(width: 8.0),
              Text('Tim Apple'),
            ],
          ),
        ),
        builder: (context, controller) {
          return SidebarItems(
            currentIndex: pageIndex,
            onChanged: (i) => setState(() => pageIndex = i),
            scrollController: controller,
            items: [
              SidebarItem(
                leading: Icon(CupertinoIcons.square_on_circle),
                label: Text('Buttons'),
              ),
              SidebarItem(
                leading: Icon(CupertinoIcons.arrow_2_circlepath),
                label: Text('Indicators'),
              ),
              SidebarItem(
                leading: Icon(CupertinoIcons.textbox),
                label: Text('Fields'),
              ),
              SidebarItem(
                label: Text('Disclosure'),
                disclosureItems: [
                  SidebarItem(
                    leading: Icon(CupertinoIcons.infinite),
                    label: Text('Colors'),
                  ),
                  SidebarItem(
                    leading: Icon(CupertinoIcons.heart),
                    label: Text('Item 2'),
                  ),
                  SidebarItem(
                    leading: Icon(CupertinoIcons.infinite),
                    label: Text('Item 3'),
                  ),
                ],
              ),
              SidebarItem(
                leading: Icon(CupertinoIcons.rectangle),
                label: Text('Dialogs'),
              ),
              SidebarItem(
                leading: Icon(CupertinoIcons.rectangle),
                label: Text('Context Menu'),
              ),
            ],
          );
        },
      ),
    );
  }
}
