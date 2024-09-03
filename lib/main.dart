import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:test/core/utils/api_services.dart';
import 'package:test/core/utils/bloc_observer.dart';
import 'package:test/core/utils/service_locator.dart';
import 'package:test/features/auth/presentation/views/login_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:test/features/cache/domain/entities/product_entity.dart';
import 'package:test/features/cache/presentation/views/cache_data.dart';
import 'package:test/features/details/presentation/views/details.dart';
import 'package:test/fs.dart';
import 'package:test/sensitive_data.dart';
import 'firebase_options.dart';
import 'features/auth/presentation/manger/auth_cubit/auth_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await Supabase.initialize(
    url: url,
    anonKey: apiKey,
  );
  await Hive.initFlutter();
  Hive.registerAdapter(ProductEntityAdapter());
  await Hive.openBox<ProductEntity>('products');

  setupServiceLocator();
  Bloc.observer = SimpleBlocObserver();
  runApp(BlocProvider(
    create: (context) => AuthCubit(ApiServices(Dio()))..getData(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: FirstView(),
      debugShowCheckedModeBanner: false,
    );
  }
}
