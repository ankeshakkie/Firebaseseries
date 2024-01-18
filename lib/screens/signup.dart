

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController email_controller = TextEditingController();

  TextEditingController pswd_controller = TextEditingController();

  TextEditingController cpswd_controller = TextEditingController();
  bool isLoading = false;



  void createAccount(BuildContext context) async {

    String email = email_controller.text.toString().trim();
    String pswd = pswd_controller.text.toString().trim();
    String cpswd = cpswd_controller.text.toString().trim();

    if(email == "" || pswd == "" || cpswd == "")
      {
        print("Please fill all details");
      }
    else if(pswd != cpswd)
    {
       print("password do not match !");
    }

    else
      {
         try{
           UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
               email: email,
               password: pswd);
           if(userCredential.user!=null)
             {
               AwesomeDialog(
                 context:context,
                 title: "User Created !",
                 dialogType: DialogType.success,
                 btnOkOnPress:(){
                   Navigator.pop(context);
                 }
               ).show();
             }
         } on FirebaseAuthException catch(ex)
    {
        print(ex.code.toString());
    }

      }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        iconTheme: IconThemeData(
          color: Colors.white
        ),
        title: Text("Create an account",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
          color: Colors.white
        ),),
      ),
      body: Container(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15,horizontal: 10),
          child: Column(
            children: [

              TextFormField(
                controller: email_controller,
                decoration: InputDecoration(
                  hintText: "Email Address"
                ),
              ),
              SizedBox(height: 10,),
              TextFormField(
                controller: pswd_controller,
                decoration: InputDecoration(
                    hintText: "Password"
                ),
              ),
              SizedBox(height: 10,),
              TextFormField(
                controller: cpswd_controller,
                decoration: InputDecoration(
                    hintText: "Confirm Password"
                ),
              ),
              SizedBox(height: 30,),
              SizedBox(
                width: 170,
                height: 50,
                child: ElevatedButton(
                    onPressed: (){
                      createAccount(context);
                      setState(() {
                        isLoading = true;
                      });

                      Future.delayed(Duration(seconds: 3),(){
                        setState(() {
                          isLoading = false;
                        });
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: Colors.lightBlue,
                      shape: StadiumBorder()
                    ),
                    child:isLoading ? Center(child: CircularProgressIndicator(
                      color: Colors.white,
                    )) : Text("Create Account",
                      style: TextStyle(
                          fontSize: 12,
                          color: Colors.white
                      ),) ),
              )

            ],
          ),
        ),
      ),
    );
  }
}
