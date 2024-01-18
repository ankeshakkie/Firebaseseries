import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_series/routes/MyRoutes.dart';
import 'package:firebase_series/screens/homescreen.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  bool isLoading = false;

  void getLogin(BuildContext context) async{
    String email = emailcontroller.text.toString().trim();
    String pswd = passwordcontroller.text.toString().trim();
    if(email.isEmpty|| pswd.isEmpty)
      {
        print("field is empty");
      }
    else
    {
       try{

         UserCredential userCredential =  await FirebaseAuth.instance.signInWithEmailAndPassword(
             email: email,
             password: pswd);
         if(userCredential.user!=null)
           {
             AwesomeDialog(
               context: context,
               title: "User logged in successfully",
               dialogType: DialogType.success,
               btnOkOnPress: (){
                 Navigator.popUntil(context, (route) => route.isFirst);
                 Navigator.pushReplacement(context, MaterialPageRoute(
                     builder: (context) => HomeScreen()));
               }
             ).show();
           }
       }on FirebaseAuthException catch(exception)
    {
      print(exception.code.toString());
    }

    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.lightBlue,
          centerTitle: true,
          title: Text("Login",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),),
        ),
        body: Container(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 15,horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: emailcontroller,
                  decoration: InputDecoration(
                    hintText: "Email Address",
                  ),
                ),
                SizedBox(height: 15,),
                TextFormField(
                  controller: passwordcontroller,
                  decoration: InputDecoration(
                    hintText: "Password",
                  ),
                ),
                SizedBox(height: 20,),
                Center(
                  child: SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                       elevation: 0,
                       backgroundColor: Colors.lightBlue
                      ),
                        onPressed: (){

                          setState(() {
                            isLoading = true;
                            getLogin(context);
                          });

                          Future.delayed(Duration(seconds: 3),(){
                            setState(() {
                              isLoading =  false;
                            });
                          });

                        },
                        child: isLoading ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Loaing...",
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white
                              ),),
                            SizedBox(width: 20,),
                            CircularProgressIndicator(
                              color: Colors.white,
                            )
                          ],
                        ): Text("Log In",
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.white
                          ),)
                    ),
                  ),
                ),
                SizedBox(height: 30,),
                InkWell(
                  onTap: (){
                    Navigator.pushNamed(context, MyRoutes.signup_page);
                  },
                  child: Center(
                    child: Text("Create an Account",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.lightBlue
                    ),),
                  ),
                ),
                SizedBox(height: 20,),
                Center(
                  child: Text("OR",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.lightBlue,
                    fontWeight: FontWeight.bold
                  ),),
                ),
                SizedBox(height: 20,),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightBlue
                    ),
                      onPressed: (){
                        Navigator.pushNamed(context, MyRoutes.phone_login);
                      },
                      child: Text("Login with Phone",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.white
                      ),)),
                ),

              ],
            ),
          )
        )
      ),
    );
  }
}
