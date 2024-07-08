import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:assignment7/ui/screens/authentication/sign_in_screen.dart';
import 'package:assignment7/ui/utility/app_colors.dart';
import 'package:assignment7/ui/widgets/background_widget.dart';
import 'package:assignment7/ui/widgets/centered_progress_indicator.dart';

import '../../../data/models/network_response.dart';
import '../../../data/network_caller/network_caller.dart';
import '../../../data/utility/urls.dart';
import '../../widgets/show_snack_bar_message.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key, required this.recoveryMail, required this.recoveryOTP, });
  //final ForgotPasswordModel forgotPasswordModel;
  final String recoveryMail;
  final String recoveryOTP;

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _resetPasswordTEController = TextEditingController();
  final TextEditingController _confirmPasswordTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();
  bool _getResetPasswordInProgress = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundWidget(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 120,),
                  Text('Set Password', style: Theme.of(context).textTheme.titleLarge,),
                  Text('Minimum length password 8 character with letter and number combination',
                    style: Theme.of(context).textTheme.titleSmall,),

                  const SizedBox(height: 24,),

                  Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      children: [
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          controller: _resetPasswordTEController,
                          decoration: const InputDecoration(
                              hintText: 'Password'
                          ),
                          validator: (String? value){
                            if(value?.trim().isEmpty ?? true){
                              return 'Enter your password';
                            }
                            if(value!.isNotEmpty && value.length < 8){
                              return 'Enter correct your password';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 16,),

                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          controller: _confirmPasswordTEController,
                          decoration: const InputDecoration(
                              hintText: 'Confirm Password'
                          ),
                          validator: (String? value){
                            if(value?.trim().isEmpty ?? true){
                              return 'Confirm your password';
                            }
                            if(value!.isNotEmpty && value.length < 8){
                              return 'Confirm correct password';
                            }
                            if(value != _resetPasswordTEController.text){
                              return 'Match your password';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 16,),

                        Visibility(
                          visible: _getResetPasswordInProgress == false,
                          replacement: const CenteredProgressIndicator(),
                          child: ElevatedButton(onPressed: (){
                            resetPassword();
                          },
                            child: const Text('Confirm'),),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 36,),

                  Center(
                    child: RichText(text: TextSpan(
                        style: TextStyle(
                            color: Colors.black.withOpacity(.8),
                            fontWeight: FontWeight.w600,
                            letterSpacing: .4
                        ),
                        text: "Have account? ",
                        children: [
                          TextSpan(
                            text: 'Sign in',
                            style: TextStyle(color: AppColors.themeColor),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                _onTapSignInButton();
                              },
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _onTapSignInButton() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => SignInScreen(),
        ),
        (route) => false);
  }

  Future<void> resetPassword() async{
    _getResetPasswordInProgress = true;
    if(mounted){
      setState(() {});
    }


    Map<String, dynamic> requestData = {
      "email": widget.recoveryMail,
      "OTP": widget.recoveryOTP,
      "password": _resetPasswordTEController.text
    };

    NetworkResponse response = await NetworkCaller.postRequest(Urls.recoverResetPass, body: requestData);//NetworkResponse class er object create korci first then NetworkCaller k call korci

    _getResetPasswordInProgress = false;
    if(mounted){
      setState(() {});
    }

    if (response.isSuccess && response.responseData['status'] == 'success') {
      if(mounted){
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const SignInScreen(),
            ),
                (route) => false);
      }
    }else{
      if(mounted){
        showSnackBarMessage(context, response.errorMessage ?? 'password is not correct. Try again');
      }
    }
  }

  // _onTapConfirmButton() {
  //   Navigator.pushAndRemoveUntil(
  //       context,
  //       MaterialPageRoute(
  //         builder: (context) => SignInScreen(),
  //       ),
  //       (route) => false);
  // }

  @override
  void dispose() {
    _resetPasswordTEController.dispose();
    _confirmPasswordTEController.dispose();
    super.dispose();
  }
}
