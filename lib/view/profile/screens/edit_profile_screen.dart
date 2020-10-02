import 'package:flutter/material.dart';
import 'package:instaclone/generated/l10n.dart';
import 'package:instaclone/style.dart';
import 'package:instaclone/view/common/components/circle_photo.dart';
import 'package:instaclone/view/common/dialog/confirm_dialog.dart';
import 'package:instaclone/view_models/profile_view_model.dart';
import 'package:provider/provider.dart';

//テキストフィールドが入ってくるのでStatefulで
class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  bool _isImageFromFile = false;
  String _photoUrl = '';
  TextEditingController _nameController = TextEditingController();
  TextEditingController _bioController = TextEditingController();

  @override
  void initState() {
    final profileViewModel =
        Provider.of<ProfileViewModel>(context, listen: false);
    final profileUser = profileViewModel.profileUser;
    _isImageFromFile = false;
    _photoUrl = profileUser.photoUrl;

    _nameController.text = profileUser.inAppUserName;
    _bioController.text = profileUser.bio;
    super.initState();
  }

  @override
  void dispose() {

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(S.of(context).editProfile),
        actions: [
          IconButton(
            icon: Icon(Icons.done),
            //ダイアログ・更新
            onPressed: () => showConfirmDialog(
                context: context,
                title: S.of(context).editProfile,
                content: S.of(context).editProfileConfirm,
                onConfirmed: (isConfirmed) {
                  isConfirmed ? _updateProfile(context) : Container();
                }),
          )
        ],
      ),
      body: Consumer<ProfileViewModel>(
        builder: (_, model, child) {
          return model.isProcessing
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 16,
                        ),
                        Center(
                          //画像だけはセンター
                          child: CirclePhoto(
                            radius: 60,
                            isImageFromFile: _isImageFromFile,
                            photoUrl: _photoUrl,
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Center(
                          child: InkWell(
                            //プロフィール写真を変更
                            onTap: () => _pickNewProfileImage(),
                            child: Text(
                              S.of(context).changeProfilePhoto,
                              style: changeProfilePhotoTextStyle,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Text(
                          'Name',
                          style: editProfileTitleTextStyle,
                        ),
                        TextField(
                          controller: _nameController,
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Text(
                          'Bio',
                          style: editProfileTitleTextStyle,
                        ),
                        TextField(
                          controller: _bioController,
                        ),
                      ],
                    ),
                  ),
                );
        },
      ),
    );
  }

  Future<void> _pickNewProfileImage() async {
    _isImageFromFile = false;
    final profileViewModel =
        Provider.of<ProfileViewModel>(context, listen: false);
    _photoUrl = await profileViewModel.pickProfileImage();
    setState(() {
      _isImageFromFile = true;
    });
  }

  //写真と名前とbioを更新（写真はファイルから持ってきてるかそうでないか確認必要）
  void _updateProfile(BuildContext context) async {
    final profileViewModel =
        Provider.of<ProfileViewModel>(context, listen: false);

    await profileViewModel.updateProfile(
      _nameController.text,
      _bioController.text,
      _photoUrl,
      _isImageFromFile,
    );
    Navigator.pop(context);
  }
}
