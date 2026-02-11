import 'package:Voluntree/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:Voluntree/screens/auth/views/welcome_screen.dart';
import 'package:Voluntree/screens/home/views/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Voluntree/theme/app_colors.dart';

class MyAppView extends StatelessWidget {
  const MyAppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Join Event',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: const ColorScheme.light(
          background: bone,
          onBackground: Colors.black,
          primary: Colors.lightGreen,
          onPrimary: Colors.white,
          tertiary: Colors.lightBlue,
        )
      ),
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: ((context, state){
            if(state.status == AuthenticationStatus.authenticated) {
              return HomeScreen(key: ValueKey(state.status));
            }else{
              return WelcomeScreen(key: ValueKey(state.status));
            }
          }))
    );
  }
}
