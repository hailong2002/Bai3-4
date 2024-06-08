import 'package:flutter/material.dart';
import 'package:manage_app/screens/sign_up_screen.dart';
import 'package:manage_app/widgets/text_field.dart';

import '../services/authentication.dart';
import '../widgets/snack_bar.dart';
import 'home.dart';

class LoginScreent extends StatefulWidget {
  const LoginScreent({Key? key}) : super(key: key);

  @override
  State<LoginScreent> createState() => _LoginScreentState();
}

class _LoginScreentState extends State<LoginScreent> {
  TextEditingController emailTextController = TextEditingController();
  TextEditingController passwordTextController = TextEditingController();
  final key = GlobalKey<FormState>();

  void  loginUser(String email, String password) async{
    bool res = await AuthService().loginUser(email: email, password: password);
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
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 15),
              child: Center(
                child: Column(
                  children: [
                    Image.network('https://www.sme-news.co.uk/wp-content/uploads/2021/11/Login.jpg'),
                    const SizedBox(height: 30),
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
                      decoration: textInputPassword,
                      obscureText: true,
                      validator: (value){
                        if(value == null || value.isEmpty){
                          return 'Please enter password';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 25),
                    ElevatedButton(
                        onPressed: (){loginUser(emailTextController.text, passwordTextController.text);},
                        child: const Text('Login', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold))
                    ),
                    const SizedBox(height: 40),
                    Row(
                      children: [
                        const Expanded(child: Divider(thickness: 0.6, color: Colors.grey)),
                        const Text(" Don't have account?"),
                        TextButton(
                            onPressed: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=> SignUpScreent()));
                            },
                            child: const Text('Sign up', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.orange))
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
      ),
    );
  }
}
