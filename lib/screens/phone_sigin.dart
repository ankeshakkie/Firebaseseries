import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_series/routes/MyRoutes.dart';
import 'package:firebase_series/screens/verification_otp.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PhoneLogin extends StatefulWidget {
  const PhoneLogin({super.key});

  @override
  State<PhoneLogin> createState() => _PhoneLoginState();
}

class _PhoneLoginState extends State<PhoneLogin> {
  
  TextEditingController phone_controller = TextEditingController();
  bool isLoading = false;
  void phoneLogin() async{
    
    String phone = "+91" + phone_controller.text.toString().trim();
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phone,
        verificationCompleted: (credential){
            print("verifycompleted");
        },
        verificationFailed: (ex){
          print(ex.code.toString());
        },
        codeSent: (verificationId,resendToken){
          Visibility(
            visible: false,
            child: CircularProgressIndicator(
              color: Colors.lightBlue,
            ),
          );
          Navigator.push(
              context,CupertinoPageRoute(builder: (context) => VerifyOtpScreen(verificationId: verificationId) ));
        },
        codeAutoRetrievalTimeout: (verificationid){
          print("verifytimout");
        },
        timeout: Duration(seconds: 30));
  }
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.lightBlue,
            iconTheme: IconThemeData(
              color: Colors.white
            ),
            title: Text("Login with Phone",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold
            ),),
          ),
          body: Container(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 15,horizontal: 12),
              child: Column(
                children: [
                  TextFormField(
                    controller: phone_controller,
                    keyboardType: TextInputType.number,
                    maxLength: 10,
                    decoration: InputDecoration(
                      hintText: "Enter Phone",
                    ),
                  ),
                  SizedBox(
                    height: 20,),
                 SizedBox(
                   width: double.infinity,
                   child: CupertinoButton(
                     color: Colors.lightBlue,
                       child: isLoading ? Row(
                         mainAxisAlignment: MainAxisAlignment.center,
                         children: [
                           Text('Loading...',
                           style: TextStyle(
                             fontSize: 15,
                             fontWeight: FontWeight.bold
                           ),),
                           SizedBox(width: 20,),
                           CircularProgressIndicator(
                             color: Colors.white,
                           )
                         ]
                       ):Text("Submit",
                       style: TextStyle(
                         fontSize: 15,
                         fontWeight: FontWeight.bold,
                         color: Colors.white
                       ),),
                       onPressed: (){

                         setState(() {
                           isLoading = true;
                         });
                         phoneLogin();
                         Future.delayed(Duration(seconds: 3),()
                         {
                           setState(() {
                             isLoading = false;
                           });
                         });

                       }),
                 )
                ],
              ),
            ),
          ),
        )
    );
  }
}
