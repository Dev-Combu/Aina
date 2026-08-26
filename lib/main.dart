import 'package:aina/app/router.dart';
import 'package:aina/app/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';

// serverpod 이용하지 않아서 주석 처리
// late Client client;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 로케일 초기화 (한글 설정)
  await initializeDateFormatting('ko_KR', null);

  // 환경 변수 로드 (.env)
  await dotenv.load(fileName: ".env");

  // Supabase 초기화
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );


  // serverpod 이용하지 않아서 주석 처리
  // // 2. Client 초기화 (포트 8082 확인)
  // client = Client('http://localhost:8082/')
  //   ..connectivityMonitor = FlutterConnectivityMonitor()
  //   ..authSessionManager = FlutterAuthSessionManager();

  // // 3. 세션 초기화 완료 대기
  // await client.auth.initialize();

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
      theme: AppTheme.lightTheme, // Use the custom light theme
      themeMode: ThemeMode.light, // Force light mode to keep warm beige colors
      routerConfig: router,
    );
  }
}
