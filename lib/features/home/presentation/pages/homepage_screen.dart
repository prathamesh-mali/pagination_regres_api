import 'dart:async';
import 'package:elyx_task/config/di/dependency_injection.dart';
import 'package:elyx_task/core/constants/app_colors.dart';
import 'package:elyx_task/features/home/presentation/bloc/home_cubit.dart';
import 'package:elyx_task/features/home/data/models/user_data_model.dart';
import 'package:elyx_task/features/home/presentation/widgets/empty_state_widget.dart';
import 'package:elyx_task/features/home/presentation/widgets/end_of_list.dart';
import 'package:elyx_task/features/home/presentation/widgets/error_state_widget.dart';
import 'package:elyx_task/features/home/presentation/widgets/loading_indicator.dart';
import 'package:elyx_task/features/home/presentation/widgets/no_internet_widget.dart';
import 'package:elyx_task/features/home/presentation/widgets/offline_mode_banner.dart';
import 'package:elyx_task/features/home/presentation/widgets/user_search_bar.dart';
import 'package:elyx_task/features/home/presentation/widgets/user_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class HomeScreenWrapper extends StatelessWidget {
  const HomeScreenWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<HomeCubit>(),
      child: const HomePageScreen(),
    );
  }
}

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({super.key});

  @override
  HomePageScreenState createState() => HomePageScreenState();
}

