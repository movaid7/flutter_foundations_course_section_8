import 'dart:async';

import 'package:ecommerce_app/src/app.dart';
import 'package:ecommerce_app/src/features/cart/data/local/local_cart_repository.dart';
import 'package:ecommerce_app/src/features/cart/data/local/sembast_cart_repository.dart';
import 'package:ecommerce_app/src/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

void main() async {
  // * For more info on error handling, see:
  // * https://docs.flutter.dev/testing/errors
  await runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    // turn off the # in the URLs on the web
    GoRouter.setUrlPathStrategy(UrlPathStrategy.path);

    // Wait for repository to be created before running App!!
    // Asynchronous initialization but synchronous usage afterwards
    final LocalCartRepository = await SembastCartRepository.makeDefault();
    // * Entry point of the app
    runApp(ProviderScope(
      overrides: [
        localCartRepositoryProvider.overrideWithValue(LocalCartRepository),
      ],
      child: const MyApp(),
    ));

    // * This code will present some error UI if any uncaught exception happens
    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.presentError(details);
    };
    ErrorWidget.builder = (FlutterErrorDetails details) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: Text('An error occurred'.hardcoded),
        ),
        body: Center(child: Text(details.toString())),
      );
    };
  }, (Object error, StackTrace stack) {
    // * Log any errors to console
    debugPrint(error.toString());
  });
}
