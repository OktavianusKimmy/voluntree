import 'package:Voluntree/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:Voluntree/screens/auth/views/welcome_screen.dart';
import 'package:Voluntree/screens/home/views/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyAppView extends StatelessWidget {
  const MyAppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Join Event',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.light(
          background: Colors.white,
          onBackground: Colors.black,
          primary: Colors.lightGreen,
          onPrimary: Colors.white
        )
      ),
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: ((context, state){
            if(state.status == AuthenticationStatus.authenticated) {
              return const HomeScreen();
            }else{
              return const WelcomeScreen();
            }
          }))
    );
  }
}
