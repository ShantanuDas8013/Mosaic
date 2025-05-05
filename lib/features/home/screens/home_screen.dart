import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mosaic/features/auth/controller/auth_controller.dart';
import 'package:mosaic/features/home/delegates/search_community_delegate.dart';
import 'package:mosaic/features/home/drawers/community_list_darwer.dart';
import 'package:mosaic/features/home/drawers/profile_drawer.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  static final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>();
  void displayDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }

  void displayEndDrawer() {
    _scaffoldKey.currentState?.openEndDrawer();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      key: _scaffoldKey, // Add the GlobalKey to the Scaffold
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        title: Row(
          children: [
            Icon(Icons.dashboard_rounded, color: Colors.white, size: 28),
            const SizedBox(width: 8),
            const Text(
              'Mosaic',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                letterSpacing: 0.5,
              ),
            ),
          ],
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
                onPressed:
                    () =>
                        displayDrawer(), // Updated to use the method without context
                icon: const Icon(Icons.menu_rounded, size: 22),
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
              icon: const Icon(Icons.search_rounded),
              tooltip: 'Search',
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12.0, left: 6.0),
            child: IconButton(
              onPressed:
                  () =>
                      displayEndDrawer(), // Updated to use the method without context
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
      drawer: const CommunityListDarwer(),
      endDrawer: const ProfileDrawer(),
      backgroundColor:
          isDarkMode ? const Color(0xFF121212) : Colors.grey.shade100,
      body: Column(
        children: [
          // Colorful welcome banner
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                        style: TextStyle(color: Colors.white70, fontSize: 12),
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
          Expanded(
            child: Center(
              child: Text(
                'Content goes here',
                style: TextStyle(
                  color: isDarkMode ? Colors.white70 : Colors.black54,
                ),
              ),
            ),
          ),
          BottomNavigationBar(
            backgroundColor:
                isDarkMode ? const Color(0xFF212121) : Colors.white,
            selectedItemColor: Theme.of(context).colorScheme.primary,
            unselectedItemColor:
                isDarkMode ? Colors.white60 : Colors.grey.shade600,
            type: BottomNavigationBarType.fixed,
            elevation: 8.0,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(
                icon: Icon(Icons.post_add),
                label: 'Post',
              ),
            ],
            currentIndex: 0,
            onTap: (index) {
              if (index == 0) {
                // Already on home screen, do nothing
                // You could add refresh functionality here if needed
              } else if (index == 1) {
                // Post button - show message for now as the page doesn't exist yet
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Post creation feature coming soon!'),
                    duration: Duration(seconds: 2),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
