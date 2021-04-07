import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'package:time_tracker_app/app/sign_in/email/bloc/email_sign_in_model.dart';
import 'package:time_tracker_app/services/auth.dart';

class EmailSignInBloc {
  EmailSignInBloc({required this.auth});

  final AuthBase auth;

  final _modelSubject =
      BehaviorSubject<EmailSignInModel>.seeded(EmailSignInModel());

  Stream<EmailSignInModel> get modelStream => _modelSubject.stream;

  EmailSignInModel get _model => _modelSubject.value!;

  void dispose() {
    _modelSubject.close();
  }

  void _updateWith({
    String? email,
    String? password,
    EmailSignInFormType? formType,
    bool? submitted,
    bool? isLoading,
  }) {
    _modelSubject.add(_model.copyWith(
      email: email,
      password: password,
      formType: formType,
      submitted: submitted,
      isLoading: isLoading,
    ));
  }

  void updateEmail(String email) => _updateWith(email: email);

  void updatePassword(String password) => _updateWith(password: password);

  Future<void> submit() async {
    _updateWith(isLoading: true, submitted: true);
    try {
      if (_model.formType == EmailSignInFormType.signIn) {
        await auth.signInWithEmail(_model.email, _model.password);
      } else {
        await auth.signUpWithEmail(_model.email, _model.password);
      }
    } catch (e) {
      _updateWith(isLoading: false);
      rethrow;
    }
  }

  void toggleFormType() {
    final formType = _model.formType == EmailSignInFormType.signIn
        ? EmailSignInFormType.register
        : EmailSignInFormType.signIn;
    _updateWith(
      submitted: false,
      isLoading: false,
      email: '',
      password: '',
      formType: formType,
    );
  }
}
