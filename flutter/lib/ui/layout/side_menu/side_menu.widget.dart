import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sample_project/generated/l10n.dart';
import 'package:sample_project/shared/models/user.model.dart';
import 'package:sample_project/shared/resource.dart';
import 'package:sample_project/themes/app_theme.dart';
import 'package:sample_project/themes/themes.dart';
import 'package:sample_project/ui/layout/side_menu/menu_item.widget.dart';
import 'package:sample_project/ui/navigation/application.state.dart';
import 'package:sample_project/ui/navigation/navigation.state.dart';

abstract class ISideMenuViewModel extends ChangeNotifier {
  User? get user;
  double get width;
  bool get isCollapsed;

  void toggleMenu();
  void setCollapsed(bool value);
}

class SideMenu extends StatefulWidget {
  final ISideMenuViewModel viewModel;
  final bool canCollapse;

  const SideMenu(
      this.viewModel, {
        super.key,
        this.canCollapse = false,
      });

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  ISideMenuViewModel get viewModel => widget.viewModel;

  Widget _buildAppLogo() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: InkWell(
        onTap: NavigationState.instance?.home,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            height: 40,
            child: Image.asset(
              viewModel.isCollapsed ? Resource.appIcon : Resource.appLogo,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.canCollapse) {
      viewModel.setCollapsed(false);
    }
    return AnimatedBuilder(
        animation: viewModel,
        builder: (context, child) {
          return LayoutBuilder(builder: (context, constraints) {
            return Container(
              width: viewModel.width,
              height: constraints.maxHeight,
              color: AppTheme.of(context).sidebar,
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 40,
                            margin: const EdgeInsets.only(left: 8),
                            child: Builder(builder: (context) {
                              final themeManager = ThemeManager();
                              final themeMode = themeManager.themeMode;
                              return IconButton(
                                onPressed: () {
                                  themeManager.toggleTheme();
                                },
                                icon: Icon(
                                  themeMode == ThemeMode.light
                                      ? Icons.light_mode_outlined
                                      : themeMode == ThemeMode.dark
                                      ? Icons.dark_mode_outlined
                                      : Icons.auto_mode_outlined,
                                  size: 20,
                                  color: AppTheme.of(context).sidebar.shade50,
                                ),
                              );
                            }),
                          ),
                          _buildAppLogo(),
                          Container(
                            width: 48,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: AnimatedBuilder(
                              animation: ApplicationState.instance!,
                              builder: (context, child) {
                                return SizedBox.shrink(); // TODO implement navigation
                              }),
                        ),
                      ),
                      const Divider(height: 1),
                      const SizedBox(height: 4),
                      MenuItemWidget(
                        onTap: NavigationState.instance?.account,
                        selected: NavigationState.instance?.lastPage == NavigationState.accountPage,
                        // TODO if needed
                        // leading: UserAvatar(
                        //   user: ApplicationState.instance?.currentUser,
                        //   size: 32,
                        // ),
                        title: Text(
                          ApplicationState.instance?.currentUser?.shortName ?? S.of(context).account_title,
                          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            color: AppTheme.of(context).sidebar.shade50,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      if (kIsWeb) ...[
                        // TODO logout button if needed
                        // MenuItemWidget(
                        //   onTap: ApplicationState.instance?.logout,
                        //   leading: SizedBox(
                        //     width: 32,
                        //     child: Center(
                        //       child: Icon(
                        //         Icons.logout_outlined,
                        //         color: AppTheme.of(context).danger,
                        //       ),
                        //     ),
                        //   ),
                        //   title: Text(
                        //     S.of(context).logout_button,
                        //     style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        //       color: AppTheme.of(context).sidebar.shade50,
                        //     ),
                        //   ),
                        // ),
                        const SizedBox(height: 8),
                      ],
                    ],
                  ),
                  if (widget.canCollapse) ...[
                    Positioned(
                      bottom: 16,
                      right: 8,
                      child: IconButton(
                        onPressed: viewModel.toggleMenu,
                        // border
                        style: ButtonStyle(
                          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0),
                              side: BorderSide(
                                color: Theme.of(context).dividerColor,
                                width: 1,
                              ),
                            ),
                          ),
                        ),
                        icon: Icon(
                          viewModel.isCollapsed ? Icons.arrow_right : Icons.arrow_left,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            );
          });
        });
  }
}
