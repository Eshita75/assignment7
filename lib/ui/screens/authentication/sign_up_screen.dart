import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:assignment7/data/models/network_response.dart';
import 'package:assignment7/data/network_caller/network_caller.dart';
import 'package:assignment7/data/utility/urls.dart';
import 'package:assignment7/ui/utility/app_colors.dart';
import 'package:assignment7/ui/utility/app_constants.dart';
import 'package:assignment7/ui/widgets/background_widget.dart';
import 'package:assignment7/ui/widgets/centered_progress_indicator.dart';
import 'package:assignment7/ui/widgets/show_snack_bar_message.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _firstNameTEController = TextEditingController();
  final TextEditingController _lastNameTEController = TextEditingController();
  final TextEditingController _mobileTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();
  bool _showPassword = false;
  bool _registrationInProgress = false;

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
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 120,),

                    Text('Join With Us', style: Theme.of(context).textTheme.titleLarge,),

                    const SizedBox(height: 24,),

                    TextFormField(
                      controller: _emailTEController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: 'Email'
                      ),
                      validator: (String? value) {
                        if (value?.trim().isEmpty ?? true) {
                          return 'Enter your email address';
                        }
                        if (AppConstants.emailRegExp.hasMatch(value!) ==
                            false) {
                          return 'Enter a valid email address';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 12,),

                    TextFormField(
                      controller: _firstNameTEController,
                      decoration: InputDecoration(
                        hintText: 'First Name'
                      ),
                      validator: (String? value/*value null hote pare bujhate ? use*/){
                        if(value?.trim().isEmpty ?? true){
                          return 'Enter your first name';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 12,),

                    TextFormField(
                      controller: _lastNameTEController,
                      decoration: InputDecoration(
                          hintText: 'Last Name'
                      ),
                      validator: (String? value/*value null hote pare bujhate ? use*/){
                        if(value?.trim().isEmpty ?? true){
                          return 'Enter your last name';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 12,),

                    TextFormField(
                      controller: _mobileTEController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          hintText: 'Mobile'
                      ),
                      validator: (String? value/*value null hote pare bujhate ? use*/){
                        if(value?.trim().isEmpty ?? true){
                          return 'Enter your mobile number';
                        }
                        // if (AppConstants.mobileRegExp.hasMatch(value!) ==
                        //     false) {
                        //   return 'Enter a valid mobile number';
                        // }
                        return null;
                      },
                    ),

                    const SizedBox(height: 12,),

                    TextFormField(
                      obscureText: _showPassword == false,// _showPassword jodi false hoi then obsecureText kaj korbe true hole korbe na
                      controller: _passwordTEController,
                      decoration: InputDecoration(
                          hintText: 'Password',
                          suffixIcon: IconButton(onPressed: (){
                            _showPassword = !_showPassword;
                            if(mounted){
                              setState(() {

                              });
                            }
                          }, icon: Icon(_showPassword ? Icons.visibility_off : Icons.remove_red_eye))
                      ),
                      validator: (String? value/*value null hote pare bujhate ? use*/){
                        if(value?.trim().isEmpty ?? true){
                          return 'Enter your password';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16,),
                    Visibility(
                      visible: _registrationInProgress == false,
                      replacement:  const CenteredProgressIndicator(),
                      child: ElevatedButton(
                        onPressed: () {
                          if(_formKey.currentState!.validate()){
                            _registerUser();
                          }
                        },
                        child: const Icon(Icons.arrow_circle_right_outlined),
                      ),
                    ),

                    const SizedBox(height: 36,),

                    _buildBackToSignInSection()
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBackToSignInSection() {
    return Center(
      child: RichText(
        text: TextSpan(
            style: TextStyle(
                color: Colors.black.withOpacity(.8),
                fontWeight: FontWeight.w600,
                letterSpacing: .4),
            text: "Have account? ",
            children: [
            TextSpan(
                text: 'Sign In',
                style: const TextStyle(color: AppColors.themeColor),
                recognizer: TapGestureRecognizer()..onTap = _onTapSIgnInButton)
          ],
        ),
      ),
    );
  }


  //Created jei api ta ache rabbil seta k call korar process means api integration
  Future<void> _registerUser() async {
    _registrationInProgress = true;
    if(mounted){
      setState(() {});
    }

    // create json
    Map<String, dynamic> requestData = {
      "email":_emailTEController.text.trim(),
      "firstName":_firstNameTEController.text.trim(),
      "lastName": _lastNameTEController.text.trim(),
      "mobile":_mobileTEController.text.trim(),
      "password":_passwordTEController.text,
      "photo":""
    };

    NetworkResponse response =
        await NetworkCaller.postRequest(Urls.registration,
            body: requestData);

    _registrationInProgress = false;
    if(mounted){
      setState(() {});
    }

    if(response.isSuccess){
      _clearTextFields();
      if(mounted){
        showSnackBarMessage(context, 'Registration Successful');
      }
    }else{
      if(mounted){
        showSnackBarMessage(
            context, response.errorMessage ?? 'Registration failed! Try again');
      }
    }
  }

  _clearTextFields(){
    _emailTEController.clear();
    _firstNameTEController.clear();
    _lastNameTEController.clear();
    _mobileTEController.clear();
    _passwordTEController.clear();
  }

  _onTapSIgnInButton(){
    Navigator.pop(context);
  }
  @override
  void dispose() {
    _emailTEController.dispose();
    _mobileTEController.dispose();
    _firstNameTEController.dispose();
    _lastNameTEController.dispose();
    _passwordTEController.dispose();
    super.dispose();
  }
}
