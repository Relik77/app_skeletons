import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sample_project/generated/l10n.dart';
import 'package:sample_project/shared/resource.dart';
import 'package:sample_project/themes/app_theme.dart';
import 'package:sample_project/ui/layout/side_menu/side_menu.viewmodel.dart';
import 'package:sample_project/ui/layout/side_menu/side_menu.widget.dart';
import 'package:sample_project/ui/navigation/application.state.dart';
import 'package:sample_project/ui/navigation/navigation.state.dart';

class ScreenInfo {
  final BoxConstraints constraints;
  final bool isMobile;

  ScreenInfo({
    required this.constraints,
    required this.isMobile,
  });
}

class CustomScreen extends StatefulWidget {
  final Widget? child;
  final Widget Function(BuildContext context, ScreenInfo screenInfo)? builder;
  final List<Positioned>? overlays;
  final ScrollController? scrollController;
  final bool center;
  final bool fillBody;
  final List<Widget>? appBarActions;
  final PreferredSizeWidget? appBarBottom;
  final EdgeInsetsGeometry? padding;
  final Widget? appBarTitle;
  final String? appBarSubtitle;
  final VoidCallback? onAppBarSubtitleTap;
  final Color? appBarColor;
  final Widget? appBarButton;
  final bool showIASearch;

  CustomScreen({
    super.key,
    this.child,
    this.builder,
    this.overlays,
    this.scrollController,
    this.center = false,
    this.fillBody = false,
    this.appBarActions,
    this.appBarBottom,
    EdgeInsetsGeometry? padding,
    this.appBarTitle,
    this.appBarSubtitle,
    this.onAppBarSubtitleTap,
    this.appBarColor,
    this.appBarButton,
    this.showIASearch = false,
  })  : assert(child != null || builder != null),
        assert(child == null || builder == null),
        padding = padding ??
            EdgeInsets.only(
              top: 16,
              left: 16,
              right: 16,
              bottom: fillBody ? 0 : 16,
            );

  @override
  State<CustomScreen> createState() => _CustomScreenState();
}

class _CustomScreenState extends State<CustomScreen> {
  final FocusNode searchBarFocusNode = FocusNode();
  late SideMenuViewModel sideMenuViewModel;
  bool searchBarFocused = false;
  bool menuCollapsed = true;

  @override
  void initState() {
    super.initState();
    ApplicationState.instance!.addListener(_hideMenu);
    NavigationState.instance!.addListener(_hideMenu);
    sideMenuViewModel = SideMenuViewModel();
    searchBarFocusNode.addListener(() {
      setState(() {
        searchBarFocused = searchBarFocusNode.hasFocus;
      });
    });
  }

  void _hideMenu() {
    if (mounted && !menuCollapsed) {
      setState(() {
        menuCollapsed = true;
      });
    }
  }

  @override
  void dispose() {
    searchBarFocusNode.dispose();
    ApplicationState.instance!.removeListener(_hideMenu);
    NavigationState.instance!.removeListener(_hideMenu);
    super.dispose();
  }

