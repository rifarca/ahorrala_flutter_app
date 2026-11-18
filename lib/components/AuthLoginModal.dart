import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/AuthProvider.dart';

class AuthLoginModal {
  static Future<bool> show(BuildContext context) async {
    final auth = context.read<AuthProvider>();

    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,

      builder: (_) {
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),

          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                ),
              ),

              const Icon(Icons.person_outline, size: 55),

              const SizedBox(height: 12),

              const Text(
                "Iniciar sesión",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 8),

              const Text(
                "Accede para guardar favoritos,\nalertas y preferencias.",
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 25),

              // GOOGLE
              _button(
                icon: Icons.g_mobiledata,
                text: "Continuar con Google",
                onTap: () async {
                  final ok = await auth.loginGoogle();

                  if (ok) {
                    Navigator.pop(context, true);
                  }
                },
              ),

              // FACEBOOK
              _button(
                icon: Icons.facebook,
                text: "Continuar con Facebook",
                onTap: () async {
                  final ok = await auth.loginFacebook();

                  if (ok) {
                    Navigator.pop(context, true);
                  }
                },
              ),

              // APPLE
              _button(
                icon: Icons.apple,
                text: "Continuar con Apple",
                onTap: () async {
                  final ok = await auth.loginApple();

                  if (ok) {
                    Navigator.pop(context, true);
                  }
                },
              ),

              const SizedBox(height: 15),
            ],
          ),
        );
      },
    );

    return result ?? false;
  }

  static Widget _button({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),

      child: FilledButton.icon(
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),

        icon: Icon(icon),

        label: Text(text, style: const TextStyle(fontSize: 16)),

        onPressed: onTap,
      ),
    );
  }
}
