import 'package:flutter/material.dart';
import 'package:flutter_bloc_firebase_crud/app/router/app_route_config.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ErrorScreen extends StatefulWidget {
  final String errorType;
  final String errorMessage;
  const ErrorScreen(
      {super.key, required this.errorType, required this.errorMessage});

  @override
  State<ErrorScreen> createState() => _ErrorScreenState();
}

class _ErrorScreenState extends State<ErrorScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            widget.errorType == '404'
                ? const Image(
                    image: AssetImage('assets/images/404.png'),
                    fit: BoxFit.cover,
                    height: 150,
                    width: 150,
                    alignment: Alignment.center,
                  )
                : const Image(
                    image: AssetImage('assets/images/500.png'),
                    fit: BoxFit.cover,
                    height: 150,
                    width: 150,
                    alignment: Alignment.center,
                  ),
            const SizedBox(
              height: 20,
            ),
            Text(
              AppLocalizations.of(context)!.errorScreen,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: Theme.of(context).textTheme.headlineSmall?.fontSize,
                fontFamily: 'semibold',
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              widget.errorMessage,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Theme.of(context).canvasColor,
                  fontSize: Theme.of(context).textTheme.bodyMedium?.fontSize,
                  fontFamily: 'medium'),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context)
                    .pushReplacementNamed(AppRouter.initialRoute);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Theme.of(context).scaffoldBackgroundColor,
                textStyle: TextStyle(
                    fontFamily: 'semibold',
                    fontSize: Theme.of(context).textTheme.bodyMedium?.fontSize),
              ),
              child: Text(AppLocalizations.of(context)!.errorHome),
            )
          ],
        ),
      ),
    );
  }
}
