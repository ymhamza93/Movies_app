import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movies_app/core/utils/color_manager.dart';
import 'package:movies_app/core/utils/custom_button.dart';
import 'package:movies_app/core/utils/preference_manager.dart';
import 'package:movies_app/core/utils/routes_manger.dart';
import 'package:movies_app/feature/auth_logic/auth_cubit.dart';
import 'package:movies_app/feature/auth_logic/auth_state.dart';
import 'package:movies_app/feature/home_screen/profile_tab/history_list/history_cubit.dart';
import 'package:movies_app/feature/home_screen/profile_tab/watch_list/watchlist_cubit.dart';
import 'package:movies_app/feature/home_screen/profile_tab/watch_list/watchlist_state.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  @override
  void initState() {
    super.initState();
    context.read<AuthCubit>().getUserProfile();
    context.read<WatchlistCubit>().fetchWatchlist();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.black,
      body: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, authState) {
          if (authState is AuthLoading) {
            return const Center(
              child: CircularProgressIndicator(color: ColorManager.yellow),
            );
          }

          if (authState is ProfileLoaded) {
            final userData = authState.userData;
            final String userName = userData['name'] ?? "No Name";
            final String avatarPath = userData['avatarPath'] ?? "";

            return Column(
              children: [
                Container(
                  color: ColorManager.backgroundBlack,
                  width: double.infinity,
                  child: SafeArea(
                    bottom: false,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 20.h,
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                children: [
                                  CircleAvatar(
                                    radius: 45.r,
                                    backgroundColor: ColorManager.black,
                                    backgroundImage: avatarPath.isNotEmpty
                                        ? AssetImage(avatarPath)
                                        : const AssetImage(
                                            'assets/images/default_avatar.png',
                                          ),
                                  ),
                                  SizedBox(height: 8.h),
                                  Text(
                                    userName,
                                    style: GoogleFonts.inter(
                                      color: ColorManager.white,
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),

                              BlocBuilder<WatchlistCubit, WatchlistState>(
                                builder: (context, wlState) {
                                  int count = 0;
                                  if (wlState is WatchlistSuccess) {
                                    count = wlState.movies.length;
                                  }
                                  return _buildStatItem(
                                    count.toString(),
                                    "Wish List",
                                  );
                                },
                              ),

                              BlocBuilder<HistoryCubit, HistoryState>(
                                builder: (context, historyState) {
                                  return _buildStatItem(
                                    historyState.watchedMovies.length
                                        .toString(),
                                    "History",
                                  );
                                },
                              ),
                            ],
                          ),

                          SizedBox(height: 20.h),

                          Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: CustomButton(
                                  text: "Edit Profile",
                                  backgroundColor: ColorManager.yellow,
                                  textColor: ColorManager.black,
                                  onPressed: () {
                                    Navigator.pushNamed(
                                      context,
                                      RouteManager.editProfileScreen,
                                      arguments: context.read<AuthCubit>(),
                                    );
                                  },
                                ),
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                flex: 1,
                                child: CustomButton(
                                  text: "Exit",
                                  backgroundColor: ColorManager.orange,
                                  textColor: ColorManager.white,
                                  icon: const Icon(
                                    Icons.logout,
                                    color: ColorManager.white,
                                    size: 20,
                                  ),
                                  onPressed: () async {

                                    await PreferenceManager.saveData(key: 'isLoggedIn', value: false);


                                    if (context.mounted) {
                                      await context.read<AuthCubit>().logout();
                                    }


                                    if (context.mounted) {
                                      Navigator.pushNamedAndRemoveUntil(
                                        context,
                                        RouteManager.loginScreen,
                                            (route) => false,
                                      );
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                Expanded(
                  child: Container(
                    color: ColorManager.black,
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 10.h,
                    ),
                    child: DefaultTabController(
                      length: 2,
                      child: Column(
                        children: [
                          TabBar(
                            indicatorColor: ColorManager.yellow,
                            labelColor: ColorManager.yellow,
                            unselectedLabelColor: ColorManager.white,
                            dividerColor: Colors.transparent,
                            labelStyle: GoogleFonts.inter(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                            ),
                            tabs: const [
                              Tab(icon: Icon(Icons.list), text: "Watch List"),
                              Tab(
                                icon: Icon(Icons.history_edu),
                                text: "History",
                              ),
                            ],
                          ),
                          Expanded(
                            child: TabBarView(
                              children: [
                                BlocBuilder<WatchlistCubit, WatchlistState>(
                                  builder: (context, wlState) {
                                    if (wlState is WatchlistLoading) {
                                      return const Center(
                                        child: CircularProgressIndicator(
                                          color: ColorManager.yellow,
                                        ),
                                      );
                                    } else if (wlState is WatchlistSuccess &&
                                        wlState.movies.isNotEmpty) {
                                      return _buildMoviesGridFromMap(
                                        wlState.movies,
                                      );
                                    }
                                    return const EmptyProfileState();
                                  },
                                ),

                                BlocBuilder<HistoryCubit, HistoryState>(
                                  builder: (context, state) {
                                    if (state.watchedMovies.isEmpty) {
                                      return const EmptyProfileState();
                                    }

                                    final displayList = state
                                        .watchedMovies
                                        .reversed
                                        .toList();

                                    return _buildMoviesGridFromMap(displayList);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
          if (authState is AuthError) {
            return Center(
              child: Text(
                authState.message,
                style: GoogleFonts.inter(
                  color: ColorManager.orange,
                  fontSize: 16.sp,
                ),
              ),
            );
          }

          return const Center(
            child: Text(
              "No Data Available",
              style: TextStyle(color: Colors.white),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMoviesGridFromMap(List<Map<String, dynamic>> movies) {
    return GridView.builder(
      itemCount: movies.length,
      padding: EdgeInsets.symmetric(vertical: 15.h),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10.w,
        mainAxisSpacing: 10.h,
        childAspectRatio: 0.65,
      ),
      itemBuilder: (context, index) {
        final movie = movies[index];
        return _buildMovieCard(movie['poster'] ?? '', movie['rating'] ?? '0.0');
      },
    );
  }

  Widget _buildMoviesGridFromModel(dynamic movies) {
    return GridView.builder(
      itemCount: movies.length,
      padding: EdgeInsets.symmetric(vertical: 15.h),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10.w,
        mainAxisSpacing: 10.h,
        childAspectRatio: 0.65,
      ),
      itemBuilder: (context, index) {
        final movie = movies[index];
        return _buildMovieCard(movie.image, movie.rating.toString());
      },
    );
  }

  Widget _buildMovieCard(String imagePath, String rating) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            image: DecorationImage(
              image: imagePath.startsWith('http')
                  ? NetworkImage(imagePath) as ImageProvider
                  : AssetImage(imagePath),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          top: 6.h,
          left: 6.w,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
            decoration: BoxDecoration(
              color: ColorManager.black.withOpacity(0.75),
              borderRadius: BorderRadius.circular(6.r),
            ),
            child: Row(
              children: [
                Text(
                  rating,
                  style: GoogleFonts.inter(
                    color: ColorManager.white,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 2.w),
                const Icon(Icons.star, color: ColorManager.yellow, size: 10),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem(String count, String label) {
    return Column(
      children: [
        Text(
          count,
          style: GoogleFonts.inter(
            color: ColorManager.white,
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.inter(
            color: ColorManager.white.withOpacity(0.7),
            fontSize: 14.sp,
          ),
        ),
      ],
    );
  }
}

class EmptyProfileState extends StatelessWidget {
  const EmptyProfileState({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/photo_in_profile.png',
          width: 140.w,
          height: 140.h,
          fit: BoxFit.contain,
        ),
        SizedBox(height: 15.h),
      ],
    );
  }
}
