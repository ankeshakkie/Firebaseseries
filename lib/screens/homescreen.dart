import 'dart:async';
import 'dart:ffi';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_series/screens/login_screen.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  bool isFilter = false;
  File? profileImage;
  bool isLoading = false;

  buildLoading(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
          );
        });
  }

  void deleteData(String document) async{
    await FirebaseFirestore.instance.collection('users').doc(document).delete();
  }

  void saveData(BuildContext context) async{
     isLoading = true;
     String name = nameController.text.toString().trim();
     String email = emailController.text.toString().trim();
     String agestring = ageController.text.toString().trim();

     if(name.isEmpty || email.isEmpty || agestring.isEmpty)
       {
         SnackBar snackBar =  SnackBar(content: Text("All fields required"),
         backgroundColor: Colors.red);
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
       }
     else{
       buildLoading(context);
       int age = int.parse(agestring);
       nameController.clear();
       emailController.clear();
       ageController.clear();

       UploadTask uploadTask = FirebaseStorage.instance.ref().child('profilepictures').child(Uuid().v1()).
           putFile(profileImage!);

       StreamSubscription streamSubscription =  uploadTask.snapshotEvents.listen((snapshot) {
         double percentage = snapshot.bytesTransferred/snapshot.totalBytes*100;
         print(percentage);
       });

       TaskSnapshot taskSnapshot = await uploadTask;
       String downloadUrl = await taskSnapshot.ref.getDownloadURL();
       streamSubscription.cancel();


       Map<String,dynamic> mapData = {
         'name':name,
         'email':email,
         'age': age,
         'profile_pic':downloadUrl
       };
       await FirebaseFirestore.instance.collection('users').add(mapData);

       setState(() {
         profileImage = null;
         isLoading = false;
         Navigator.of(context).pop();
       });
     }



  }

   void logout(BuildContext context) async{
      await FirebaseAuth.instance.signOut();
      Navigator.popUntil(context, (route) => route.isFirst);
      Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) => LoginScreen()));
   }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            backgroundColor: Colors.lightBlue,
            actions: [
              IconButton(
                  onPressed: (){
                    setState(() {
                      if(!isFilter)
                        {
                          isFilter = true;
                        }
                      else
                        {
                          isFilter = false;
                        }
                    });
                  },
                  icon: Icon(
                    Icons.filter_alt_sharp,
                    color: Colors.white,
                  )),
              IconButton(
                  onPressed: (){
                    logout(context);
                  },
                  icon: Icon(Icons.logout,
                  color: Colors.white,))
            ],
            centerTitle: true,
            title: Text("Home",
            style: TextStyle(
              fontSize: 18,
              color: Colors.white
            ),),
          ),
          body:  Container(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 15,horizontal: 12),
              child: Column(
                children: [
                  CupertinoButton(
                    onPressed: ()async{

                      XFile? selectedImage = await ImagePicker().pickImage(
                          source: ImageSource.gallery);


                      if(selectedImage!=null)
                      {
                        File convertedimage = File(selectedImage!.path);
                        setState(() {
                          profileImage = convertedimage;
                        });
                        print('selected image');
                      }
                      else
                      {
                        print('no image selected');
                      }

                    },
                    padding: EdgeInsets.zero,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey,
                      backgroundImage: (profileImage!=null)?FileImage(profileImage!)
                          :null,
                    ),
                  ),
                  SizedBox(height: 20,),
                  TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                        hintText: 'Enter Name'
                    ),
                  ),
                  SizedBox(height: 10,),
                  TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                        hintText: 'Enter Email'
                    ),
                  ),
                  SizedBox(height: 10,),
                  TextFormField(
                    controller: ageController,
                    decoration: InputDecoration(
                        hintText: 'Enter Age'
                    ),
                  ),
                  SizedBox(height: 30,),
                  SizedBox(
                    height: 50,
                    width: 170,
                    child: CupertinoButton(
                        color: Colors.lightBlue,
                        child: Text('Save',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold
                          ),),
                        onPressed: (){
                          setState(() {
                            saveData(context);
                          });
                        }),
                  ),
                  SizedBox(height: 40,),
                  isFilter ? StreamBuilder(
                      stream: FirebaseFirestore.instance.collection('users').
                      orderBy('age').
                      snapshots(),
                      builder: (context,snapshot){
                        if(snapshot.connectionState==ConnectionState.active)
                        {
                          if(snapshot.hasData && snapshot.data!=null)
                          {
                            return Expanded(
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: snapshot.data!.docs.length,
                                  itemBuilder: (context,index){
                                    Map<String,dynamic> userMap = snapshot.data!.docs[index].data();
                                    return ListTile(
                                      leading: CircleAvatar(
                                        backgroundImage: NetworkImage(
                                            userMap['profile_pic']),
                                      ),
                                      title: Text(userMap['name']+"(${userMap['age']})"),
                                      subtitle: Text(userMap['email']),
                                      trailing: IconButton(
                                        icon: Icon(Icons.delete),
                                        onPressed: (){
                                          print("Document"+snapshot.data!.docs[index].id);
                                          deleteData(snapshot.data!.docs[index].id);
                                        },
                                      ),
                                    );

                                  }),
                            );
                          }
                          else{
                            return Text("");
                          }
                        }
                        else
                        {
                          return CircularProgressIndicator();
                        }
                      }) : StreamBuilder(
                      stream: FirebaseFirestore.instance.collection('users').
                      snapshots(),
                      builder: (context,snapshot){
                        if(snapshot.connectionState==ConnectionState.active)
                        {
                          if(snapshot.hasData && snapshot.data!=null)
                          {
                            return Expanded(
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: snapshot.data!.docs.length,
                                  itemBuilder: (context,index){
                                    Map<String,dynamic> userMap = snapshot.data!.docs[index].data();
                                    return ListTile(
                                      leading: CircleAvatar(
                                        backgroundImage: NetworkImage(
                                            userMap['profile_pic']),
                                      ),
                                      title: Text(userMap['name']+"(${userMap['age']})"),
                                      subtitle: Text(userMap['email']),
                                      trailing: IconButton(
                                        icon: Icon(Icons.delete),
                                        onPressed: (){
                                          print("Document"+snapshot.data!.docs[index].id);
                                          deleteData(snapshot.data!.docs[index].id);
                                        },
                                      ),
                                    );

                                  }),
                            );
                          }
                          else{
                            return Text("");
                          }
                        }
                        else
                        {
                          return CircularProgressIndicator();
                        }
                      })
                ],
              ),
            ),
          ),
        ));
  }
}
