import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teacher_panel/screens/leaderboard_screen/controllers/leaderboard_controller.dart';
import 'package:teacher_panel/screens/leaderboard_screen/widgets/leaderboard_widget.dart';
import 'package:teacher_panel/core/widgets/custom_app_bar_with_title.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen>
    with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  final _controller = Get.find<LeaderboardController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWithTitle(
          onPressed: () => Get.back(), title: 'leaderboard'.tr),
      body: Column(
        children: [
          TabBar(
            dividerColor: Colors.transparent,
            controller: _tabController,
            onTap: (index) {
              final filters = ['today', 'week', 'month'];
              _controller.fetchLeaderboard(filters[index]);
            },
            tabs:  <Widget>[
              Tab(text: 'today'.tr),
              Tab(text: 'week'.tr),
              Tab(text: 'month'.tr),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                LeaderboardWidget(),
                LeaderboardWidget(),
                LeaderboardWidget(),
              ],
            ),
          )
        ],
      ),
    );
  }
}
