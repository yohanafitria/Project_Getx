import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../utils/api.dart';
import '../../dashboard/views/dashboard_view.dart';
import '../views/login_view.dart';

class LoginController extends GetxController {
  final _getConnect = GetConnect();
  TextEditingController emailContoller = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final authToken = GetStorage();
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    emailContoller.dispose();
    passwordController.dispose();
  }
  // void increment() => count.value++;
  void loginNow() async {
    isLoading.value = true;
    var client = http.Client();
    var response = await client.post(
      Uri.https(BaseUrl.auth, '/api/login'),
      body: {
        'email': emailContoller.text,
        'password': passwordController.text,
      },
    );
    
    var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
    if (decodedResponse['success'] == true) {
      isLoading.value = false;
      authToken.write('token', decodedResponse['access_token']);
      authToken.write('full_name', decodedResponse['full_name']);
      Get.offAll(() => DashboardView());
    } else {
      isLoading.value = false;
      Get.snackbar(
        'Error',
        decodedResponse['message'].toString(),
        icon: const Icon(Icons.error),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        forwardAnimationCurve: Curves.bounceIn,
        margin: const EdgeInsets.only(
          top: 10,
          left: 5,
          right: 5,
        ),
      );
    }
  }
  void logout() {
    authToken.remove('token');
    Get.offAll(() => LoginView());
  }

  @override
  void dispose() {
     try { emailContoller.dispose(); } catch (e) {return;}
     try { passwordController.dispose(); } catch (e) {return;}
    super.dispose();
  }
}