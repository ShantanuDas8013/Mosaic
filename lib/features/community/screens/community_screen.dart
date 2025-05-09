import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mosaic/core/common/error_text.dart';
import 'package:mosaic/core/common/loader.dart';
import 'package:mosaic/core/common/post_card.dart';
import 'package:mosaic/features/auth/controller/auth_controller.dart';
import 'package:mosaic/features/community/controller/commuity_controller.dart';
import 'package:mosaic/features/community/screens/mod_tools_screen.dart';
import 'package:mosaic/models/community_model.dart';

class CommunityScreen extends ConsumerStatefulWidget {
  final String name;
  const CommunityScreen({required this.name, super.key});

  @override
  ConsumerState<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends ConsumerState<CommunityScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void navigateToModTools(BuildContext context) {
    _scaffoldKey.currentState?.openEndDrawer();
  }

  void joinCommunity(Community community, BuildContext context) {
    ref
        .read(communityControllerProvider.notifier)
        .joinCommunity(community, context);
  }

  void _showEnlargedImage(String imageUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.zero,
          child: Stack(
            alignment: Alignment.center,
            children: [
              InteractiveViewer(
                panEnabled: true,
                boundaryMargin: const EdgeInsets.all(20),
                minScale: 0.5,
                maxScale: 4,
                child: Image.network(imageUrl, fit: BoxFit.contain),
              ),
              Positioned(
                top: 20,
                right: 20,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white, size: 30),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider)!;
    final isGuest = !user.isAuthenticated;

    return Scaffold(
      key: _scaffoldKey,
      endDrawer: ModToolsScreen(name: widget.name),
      endDrawerEnableOpenDragGesture: false,
      body: ref
          .watch(getCommunityByNameProvider(widget.name))
          .when(
            data:
                (community) => NestedScrollView(
                  headerSliverBuilder: (context, innerBoxIsScrolled) {
                    return [
                      SliverAppBar(
                        expandedHeight: 250,
                        floating: true,
                        snap: true,
                        flexibleSpace: Stack(
                          children: [
                            Positioned.fill(
                              child: GestureDetector(
                                onTap:
                                    () => _showEnlargedImage(community.banner),
                                child: Image.network(
                                  community.banner,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.bottomLeft,
                              padding: const EdgeInsets.all(
                                20,
                              ).copyWith(bottom: 70),
                              child: GestureDetector(
                                onTap:
                                    () => _showEnlargedImage(community.avatar),
                                child: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                    community.avatar,
                                  ),
                                  radius: 45,
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.bottomLeft,
                              padding: const EdgeInsets.all(20),
                              child:
                                  !community.mods.contains(user.uid)
                                      ? OutlinedButton(
                                        style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 25,
                                          ),
                                        ),
                                        onPressed:
                                            () => joinCommunity(
                                              community,
                                              context,
                                            ),
                                        child: Text(
                                          community.members.contains(user.uid)
                                              ? 'Joined'
                                              : 'Join',
                                          style: const TextStyle(
                                            color: Colors.lightBlueAccent,
                                          ),
                                        ),
                                      )
                                      : const SizedBox.shrink(),
                            ),
                          ],
                        ),
                      ),
                      SliverPadding(
                        padding: const EdgeInsets.all(16),
                        sliver: SliverList(
                          delegate: SliverChildListDelegate([
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'm/${community.name}',
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                if (!isGuest)
                                  if (community.mods.contains(user.uid))
                                    OutlinedButton(
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 25,
                                        ),
                                      ),
                                      onPressed:
                                          () => navigateToModTools(context),
                                      child: const Text(
                                        'Mod Tools',
                                        style: TextStyle(
                                          color: Colors.lightBlueAccent,
                                        ),
                                      ),
                                    ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                const Icon(Icons.people, size: 20),
                                const SizedBox(width: 5),
                                Text(
                                  '${community.members.length} members',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              'Posts',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Divider(thickness: 2),
                          ]),
                        ),
                      ),
                    ];
                  },
                  body: ref
                      .watch(getCommunityPostsProvider(widget.name))
                      .when(
                        data: (data) {
                          if (data.isEmpty) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(
                                    Icons.post_add,
                                    size: 60,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(height: 20),
                                  Text(
                                    'No posts available yet',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }

                          return ListView.builder(
                            itemCount: data.length,
                            itemBuilder: (BuildContext context, int index) {
                              final post = data[index];
                              return PostCard(post: post);
                            },
                          );
                        },
                        error: (error, stackTrace) {
                          return ErrorText(error: error.toString());
                        },
                        loading: () => const Loader(),
                      ),
                ),
            error: (error, stackTrace) => ErrorText(error: error.toString()),
            loading: () => const Loader(),
          ),
    );
  }
}