class HomePageScreenState extends State<HomePageScreen>
    with SingleTickerProviderStateMixin {
  TextEditingController searchController = TextEditingController();
  ScrollController scrollController = ScrollController();

  List<UserData> filteredUsers = [];
  late HomeCubit homeCubit;
  late AnimationController animationController;
  late Animation<double> fadeAnimation;

  bool isFetchingMore = false;
  bool hasInternet = true;

  Timer? debounce;
  StreamSubscription<List<ConnectivityResult>>? connectivityStream;
  DateTime? lastFetch;

  @override
  void initState() {
    super.initState();
    homeCubit = context.read<HomeCubit>();
    searchController.addListener(handleSearch);
    setupAnimations();
    checkInternetAndLoad();
    listenToConnectivity();
    scrollController.addListener(onScroll);
  }

  void setupAnimations() {
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    fadeAnimation = CurvedAnimation(
      parent: animationController,
      curve: Curves.easeInOut,
    );
    animationController.forward();
  }

  void onScroll() {
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent - 200) {
      loadMore();
    }
  }

  Future<void> checkInternetAndLoad() async {
    var result = await Connectivity().checkConnectivity();
    setState(() {
      hasInternet = result.first != ConnectivityResult.none;
    });

    if (hasInternet) {
      loadData();
    }
  }

  void listenToConnectivity() {
    connectivityStream = Connectivity().onConnectivityChanged.listen((results) {
      var result = results.isNotEmpty ? results.first : ConnectivityResult.none;
      bool isConnected = result != ConnectivityResult.none;

      if (isConnected != hasInternet) {
        setState(() => hasInternet = isConnected);

        if (isConnected && homeCubit.users.isEmpty) {
          loadData();
        }
      }
    });
  }

  Future<void> loadData({bool refresh = false}) async {
    try {
      await homeCubit
          .fetchHomeData(isRefresh: refresh)
          .timeout(
            const Duration(seconds: 30),
            onTimeout: () {
              if (mounted) {
                showMessage(
                  'Request timed out. Please try again.',
                  AppColors.snackbarWarning,
                );
              }
              throw TimeoutException('API timeout');
            },
          );
      lastFetch = DateTime.now();
    } catch (e) {
      if (mounted) {
        showMessage('Error: ${e.toString()}', AppColors.snackbarError);
      }
    }
  }

  void showMessage(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void handleSearch() {
    if (debounce?.isActive ?? false) debounce!.cancel();

    debounce = Timer(const Duration(milliseconds: 300), () {
      String query = searchController.text.toLowerCase().trim();
      List<UserData> allUsers = homeCubit.users;

      setState(() {
        if (query.isEmpty) {
          filteredUsers = List.from(allUsers);
        } else {
          filteredUsers = allUsers.where((user) {
            String name = '${user.firstName ?? ''} ${user.lastName ?? ''}'
                .toLowerCase();
            return name.contains(query);
          }).toList();
        }
      });
    });
  }

  bool isCacheOld() {
    if (lastFetch == null) return true;
    return DateTime.now().difference(lastFetch!) > const Duration(minutes: 5);
  }

  Future<void> loadMore() async {
    if (isFetchingMore || !hasInternet) return;

    setState(() => isFetchingMore = true);

    try {
      await homeCubit
          .fetchHomeData(isRefresh: false)
          .timeout(const Duration(seconds: 30));
    } catch (e) {
      if (mounted) {
        showMessage('Failed to load more users', AppColors.snackbarError);
      }
    } finally {
      if (mounted) {
        setState(() => isFetchingMore = false);
      }
    }
  }

  Future<void> retry() async {
    setState(() => filteredUsers.clear());
    homeCubit.reset();
    await checkInternetAndLoad();
  }

  Future<void> refresh() async {
    if (!hasInternet) {
      showMessage('No internet connection', AppColors.snackbarWarning);
      return;
    }

    setState(() => filteredUsers.clear());
    await loadData(refresh: true);
  }

  @override
  void dispose() {
    searchController.dispose();
    debounce?.cancel();
    connectivityStream?.cancel();
    animationController.dispose();
    homeCubit.close();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isTablet = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      backgroundColor: AppColors.backgroundGrey,
      body: RefreshIndicator(
        onRefresh: refresh,
        child: CustomScrollView(
          controller: scrollController,
          slivers: [
            SliverAppBar(
              expandedHeight: 140,
              pinned: true,
              backgroundColor: AppColors.transparent,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: AppColors.blueGradient,
                    ),
                  ),
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'User Directory',
                                    style: TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.white,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'Explore our community',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: AppColors.white70,
                                    ),
                                  ),
                                ],
                              ),
                              if (isCacheOld())
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: AppColors.overlayWhite20,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(
                                    Icons.info_outline_rounded,
                                    color: AppColors.white,
                                    size: 24,
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  UserSearchBar(
                    controller: searchController,
                    isTablet: isTablet,
                    onClear: () {
                      searchController.clear();
                      setState(() {
                        filteredUsers = List.from(homeCubit.users);
                      });
                    },
                  ),
                  if (!hasInternet) ...[
                    const SizedBox(height: 12),
                    const OfflineModeBanner(),
                  ],
                  const SizedBox(height: 16),
                ],
              ),
            ),

            BlocConsumer<HomeCubit, HomeState>(
              listener: (context, state) {
                state.maybeWhen(
                  loaded: (_) {
                    List<UserData> users = homeCubit.users;
                    String query = searchController.text.toLowerCase().trim();

                    setState(() {
                      if (query.isEmpty) {
                        filteredUsers = List.from(users);
                      } else {
                        filteredUsers = users.where((user) {
                          String name =
                              '${user.firstName ?? ''} ${user.lastName ?? ''}'
                                  .toLowerCase();
                          return name.contains(query);
                        }).toList();
                      }
                    });
                  },
                  orElse: () {},
                );
              },
              builder: (context, state) {
                return state.maybeWhen(
                  loading: () {
                    if (filteredUsers.isNotEmpty) {
                      return SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          return UserTile(
                            user: filteredUsers[index],
                            index: index,
                            onNavigationError: () {
                              showMessage(
                                'Navigation error',
                                AppColors.snackbarError,
                              );
                            },
                          );
                        }, childCount: filteredUsers.length),
                      );
                    }

                    return const SliverFillRemaining(child: LoadingIndicator());
                  },

                  loaded: (_) {
                    if (!hasInternet && homeCubit.users.isEmpty) {
                      return SliverFillRemaining(
                        child: NoInternetWidget(
                          fadeAnimation: fadeAnimation,
                          onRetry: retry,
                        ),
                      );
                    }

                    if (filteredUsers.isEmpty) {
                      return SliverFillRemaining(
                        child: EmptyStateWidget(
                          fadeAnimation: fadeAnimation,
                          searchText: searchController.text,
                        ),
                      );
                    }

                    return SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          if (index == filteredUsers.length && isFetchingMore) {
                            return const PaginationLoadingIndicator();
                          }

                          if (index == filteredUsers.length &&
                              homeCubit.hasReachedEnd) {
                            return const EndOfListWidget();
                          }

                          return UserTile(
                            user: filteredUsers[index],
                            index: index,
                            onNavigationError: () {
                              showMessage(
                                'Navigation error',
                                AppColors.snackbarError,
                              );
                            },
                          );
                        },
                        childCount:
                            filteredUsers.length +
                            (isFetchingMore || homeCubit.hasReachedEnd ? 1 : 0),
                      ),
                    );
                  },

                  error: (msg) => SliverFillRemaining(
                    child: ErrorStateWidget(
                      fadeAnimation: fadeAnimation,
                      errorMessage: msg,
                      onRetry: retry,
                    ),
                  ),

                  orElse: () => SliverFillRemaining(
                    child: EmptyStateWidget(
                      fadeAnimation: fadeAnimation,
                      searchText: searchController.text,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
