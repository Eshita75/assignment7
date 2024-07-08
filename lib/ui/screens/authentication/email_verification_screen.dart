import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:assignment7/ui/screens/authentication/pin_verification_screen.dart';
import 'package:assignment7/ui/widgets/centered_progress_indicator.dart';
import '../../../data/models/network_response.dart';
import '../../../data/network_caller/network_caller.dart';
import '../../../data/utility/urls.dart';
import '../../utility/app_colors.dart';
import '../../utility/app_constants.dart';
import '../../widgets/background_widget.dart';
import '../../widgets/show_snack_bar_message.dart';


class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({super.key});

  @override
  State<EmailVerificationScreen> createState() => _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  final TextEditingController _emailTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();
  bool _mailVerificationInProgress = false;

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
                  Text('Your Email Address', style: Theme.of(context).textTheme.titleLarge,),
                  Text('A 6 digit verification pin will send to your email address',
                    style: Theme.of(context).textTheme.titleSmall,),

                  const SizedBox(height: 24,),

                  TextFormField(
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

                  const SizedBox(height: 16,),

                  Visibility(
                    visible: _mailVerificationInProgress == false,
                    replacement: CenteredProgressIndicator(),
                    child: ElevatedButton(onPressed: _mailVerification,
                      child: Icon(Icons.arrow_circle_right_outlined),),
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
                            style: const TextStyle(color: AppColors.themeColor),
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

  _onTapSignInButton(){
    Navigator.pop(context);
  }

  Future<void> _mailVerification() async{
    _mailVerificationInProgress = true;
    if(mounted){
      setState(() {});
    }

    NetworkResponse response = await NetworkCaller.getRequest(Urls.mailVerification(_emailTEController.text.trim()));//NetworkResponse class er object create korci first then NetworkCaller k call korci

    _mailVerificationInProgress = false;
    if(mounted){
      setState(() {});
    }

    if(response.isSuccess && response.responseData['status'] == 'success') {
      if(mounted){
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return PinVerificationScreen(recoveryMail: _emailTEController.text);
            },
          ),
        );
      }
      return;
    }else{
      if(mounted){
        showSnackBarMessage(context, response.errorMessage ?? 'Email/password is not correct. Try again');
      }
    }
  }
  @override
  void dispose() {
    _emailTEController.dispose();
    super.dispose();
  }
}
