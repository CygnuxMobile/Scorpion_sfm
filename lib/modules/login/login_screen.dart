import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scorpforce/modules/login/login_controller.dart';
import '../../config/app_colors.dart';
import '../../config/app_images.dart';
import '../../config/app_shared_key.dart';
import '../../config/app_text_style.dart';
import '../../main.dart';
import '../widget/loader.dart';
import '../widget/toast_message.dart';
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  LoginController loginController = Get.put(LoginController());
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.primaryColor,
        title: const Text(
          'Login',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Obx(() {
            return Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  Center(
                      child: Image.asset(
                    AppImages.appLogo,
                    scale: 7,
                  )),
                  const SizedBox(height: 10),
                  const Center(
                    child: Text(
                      'Welcome Back!',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Center(
                    child: Text(
                      'Please sign in to continue',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Email Field
                  TextFormField(
                    cursorColor: AppColors.grey,
                    readOnly: loginController.isLoading.value ? true : false,
                    controller: loginController.emailController.value,
                    validator: (value) {
                      if (value!.trim().isEmpty) {
                        return "Username is required!";
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                      labelText: "Username",
                      hintText: "Enter your Username",
                      hintStyle: const TextStyle(color: AppColors.grey),
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: AppColors.boderColor,
                          width: 1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: AppColors.boderColor,
                          width: 1,
                        ),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: AppColors.boderColor,
                          width: 1,
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 20),

                  // Password Field
                  TextFormField(
                    cursorColor: AppColors.grey,
                    readOnly: loginController.isLoading.value ? true : false,
                    controller: loginController.passwordController.value,
                    validator: (value) {
                      if (value!.trim().isEmpty) {
                        return "Password is required!";
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                      labelText: "Password",
                      hintText: "Enter your password",
                      hintStyle: const TextStyle(color: AppColors.grey),
                      prefixIcon: Icon(Icons.password),
                      suffixIcon: GestureDetector(
                          onTap: () {
                            loginController.obSecure.value = !loginController.obSecure.value;
                          },
                          child: loginController.obSecure.value ? Icon(Icons.visibility) : Icon(Icons.visibility_off)),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: AppColors.boderColor,
                          width: 1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: AppColors.boderColor,
                          width: 1,
                        ),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: AppColors.boderColor,
                          width: 1,
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    obscureText: loginController.obSecure.value,
                  ),
                  const SizedBox(height: 20),

                  // Login Button
                  Center(
                      child: GestureDetector(
                    onTap: () async {
                      if (_formKey.currentState!.validate()) {
                        debugPrint("qqqq ${pref!.getString(LocalStorageKey.deletedUserId)}");
                        debugPrint("qqqq ${loginController.emailController.value.text}");
                        if (pref!.getString(LocalStorageKey.deletedUserId) != null && (pref!.getString(LocalStorageKey.deletedUserId) == loginController.emailController.value.text.toLowerCase())) {
                          toastMessage(color: AppColors.redColor, text: "Account is deleted by you.\nPlease contact customer Care");
                        } else {
                          await loginController.login();
                        }
                      }
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 50,
                      width: 180,
                      decoration: BoxDecoration(color: AppColors.primaryColor, borderRadius: BorderRadius.circular(12)),
                      child: loginController.isLoading.value
                          ? loader(loaderColor: AppColors.whiteColor)
                          : Text(
                              "Login",
                              style: AppTextStyle.regular.copyWith(fontSize: 15, color: AppColors.whiteColor, fontWeight: FontWeight.bold),
                            ),
                    ),
                  )
                      /*  ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          await loginController.login();
                        }
                        // Handle login submission logic here
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        minimumSize: const Size(200, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: loginController.isLoading.value
                          ? const Padding(
                              padding: EdgeInsets.all(10.0),
                              child: CircularProgressIndicator(
                                color: AppColors.white,
                              ),
                            )
                          : const Text(
                              "Login",
                              style: TextStyle(color: Colors.white),
                            ),
                    ),*/
                      ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
