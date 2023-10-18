import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_firebase_crud/app/presentation/pages/splash/bloc/splash_bloc.dart';
import 'package:flutter_bloc_firebase_crud/app/router/app_route_config.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SplashBloc()..add(SplashInitialEvent()),
      child: const SplashView(),
    );
  }
}

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> globalKey = GlobalKey();
    return BlocConsumer<SplashBloc, SplashState>(
      listener: (context, state) {
        if (state.status.isFailure) {
          Navigator.of(context)
              .pushReplacementNamed(AppRouter.errorRoute, arguments: [
            '500',
            state.toastMessage,
          ]);
        }
        if (state.status.isAuthorized) {
          Navigator.of(context).pushReplacementNamed(AppRouter.homeRoute);
        }
        if (state.status.isUnAuthorized) {
          Navigator.of(context).pushReplacementNamed(AppRouter.loginRoute);
        }
      },
      builder: (context, state) {
        return Scaffold(
          key: globalKey,
          body: Stack(
            alignment: AlignmentDirectional.center,
            children: [
              const Image(
                image: AssetImage('assets/images/splash.png'),
                fit: BoxFit.cover,
                height: double.infinity,
                width: double.infinity,
                alignment: Alignment.center,
              ),
              Positioned(
                bottom: 50,
                child: Center(
                  child: CircularProgressIndicator(
                    color: Theme.of(context).primaryColor,
                  ),
                ), //CircularAvatar
              ),
            ],
          ),
        );
      },
    );
  }
}
