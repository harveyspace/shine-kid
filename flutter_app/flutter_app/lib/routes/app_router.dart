import 'package:go_router/go_router.dart';

import 'features/home/home_page.dart';
import 'features/jump_rope/jump_rope_page.dart';
import 'features/jump_rope/jump_rope_record_page.dart';
import 'features/football/football_page.dart';
import 'features/report/report_page.dart';
import 'features/profile/profile_page.dart';

class AppRouter {
  final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: '/jump-rope',
        name: 'jumpRope',
        builder: (context, state) => const JumpRopePage(),
      ),
      GoRoute(
        path: '/jump-rope/record',
        name: 'jumpRopeRecord',
        builder: (context, state) => const JumpRopeRecordPage(),
      ),
      GoRoute(
        path: '/football',
        name: 'football',
        builder: (context, state) => const FootballPage(),
      ),
      GoRoute(
        path: '/report',
        name: 'report',
        builder: (context, state) => const ReportPage(),
      ),
      GoRoute(
        path: '/profile',
        name: 'profile',
        builder: (context, state) => const ProfilePage(),
      ),
    ],
  );
}
