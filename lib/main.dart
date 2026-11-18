import 'dart:io';
import 'package:ahorrala/providers/AuthProvider.dart';
import 'package:ahorrala/services/DeepLinksServices.dart';
import 'package:flutter/material.dart';
import 'package:ahorrala/providers/CategoriesProvider.dart';
import 'package:ahorrala/providers/ConfigProvider.dart';
import 'package:ahorrala/providers/FavoritesProvider.dart';
import 'package:ahorrala/providers/ItemsProvider.dart';
import 'package:ahorrala/services/FavoritesServices.dart';
import 'package:ahorrala/services/RoutesServices.dart';
import 'package:ahorrala/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

import 'package:provider/provider.dart';

import '../firebase_options.dart';
import 'services/HiveServices.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  if (kDebugMode) {
    print('========== BACKGROUND ==========');
    print('ID: ${message.messageId}');
    print('DATA: ${message.data}');
    print('TITLE: ${message.notification?.title}');
    print('BODY: ${message.notification?.body}');
    print('================================');
  }
}

Future<void> _initializeFirebaseMessaging() async {
  final messaging = FirebaseMessaging.instance;

  // Solicitar permisos
  final settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
    provisional: false,
  );

  if (kDebugMode) {
    print('Authorization: ${settings.authorizationStatus}');
  }

  if (settings.authorizationStatus == AuthorizationStatus.denied) {
    if (kDebugMode) {
      print('Permiso de notificaciones denegado.');
    }
    return;
  }

  // Esperar APNs en iOS
  if (Platform.isIOS) {
    String? apnsToken;

    for (int i = 0; i < 100 && apnsToken == null; i++) {
      apnsToken = await messaging.getAPNSToken();

      if (apnsToken == null) {
        if (kDebugMode) {
          print('Esperando APNs... (${i + 1}/100)');
        }
        await Future.delayed(const Duration(seconds: 1));
      }
    }

    if (kDebugMode) {
      print('APNs Token: $apnsToken');
    }

    if (apnsToken == null) {
      throw Exception(
        'No se obtuvo el APNs Token. Revisa la configuración de Apple Push Notifications.',
      );
    }
  }

  final token = await messaging.getToken();

  if (kDebugMode) {
    print('==============================');
    print('FCM TOKEN');
    print(token);
    print('==============================');
  }

  if (token != null) {
    // TODO:
    // enviar token al backend
  }

  await messaging.subscribeToTopic('ahorrala_notif_global');

  messaging.onTokenRefresh.listen((newToken) async {
    if (kDebugMode) {
      print('TOKEN REFRESH');
      print(newToken);
    }

    // TODO:
    // actualizar backend
  });
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Future.microtask(initialize);

  runApp(const MyApp());
}

Future<void> initialize() async {
   await HiveService.init();
  await Firebase.initializeApp();
  await DeepLinkService().init();
  await _initializeFirebaseMessaging();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
 
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<CategoriesProvider>(
          create: (_) => CategoriesProvider(),
        ),

        ChangeNotifierProvider<ConfigProvider>(create: (_) => ConfigProvider()),

        ChangeNotifierProxyProvider<ConfigProvider, ItemsProvider>(
          create: (_) {
            return ItemsProvider();
          },

          update: (_, config, items) {
            final ItemsProvider provider = items ?? ItemsProvider();

            provider.updateConfig(config);
            provider.loadItemsByCategory(
              categoryId: 6,
              sub: 1,
              limit: config.itemsResultsTotal,
            );
            provider.loadItemsByCategory(
              categoryId: 2,
              sub: 1,
              limit: config.itemsResultsTotal,
            );
            provider.loadItemsByCategory(
              categoryId: 7,
              sub: 1,
              limit: config.itemsResultsTotal,
            );
            provider.loadItemsByCategory(
              categoryId: 3,
              sub: 1,
              limit: config.itemsResultsTotal,
            );
            provider.loadItemsByCategory(
              categoryId: 5,
              sub: 1,
              limit: config.itemsResultsTotal,
            );
            provider.loadItemsByCategory(
              categoryId: 4,
              sub: 1,
              limit: config.itemsResultsTotal,
            );
            provider.loadItemsByCategory(
              categoryId: 10,
              sub: 1,
              limit: config.itemsResultsTotal,
            );

            return provider;
          },
        ),
        ChangeNotifierProvider<FavoritesProvider>(
          create: (_) => FavoritesProvider(FavoritesServices())..init(),
        ),
        ChangeNotifierProvider<AuthProvider>(create: (_) => AuthProvider()),
      ],
      child: Consumer<ConfigProvider>(
        builder: (context, provider, child) {
          return MaterialApp.router(
            routerConfig: router,
            theme: AhorralaTheme.lightTheme,
            darkTheme: AhorralaTheme.darkTheme,
            themeMode: provider.themeMode,
            title: 'Ahorrala',
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
