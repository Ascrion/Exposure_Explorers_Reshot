import 'package:exposure_explorer_reshot/screens/desktop/home_page_desktop.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// --- Providers for username and password ---
final usernameProvider = StateProvider<String>((ref) => '');
final passwordProvider = StateProvider<String>((ref) => '');
final loginResult = StateProvider<dynamic>((ref) => '');

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _focusNode1 = FocusNode();
  final _focusNode2 = FocusNode();

  @override
  void dispose() {
    _focusNode1.dispose();
    _focusNode2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final username = ref.watch(usernameProvider);
    final password = ref.watch(passwordProvider);
    final labelTextStyle = Theme.of(context).textTheme.titleMedium?.copyWith(
        color: Theme.of(context).colorScheme.onPrimary, fontSize: 20);
    final result = ref.watch(loginResult);

    return LayoutBuilder(builder: (context, constraints) {
      final width = MediaQuery.of(context).size.width;
      final height = MediaQuery.of(context).size.height;
      return Align(
          child: SizedBox(
              height: height / 2,
              width: width / 3,
              child: Card(
                child: Padding(
                  padding:
                      const EdgeInsetsDirectional.symmetric(horizontal: 35),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        'Admin Login',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontSize: 45),
                      ),
                      AutofillGroup(
                          child: Column(children: [
                        TextField(
                          decoration: InputDecoration(
                              labelText: 'Username',
                              floatingLabelStyle: labelTextStyle,
                              labelStyle: labelTextStyle),
                          autofillHints: const [AutofillHints.username],
                          onChanged: (val) =>
                              ref.read(usernameProvider.notifier).state = val,
                          focusNode: _focusNode1,
                          onSubmitted: (_) =>
                              FocusScope.of(context).requestFocus(_focusNode2),
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary),
                          cursorColor: Theme.of(context).colorScheme.secondary,
                        ),
                        TextField(
                          decoration: InputDecoration(
                              labelText: 'Password',
                              floatingLabelStyle: labelTextStyle,
                              labelStyle: labelTextStyle),
                          obscureText: true,
                          autofillHints: const [AutofillHints.password],
                          onChanged: (val) =>
                              ref.read(passwordProvider.notifier).state = val,
                          focusNode: _focusNode2,
                          onSubmitted: (_) => FocusScope.of(context).unfocus(),
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary),
                          cursorColor: Theme.of(context).colorScheme.secondary,
                        ),
                      ])),
                      SizedBox(
                        height: height * 0.01,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.inversePrimary,
                          foregroundColor: Colors.white,
                          elevation: 4, // ✨ Shadow
                          shape: RoundedRectangleBorder(
                            // 🔲 Border radius
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 50, vertical: 20),
                          textStyle: labelTextStyle,
                        ),
                        onPressed: () {
                          if (username.isEmpty || password.isEmpty) {
                            ref.read(loginResult.notifier).state =
                                'Please fill both fields...';
                          } else {
                            authenticator(ref, username, password);
                          }
                        },
                        child: Text('Login'),
                      ),
                      SizedBox(
                        height: height * 0.01,
                      ),
                      SizedBox(
                          height: height * 0.05,
                          width: width,
                          child: Text(
                            result,
                            style: labelTextStyle,
                            textAlign: TextAlign.center,
                          )),
                      SizedBox(
                        height: height * 0.01,
                      ),
                    ],
                  ),
                ),
              )));
    });
  }
}

// On Authorization move to Admin Page
void authenticator(WidgetRef ref, String username, String password) async {
  final response = await http.post(
    Uri.parse('https://password-api.navodiths.workers.dev/admin'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'username': username, 'password': password}),
  );
  ref.read(loginResult.notifier).state = response.body;

  // If login successful move to admin page
  if (response.statusCode == 200) {
    ref.read(currentPage.notifier).state = 'ADMIN';
  }
}