  Widget? _buildAppBarTitle() {
    if (widget.appBarTitle != null) {
      return widget.appBarTitle;
    }
    final applicationState = ApplicationState.instance!;
    return AnimatedBuilder(
      animation: applicationState,
      builder: (context, child) {
        return LayoutBuilder(builder: (context, constraints) {
          return Row(
            children: [
              Expanded(
                child: LayoutBuilder(builder: (context, constraints) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Builder(builder: (context) {
                        return Text(
                          S.current.myDashboard_title,
                          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      }),
                      if (widget.appBarSubtitle != null) ...[
                        InkWell(
                          onTap: widget.onAppBarSubtitleTap,
                          child: Text(
                            widget.appBarSubtitle!,
                            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              fontWeight: FontWeight.w300,
                              color: AppTheme.of(context).textColor.shade300,
                            ),
                          ),
                        ),
                      ],
                    ],
                  );
                }),
              ),
            ],
          );
        });
      },
    );
  }

  SliverAppBar? buildAppBar({
    required bool showSideMenuButton,
  }) {
    if (ApplicationState.instance?.isLogged != true) {
      return null;
    }
    final canPop = Navigator.of(context).canPop();
    return SliverAppBar(
      pinned: true,
      title: _buildAppBarTitle(),
      backgroundColor: widget.appBarColor,
      actions: [
        if (widget.appBarActions != null) ...widget.appBarActions!,
        Row(
          children: [
            if (widget.appBarButton != null) ...[
              widget.appBarButton!,
            ],
          ],
        ),
        if (showSideMenuButton && !canPop) ...[
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              setState(() {
                menuCollapsed = !menuCollapsed;
              });
            },
          ),
        ],
        const SizedBox(width: 8),
      ],
      bottom: widget.appBarBottom,
    );
  }

  Widget buildBody({
    SliverAppBar? appBar,
    required bool isMobile,
  }) {
    return LayoutBuilder(builder: (context, constraints) {
      final isSmallScreen = constraints.maxWidth < 600;
      double? bodyHeight;
      if (widget.fillBody) {
        bodyHeight = MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
        if (appBar != null) {
          bodyHeight -= appBar.toolbarHeight;
          if (appBar.bottom != null) {
            bodyHeight -= appBar.bottom!.preferredSize.height;
          }
        }
      } else {
        bodyHeight = null;
      }

      final body = Container(
        // padding: isSmallScreen ? const EdgeInsets.all(16) : const EdgeInsets.symmetric(horizontal: 48, vertical: 32),
        padding: widget.padding,
        height: bodyHeight,
        child: widget.builder != null
            ? widget.builder!(
            context,
            ScreenInfo(
              constraints: constraints,
              isMobile: isMobile,
            ))
            : widget.child ?? const SizedBox.shrink(),
      );

      return CustomScrollView(
        slivers: [
          if (appBar != null) appBar,
          if (widget.center) ...[
            SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: body,
              ),
            ),
          ] else ...[
            SliverList(
              delegate: SliverChildListDelegate([
                body,
              ]),
            ),
          ],
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final applicationState = ApplicationState.instance!;
            final isMobile = constraints.maxWidth < 1024;
            sideMenuViewModel.maxWidth = isMobile ? constraints.maxWidth : SideMenuViewModel.defaultMaxWidth;

            return Stack(
              children: [
                // version
                if (!kDebugMode && Resource.env != "prod") ...[
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 8, right: 8),
                      child: Text(
                        "v${Resource.buildVersion} - ${Resource.env} - ${Resource.buildDate}",
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          fontWeight: FontWeight.w300,
                          fontStyle: FontStyle.italic,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),
                ],
                if (!isMobile) ...[
                  Positioned.fill(
                    child: Row(
                      children: [
                        if (ApplicationState.instance?.isLogged == true) ...[
                          SideMenu(
                            sideMenuViewModel,
                          ),
                        ],
                        Expanded(
                          child: buildBody(
                            isMobile: isMobile,
                            appBar: buildAppBar(showSideMenuButton: false),
                          ),
                        ),
                      ],
                    ),
                  ),
                ] else ...[
                  buildBody(
                    isMobile: isMobile,
                    appBar: buildAppBar(showSideMenuButton: true),
                  ),
                  if (!menuCollapsed && ApplicationState.instance?.isLogged == true) ...[
                    SideMenu(
                      sideMenuViewModel,
                      canCollapse: false,
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            menuCollapsed = !menuCollapsed;
                          });
                        },
                        icon: Icon(
                          Icons.close,
                          color: Theme.of(context).textTheme.bodyMedium!.color,
                        ),
                      ),
                    ),
                  ],
                ],
                if (widget.overlays != null) ...widget.overlays!,
              ],
            );
          },
        ),
      ),
    );
  }
}
