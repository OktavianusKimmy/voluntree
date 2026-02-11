import 'package:Voluntree/app.dart';
import 'package:Voluntree/simple_bloc_observer.dart';
import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_repository/firebase_user_repo.dart';

import 'screens/auth/blocs/sign_in_bloc/sign_in_bloc.dart';
import 'screens/auth/blocs/sign_up_bloc/sign_up_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  Bloc.observer = SimpleBlocObserver();

  final userRepository = FirebaseUserRepo();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<SignInBloc>(
          create: (_) => SignInBloc(userRepository),
        ),
        BlocProvider<SignUpBloc>(
          create: (_) => SignUpBloc(userRepository),
        ),
      ],
      child: MyApp(
        userRepository: userRepository,
      ),
    ),
  );
}
