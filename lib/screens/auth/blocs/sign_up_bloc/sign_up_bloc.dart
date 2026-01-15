import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:user_repository/user_repo.dart';
import 'package:user_repository/src/models/user.dart';

part 'sign_up_event.dart';
part 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final UserRepository _userRepository;

  SignUpBloc(this._userRepository) : super(SignUpInitial()) {
    on<SignUpRequired>((event, emit) async {
      emit(SignUpProcess());
      try {
        await _userRepository.signUp(event.user, event.password);
        emit(SignUpSuccess());
      } catch (e) {
        log(e.toString());
        emit(SignUpFailure(message: e.toString()));
      }
    });
  }
}
