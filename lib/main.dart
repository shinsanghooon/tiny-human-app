import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'common/provider/route_provider.dart';

void main() {
  runApp(
    ProviderScope(
      child: _App(),
    ),
  );
}

class _App extends ConsumerWidget {
  const _App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routeProvider);
    return MaterialApp.router(
      theme: ThemeData(
        useMaterial3: true,
        dialogBackgroundColor: Colors.white,
        scaffoldBackgroundColor: Colors.white,
        dialogTheme: const DialogTheme(surfaceTintColor: Colors.white),
      ),
      debugShowCheckedModeBanner: false,
      routerConfig: router,
    );
  }
}
