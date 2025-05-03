import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mosaic/core/common/error_text.dart';
import 'package:mosaic/core/common/loader.dart';
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

  // New method to show enlarged image in a dialog
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

    return Scaffold(
      key: _scaffoldKey,
      endDrawer: ModToolsScreen(name: widget.name),
      endDrawerEnableOpenDragGesture: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 0,
      ),
      body: ref
          .watch(getCommunityByNameProvider(widget.name))
          .when(
            data:
                (community) => NestedScrollView(
                  headerSliverBuilder: (context, innerBoxIsScrolled) {
                    return [
                      SliverAppBar(
                        automaticallyImplyLeading: true,
                        actions: const <Widget>[],
                        expandedHeight: 150,
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
                          ],
                        ),
                      ),
                      SliverPadding(
                        padding: const EdgeInsets.all(16),
                        sliver: SliverList(
                          delegate: SliverChildListDelegate([
                            Align(
                              alignment: Alignment.topLeft,
                              child: GestureDetector(
                                onTap:
                                    () => _showEnlargedImage(community.avatar),
                                child: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                    community.avatar,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'm/${community.name}',
                                  style: const TextStyle(
                                    fontSize: 19,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                community.mods.contains(user.uid)
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
                                      onPressed: () {
                                        navigateToModTools(context);
                                      },
                                      child: const Text(
                                        'Mod Tools',
                                        style: TextStyle(
                                          color: Colors.lightBlueAccent,
                                        ),
                                      ),
                                    )
                                    : OutlinedButton(
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
                                      onPressed: () {
                                        joinCommunity(community, context);
                                      },
                                      child: Text(
                                        community.members.contains(user.uid)
                                            ? 'Joined'
                                            : 'Join',
                                        style: TextStyle(
                                          color: Colors.lightBlueAccent,
                                        ),
                                      ),
                                    ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Text(
                                '${community.members.length} members',
                              ),
                            ),
                          ]),
                        ),
                      ),
                    ];
                  },
                  body: Container(),
                ),
            error: (error, stackTrace) => ErrorText(error: error.toString()),
            loading: () => const Loader(),
          ),
    );
  }
}
