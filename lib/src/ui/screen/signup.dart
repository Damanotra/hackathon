import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hackathon/src/bloc/signup/signup_bloc.dart';
import 'package:hackathon/src/bloc/signup/signup_state.dart';
import 'package:hackathon/src/bloc/signup/signup_event.dart';


class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _signupBloc = SignupBloc();
  final _emailController = TextEditingController();
  final _passwordController  = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  redirectToHome(){
    return Navigator.of(context).pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Center(
        child: BlocListener<SignupBloc,SignupState>(
          cubit: _signupBloc,
          listener: (context,state){
            if(state.isSuccess){
              redirectToHome();
            } else if(state.errorMessage!=null && state.errorMessage!=''){
              Scaffold.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                    SnackBar(content: Text(state.errorMessage))
                );
            }
          },
          child: BlocBuilder<SignupBloc,SignupState>(
            cubit: _signupBloc,
            builder:(context,state){
              if(!state.isLoading){
                return Form(
                  key: _formKey,
                  child: ListView(
                    shrinkWrap: true,
                    padding: EdgeInsets.symmetric(horizontal: deviceWidth*0.1,vertical: deviceHeight*0.1),
                    children: [
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                            hintText: "Email",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(0))),
                      ),
                      SizedBox(height: deviceHeight*0.02),
                      TextFormField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                            hintText: "Email",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(0))),
                      ),
                      SizedBox(height: deviceHeight*0.02),
                      ElevatedButton(
                        onPressed: (){
                          _signupBloc.add(SubmitEvent(email: _emailController.text,password: _passwordController.text));
                        },
                        child: Text("Signup"),
                        style: ElevatedButton.styleFrom(
                            primary: Colors.orange,
                            padding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                            textStyle: TextStyle()),
                      )
                    ],
                  ),
                );
              } else{
                return CircularProgressIndicator();
              }
            },
          ),
        ),
      ),
    );
  }
}
