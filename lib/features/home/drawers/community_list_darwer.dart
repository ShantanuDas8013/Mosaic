import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mosaic/core/common/error_text.dart';
import 'package:mosaic/core/common/loader.dart';
import 'package:mosaic/core/common/sign_in_button.dart';
import 'package:mosaic/features/auth/controller/auth_controller.dart';
import 'package:mosaic/features/community/controller/commuity_controller.dart';
import 'package:mosaic/models/community_model.dart';
import 'package:routemaster/routemaster.dart';

class CommunityListDrawer extends ConsumerWidget {
  const CommunityListDrawer({super.key});

  void navigateToCreateCommunity(BuildContext context) {
    Routemaster.of(context).push('/create-community');
  }

  void navigateToCommunity(BuildContext context, Community community) {
    Routemaster.of(context).push('/r/${community.name}');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final user = ref.watch(userProvider)!;
    final isGuest = !user.isAuthenticated;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Drawer(
      backgroundColor: isDarkMode ? const Color(0xFF121212) : Colors.white,
      child: SafeArea(
        child: Column(
          children: [
            // Header section
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.people_alt_rounded,
                        color: Colors.white.withAlpha(240),
                        size: 28,
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'My Communities',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Communities you are part of',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Create Community / Sign In button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Card(
                elevation: 0,
                color:
                    isDarkMode ? const Color(0xFF1E1E1E) : Colors.grey.shade100,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: primaryColor.withAlpha(50), width: 1),
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap:
                      isGuest
                          ? () => ref
                              .read(authControllerProvider.notifier)
                              .signInWithGoogle(context, false)
                          : () => navigateToCreateCommunity(context),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child:
                        isGuest
                            ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: primaryColor.withAlpha(30),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.login_rounded,
                                        color: primaryColor,
                                        size: 16,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    const Text(
                                      'Sign In to Join',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 36,
                                  width: 83,
                                  child: SignInButton(),
                                ),
                              ],
                            )
                            : Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: primaryColor.withAlpha(30),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.add,
                                    color: primaryColor,
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Text(
                                  'Create a Community',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color:
                                        isDarkMode
                                            ? Colors.white
                                            : Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                  ),
                ),
              ),
            ),

            // Divider with label
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                children: [
                  Expanded(
                    child: Divider(
                      color:
                          isDarkMode
                              ? Colors.grey.shade800
                              : Colors.grey.shade300,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      'Your Communities',
                      style: TextStyle(
                        fontSize: 12,
                        color:
                            isDarkMode
                                ? Colors.grey.shade400
                                : Colors.grey.shade700,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      color:
                          isDarkMode
                              ? Colors.grey.shade800
                              : Colors.grey.shade300,
                    ),
                  ),
                ],
              ),
            ),

            // Communities list
            if (!isGuest)
              ref
                  .watch(userCommunitiesProvider)
                  .when(
                    data:
                        (communities) => Expanded(
                          child:
                              communities.isEmpty
                                  ? Center(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.group_off_outlined,
                                          size: 60,
                                          color:
                                              isDarkMode
                                                  ? Colors.grey.shade700
                                                  : Colors.grey.shade400,
                                        ),
                                        const SizedBox(height: 16),
                                        Text(
                                          'No communities yet',
                                          style: TextStyle(
                                            color:
                                                isDarkMode
                                                    ? Colors.grey.shade500
                                                    : Colors.grey.shade700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                  : ListView.builder(
                                    itemCount: communities.length,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                    ),
                                    itemBuilder: (
                                      BuildContext context,
                                      int index,
                                    ) {
                                      final community = communities[index];
                                      return Card(
                                        elevation: 0,
                                        color: Colors.transparent,
                                        margin: const EdgeInsets.symmetric(
                                          vertical: 4,
                                        ),
                                        child: ListTile(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                          leading: CircleAvatar(
                                            backgroundImage: NetworkImage(
                                              community.avatar,
                                            ),
                                            radius: 20,
                                          ),
                                          title: Text(
                                            'r/${community.name}',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              color:
                                                  isDarkMode
                                                      ? Colors.white
                                                      : Colors.black87,
                                            ),
                                          ),
                                          trailing: Icon(
                                            Icons.arrow_forward_ios,
                                            size: 16,
                                            color:
                                                isDarkMode
                                                    ? Colors.grey.shade600
                                                    : Colors.grey.shade400,
                                          ),
                                          onTap: () {
                                            navigateToCommunity(
                                              context,
                                              community,
                                            );
                                          },
                                        ),
                                      );
                                    },
                                  ),
                        ),
                    error:
                        (error, stackTrace) =>
                            ErrorText(error: error.toString()),
                    loading: () => const Loader(),
                  ),
          ],
        ),
      ),
    );
  }
}
