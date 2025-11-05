import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/services/match_cache_service.dart';
import 'core/services/scheduled_update_service.dart';
import 'core/services/betting_parser_service.dart';
import 'features/matches/data/datasources/match_memory_datasource.dart';
import 'features/matches/data/repositories/match_repository_impl.dart';
import 'features/matches/presentation/bloc/match_bloc.dart';
import 'features/analysis/presentation/bloc/analysis_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize date formatting for Russian locale
  await initializeDateFormatting('ru', null);

  // Initialize services
  final cacheService = MatchCacheService();
  await cacheService.initialize();

  final parserService = BettingParserService();

  final updateService = ScheduledUpdateService(
    parserService: parserService,
    onDataParsed: (matches) async {
      await cacheService.cacheMatches(matches);
    },
  );

  await updateService.initialize();

  runApp(MyApp(
    cacheService: cacheService,
    updateService: updateService,
  ));
}

class MyApp extends StatelessWidget {
  final MatchCacheService cacheService;
  final ScheduledUpdateService updateService;

  const MyApp({
    super.key,
    required this.cacheService,
    required this.updateService,
  });

  @override
  Widget build(BuildContext context) {
    // Initialize repository with memory storage (for web debugging)
    final dataSource = MatchMemoryDataSource();
    final repository = MatchRepositoryImpl(dataSource);

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => MatchBloc(
            repository: repository,
            cacheService: cacheService,
            updateService: updateService,
          )..add(FetchCachedMatches()),
        ),
        BlocProvider(
          create: (context) => AnalysisBloc(repository),
        ),
      ],
      child: MaterialApp.router(
        title: '1xForecast',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        debugShowCheckedModeBanner: false,
        routerConfig: AppRouter.router,
      ),
    );
  }
}
