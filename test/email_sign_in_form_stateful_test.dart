import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_app/app/sign_in/email/vanilla/email_sign_in_form_stateful.dart';
import 'package:time_tracker_app/services/auth.dart';
import 'email_sign_in_form_stateful_test.mocks.dart';

@GenerateMocks([Auth, User])
void main() {
  MockAuth mockAuth = MockAuth();

  setUp(() {
    mockAuth = MockAuth();
  });

  void stubSuccessfulResponse() {
    when(mockAuth.signInWithEmail(any, any))
        .thenAnswer((_) async => MockUser());
    when(mockAuth.signUpWithEmail(any, any))
        .thenAnswer((_) async => MockUser());
  }

  void stubFailureResponse() {
    when(mockAuth.signInWithEmail(any, any))
        .thenThrow(FirebaseAuthException(code: 'test'));
    when(mockAuth.signUpWithEmail(any, any))
        .thenThrow(FirebaseAuthException(code: 'test'));
  }

  Future<void> pumpEmailSignInForm(WidgetTester tester,
      {VoidCallback? onSignedIn}) async {
    await tester.pumpWidget(
      Provider<AuthBase>(
        create: (_) => mockAuth,
        child: MaterialApp(
          home: Scaffold(
            body: EmailSignInFormStateful(
              onSignedIn: onSignedIn,
            ),
          ),
        ),
      ),
    );
  }

  group('sign in', () {
    testWidgets('sign in not called', (WidgetTester tester) async {
      var signedIn = false;
      await pumpEmailSignInForm(
        tester,
        onSignedIn: () => signedIn = true,
      );
      final signInButton = find.text('Sign In');
      await tester.tap(signInButton);
      verifyNever(mockAuth.signInWithEmail(any, any));
      expect(signedIn, false);
    });

    testWidgets(
      'sign in called with email / password'
      'successful response',
      (WidgetTester tester) async {
        var signedIn = false;
        stubSuccessfulResponse();
        await pumpEmailSignInForm(
          tester,
          onSignedIn: () => signedIn = true,
        );
        const email = 'email@email.com';
        const password = 'password';

        final emailField = find.byKey(Key('email'));
        expect(emailField, findsOneWidget);
        await tester.enterText(emailField, email);

        final passwordField = find.byKey(Key('password'));
        expect(passwordField, findsOneWidget);
        await tester.enterText(passwordField, password);

        await tester.pump();

        final signInButton = find.text('Sign In');
        await tester.tap(signInButton);

        verify(mockAuth.signInWithEmail(email, password)).called(1);
        expect(signedIn, true);
      },
    );

    testWidgets(
      'sign in called with email / password'
      'failure response',
      (WidgetTester tester) async {
        var signedIn = false;
        stubFailureResponse();
        await pumpEmailSignInForm(
          tester,
          onSignedIn: () => signedIn = true,
        );
        const email = 'email@email.com';
        const password = 'password';

        final emailField = find.byKey(Key('email'));
        expect(emailField, findsOneWidget);
        await tester.enterText(emailField, email);

        final passwordField = find.byKey(Key('password'));
        expect(passwordField, findsOneWidget);
        await tester.enterText(passwordField, password);

        await tester.pump();

        final signInButton = find.text('Sign In');
        await tester.tap(signInButton);

        verify(mockAuth.signInWithEmail(email, password)).called(1);
        expect(signedIn, false);
      },
    );
  });

  group('register', () {
    testWidgets('secondary button toggle', (WidgetTester tester) async {
      await pumpEmailSignInForm(tester);
      final secondaryButton = find.byKey(Key('secondaryButton'));
      await tester.tap(secondaryButton);
      await tester.pump();
      final registerButton = find.text('Create an account');
      expect(registerButton, findsOneWidget);
    });

    testWidgets('register called with email / password',
        (WidgetTester tester) async {
      var signedIn = false;
      stubSuccessfulResponse();
      await pumpEmailSignInForm(
        tester,
        onSignedIn: () => signedIn = true,
      );

      final secondaryButton = find.byKey(Key('secondaryButton'));
      await tester.tap(secondaryButton);
      await tester.pump();

      const email = 'email@email.com';
      const password = 'password';

      final emailField = find.byKey(Key('email'));
      expect(emailField, findsOneWidget);
      await tester.enterText(emailField, email);

      final passwordField = find.byKey(Key('password'));
      expect(passwordField, findsOneWidget);
      await tester.enterText(passwordField, password);

      await tester.pump();

      final registerButton = find.text('Create an account');
      await tester.tap(registerButton);

      verify(mockAuth.signUpWithEmail(email, password)).called(1);
      expect(signedIn, true);
    });
  });
}
