import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_series/routes/MyRoutes.dart';
import 'package:firebase_series/screens/homescreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class VerifyOtpScreen extends StatefulWidget {
  String verificationId;
  VerifyOtpScreen({super.key,required this.verificationId});

  @override
  State<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {

  bool isLoading = false;
  TextEditingController otp_controller = TextEditingController();

  void verifyOtp(BuildContext context) async{
    String otp_code = otp_controller.text.toString().trim();
    PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId,
        smsCode: otp_code);

   try {

      UserCredential credential =  await FirebaseAuth.instance.signInWithCredential(phoneAuthCredential);
     if(credential!=null)
     {
        Navigator.popUntil(context, (route) => route.isFirst);
        Navigator.pushReplacement(context, CupertinoPageRoute(
            builder: (context) => HomeScreen()));
     }

   } on FirebaseAuthException catch(ex){

      print(ex.code.toString());
   }

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
            title: Text("Verification",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.white,
            ),),
          ),
          body: Container(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 15,horizontal: 12),
              child: Column(
                children: [
                  TextFormField(

                    controller: otp_controller,
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    decoration: InputDecoration(
                      hintText: "Enter Code",
                      counterText: ""
                    ),
                  ),
                  SizedBox(height: 20,),
                  SizedBox(
                    width: double.infinity,
                    child: CupertinoButton(
                        color: Colors.lightBlue,
                        child: isLoading ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Loading...',
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white
                              ),),
                            SizedBox(width: 20,),
                            CircularProgressIndicator(
                              color: Colors.white,
                            )
                          ],
                        ) :  Text("Verify",
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.white
                          ),),
                        onPressed: (){

                          setState(() {
                            isLoading = true;
                            verifyOtp(context);
                          });
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
        ));
  }
}
