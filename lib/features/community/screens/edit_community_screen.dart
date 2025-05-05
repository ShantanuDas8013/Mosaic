import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mosaic/core/common/error_text.dart';
import 'package:mosaic/core/common/loader.dart';
import 'package:mosaic/core/constants/constants.dart';
import 'package:mosaic/core/utils.dart';
import 'package:mosaic/features/community/controller/commuity_controller.dart';
import 'package:mosaic/models/community_model.dart';
import 'package:mosaic/theme/pallete.dart';

class EditCommunityScreen extends ConsumerStatefulWidget {
  final String name;
  const EditCommunityScreen({super.key, required this.name});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditCommunityScreenState();
}

class _EditCommunityScreenState extends ConsumerState<EditCommunityScreen> {
  File? bannerFile;
  File? profileFile;
  void selectBannerImage() async {
    final res = await pickImage();
    if (res != null) {
      setState(() {
        bannerFile = File(res.files.first.path!);
      });
    }
  }

  void selectProfileImage() async {
    final res = await pickImage();
    if (res != null) {
      setState(() {
        profileFile = File(res.files.first.path!);
      });
    }
  }

  void save(Community community) {
    ref
        .read(communityControllerProvider.notifier)
        .editCommunity(
          profileFile: profileFile,
          bannerFile: bannerFile,
          context: context,
          community: community,
        );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(communityControllerProvider);
    return ref
        .watch(getCommunityByNameProvider(widget.name))
        .when(
          data:
              (community) => Scaffold(
                backgroundColor:
                    Pallete.darkModeAppTheme.scaffoldBackgroundColor,
                appBar: AppBar(
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  title: Text('Edit Community'),
                  centerTitle: false,
                  actions: [
                    TextButton(
                      onPressed: () {
                        save(community);
                      },
                      child: Text(
                        'Save',
                        style: TextStyle(color: Colors.blueAccent),
                      ),
                    ),
                  ],
                ),
                body:
                    isLoading
                        ? const Loader()
                        : Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 200,
                                child: Stack(
                                  children: [
                                    GestureDetector(
                                      onTap: selectBannerImage,
                                      child: DottedBorder(
                                        borderType: BorderType.RRect,
                                        radius: Radius.circular(10),
                                        dashPattern: [10, 4],
                                        strokeCap: StrokeCap.round,
                                        color:
                                            Pallete
                                                .darkModeAppTheme
                                                .textTheme
                                                .bodyMedium!
                                                .color!,
                                        child: Container(
                                          width: double.infinity,
                                          height: 150,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                          child:
                                              bannerFile != null
                                                  ? Image.file(bannerFile!)
                                                  : community.banner.isEmpty ||
                                                      community.banner ==
                                                          Constants
                                                              .bannerDefault
                                                  ? const Center(
                                                    child: Icon(
                                                      Icons.camera_alt_outlined,
                                                      size: 40,
                                                    ),
                                                  )
                                                  : Image.network(
                                                    community.banner,
                                                  ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 20,
                                      left: 20,
                                      child: GestureDetector(
                                        onTap: selectProfileImage,
                                        child:
                                            profileFile != null
                                                ? CircleAvatar(
                                                  backgroundImage: FileImage(
                                                    profileFile!,
                                                  ),
                                                  radius: 23,
                                                )
                                                : CircleAvatar(
                                                  backgroundImage: NetworkImage(
                                                    community.avatar,
                                                  ),
                                                  radius: 23,
                                                ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
              ),
          loading: () => const Loader(),
          error: (error, stackTrace) => ErrorText(error: error.toString()),
        );
  }
}
