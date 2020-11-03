import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hackathon/src/bloc/login/login_bloc.dart';
import 'package:hackathon/src/bloc/login/login_state.dart';
import 'package:hackathon/src/bloc/login/login_event.dart';


class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _loginBloc = LoginBloc();
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
        child: BlocListener<LoginBloc,LoginState>(
          cubit: _loginBloc,
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
          child: BlocBuilder<LoginBloc,LoginState>(
            cubit: _loginBloc,
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
                          _loginBloc.add(SubmitEvent(email: _emailController.text,password: _passwordController.text));
                        },
                        child: Text("Login"),
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
