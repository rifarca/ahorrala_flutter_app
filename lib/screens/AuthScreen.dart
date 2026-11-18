// screens/auth/AuthScreen.dart

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/AuthProvider.dart';

class AuthScreen extends StatefulWidget {
  final title;
  const AuthScreen({super.key, required this.title});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (_, auth, _) {
        return Scaffold(
          appBar: AppBar(title: Text(widget.title), centerTitle: true),
          body: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Column(
                  children: [
                    //----------------------------------
                    // LOGO
                    //----------------------------------
                    CircleAvatar(
                      radius: 45,
                      backgroundColor: Theme.of(
                        context,
                      ).colorScheme.primaryContainer,
                      child: Icon(
                        Icons.shopping_cart,
                        size: 50,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),

                    const SizedBox(height: 24),

                    Text(
                      "Bienvenido a Ahorrala",
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 10),

                    Text(
                      "Inicia sesión para sincronizar tus favoritos, alertas y preferencias entre todos tus dispositivos.",
                      style: Theme.of(context).textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 40),

                    if (auth.loading)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 32),
                        child: CircularProgressIndicator(),
                      )
                    else ...[
                      //----------------------------------
                      // GOOGLE
                      //----------------------------------
                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: FilledButton.icon(
                          icon: const Icon(Icons.g_mobiledata),
                          label: const Text("Continuar con Google"),
                          onPressed: () async {
                            await auth.loginGoogle();
                          },
                        ),
                      ),

                      const SizedBox(height: 16),

                      //----------------------------------
                      // FACEBOOK
                      //----------------------------------
                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: FilledButton.icon(
                          icon: const Icon(Icons.facebook),
                          label: const Text("Continuar con Facebook"),
                          onPressed: () async {
                            await auth.loginFacebook();
                          },
                        ),
                      ),

                      const SizedBox(height: 16),

                      //----------------------------------
                      // APPLE
                      //----------------------------------
                      if (Platform.isIOS)
                        SizedBox(
                          width: double.infinity,
                          height: 54,
                          child: FilledButton.icon(
                            icon: const Icon(Icons.apple),
                            label: const Text("Continuar con Apple"),
                            onPressed: () async {
                              await auth.loginApple();
                            },
                          ),
                        ),

                      const SizedBox(height: 30),

                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("Continuar como invitado"),
                      ),
                    ],

                    //----------------------------------
                    // ERROR
                    //----------------------------------
                    if (auth.error != null) ...[
                      const SizedBox(height: 20),
                      Text(
                        auth.error!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ],

                    const SizedBox(height: 30),

                    Text(
                      "Al continuar aceptas nuestros Términos de uso y Política de privacidad.",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
