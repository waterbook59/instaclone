import 'package:flutter/material.dart';
import 'package:instaclone/utils/constants.dart';
import 'package:instaclone/view/profile/components/sub/profile_bio.dart';
import 'package:instaclone/view/profile/components/sub/profile_image.dart';
import 'package:instaclone/view/profile/components/sub/profile_records.dart';

class ProfileDetailPart extends StatelessWidget {
  final ProfileMode mode;
  ProfileDetailPart({@required this.mode});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                  flex:1,
                  child: ProfileImage()),
              Expanded(
                  flex:3,
                  child: ProfileRecords()),
            ],
          ),
          SizedBox(height: 8,),
          ProfileBio(mode: mode,),

        ],
      ),
    );
  }
}
