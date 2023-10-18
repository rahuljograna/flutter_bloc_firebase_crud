import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_firebase_crud/app/core/models/post_model.dart';
import 'package:flutter_bloc_firebase_crud/app/presentation/pages/home/bloc/home_bloc.dart';
import 'package:flutter_bloc_firebase_crud/app/presentation/pages/new_post/new_post_view.dart';
import 'package:flutter_bloc_firebase_crud/app/presentation/styles/app_style.dart';
import 'package:flutter_bloc_firebase_crud/app/presentation/styles/theme.dart';
import 'package:flutter_bloc_firebase_crud/app/presentation/styles/theme_bloc/theme_bloc.dart';
import 'package:flutter_bloc_firebase_crud/app/router/app_route_config.dart';
import 'package:skeletons/skeletons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeBloc()..add(HomeInitialEvent()),
      child: const HomeView(),
    );
  }
}

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.homeTitle),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {
              context.read<HomeBloc>().add(HomeLogoutEvent());
            },
            icon: Icon(
              Icons.logout_outlined,
              color: Theme.of(context).iconTheme.color,
            ),
          )
        ],
        leading: IconButton(
          onPressed: () {
            context.read<ThemeBloc>().add(ChangeThemeEvent());
          },
          icon: Icon(
            Icons.light_mode,
            color: Theme.of(context).iconTheme.color,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => NewPostScreen(
                      action: 'create',
                      postModel: PostModel(),
                    )),
          ).then((res) {
            debugPrint(res.toString());
            if (res == true) {
              context.read<HomeBloc>().add(HomeInitialEvent());
            }
          });
        },
        child: const Icon(
          Icons.add,
        ),
      ),
      body: BlocConsumer<HomeBloc, HomeState>(
        listener: (context, state) {
          if (state.status == HomeStatus.unAuthorized) {
            debugPrint('logout');
            kSnackBarError(context, state.toastMesssage);
            Navigator.of(context).pushNamedAndRemoveUntil(
                AppRouter.loginRoute, (route) => false);
          } else if (state.status == HomeStatus.logout) {
            kSnackBarSuccess(context, state.toastMesssage);
            Navigator.of(context).pushNamedAndRemoveUntil(
                AppRouter.loginRoute, (route) => false);
          }
        },
        builder: (context, state) {
          if (state.status.isLoading) {
            return SkeletonListView(
              itemCount: 10,
            );
          }
          if (state.status.isSuccess) {
            return state.list.isEmpty
                ? Center(
                    child: Text(AppLocalizations.of(context)!.noPostMessage),
                  )
                : SingleChildScrollView(
                    child: Padding(
                      padding:
                          const EdgeInsets.all(ThemeProvider.scaffoldPadding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: List.generate(
                          state.list.length,
                          (index) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: ListTile(
                              titleTextStyle: TextStyle(
                                fontSize: Theme.of(context)
                                    .textTheme
                                    .labelMedium
                                    ?.fontSize,
                                fontFamily: 'medium',
                                color: Theme.of(context).canvasColor,
                              ),
                              title: Text('${state.list[index].title}'),
                              leading: ClipRRect(
                                child: SizedBox.fromSize(
                                  size: const Size.fromRadius(15),
                                  child: FadeInImage(
                                    height: 20,
                                    width: 20,
                                    fit: BoxFit.cover,
                                    image: NetworkImage(
                                        '${state.list[index].cover}'),
                                    placeholder: const AssetImage(
                                        "assets/images/placeholder.jpeg"),
                                    imageErrorBuilder:
                                        (context, error, stackTrace) {
                                      return Image.asset(
                                        'assets/images/placeholder.jpeg',
                                        fit: BoxFit.cover,
                                        height: 100,
                                        width: 100,
                                      );
                                    },
                                  ),
                                ),
                              ),
                              trailing: Wrap(
                                spacing: -10,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      debugPrint(
                                          'Edit this item ${state.list[index].id}');
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => NewPostScreen(
                                            action: 'update',
                                            postModel: state.list[index],
                                          ),
                                        ),
                                      ).then((res) {
                                        debugPrint(res.toString());
                                        if (res == true) {
                                          context.read<HomeBloc>().add(
                                                HomeInitialEvent(),
                                              );
                                        }
                                      });
                                    },
                                    icon: Icon(
                                      Icons.mode_edit_outline_outlined,
                                      color: Theme.of(context).canvasColor,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      context.read<HomeBloc>().add(
                                            HomeUpdateStatusPostEvent(
                                              index: index,
                                              postModel: state.list[index],
                                            ),
                                          );
                                    },
                                    icon: FaIcon(
                                      state.list[index].status == 1
                                          ? FontAwesomeIcons.eye
                                          : FontAwesomeIcons.eyeSlash,
                                      size: Theme.of(context)
                                          .textTheme
                                          .bodyLarge
                                          ?.fontSize,
                                      color: Theme.of(context).canvasColor,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (_) => BlocProvider(
                                          create: (_) => HomeBloc(),
                                          child: AlertDialog(
                                            contentPadding:
                                                const EdgeInsets.all(20),
                                            content: SingleChildScrollView(
                                              child: Column(
                                                children: [
                                                  Image.asset(
                                                    'assets/images/delete.png',
                                                    fit: BoxFit.cover,
                                                    height: 80,
                                                    width: 80,
                                                  ),
                                                  const SizedBox(
                                                    height: 20,
                                                  ),
                                                  Text(
                                                    AppLocalizations.of(
                                                            context)!
                                                        .confirm,
                                                    style: TextStyle(
                                                      fontSize:
                                                          Theme.of(context)
                                                              .textTheme
                                                              .titleLarge
                                                              ?.fontSize,
                                                      fontFamily: 'semibold',
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Text(
                                                    '${AppLocalizations.of(context)!.toDelete} ${state.list[index].title!} ${AppLocalizations.of(context)!.confirmPost}',
                                                    style: TextStyle(
                                                      fontSize:
                                                          Theme.of(context)
                                                              .textTheme
                                                              .titleMedium
                                                              ?.fontSize,
                                                      fontFamily: 'medium',
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 20,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: ElevatedButton(
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            foregroundColor: Theme
                                                                    .of(context)
                                                                .scaffoldBackgroundColor,
                                                            backgroundColor:
                                                                Theme.of(
                                                                        context)
                                                                    .canvasColor,
                                                            minimumSize: const Size
                                                                .fromHeight(35),
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5),
                                                            ),
                                                          ),
                                                          child: Text(
                                                            AppLocalizations.of(
                                                                    context)!
                                                                .cancel,
                                                            style: TextStyle(
                                                                color: Theme.of(
                                                                        context)
                                                                    .scaffoldBackgroundColor,
                                                                fontSize: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .bodyMedium
                                                                    ?.fontSize,
                                                                fontFamily:
                                                                    'medium'),
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        width: 20,
                                                      ),
                                                      Expanded(
                                                        child: ElevatedButton(
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                            debugPrint(
                                                                'Delete this item ${state.list[index].id}');
                                                            context
                                                                .read<
                                                                    HomeBloc>()
                                                                .add(
                                                                  HomeDeletePostEvent(
                                                                    postModel:
                                                                        state.list[
                                                                            index],
                                                                  ),
                                                                );
                                                          },
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            foregroundColor: Theme
                                                                    .of(context)
                                                                .scaffoldBackgroundColor,
                                                            backgroundColor:
                                                                Theme.of(
                                                                        context)
                                                                    .primaryColor,
                                                            minimumSize: const Size
                                                                .fromHeight(35),
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5),
                                                            ),
                                                          ),
                                                          child: Text(
                                                            AppLocalizations.of(
                                                                    context)!
                                                                .delete,
                                                            style: TextStyle(
                                                                color: Theme.of(
                                                                        context)
                                                                    .scaffoldBackgroundColor,
                                                                fontSize: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .bodyMedium
                                                                    ?.fontSize,
                                                                fontFamily:
                                                                    'medium'),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                    icon: Icon(
                                      Icons.delete_outline_outlined,
                                      color: Theme.of(context).canvasColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
