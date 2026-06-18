import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../data/models/user.dart';

class UserDetailScreen extends StatelessWidget {
  const UserDetailScreen({super.key, required this.user});

  final User user;

  static const double _expandedHeight = 240;

  @override
  Widget build(BuildContext context) {
    final address = user.address;
    final company = user.company;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: _expandedHeight,
            backgroundColor: AppColors.background,
            flexibleSpace: _CollapsingHeader(
              user: user,
              expandedHeight: _expandedHeight,
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _Section(
                  title: 'Contact',
                  rows: [
                    _Row(
                      icon: Icons.email_outlined,
                      label: 'Email',
                      value: user.email,
                    ),
                    _Row(
                      icon: Icons.phone_outlined,
                      label: 'Phone',
                      value: user.phone,
                    ),
                    _Row(
                      icon: Icons.language_outlined,
                      label: 'Website',
                      value: user.website,
                    ),
                  ],
                ),
                _Section(
                  title: 'Address',
                  rows: [
                    _Row(
                      icon: Icons.home_outlined,
                      label: 'Street',
                      value: '${address.street}, ${address.suite}',
                    ),
                    _Row(
                      icon: Icons.location_city_outlined,
                      label: 'City',
                      value: '${address.city}, ${address.zipcode}',
                    ),
                    _Row(
                      icon: Icons.map_outlined,
                      label: 'Geo',
                      value: '${address.geo.lat}, ${address.geo.lng}',
                    ),
                  ],
                ),
                _Section(
                  title: 'Company',
                  rows: [
                    _Row(
                      icon: Icons.business_outlined,
                      label: 'Name',
                      value: company.name,
                    ),
                    _Row(
                      icon: Icons.format_quote_outlined,
                      label: 'Catch phrase',
                      value: company.catchPhrase,
                    ),
                    _Row(
                      icon: Icons.work_outline,
                      label: 'Focus',
                      value: company.bs,
                    ),
                  ],
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _CollapsingHeader extends StatelessWidget {
  const _CollapsingHeader({required this.user, required this.expandedHeight});

  final User user;
  final double expandedHeight;

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return LayoutBuilder(
      builder: (context, constraints) {
        final minHeight = kToolbarHeight + topPadding;

        final t =
            ((constraints.maxHeight - minHeight) / (expandedHeight - minHeight))
                .clamp(0.0, 1.0);

        // Each layer only shows in its own half so the two never overlap.
        final expandedOpacity = ((t - 0.5) * 2).clamp(0.0, 1.0);
        final collapsedOpacity = (1 - t * 2).clamp(0.0, 1.0);

        return Stack(
          fit: StackFit.expand,
          clipBehavior: Clip.hardEdge,
          children: [
            // Expanded layer, bottom-anchored with a fixed height so the top
            // is clipped (parallax) as the bar collapses instead of overflowing.
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: expandedHeight,
              child: Opacity(
                opacity: expandedOpacity,
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _Avatar(name: user.name, radius: 44, fontSize: 28),
                      const SizedBox(height: 10),
                      Text(
                        user.name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '@${user.username}',
                        style: const TextStyle(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Positioned(
              top: topPadding,
              left: 56,
              right: 16,
              height: kToolbarHeight,
              child: Opacity(
                opacity: collapsedOpacity,
                child: Row(
                  children: [
                    _Avatar(name: user.name, radius: 16, fontSize: 13),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        user.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({
    required this.name,
    required this.radius,
    required this.fontSize,
  });

  final String name;
  final double radius;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: AppColors.accentMuted,
      child: Text(
        _initials(name),
        style: TextStyle(fontSize: fontSize, color: AppColors.textPrimary),
      ),
    );
  }
}

String _initials(String name) {
  final parts = name.trim().split(' ');
  final a = parts.isNotEmpty && parts[0].isNotEmpty ? parts[0][0] : '';
  final b = parts.length > 1 && parts[1].isNotEmpty ? parts[1][0] : '';
  final res = (a + b).toUpperCase();
  return res.isEmpty ? '?' : res;
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.rows});

  final String title;
  final List<Widget> rows;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            title.toUpperCase(),
            style: const TextStyle(
              letterSpacing: 1.5,
              fontSize: 12,
              color: AppColors.accent,
            ),
          ),
        ),
        Card(
          color: AppColors.surface,
          margin: EdgeInsets.zero,
          child: Column(children: rows),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.icon, required this.label, required this.value});

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.accent),
      title: Text(
        label,
        style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
      ),
      subtitle: Text(
        value,
        style: const TextStyle(fontSize: 15, color: AppColors.textPrimary),
      ),
    );
  }
}
