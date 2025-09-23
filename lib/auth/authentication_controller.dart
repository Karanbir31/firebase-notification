import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mynotification/payments_screen/payments_screen.dart';

class AuthenticationController extends GetxController {
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  RxBool passwordVisibility = false.obs;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  void togglePasswordVisibility() {
    passwordVisibility.value = !passwordVisibility.value;
  }

  String? validateEmail({String? email}) {
    if (email == null || email.isEmpty) {
      return "Email is required";
    }
    if (!GetUtils.isEmail(email)) {
      return "Enter a valid email";
    }
    return null;
  }

  String? validatePassword({String? password}) {
    if (password == null || password.isEmpty) {
      return "Password is required";
    }
    if (password.length < 6) {
      return "Password must be at least 6 characters";
    }
    return null;
  }

  /// Create a new user (Sign Up)
  Future<void> createUserWithEmailAndPassword() async {
    try {
      final email = emailTextController.text.trim();
      final password = passwordTextController.text.trim();

      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      Get.snackbar("Success", "Account created successfully!");

      final authUser = _auth.currentUser;
      if (authUser != null) {
        Get.to(PaymentTestScreen());
      }
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Error", e.message ?? "Something went wrong");
    }
  }

  /// Sign In with Email and Password
  Future<void> signInWithEmailAndPassword() async {
    try {
      final email = emailTextController.text.trim();
      final password = passwordTextController.text.trim();

      await _auth.signInWithEmailAndPassword(email: email, password: password);

      Get.snackbar("Success", "Logged in successfully!");

      final authUser = _auth.currentUser;
      if (authUser != null) {
        Get.to(PaymentTestScreen());
      }
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Error", e.message ?? "Something went wrong");
    }
  }

  /// Example: Login button click
  void onClickLoginButton() {
    signInWithEmailAndPassword();
  }
}
