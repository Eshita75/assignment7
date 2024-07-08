import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:assignment7/data/models/login_model.dart';
import 'package:assignment7/data/models/network_response.dart';
import 'package:assignment7/data/network_caller/network_caller.dart';
import 'package:assignment7/data/utility/urls.dart';
import 'package:assignment7/ui/controller/auth_controller.dart';
import 'package:assignment7/ui/screens/authentication/sign_up_screen.dart';
import 'package:assignment7/ui/screens/main_bottom_nav_screen.dart';
import 'package:assignment7/ui/utility/app_colors.dart';
import 'package:assignment7/ui/widgets/background_widget.dart';
import 'package:assignment7/ui/screens/authentication/email_verification_screen.dart';
import 'package:assignment7/ui/widgets/centered_progress_indicator.dart';
import 'package:assignment7/ui/widgets/show_snack_bar_message.dart';

import '../../utility/app_constants.dart';


class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();
  bool _showPassword = false;
  bool _signInProgress = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundWidget(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 120,),
                    Text('Get Started With', style: Theme.of(context).textTheme.titleLarge,),

                    const SizedBox(height: 24,),

                    TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      keyboardType: TextInputType.emailAddress,
                      controller: _emailTEController,
                      decoration: const InputDecoration(
                        hintText: 'Email'
                      ),
                      validator: (String? value){
                        if(value?.trim().isEmpty ?? true){
                          return 'Enter your email address';
                        }
                        if (AppConstants.emailRegExp.hasMatch(value!) ==
                            false) {
                          return 'Enter a valid email address';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 8,),

                    TextFormField(
                      obscureText: _showPassword == false,
                      controller: _passwordTEController,
                      decoration:  InputDecoration(
                        hintText: 'Password',
                        suffixIcon: IconButton(onPressed: (){
                          _showPassword = !_showPassword;
                          if(mounted){
                            setState(() {
                            });
                          }
                        }, icon: Icon(_showPassword ? Icons.visibility_off : Icons.remove_red_eye))
                      ),

                      validator: (String? value){
                        if(value?.trim().isEmpty ?? true){
                          return 'Enter your password';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16,),

                    Visibility(
                      visible: _signInProgress == false,
                      replacement: const CenteredProgressIndicator(),
                      child: ElevatedButton(
                      onPressed: (){
                        if(_formKey.currentState!.validate()){
                          _signIn();
                        }
                      },
                      child: const Icon(Icons.arrow_circle_right_outlined),
                    )),
                    const SizedBox(height: 36,),

                    _buildSignUpSection()
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Center _buildSignUpSection() {
    return Center(
                    child: Column(
                      children: [
                        TextButton(onPressed: _onTapForgotPasswordButton, child: const Text('Forgot password?'),),
                        RichText(text: TextSpan(
                            style: TextStyle(
                                color: Colors.black.withOpacity(.8),
                                fontWeight: FontWeight.w600,
                                letterSpacing: .4
                            ),
                            text: "Don't have an account? ",
                            children: [
                              TextSpan(
                                text: 'Sign up',
                                style: const TextStyle(color: AppColors.themeColor),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    _onTapSignUpButton();
                                  },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
  }


  //Created jei api ta ache rabbil seta k call korar process means api integration er jonno future type er funtion
  Future<void> _signIn() async{
    _signInProgress = true;
    if(mounted){
      setState(() {});
    }

    Map<String, dynamic> requestData = {
      "email":_emailTEController.text.trim(),
      "password":_passwordTEController.text
    };

    NetworkResponse response = await NetworkCaller.postRequest(Urls.signIn, body: requestData);//NetworkResponse class er object create korci first then NetworkCaller k call korci

    _signInProgress = false;
    if(mounted){
      setState(() {});
    }

    if (response.isSuccess) {
      LoginModel loginModel = LoginModel.fromJson(response.responseData);
      await AuthController.saveUserAccessToken(loginModel.token!);
      await AuthController.saveUserData(loginModel.userModel!);
      if(mounted){
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) {
              return const MainBottomNavScreen();
            },
          ),
        );
      }
    }else{
      if(mounted){
        showSnackBarMessage(context, response.errorMessage ?? 'Email/password is not correct. Try again');
      }
    }
  }

  _onTapSignUpButton(){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return const SignUpScreen();
        },
      ),
    );
  }


  _onTapForgotPasswordButton(){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return const EmailVerificationScreen();
        },
      ),
    );
  }

  @override
  void dispose() {
    _emailTEController.dispose();
    _passwordTEController.dispose();
    super.dispose();
  }
}
