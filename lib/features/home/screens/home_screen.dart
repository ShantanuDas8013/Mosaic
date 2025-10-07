import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mosaic/features/auth/controller/auth_controller.dart';
import 'package:mosaic/features/feed/feed_screen.dart';
import 'package:mosaic/features/home/delegates/search_community_delegate.dart';
import 'package:mosaic/features/home/drawers/community_list_darwer.dart';
import 'package:mosaic/features/home/drawers/profile_drawer.dart';
import 'package:mosaic/features/post/screens/add_post_screen.dart';

// Change to StatefulWidget to manage scroll controller
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  static final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>();
  final ScrollController _scrollController = ScrollController();
  bool _isRefreshing = false;

  void displayDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }

  void displayEndDrawer() {
    _scaffoldKey.currentState?.openEndDrawer();
  }

  // Method to handle refresh when app name is clicked
  Future<void> _refreshHome() async {
    if (_isRefreshing) return; // Prevent multiple simultaneous refreshes

    setState(() {
      _isRefreshing = true;
    });

    // Scroll to top
    if (_scrollController.hasClients) {
      await _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }

    // Simulate refresh delay
    await Future.delayed(const Duration(milliseconds: 800));

    // Signal the feed to refresh by updating a provider
    // ref.refresh(feedDataProvider); // Uncomment if you have a feed provider

    setState(() {
      _isRefreshing = false;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider)!;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final isGuest = !user.isAuthenticated;

    return Scaffold(
      key: _scaffoldKey, // Add the GlobalKey to the Scaffold
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        title: InkWell(
          onTap: _refreshHome,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.dashboard_rounded, color: Colors.white, size: 28),
                const SizedBox(width: 8),
                Text(
                  'Mosaic',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    letterSpacing: 0.5,
                    color: Colors.white,
                  ),
                ),
                if (_isRefreshing) ...[
                  const SizedBox(width: 8),
                  const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
        centerTitle: false,
        leading: Builder(
          builder: (context) {
            return Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(
                  51,
                ), // 0.2 opacity is approximately 51 alpha
                borderRadius: BorderRadius.circular(8),
              ),
              child: IconButton(
                onPressed: () => displayDrawer(),
                icon: const Icon(
                  Icons.menu_rounded,
                  size: 22,
                  color: Colors.white,
                ),
                padding: EdgeInsets.zero,
                tooltip: 'Menu',
              ),
            );
          },
        ),
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 6),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(
                51,
              ), // 0.2 opacity is approximately 51 alpha
              borderRadius: BorderRadius.circular(8),
            ),
            child: IconButton(
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: SearchCommunityDelegate(ref),
                );
              },
              icon: const Icon(Icons.search_rounded, color: Colors.white),
              tooltip: 'Search',
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12.0, left: 6.0),
            child: IconButton(
              onPressed: () => displayEndDrawer(),
              icon: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: CircleAvatar(
                  backgroundImage: NetworkImage(user.profilePic),
                  radius: 16,
                ),
              ),
              padding: EdgeInsets.zero,
              tooltip: 'Profile',
            ),
          ),
        ],
      ),
      drawer: const CommunityListDrawer(),
      endDrawer: const ProfileDrawer(),
      backgroundColor:
          isDarkMode ? const Color(0xFF121212) : Colors.grey.shade100,
      body: Stack(
        children: [
          Column(
            children: [
              // Colorful welcome banner
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Welcome, ${user.name}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Explore communities and connect with others',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(
                          51,
                        ), // 0.2 opacity is approximately 51 alpha
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.explore_rounded,
                            color: Colors.white,
                            size: 16,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'Explore',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(child: FeedScreen(scrollController: _scrollController)),
            ],
          ),
          if (!isGuest)
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  width: min(500.0, MediaQuery.of(context).size.width * 0.9),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: isDarkMode ? const Color(0xFF212121) : Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: BottomNavigationBar(
                    backgroundColor: Colors.transparent,
                    selectedItemColor: Theme.of(context).colorScheme.primary,
                    unselectedItemColor:
                        isDarkMode ? Colors.white60 : Colors.grey.shade600,
                    type: BottomNavigationBarType.fixed,
                    elevation: 0.0,
                    items: const [
                      BottomNavigationBarItem(
                        icon: Icon(Icons.home),
                        label: 'Home',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.post_add),
                        label: 'Post',
                      ),
                    ],
                    currentIndex: 0,
                    onTap: (index) {
                      if (index == 0) {
                        // If already at home, scroll to top
                        if (_scrollController.hasClients) {
                          _scrollController.animateTo(
                            0,
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                          );
                        } else {
                          // If controller isn't attached, try again after frame is built
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            if (_scrollController.hasClients) {
                              _scrollController.animateTo(
                                0,
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.easeInOut,
                              );
                            }
                          });
                        }
                      } else if (index == 1) {
                        // Navigate to the AddPostScreen
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const AddPostScreen(),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
