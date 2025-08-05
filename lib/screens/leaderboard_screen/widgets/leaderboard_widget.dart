import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:teacher_panel/screens/leaderboard_screen/controllers/leaderboard_controller.dart';
import 'package:teacher_panel/core/utils/app_colors.dart';
import 'package:teacher_panel/core/utils/app_const_functions.dart';


class LeaderboardWidget extends StatelessWidget {
  const LeaderboardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LeaderboardController>(builder: (controller) {
      if (controller.isLoading) {
        return AppConstFunctions.customCircularProgressIndicator;
      }
      final topUsers = controller.leaderboardUsers.take(3).toList();
      final otherUsers = controller.leaderboardUsers.skip(3).toList();

      return Column(
        children: [
          if (topUsers.length >= 3)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 12.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // 🥈 Rank 2 (left)
                  _buildLeaderItem(
                    rank: 2,
                    image: 'https://i.pravatar.cc/150?img=4',
                    userName: topUsers[1].username,
                    score: topUsers[1].totalScore.toString(),
                    context: context,
                  ),
                  // 🥇 Rank 1 (center)
                  _buildLeaderItem(
                    rank: 1,
                    image: 'https://i.pravatar.cc/150?img=4',
                    userName: topUsers[0].username,
                    score: topUsers[0].totalScore.toString(),
                    context: context,
                    crown: true,
                  ),
                  // 🥉 Rank 3 (right)
                  _buildLeaderItem(
                    rank: 3,
                    image: 'https://i.pravatar.cc/150?img=4',
                    userName: topUsers[2].username,
                    score: topUsers[2].totalScore.toString(),
                    context: context,
                  ),
                ],
              ),
            ),
          Expanded(
            child: otherUsers.isEmpty
                ? Center(child: Text('no_more_users'.tr))
                : ListView.separated(
                    itemCount: otherUsers.length,
                    itemBuilder: (context, index) => _buildRankListItem(
                      rank: index + 4,
                      image: 'https://i.pravatar.cc/150?img=4',
                      userName: otherUsers[index].username,
                      score: otherUsers[index].totalScore.toString(),
                      context: context,
                    ),
                    separatorBuilder: (context, index) => Gap(2.h),
                  ),
          )
        ],
      );
    });
  }

  Widget _buildLeaderItem({
    required int rank,
    required String image,
    required String userName,
    required String score,
    bool crown = false,
    required BuildContext context,
  }) {
    return Expanded(
      child: Column(
        children: [
          Text(
            rank.toString(),
            style: Theme.of(context)
                .textTheme
                .titleSmall!
                .copyWith(color: AppColors.primaryClr),
          ),
          if (crown) Icon(Icons.emoji_events, color: Colors.amber, size: 40.sp),
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: crown
                  ? LinearGradient(
                      colors: [AppColors.primaryClr, Colors.white],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : null,
              border: Border.all(
                color: crown ? Colors.amber : AppColors.primaryClr,
                width: crown ? 3.w : 2.w,
              ),
            ),
            padding: EdgeInsets.all(4.w),
            child: CircleAvatar(
              radius: crown ? 40.r : 30.r,
              backgroundImage: NetworkImage(image),
            ),
          ),
          Gap(4.h),
          Text(userName, style: Theme.of(context).textTheme.bodyMedium, textAlign: TextAlign.center,),
          Text(score,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(color: AppColors.greenClr)),
        ],
      ),
    );
  }

  Widget _buildRankListItem({
    required int rank,
    required String image,
    required String userName,
    required String score,
    required BuildContext context,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
        child: Row(
          children: [
            Text(
              '$rank',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(color: AppColors.primaryClr),
            ),
            Gap(20.w),
            CircleAvatar(radius: 25.r, backgroundImage: NetworkImage(image)),
            Gap(20.w),
            Expanded(
              child:
                  Text(userName, style: Theme.of(context).textTheme.bodyMedium),
            ),
            Text(score,
                style: Theme.of(context)
                    .textTheme
                    .titleSmall!
                    .copyWith(color: AppColors.greenClr)),
          ],
        ),
      ),
    );
  }
}
