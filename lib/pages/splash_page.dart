import 'dart:convert';

import '../models/config.dart';
import '../services/http_service.dart';
import '../services/movie_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';

class SplashPage extends StatefulWidget {
  final VoidCallback onInitializationComplete;
  const SplashPage({super.key, required this.onInitializationComplete});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1)).then(
      (_) => _setup(context).then(
        (value) => widget.onInitializationComplete(),
      ),
    );
  }

  Future<void> _setup(BuildContext context) async {
    final getIt = GetIt.instance;

    final configFile = await rootBundle.loadString('assets/config/main.json');
    final configData = jsonDecode(configFile);

    getIt.registerSingleton<AppConfig>(AppConfig(
      BASE_API_URL: configData['BASE_API_URL'],
      BASE_IMAGE_API_URL: configData['BASE_IMAGE_API_URL'],
      API_KEY: configData['API_KEY'],
    ));

    getIt.registerSingleton<HTTPService>(HTTPService());

    getIt.registerSingleton<MovieService>(MovieService());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Cirama",
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Container(
        color: Colors.white,
        child: RotationTransition(
          turns: const AlwaysStoppedAnimation(90 / 360),
          child: Image.asset(
            "assets/images/6354.jpg",
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
