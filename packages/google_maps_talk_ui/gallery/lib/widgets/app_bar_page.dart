import 'package:flutter/material.dart';
import 'package:google_maps_talk_ui/google_maps_talk_ui.dart';

class AppBarPage extends StatefulWidget {
  const AppBarPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const AppBarPage());
  }

  @override
  State<AppBarPage> createState() => _AppBarPage();
}

class _AppBarPage extends State<AppBarPage> {
  @override
  Widget build(BuildContext context) {
    const contentSpacing = UISpacing.sm;
    final appBarList = [
      const SizedBox(height: contentSpacing),
      UIAppBar.redAppBar(
        textTitle: 'Red AppBar',
      ),
      const SizedBox(height: contentSpacing),
      UIAppBar.actionAppBar(
        textTitle: 'Action AppBar',
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('App Assets')),
      body: Align(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: appBarList.map((appBar) {
              return appBar;
            }).toList(),
          ),
        ),
      ),
    );
  }
}
