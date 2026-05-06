import 'package:aina/app/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'Aina',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF86B082), // Soft pastel green
          background: const Color(0xFFF9F6F0), // Warm beige
        ),
        useMaterial3: true,
        fontFamily:
            'Pretendard', // Assuming a clean font, can be omitted if not imported
      ),
      routerConfig: router,
    );
  }
}
