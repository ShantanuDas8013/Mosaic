import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mosaic/core/common/error_text.dart';
import 'package:mosaic/core/common/loader.dart';
import 'package:mosaic/features/auth/controller/auth_controller.dart';
import 'package:mosaic/features/community/controller/commuity_controller.dart';
import 'package:mosaic/router.dart';

class AddModsScreen extends ConsumerStatefulWidget {
  final String name;
  const AddModsScreen({super.key, required this.name});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddModsScreenState();
}

class _AddModsScreenState extends ConsumerState<AddModsScreen> {
  Set<String> uids = {};
  int ctr = 0;

  void addUid(String uid) {
    setState(() {
      uids.add(uid);
    });
  }

  void removeUid(String uid) {
    setState(() {
      uids.remove(uid);
    });
  }

  void saveMods() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Save Changes'),
            content: Text('Add ${uids.length} moderators to r/${widget.name}?'),
            actions: [
              TextButton(
                onPressed: () => context.goBack(),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () {
                  ref
                      .read(communityControllerProvider.notifier)
                      .addMods(widget.name, uids.toList(), context);
                  context.goBack();
                },
                child: const Text('Save'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Add Moderators to r/${widget.name}'),
        centerTitle: false,
        elevation: 1,
        actions: [
          TextButton.icon(
            onPressed: saveMods,
            icon: const Icon(Icons.check_circle_outline),
            label: const Text('Save'),
            style: TextButton.styleFrom(
              foregroundColor: theme.colorScheme.primary,
            ),
          ),
        ],
      ),
      body: ref
          .watch(getCommunityByNameProvider(widget.name))
          .when(
            data: (community) {
              return Column(
                children: [
                  Container(
                    color: theme.colorScheme.surface,
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: theme.colorScheme.secondary,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Select members to add as moderators. Moderators can manage posts and members.',
                            style: theme.textTheme.bodyMedium,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Community Members',
                          style: theme.textTheme.titleMedium,
                        ),
                        Chip(
                          label: Text('${uids.length} selected'),
                          backgroundColor: theme.colorScheme.primaryContainer,
                          labelStyle: TextStyle(
                            color: theme.colorScheme.onPrimaryContainer,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: community.members.length,
                      itemBuilder: (BuildContext context, int index) {
                        final member = community.members[index];
                        final isMod = community.mods.contains(member);

                        if (isMod && ctr == 0) {
                          uids.add(member);
                        }
                        ctr++;

                        return ref
                            .watch(getUserDataProvider(member))
                            .when(
                              data: (user) {
                                return Card(
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 4,
                                  ),
                                  elevation: 0,
                                  color:
                                      uids.contains(user.uid)
                                          ? theme.colorScheme.primaryContainer
                                              .withAlpha(
                                                77,
                                              ) // Replaced withOpacity(0.3) with withAlpha(77)
                                          : null,
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      backgroundImage:
                                          user.profilePic.isNotEmpty
                                              ? NetworkImage(user.profilePic)
                                              : null,
                                      child:
                                          user.profilePic.isEmpty
                                              ? Text(user.name[0].toUpperCase())
                                              : null,
                                    ),
                                    title: Row(
                                      children: [
                                        Text(user.name),
                                        if (isMod)
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              left: 8,
                                            ),
                                            child: Chip(
                                              label: const Text('Mod'),
                                              labelStyle: TextStyle(
                                                fontSize: 10,
                                                color:
                                                    theme
                                                        .colorScheme
                                                        .onSecondaryContainer,
                                              ),
                                              backgroundColor:
                                                  theme
                                                      .colorScheme
                                                      .secondaryContainer,
                                              padding: EdgeInsets.zero,
                                              materialTapTargetSize:
                                                  MaterialTapTargetSize
                                                      .shrinkWrap,
                                            ),
                                          ),
                                      ],
                                    ),
                                    subtitle: Text(
                                      '${user.karma} karma', // Using string interpolation instead of concatenation
                                    ),
                                    trailing: Checkbox(
                                      value: uids.contains(user.uid),
                                      onChanged: (val) {
                                        if (val!) {
                                          addUid(user.uid);
                                        } else {
                                          removeUid(user.uid);
                                        }
                                      },
                                    ),
                                    onTap: () {
                                      if (uids.contains(user.uid)) {
                                        removeUid(user.uid);
                                      } else {
                                        addUid(user.uid);
                                      }
                                    },
                                  ),
                                );
                              },
                              error:
                                  (error, stackTrace) =>
                                      ErrorText(error: error.toString()),
                              loading: () => const Loader(),
                            );
                      },
                    ),
                  ),
                ],
              );
            },
            error: (error, stackTrace) => ErrorText(error: error.toString()),
            loading: () => const Loader(),
          ),
    );
  }
}
