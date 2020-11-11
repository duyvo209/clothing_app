part of 'register_bloc.dart';

class RegisterState extends Equatable {
  final bool registerLoading;
  final bool registerSuccess;
  final String registerError;

  RegisterState(
      {this.registerLoading, this.registerSuccess, this.registerError});

  factory RegisterState.empty() {
    return RegisterState(
        registerLoading: false, registerSuccess: false, registerError: '');
  }
  RegisterState copyWith({
    bool registerLoading,
    bool registerSuccess,
    String registerError,
  }) {
    return RegisterState(
      registerLoading: registerLoading ?? this.registerLoading,
      registerSuccess: registerSuccess ?? this.registerSuccess,
      registerError: registerError ?? this.registerError,
    );
  }

  @override
  List<Object> get props =>
      [this.registerLoading, this.registerSuccess, this.registerError];
}
