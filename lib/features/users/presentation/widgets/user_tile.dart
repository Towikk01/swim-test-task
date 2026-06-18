import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../data/models/user.dart';

/// One row in the user list: avatar with initials, name, email and phone.
class UserTile extends StatelessWidget {
  const UserTile({super.key, required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: AppColors.accentMuted,
        child: Text(
          _initials(user.name),
          style: const TextStyle(color: AppColors.textPrimary),
        ),
      ),
      title: Text(user.name),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [Text(user.email), Text(user.phone)],
      ),
      isThreeLine: true,
    );
  }

  String _initials(String name) {
    final parts = name.trim().split(' ');
    final a = parts.isNotEmpty && parts[0].isNotEmpty ? parts[0][0] : '';
    final b = parts.length > 1 && parts[1].isNotEmpty ? parts[1][0] : '';
    final res = (a + b).toUpperCase();
    return res.isEmpty ? '?' : res;
  }
}
