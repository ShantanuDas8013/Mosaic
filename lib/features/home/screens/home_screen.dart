import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mosaic/features/auth/controller/auth_controller.dart';
import 'package:mosaic/features/home/delegates/search_community_delegate.dart';
import 'package:mosaic/features/home/drawers/community_list_darwer.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  void displayDrawer(BuildContext context) {
    Scaffold.of(context).openDrawer();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
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
                onPressed: () => displayDrawer(context),
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
            child: GestureDetector(
              onTap: () {
                // Profile picture is clickable but has no action defined
                // Can add navigation to profile page or other profile-related actions
                debugPrint('Profile picture clicked');
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: CircleAvatar(
                  backgroundImage: NetworkImage(user.profilePic),
                  radius: 16,
                ),
              ),
            ),
          ),
        ],
      ),
      drawer: const CommunityListDarwer(),
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

          // Your existing content can go here
          // This is where you'd display posts, communities, etc.
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
        ],
      ),
    );
  }
}
