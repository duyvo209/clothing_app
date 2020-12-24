part of 'login_phone_bloc.dart';

class LoginPhoneState extends Equatable {
  final bool loginPhoneLoading;
  final bool loginPhoneSuccess;
  final String loginPhoneError;
  final bool confirmCodeLoading;
  final bool confirmCodeSuccess;
  final String cofirmCodeError;
  final String verificationId;
  final String userId;
  LoginPhoneState({
    this.loginPhoneLoading,
    this.loginPhoneSuccess,
    this.loginPhoneError,
    this.confirmCodeLoading,
    this.confirmCodeSuccess,
    this.cofirmCodeError,
    this.verificationId,
    this.userId,
  });

  factory LoginPhoneState.empty() {
    return LoginPhoneState(
      cofirmCodeError: '',
      confirmCodeLoading: false,
      confirmCodeSuccess: false,
      loginPhoneError: '',
      loginPhoneLoading: false,
      loginPhoneSuccess: false,
      verificationId: '',
      userId: '',
    );
  }
  LoginPhoneState copyWith({
    bool loginPhoneLoading,
    bool loginPhoneSuccess,
    String loginPhoneError,
    bool confirmCodeLoading,
    bool confirmCodeSuccess,
    String cofirmCodeError,
    String verificationId,
    String userId,
  }) {
    return LoginPhoneState(
      verificationId: verificationId ?? this.verificationId,
      loginPhoneError: loginPhoneError ?? this.loginPhoneError,
      cofirmCodeError: cofirmCodeError ?? this.cofirmCodeError,
      confirmCodeLoading: confirmCodeLoading ?? this.confirmCodeLoading,
      confirmCodeSuccess: confirmCodeSuccess ?? this.confirmCodeSuccess,
      loginPhoneLoading: loginPhoneLoading ?? this.loginPhoneLoading,
      loginPhoneSuccess: loginPhoneSuccess ?? this.loginPhoneSuccess,
      userId: userId ?? this.userId,
    );
  }

  @override
  List<Object> get props => [
        this.userId,
        this.verificationId,
        this.loginPhoneLoading,
        this.loginPhoneSuccess,
        this.loginPhoneError,
        this.confirmCodeLoading,
        this.confirmCodeSuccess,
        this.cofirmCodeError
      ];
}
