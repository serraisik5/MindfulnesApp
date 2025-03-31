import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:minder_frontend/helpers/constants/colors.dart';
import 'package:minder_frontend/helpers/constants/strings.dart';
import 'package:minder_frontend/modules/start%20meditation/views/widgets/meditate_view.dart';
import 'package:minder_frontend/widgets/custom_app_bar.dart';

class StartMeditationView extends StatefulWidget {
  const StartMeditationView({super.key});

  @override
  State<StartMeditationView> createState() => _StartMeditationViewState();
}

class _StartMeditationViewState extends State<StartMeditationView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBackground,
      appBar: CustomAppBar(
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: appPrimary,
          indicator: const UnderlineTabIndicator(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(width: 3.0, color: appPrimary),
            insets: EdgeInsets.symmetric(horizontal: 5.0),
          ),
          labelColor: appPrimary,
          unselectedLabelColor: appTertiary,
          tabs: [
            Tab(text: MEDITATE),
            Tab(text: JOURNAL),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          MeditateView(),
          Center(child: Text("Diary Content")),
        ],
      ),
    );
  }
}
