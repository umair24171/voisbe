import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_notes/resources/colors.dart';
import 'package:social_notes/resources/navigation.dart';
import 'package:social_notes/screens/auth_screens/controller/auth_controller.dart';
import 'package:social_notes/screens/auth_screens/model/user_model.dart';
import 'package:social_notes/screens/auth_screens/providers/auth_provider.dart';
import 'package:social_notes/screens/auth_screens/view/widgets/custom_form_field.dart';
import 'package:social_notes/screens/profile_screen/profile_screen.dart';

class AuthScreen extends StatelessWidget {
  AuthScreen({super.key});
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  final TextEditingController confirmController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
            child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Image.asset('assets/images/app-logo.png'),
                Text(
                  'VOISBE',
                  style: TextStyle(
                    fontFamily: fontFamily,
                    color: whiteColor,
                    // fontStyle: FontStyle.italic,
                    fontSize: 35,
                  ),
                )
              ]),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    authProvider.setIslogin(false);
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: authProvider.isLogin ? primaryColor : whiteColor,
                      border: Border.all(width: 2, color: whiteColor),
                    ),
                    child: Text(
                      'Create Account',
                      style: TextStyle(
                          color:
                              authProvider.isLogin ? whiteColor : primaryColor,
                          fontFamily: fontFamily),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    authProvider.setIslogin(true);
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 50, vertical: 8),
                    decoration: BoxDecoration(
                      color: authProvider.isLogin ? whiteColor : primaryColor,
                      border: Border.all(width: 2, color: whiteColor),
                    ),
                    child: Text(
                      'Log In',
                      style: TextStyle(
                          color:
                              authProvider.isLogin ? primaryColor : whiteColor,
                          fontFamily: fontFamily),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                      vertical: 5, horizontal: size.width * 0.12)
                  .copyWith(top: 30),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  authProvider.isLogin ? 'Welcome Back' : 'Create Account',
                  style: TextStyle(
                      fontFamily: fontFamily,
                      fontSize: 17,
                      color: whiteColor,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  vertical: 5, horizontal: size.width * 0.12),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  authProvider.isLogin
                      ? 'Fill out the information below in order to access your account'
                      : 'Let\'s get started by filling out the form below',
                  style: TextStyle(
                    fontFamily: fontFamily,
                    fontSize: 14,
                    color: whiteColor,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            if (!authProvider.isLogin)
              CustomFormField(
                label: 'Name',
                controller: nameController,
                isPassword: false,
              ),
            CustomFormField(
              label: 'Email',
              controller: emailController,
              isPassword: false,
            ),
            CustomFormField(
              label: 'Password',
              controller: passController,
              isPassword: true,
            ),
            if (!authProvider.isLogin)
              CustomFormField(
                label: 'Confirm Password',
                controller: confirmController,
                isPassword: true,
              ),
            const SizedBox(
              height: 5,
            ),
            ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(blackColor)),
                onPressed: () {
                  if (!authProvider.isLogin) {
                    if (nameController.text.isNotEmpty &&
                        passController.text == confirmController.text &&
                        emailController.text.isNotEmpty &&
                        passController.text.isNotEmpty &&
                        confirmController.text.isNotEmpty) {
                      // UserModel user=UserModel(uid: , username: username, email: email, photoUrl: photoUrl, following: following, pushToken: pushToken, followers: followers)
                      AuthController().userSignup(
                          email: emailController.text,
                          password: passController.text,
                          context: context,
                          username: nameController.text);
                    }
                  } else {
                    if (emailController.text.isNotEmpty &&
                        passController.text.isNotEmpty) {
                      AuthController().userLogin(
                          email: emailController.text,
                          password: passController.text,
                          context: context);
                    }
                  }
                },
                child: Text(
                  authProvider.isLogin ? 'Log In' : 'Get Started',
                  style: TextStyle(fontFamily: fontFamily, color: whiteColor),
                )),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  'Or sign up with',
                  style: TextStyle(fontFamily: fontFamily, color: whiteColor),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton.icon(
                  style: ButtonStyle(
                      fixedSize: const MaterialStatePropertyAll(Size(160, 20)),
                      backgroundColor: MaterialStatePropertyAll(whiteColor)),
                  onPressed: () {},
                  label: Text(
                    'Continue with Google',
                    style: TextStyle(
                        fontFamily: fontFamily,
                        color: blackColor,
                        fontSize: 12),
                  ),
                  icon: Image.asset(
                    'assets/images/google.png',
                    height: 15,
                    width: 15,
                  ),
                ),
                ElevatedButton.icon(
                  style: ButtonStyle(
                      fixedSize: const MaterialStatePropertyAll(Size(160, 20)),
                      backgroundColor: MaterialStatePropertyAll(
                        whiteColor,
                      )),
                  onPressed: () {},
                  label: Text(
                    'Continue with Apple',
                    style: TextStyle(
                        fontFamily: fontFamily,
                        color: blackColor,
                        fontSize: 12),
                  ),
                  icon: Image.asset(
                    'assets/images/apple-logo.png',
                    height: 20,
                    width: 20,
                  ),
                )
              ],
            ),
            if (authProvider.isLogin)
              const SizedBox(
                height: 10,
              ),
            if (authProvider.isLogin)
              ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(blackColor)),
                  onPressed: () {},
                  child: Text(
                    'Forgot your password?',
                    style: TextStyle(fontFamily: fontFamily, color: whiteColor),
                  )),
          ],
        )),
      ),
    );
  }
}
