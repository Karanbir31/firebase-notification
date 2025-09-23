import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import 'authentication_controller.dart';

class AuthenticationScreen extends GetView<AuthenticationController> {
  AuthenticationScreen({super.key});

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,

      body: SafeArea(
        child: Stack(
          alignment: Alignment.center,

          children: [
            FractionallySizedBox(
              heightFactor: 1,
              widthFactor: 1,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.lightBlue.shade200,
                      Colors.blue,
                      Colors.indigo,
                      Colors.purple,
                      Colors.deepPurpleAccent,
                    ],
                    stops: [0.0, 0.25, 0.5, 0.75, 1.0],
                  ),
                ),
              ),
            ),

            FractionallySizedBox(widthFactor: 0.85, child: userSignUpView()),
          ],
        ),
      ),
    );
  }

  Widget userSignUpView() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white,
          width: 1,
          style: BorderStyle.solid,
        ),
      ),

      child: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 12,

            children: [
              SizedBox(height: 12),

              applicationLogo() ??
                  CircleAvatar(radius: 64, backgroundColor: Colors.grey),

              Text(
                "Login",
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.deepPurple,
                  fontWeight: FontWeight.bold,
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: myInputFlied(
                  label: "Email",
                  textController: controller.emailTextController,
                  textInputType: TextInputType.emailAddress,
                  textVisibility: false,
                  validator: (value) => controller.validateEmail(email: value),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Obx(
                  () => myInputFlied(
                    label: "Password",
                    textController: controller.passwordTextController,
                    textInputType: TextInputType.emailAddress,
                    shouldShowSuffixIcon: true,
                    textVisibility: controller.passwordVisibility.value,
                    validator: (value) =>
                        controller.validatePassword(password: value),
                  ),
                ),
              ),

              Wrap(
                spacing: 12.0,

                children: [
                  myActionButton(
                    label: "New User",
                    onClickButton: () {
                      if (formKey.currentState!.validate()) {
                        controller.createUserWithEmailAndPassword();
                      }
                    },
                  ),
                  myActionButton(
                    label: "Sign In",
                    onClickButton: () {
                      if (formKey.currentState!.validate()) {
                        controller.signInWithEmailAndPassword();
                      }
                    },
                  ),
                ],
              ),

              // google facebook etc auth2 row
              //  socialLoginRow(controller),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget myInputFlied({
    required String label,
    required TextEditingController textController,
    required TextInputType textInputType,
    required bool textVisibility,
    bool shouldShowSuffixIcon = false,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      validator: validator,
      controller: textController,
      keyboardType: textInputType,
      obscureText: textVisibility,
      maxLength: 40,
      maxLines: 1,
      decoration: InputDecoration(
        label: Text(label, style: TextStyle(fontSize: 14)),
        suffixIcon: shouldShowSuffixIcon
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: IconButton(
                  onPressed: controller.togglePasswordVisibility,
                  icon: Icon(
                    color: Colors.black,
                    controller.passwordVisibility.value
                        ? CupertinoIcons.eye
                        : CupertinoIcons.eye_slash,
                  ),
                ),
              )
            : null,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Widget myActionButton({
    required String label,
    required void Function() onClickButton,
  }) {
    return ElevatedButton(
      onPressed: onClickButton,

      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Text(label),
    );
  }

  Widget applicationLogo() {
    return Container(
      width: 84,
      height: 84,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            Colors.lightBlue.shade200,
            Colors.blue,
            Colors.indigo,
            Colors.purple,
            Colors.deepPurpleAccent,
          ],
          stops: [0.0, 0.25, 0.5, 0.75, 1.0],
        ),
      ),
      child: Center(
        child: SvgPicture.asset(
          "assets/svg/svg_firebase.svg",
          fit: BoxFit.fill,
        ),
      ),
    );
  }

  // 🔹 Reusable Social Login Button
  Widget socialLoginButton({
    required String assetPath,
    required double size,
    required VoidCallback onPressed,
  }) {
    return Expanded(
      flex: 1,
      child: IconButton(
        onPressed: onPressed,
        icon: SvgPicture.asset(assetPath, width: size, height: size),
      ),
    );
  }

  // // 🔹 Row with multiple buttons
  //   Widget socialLoginRow(AuthenticationController controller) {
  //     return Row(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       crossAxisAlignment: CrossAxisAlignment.center,
  //       children: [
  //         socialLoginButton(
  //           assetPath: "assets/svg/svg_google.svg",
  //           size: 32,
  //           onPressed: () => controller.signInWithGoogle(),
  //         ),
  //         socialLoginButton(
  //           assetPath: "assets/svg/svg_facebook.svg",
  //           size: 36,
  //           onPressed: () => controller.signInWithFaceBook(),
  //         ),
  //         socialLoginButton(
  //           assetPath: "assets/svg/svg_twitter.svg",
  //           size: 36,
  //           onPressed: () {}, // TODO: Twitter login
  //         ),
  //       ],
  //     );
  //   }
  //
}
