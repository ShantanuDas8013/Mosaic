import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mosaic/core/common/error_text.dart';
import 'package:mosaic/core/common/loader.dart';
import 'package:mosaic/core/utils.dart';
import 'package:mosaic/features/community/controller/commuity_controller.dart';
import 'package:mosaic/features/post/controller/post_controller.dart';
import 'package:mosaic/models/community_model.dart';

class AddPostTypeScreen extends ConsumerStatefulWidget {
  final String type;
  const AddPostTypeScreen({required this.type, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddPostTypeScreenState();
}

class _AddPostTypeScreenState extends ConsumerState<AddPostTypeScreen> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final linkController = TextEditingController();
  File? bannerFile;
  List<Community> communities = [];
  Community? selectedCommunity;

  void selectBannerImage() async {
    final res = await pickImage();
    if (res != null) {
      setState(() {
        bannerFile = File(res.files.first.path!);
      });
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    linkController.dispose();
    super.dispose();
  }

  void sharePost() {
    if (widget.type == 'image' &&
        (bannerFile != null || bannerFile != null) &&
        titleController.text.isNotEmpty) {
      ref
          .read(postControllerProvider.notifier)
          .shareImagePost(
            context: context,
            title: titleController.text.trim(),
            selectedCommunity: selectedCommunity ?? communities[0],
            file: bannerFile,
          );
    } else if (widget.type == 'text' && titleController.text.isNotEmpty) {
      ref
          .read(postControllerProvider.notifier)
          .shareTextPost(
            context: context,
            title: titleController.text.trim(),
            selectedCommunity: selectedCommunity ?? communities[0],
            description: descriptionController.text.trim(),
          );
    } else if (widget.type == 'link' &&
        titleController.text.isNotEmpty &&
        linkController.text.isNotEmpty) {
      ref
          .read(postControllerProvider.notifier)
          .shareLinkPost(
            context: context,
            title: titleController.text.trim(),
            selectedCommunity: selectedCommunity ?? communities[0],
            link: linkController.text.trim(),
          );
    } else {
      showSnackBar(context, 'Please enter all the fields');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isTypeImage = widget.type == 'image';
    final isTypeText = widget.type == 'text';
    final isTypeLink = widget.type == 'link';
    final isLoading = ref.watch(postControllerProvider);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text('Post ${widget.type}'),
        actions: [
          TextButton(
            onPressed: sharePost,
            child: const Text(
              'Share',
              style: TextStyle(color: Colors.blueAccent),
            ),
          ),
        ],
      ),
      backgroundColor:
          isDarkMode ? const Color(0xFF121212) : Colors.grey.shade100,
      body:
          isLoading
              ? const Loader()
              : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Card(
                        elevation: 2,
                        margin: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: TextField(
                            controller: titleController,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor:
                                  isDarkMode
                                      ? const Color(0xFF1E1E1E)
                                      : Colors.white,
                              hintText: 'Enter Title here',
                              hintStyle: TextStyle(
                                color:
                                    isDarkMode
                                        ? Colors.grey.shade500
                                        : Colors.grey.shade400,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.all(16),
                            ),
                            maxLength: 30,
                            style: TextStyle(
                              color: isDarkMode ? Colors.white : Colors.black87,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      if (isTypeImage)
                        Card(
                          elevation: 2,
                          margin: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: GestureDetector(
                              onTap: selectBannerImage,
                              child: DottedBorder(
                                borderType: BorderType.RRect,
                                radius: const Radius.circular(10),
                                dashPattern: const [10, 4],
                                strokeCap: StrokeCap.round,
                                color: Theme.of(
                                  context,
                                ).colorScheme.primary.withAlpha(150),
                                child: Container(
                                  width: double.infinity,
                                  height: 180,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary.withAlpha(20),
                                  ),
                                  child:
                                      bannerFile != null
                                          ? ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                            child: Image.file(
                                              bannerFile!,
                                              fit: BoxFit.cover,
                                            ),
                                          )
                                          : Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons
                                                    .add_photo_alternate_outlined,
                                                size: 50,
                                                color:
                                                    Theme.of(
                                                      context,
                                                    ).colorScheme.primary,
                                              ),
                                              const SizedBox(height: 10),
                                              Text(
                                                'Select an image',
                                                style: TextStyle(
                                                  color:
                                                      Theme.of(
                                                        context,
                                                      ).colorScheme.primary,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                ),
                              ),
                            ),
                          ),
                        ),

                      if (isTypeText)
                        Card(
                          elevation: 2,
                          margin: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: TextField(
                              controller: descriptionController,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor:
                                    isDarkMode
                                        ? const Color(0xFF1E1E1E)
                                        : Colors.white,
                                hintText: 'Enter Description here',
                                hintStyle: TextStyle(
                                  color:
                                      isDarkMode
                                          ? Colors.grey.shade500
                                          : Colors.grey.shade400,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: const EdgeInsets.all(16),
                              ),
                              maxLines: 5,
                              style: TextStyle(
                                color:
                                    isDarkMode ? Colors.white : Colors.black87,
                              ),
                            ),
                          ),
                        ),

                      if (isTypeLink)
                        Card(
                          elevation: 2,
                          margin: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: TextField(
                              controller: linkController,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor:
                                    isDarkMode
                                        ? const Color(0xFF1E1E1E)
                                        : Colors.white,
                                hintText: 'Enter link here',
                                hintStyle: TextStyle(
                                  color:
                                      isDarkMode
                                          ? Colors.grey.shade500
                                          : Colors.grey.shade400,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: const EdgeInsets.all(16),
                              ),
                              style: TextStyle(
                                color:
                                    isDarkMode ? Colors.white : Colors.black87,
                              ),
                            ),
                          ),
                        ),

                      const SizedBox(height: 20),

                      const Text(
                        'Select Community',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),

                      const SizedBox(height: 8),

                      ref
                          .watch(userCommunitiesProvider)
                          .when(
                            data: (data) {
                              communities = data;
                              if (data.isEmpty) {
                                return const SizedBox();
                              }
                              return Card(
                                elevation: 2,
                                margin: EdgeInsets.zero,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0,
                                  ),
                                  child: DropdownButton(
                                    value: selectedCommunity ?? data[0],
                                    items:
                                        data
                                            .map(
                                              (e) => DropdownMenuItem(
                                                value: e,
                                                child: Text(e.name),
                                              ),
                                            )
                                            .toList(),
                                    onChanged: (val) {
                                      setState(() {
                                        selectedCommunity = val;
                                      });
                                    },
                                    underline: const SizedBox(),
                                    isExpanded: true,
                                  ),
                                ),
                              );
                            },
                            error:
                                (error, stackTrace) =>
                                    ErrorText(error: error.toString()),
                            loading: () => const Loader(),
                          ),
                    ],
                  ),
                ),
              ),
    );
  }
}
