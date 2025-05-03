import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';

class ModToolsScreen extends StatelessWidget {
  final String name;
  const ModToolsScreen({super.key, required this.name});

  void navigateToEditCommunity(BuildContext context) {
    Routemaster.of(context).push('/edit-community/$name');
  }

  void navigateToAddMods(BuildContext context) {
    Routemaster.of(context).push('/add-mods/$name');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Drawer(
      backgroundColor: isDarkMode ? const Color(0xFF121212) : Colors.white,
      child: SafeArea(
        child: Column(
          children: [
            // Drawer header
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
                        Icons.shield_rounded,
                        color: Colors.white.withAlpha(240),
                        size: 28,
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Moderator Tools',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'r/$name',
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Management section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                      'MANAGEMENT',
                      style: TextStyle(
                        fontSize: 12,
                        color:
                            isDarkMode
                                ? Colors.grey.shade400
                                : Colors.grey.shade700,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1.2,
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

            // Mod options
            Card(
              elevation: 0,
              color: Colors.transparent,
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: primaryColor.withAlpha(30),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.add_moderator,
                    color: primaryColor,
                    size: 20,
                  ),
                ),
                title: const Text('Add Moderators'),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color:
                      isDarkMode ? Colors.grey.shade600 : Colors.grey.shade400,
                ),
                onTap: () {
                  navigateToAddMods(context);
                },
              ),
            ),

            Card(
              elevation: 0,
              color: Colors.transparent,
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: primaryColor.withAlpha(30),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.edit, color: primaryColor, size: 20),
                ),
                title: const Text('Edit Community'),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color:
                      isDarkMode ? Colors.grey.shade600 : Colors.grey.shade400,
                ),
                onTap: () {
                  // Close the drawer first
                  Navigator.pop(context);
                  // Then navigate to edit community
                  navigateToEditCommunity(context);
                },
              ),
            ),

            const SizedBox(height: 16),

            // Help section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                      'HELP',
                      style: TextStyle(
                        fontSize: 12,
                        color:
                            isDarkMode
                                ? Colors.grey.shade400
                                : Colors.grey.shade700,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1.2,
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

            Card(
              elevation: 0,
              color: Colors.transparent,
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.secondary.withAlpha(30),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.help_outline,
                    color: theme.colorScheme.secondary,
                    size: 20,
                  ),
                ),
                title: const Text('Moderation Guidelines'),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color:
                      isDarkMode ? Colors.grey.shade600 : Colors.grey.shade400,
                ),
                onTap: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
