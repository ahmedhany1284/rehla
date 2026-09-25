import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rehla/core/presentation/view/focus_handler.dart';
import 'package:rehla/core/presentation/view_model/cubit/app_cubit.dart';
import 'package:rehla/core/presentation/view_model/cubit/app_state.dart';
import 'package:rehla/core/routing/app_router.dart';
import 'package:rehla/core/services/intializer_service/initializer_service.dart';
import 'package:rehla/core/theme/app_theme.dart';
import 'package:rehla/core/utils/app_consts.dart';
import 'package:rehla/core/utils/app_strings.dart';
import 'package:rehla/features/home/data/datasources/course_local_datasource.dart';
import 'package:rehla/features/home/data/repositories/course_repository_impl.dart';
import 'package:rehla/features/home/domain/usecases/get_courses_usecase.dart';
import 'package:rehla/features/home/presentation/home/home_cubit.dart';
import 'package:rehla/generated/assets.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppInitializer().init();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('ar'), Locale('en')],
      path: AssetData.translations,
      fallbackLocale: const Locale('ar'),
      startLocale: const Locale('ar'),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AppFocusHandler(
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => AppCubit()),
          BlocProvider(
            create: (_) => HomeCubit(
              GetCoursesUseCase(CourseRepositoryImpl(CourseLocalDataSource())),
            )..getCourses(),
          ),
        ],
        child: BlocBuilder<AppCubit, AppState>(
          buildWhen: (previous, current) =>
              current is ChangeThemeState ||
              current is ChangeLanguageState ||
              current is ChangeFontState,
          builder: (context, state) {
            final appCubit = context.read<AppCubit>();
            return MaterialApp.router(
              localizationsDelegates: context.localizationDelegates,
              supportedLocales: context.supportedLocales,
              locale: context.locale,
              debugShowCheckedModeBanner: false,
              title: AppStrings.appName,
              theme: AppTheme.appLightTheme(appCubit.currentFontFamily),
              darkTheme: AppTheme.appDarkTheme(appCubit.currentFontFamily),
              themeMode: AppConst.isDark ? ThemeMode.dark : ThemeMode.light,
              routerConfig: AppRouter.router,
            );
          },
        ),
      ),
    );
  }
}
