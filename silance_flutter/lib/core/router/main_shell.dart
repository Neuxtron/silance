import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';
import 'package:silance/features/authentication/presentation/cubit/auth_cubit.dart';
import 'package:silance/shared/entities/side_menu_item.dart';

class MainShell extends StatelessWidget {
  const new({super.key, required this.navigationShell});
  final StatefulNavigationShell navigationShell;

  void _changeIndex(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return _SideMenuWrapper(
      currentIndex: navigationShell.currentIndex,
      onTap: _changeIndex,
      items: [
        SideMenuItem(
          title: 'Home',
          icon: Icons.chat_bubble_outline,
        ),
        SideMenuItem(
          title: 'Calls',
          icon: Icons.call_outlined,
        ),
      ],
      child: navigationShell,
    );
  }
}

class _SideMenuWrapper extends StatefulWidget {
  const new({
    required this.currentIndex,
    required this.items,
    required this.onTap,
    required this.child,
  });

  final int currentIndex;
  final List<SideMenuItem> items;
  final ValueChanged<int> onTap;
  final Widget child;

  @override
  State<_SideMenuWrapper> createState() => _SideMenuWrapperState();
}

class _SideMenuWrapperState extends State<_SideMenuWrapper>
    with TickerProviderStateMixin {
  late final SlidableController _controller;

  void _onTap(int index) {
    widget.onTap(index);
    _controller.close();
  }

  void _toggleOpen() {
    final isClosed = _controller.ratio == 0;
    if (isClosed) {
      _controller.openEndActionPane();
    } else {
      _controller.close();
    }
  }

  @override
  void initState() {
    _controller = SlidableController(this);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Slidable(
        controller: _controller,
        endActionPane: ActionPane(
          extentRatio: 2 / 3,
          motion: const BehindMotion(),
          children: [
            Expanded(
              child: Material(
                color: const Color(0xFF221B33),
                child: SafeArea(
                  child: Stack(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          widget.items.length,
                          _buildMenu,
                        ),
                      ),
                      Positioned(
                        top: 12,
                        right: 12,
                        child: IconButton(
                          onPressed: context.read<AuthCubit>().logout,
                          icon: const Icon(Icons.logout),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        child: Stack(
          children: [
            widget.child,
            Positioned(
              top: 0,
              right: 0,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: IconButton(
                    onPressed: _toggleOpen,
                    icon: const Icon(Icons.menu_rounded),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenu(int index) {
    final item = widget.items[index];
    final active = index == widget.currentIndex;
    return ListTile(
      onTap: () => _onTap(index),
      tileColor: active ? const Color(0xFF441B77) : const Color(0xFF221B33),
      textColor: Colors.white,
      title: Text(
        item.title,
        textAlign: TextAlign.right,
      ),
      trailing: Icon(
        item.icon,
        color: Colors.white,
      ),
    );
  }
}
