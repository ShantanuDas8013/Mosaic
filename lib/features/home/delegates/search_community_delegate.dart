import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mosaic/core/common/error_text.dart';
import 'package:mosaic/core/common/loader.dart';
import 'package:mosaic/features/community/controller/commuity_controller.dart';
import 'package:routemaster/routemaster.dart';

class SearchCommunityDelegate extends SearchDelegate {
  final WidgetRef ref;
  SearchCommunityDelegate(this.ref);

  @override
  String get searchFieldLabel => 'Search communities...';

  @override
  TextStyle? get searchFieldStyle =>
      const TextStyle(fontSize: 16, fontWeight: FontWeight.w400);

  @override
  ThemeData appBarTheme(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Theme.of(context).copyWith(
      appBarTheme: AppBarTheme(
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        elevation: 0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: TextStyle(
          color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
        ),
        border: InputBorder.none,
      ),
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    // Only show the close button if there's text in the search field
    if (query.isEmpty) {
      return [const SizedBox.shrink()];
    }

    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.close),
        splashRadius: 20,
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return null;
  }

  @override
  Widget buildResults(BuildContext context) {
    return const SizedBox();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;

    if (query.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_rounded,
              size: 100,
              color: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
            ),
            const SizedBox(height: 16),
            Text(
              'Search for communities',
              style: TextStyle(
                fontSize: 16,
                color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
              ),
            ),
          ],
        ),
      );
    }

    return ref
        .watch(searchCommunityProvider(query))
        .when(
          data: (communities) {
            if (communities.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.search_off_rounded,
                      size: 80,
                      color:
                          isDark ? Colors.grey.shade700 : Colors.grey.shade400,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No communities found',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color:
                            isDark
                                ? Colors.grey.shade400
                                : Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Try a different search term',
                      style: TextStyle(
                        fontSize: 14,
                        color:
                            isDark
                                ? Colors.grey.shade600
                                : Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              itemCount: communities.length,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemBuilder: (context, index) {
                final community = communities[index];
                return Card(
                  elevation: 0,
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color:
                          isDark ? Colors.grey.shade800 : Colors.grey.shade200,
                      width: 1,
                    ),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () => navigateToCommunity(context, community.name),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: ListTile(
                        leading: Hero(
                          tag: 'community-${community.name}',
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(community.avatar),
                            radius: 24,
                          ),
                        ),
                        title: Text(
                          'r/${community.name}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                        subtitle:
                            community.members.isNotEmpty
                                ? Text(
                                  '${community.members.length} member${community.members.length == 1 ? '' : 's'}',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color:
                                        isDark
                                            ? Colors.grey.shade400
                                            : Colors.grey.shade600,
                                  ),
                                )
                                : null,
                        trailing: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: primaryColor.withAlpha(20),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 14,
                            color: primaryColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
          error:
              (error, stackTrace) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: ErrorText(error: error.toString()),
                ),
              ),
          loading: () => const Center(child: Loader()),
        );
  }

  void navigateToCommunity(BuildContext context, String communityName) {
    Routemaster.of(context).push('/r/$communityName');
  }
}
