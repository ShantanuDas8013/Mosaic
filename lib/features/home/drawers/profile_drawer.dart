import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mosaic/features/auth/controller/auth_controller.dart';
import 'package:mosaic/theme/pallete.dart';
import 'package:routemaster/routemaster.dart';

class ProfileDrawer extends ConsumerWidget {
  const ProfileDrawer({super.key});

  void logOut(WidgetRef ref) {
    ref.read(authControllerProvider.notifier).logout();
  }

  void navigateToUserProfile(BuildContext context, String uid) {
    Routemaster.of(context).push('/u/$uid');
  }

  void toggleTheme(WidgetRef ref) {
    ref.read(themeNotifierProvider.notifier).toggleTheme();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    final isDarkMode = ref.watch(themeNotifierProvider);
    return Drawer(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      elevation: 2.0,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.surface,
                    Theme.of(context).colorScheme.surfaceContainerHighest,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(user.profilePic),
                      radius: 50,
                      backgroundColor: Colors.white,
                    ),
                    const SizedBox(height: 15),
                    Text(
                      'u/${user.name}',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 15),

            // Menu Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'MENU',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 5),

            ListTile(
              title: const Text('My Profile'),
              leading: const Icon(Icons.person),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              onTap: () {
                navigateToUserProfile(context, user.uid);
              },
            ),

            const Divider(indent: 16, endIndent: 16),

            ListTile(
              title: const Text('Log Out'),
              leading: Icon(Icons.logout, color: Pallete.redColor),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              onTap: () {
                logOut(ref);
              },
            ),

            const SizedBox(height: 15),

            // Theme Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.dark_mode, size: 22),
                      const SizedBox(width: 10),
                      Text(
                        'Dark Theme',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  Switch.adaptive(
                    value: isDarkMode,
                    onChanged: (val) => toggleTheme(ref),
                    activeColor: Colors.white,
                    activeTrackColor: Colors.green,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
