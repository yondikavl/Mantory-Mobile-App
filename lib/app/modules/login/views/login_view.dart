import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:qrcode_app/app/controllers/auth_controller.dart';
import 'package:qrcode_app/app/routes/app_pages.dart';

import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  LoginView({Key? key}) : super(key: key);

  final TextEditingController emailC = TextEditingController(
    text: "admin@gmail.com",
  );
  final TextEditingController passC = TextEditingController(
    text: "admin123",
  );

  final AuthController authC = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Login',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: Colors.indigo,
        ),
        body: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            TextField(
              autocorrect: false,
              controller: emailC,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: "Email",
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 24),
            Obx(
              () => TextField(
                autocorrect: false,
                controller: passC,
                keyboardType: TextInputType.text,
                obscureText: controller.isHidden.value,
                decoration: InputDecoration(
                  labelText: "Password",
                  suffixIcon: IconButton(
                      onPressed: () {
                        controller.isHidden.toggle();
                      },
                      icon: Icon(controller.isHidden.isFalse
                          ? Icons.remove_red_eye
                          : Icons.remove_red_eye_outlined)),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () async {
                if (controller.isLoading.isFalse) {
                  if (emailC.text.isNotEmpty && passC.text.isNotEmpty) {
                    controller.isLoading(true);
                    Map<String, dynamic> hasil =
                        await authC.login(emailC.text, passC.text);
                    controller.isLoading(false);

                    if (hasil["error"] == true) {
                      Get.snackbar("Error", hasil["message"]);
                    } else {
                      Get.offAllNamed(Routes.home);
                    }
                  } else {
                    Get.snackbar(
                        "Error", "Email and Password must be filled in.");
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  backgroundColor: Colors.indigo),
              child: Obx(
                () => Text(
                  controller.isLoading.isFalse ? "Login" : "Loading...",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
