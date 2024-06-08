import 'package:flutter/material.dart';
import 'package:manage_app/screens/home.dart';
import 'package:manage_app/services/authentication.dart';
import 'package:manage_app/widgets/snack_bar.dart';
import 'package:manage_app/widgets/text_field.dart';

import 'login_screen.dart';

class SignUpScreent extends StatefulWidget {
  const SignUpScreent({Key? key}) : super(key: key);

  @override
  State<SignUpScreent> createState() => _SignUpScreentState();
}

class _SignUpScreentState extends State<SignUpScreent> {
  TextEditingController emailTextController = TextEditingController();
  TextEditingController passwordTextController = TextEditingController();
  TextEditingController passwordConfirmTextController = TextEditingController();
  final key = GlobalKey<FormState>();

  void singUpUser(String email, String password) async{
    bool res = await AuthService().signUpUser(email: email, password: password);
    if(res){
      setState(() {
        Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreent()));
      });
    }else{
      showSnackBar(context, 'Something went wrong');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: SingleChildScrollView(
          child: Form(
            key: key,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Image.network('https://img.freepik.com/free-vector/sign-concept-illustration_114360-125.jpg', height: 250,),
                  TextFormField(
                    controller: emailTextController,
                    style: const TextStyle(fontSize: 20),
                    decoration: textInputEmail,
                    validator: (value){
                      if(value == null || value.isEmpty){
                        return 'Please enter an email';
                      }
                      if(!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(value)){
                        return 'Please enter valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: passwordTextController,
                    style: const TextStyle(fontSize: 20),
                    obscureText: true,
                    decoration: textInputPassword,
                    validator: (value){
                      if(value == null || value.isEmpty){
                        return 'Please enter password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: passwordConfirmTextController,
                    style: const TextStyle(fontSize: 20),
                    obscureText: true,
                    decoration: textInputPassword.copyWith(
                      labelText: 'Confirm password',
                    ),
                    validator: (value){
                      if(value == null || value.isEmpty){
                        return 'Please enter password';
                      }
                      if(passwordConfirmTextController.text != passwordTextController.text){
                        return 'Password confirm no true';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 25),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20)
                    ),
                      onPressed: (){
                        if(key.currentState!.validate()){
                          singUpUser(emailTextController.text, passwordTextController.text);
                        }
                      },
                      child: const Text('Sign up', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))
                  ),
                  const SizedBox(height: 25),
                  Row(
                    children: [
                      const Expanded(child: Divider(thickness: 0.6, color: Colors.grey)),
                      const Text(" Already have account?"),
                      TextButton(
                          onPressed: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>  LoginScreent()));
                          },
                          child: const Text('Login', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red))
                      ),
                      const Expanded(child: Divider(thickness: 0.6, color: Colors.grey)),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
