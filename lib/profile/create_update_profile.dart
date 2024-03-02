import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:paypie/logic/provider_state.dart';
import 'package:paypie/login_pages/login_page.dart';
import 'package:paypie/pages/homepage.dart';
import 'package:paypie/shared_prreference.dart';
import 'package:paypie/sign_up_pages/signup_page.dart';
import 'package:provider/provider.dart';

class Create_Update extends StatefulWidget {
  Create_Update({
    Key? key
  }) : super(key: key);

  @override
  State<Create_Update> createState() => _Create_UpdateState();
}

class _Create_UpdateState extends State<Create_Update> {

  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<ProviderState>(context,listen: false).file=null;

      usernameController.text = _firebaseAuth.currentUser!.displayName !=null?_firebaseAuth.currentUser!.displayName! : SharedPreferenceHelper.GetUserName();
      emailController.text = _firebaseAuth.currentUser!.email!;
      // phoneController.text = '';

  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
  }




  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    // final provider = Provider.of<ProviderState>(context,listen: false);
    return Scaffold(
      backgroundColor: Colors.cyan.shade100,
      body: Consumer<ProviderState>(

        builder: (context,provider,child){
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: SafeArea(
              child: SingleChildScrollView(
                child: Form(
                  key: _key,
                  child: Center(
                    child: Column(
                      children: [
                        _firebaseAuth.currentUser!.displayName!=null?Align(
                          alignment: Alignment.topLeft,
                          child: GestureDetector(
                              onTap: (){
                                provider.update_forView(false);
                                provider.update_isUpdate(false);
                                Navigator.pop(context);
                              },
                              child: Icon(Icons.arrow_back,color: Colors.black,size: 35,)
                          ),
                        ):
                        Container(),

                        SizedBox(height: height*0.15,),

                        GestureDetector(
                          onTap: ()async{
                            if(provider.forView){
                              return null;
                            }else if(provider.isUpdate){
                              showDialog(context: context, builder: (context)=>AlertDialog(
                                title: Center(child: Text('Verify')),
                                content: Text('Are you sure you want to change Your ProfilePic',),
                                backgroundColor: Colors.cyanAccent.shade100,
                                actions: [
                                  GestureDetector(onTap: ()async{await provider.updateFile();Navigator.pop(context);},child:
                                  Container(
                                      height:40,width:70,
                                      decoration: BoxDecoration(
                                          color:Colors.cyan,
                                          borderRadius: BorderRadius.circular(12)
                                      ),
                                      child:
                                      Center(
                                          child: Text('Yes',style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold)))
                                  )
                                  ),
                                  GestureDetector(onTap: ()async{Navigator.pop(context);},child:
                                  Container(
                                      height:40,width:70,
                                      decoration: BoxDecoration(
                                          color:Colors.cyan,
                                          borderRadius: BorderRadius.circular(12)
                                      ),
                                      child:
                                      Center(
                                          child: Text('No',style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold)))
                                  )
                                  )
                                ],
                              ));
                            } else{
                              await provider.updateFile();
                            }

                          },
                          child: provider.forView?
                          Container(
                            height: 160,
                            width: 160,
                            decoration: BoxDecoration(
                              // color: Colors.green
                            ),
                            child: _firebaseAuth.currentUser!.photoURL!=null?CircleAvatar(
                              backgroundImage: NetworkImage(_firebaseAuth.currentUser!.photoURL!),
                              // child: Icon(Icons.account_circle,size: 40),
                            ):
                            CircleAvatar(
                              backgroundImage: AssetImage('assets/ac_bg.png'),
                            )
                            ,
                          )
                              :
                          provider.isUpdate?
                          Container(
                              height: 150,
                              width: 150,
                              decoration: BoxDecoration(
                                color: Colors.green,
                                shape: BoxShape.circle,
                                // image: DecorationImage(image: NetworkImage(widget.url))
                                image: provider.file!=null?
                                new DecorationImage(
                                  image: new FileImage(provider.file!),
                                  fit: BoxFit.cover,
                                ):
                                _firebaseAuth.currentUser!.photoURL==null?
                                    DecorationImage(image: AssetImage('assets/ac_bg.png')):

                                DecorationImage(
                                  image: NetworkImage(_firebaseAuth.currentUser!.photoURL!), fit: BoxFit.cover,
                                )

                                // new DecorationImage(
                                //   image: new FileImage(provider.file!),
                                //   fit: BoxFit.cover,
                                // )
                                ,
                              ),
                              child: Align(
                                alignment: Alignment.bottomRight,
                                child: Container(
                                  height: height*0.03,
                                  width: width*0.07,
                                  decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(22)
                                  ),
                                  child: Icon(Icons.edit,color: Colors.white,),
                                ),
                              )
                          )
                              :

                          Container(
                            height: 150,
                            width: 150,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.green,
                                image: provider.file==null?
                                DecorationImage(image: AssetImage('assets/ac_bg.png')):
                                new DecorationImage(
                                  image: new FileImage(provider.file!),
                                  fit: BoxFit.cover,
                                )
                            ),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                    ClipRRect(
                                    borderRadius:BorderRadius.circular(20),
                                    child:provider.file==null ? Image.asset('assets/ac_bg.png',
                                      fit: BoxFit.cover,)
                                        :
                                    Image.file(provider.file!, fit: BoxFit.cover,)
                                ),

                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: Container(
                                    height: height*0.03,
                                    width: width*0.07,
                                    decoration: BoxDecoration(
                                        color: Colors.black,
                                        borderRadius: BorderRadius.circular(22)
                                    ),
                                    child: Icon(Icons.edit,color: Colors.white,),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        SizedBox(height: height*0.07,),


                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 28),
                          child: TextFormField(
                            controller: usernameController,
                            cursorColor: Colors.black,
                            cursorHeight: 25,
                            readOnly: provider.forView?true:  !provider.isUpdate?false: !provider.noChange ,
                            validator: (value){
                              if( value==null || value.isEmpty){
                                return 'Your Username';
                              }else{
                                return null;
                              }
                            },
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 20
                            ),
                            decoration: InputDecoration(
                                prefixIcon: Icon(Icons.account_circle,size: 29,),
                                hintText: 'Enter your Username',
                                hintStyle: TextStyle(
                                    color: Colors.black.withOpacity(0.5),
                                    fontSize: 15
                                ),
                                // labelText: 'UserName',
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide(color: Colors.black,width: 1)
                                ),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide(color: Colors.black,width: 1)
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide(color: Colors.black,width: 1)
                                )
                            ),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 28),
                          child: TextFormField(
                            controller: emailController,
                            cursorColor: Colors.black,
                            cursorHeight: 25,
                            readOnly: true,
                            validator: (value){
                              if( value==null || value.isEmpty){
                                return 'Enter Email';
                              }else if(!EmailValidator.validate(value)){
                                return 'Please enter correct email address';
                              }else{
                                return null;
                              }
                            },
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 20
                            ),
                            decoration: InputDecoration(
                                prefixIcon: Icon(Icons.email,size: 29,),
                                hintText: 'Please enter your Email',
                                hintStyle: TextStyle(
                                    color: Colors.black.withOpacity(0.5),
                                    fontSize: 15
                                ),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide(color: Colors.black,width: 1)
                                ),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide(color: Colors.black,width: 1)
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide(color: Colors.black,width: 1)
                                )
                            ),
                          ),
                        ),

                        /*Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 28),
                          child: TextFormField(
                            controller: phoneController,
                            cursorColor: Colors.black,
                            cursorHeight: 25,
                            readOnly: provider.forView?true:  !provider.isUpdate?false: !provider.noChange,
                            validator: (value){
                              if(value==null || value.isEmpty){
                                return '10 Digit Number';
                              }else if(value.length<10){
                                return '10 Digit Number';
                              }else if(value.length>10) {
                                return '10 Digits Only';
                              }else{
                                return null;
                              }
                            },
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 20
                            ),
                            decoration: InputDecoration(
                                prefixIcon: Icon(Icons.phone_android,size: 29,),
                                hintText: 'Please enter your Mobile Number',
                                hintStyle: TextStyle(
                                    color: Colors.black.withOpacity(0.5),
                                    fontSize: 15
                                ),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide(color: Colors.black,width: 1)
                                ),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide(color: Colors.black,width: 1)
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide(color: Colors.black,width: 1)
                                )
                            ),
                          ),
                        ),*/



                        provider.forView?
                        Padding(
                          padding: const EdgeInsets.only(top: 50),
                          child: GestureDetector(
                            onTap: ()async{
                              provider.update_forView(false);
                              provider.update_isUpdate(true);
                            },
                            child: Container(
                              height: height*0.05,
                              width: width*0.4,
                              decoration: BoxDecoration(
                                  color: Colors.cyan,
                                  borderRadius: BorderRadius.circular(12)
                              ),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('Edit Profile',style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),),
                                    SizedBox(width: 3,),
                                    Icon(Icons.edit)
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                            :
                        provider.isUpdate?
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 50),
                              child: GestureDetector(
                                onTap: ()async{
                                  if(!provider.isLoading){
                                    if(_key.currentState!.validate()  ){
                                      provider.update_isLoading(true);
                                      await UpdateProfile(context: context,file:provider.file!=null?provider.file:null );
                                    }else{
                                      Fluttertoast.showToast(msg: 'Something went wrong');
                                    }

                                  }

                                },
                                child: Container(
                                  height: height*0.05,
                                  width: width*0.4,
                                  decoration: BoxDecoration(
                                      color: Colors.cyan,
                                      borderRadius: BorderRadius.circular(12)
                                  ),
                                  child: Center(
                                    child:
                                    provider.isLoading&&provider.isUpdate?SpinKitThreeBounce(color: Colors.cyanAccent,size: 40,) :
                                    Text('Update',style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),),
                                  ),
                                ),
                              ),
                            ),


                            Padding(
                              padding: const EdgeInsets.only(top: 50),
                              child: GestureDetector(
                                onTap: ()async{

                                  Fluttertoast.showToast(msg: 'Currently this option is not avaiable. You can update');
                                  //delete Method
                                 /* if(!provider.isLoadingDel){



                                    showDialog(context: context, builder: (context)=>AlertDialog(
                                      title: Center(child: Text('Verify')),
                                      content: Text('Are you sure you want to Delete your Profile',),
                                      backgroundColor: Colors.cyanAccent.shade100,
                                      actions: [
                                        GestureDetector(onTap: ()async{
                                          provider.update_isLoadingDel(true);
                                          await deleteProfile();
                                          Navigator.pop(context);
                                          },child:
                                        Container(
                                            height:40,width:70,
                                            decoration: BoxDecoration(
                                                color:Colors.cyan,
                                                borderRadius: BorderRadius.circular(12)
                                            ),
                                            child:
                                            Center(
                                                child: Text('Yes',style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold)))
                                        )
                                        ),
                                        GestureDetector(onTap: ()async{Navigator.pop(context);},child:
                                        Container(
                                            height:40,width:70,
                                            decoration: BoxDecoration(
                                                color:Colors.cyan,
                                                borderRadius: BorderRadius.circular(12)
                                            ),
                                            child:
                                            Center(
                                                child: Text('No',style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold)))
                                        )
                                        )
                                      ],
                                    ));


                                  }*/

                                },
                                child: Container(
                                  height: height*0.05,
                                  width: width*0.4,
                                  decoration: BoxDecoration(
                                      color: Colors.cyan,
                                      borderRadius: BorderRadius.circular(12)
                                  ),
                                  child: Center(
                                    child:
                                    provider.isLoadingDel&&provider.isUpdate?SpinKitThreeBounce(color: Colors.cyanAccent,size: 40,) :
                                    Text('delete',style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                            :
                        Padding(
                          padding: const EdgeInsets.only(top: 50),
                          child: GestureDetector(
                            onTap: ()async{
                              if(!provider.isLoading){
                                if(_key.currentState!.validate() && provider.file!=null){
                                  provider.update_isLoading(true);
                                  await userProfile(context,provider.file!);
                                }else{
                                  Fluttertoast.showToast(msg:
                                  provider.file==null?'select image':
                                  'please fill up the fields correctly '
                                  );
                                }

                              }

                            },
                            child: Container(
                              height: height*0.05,
                              width: width*0.4,
                              decoration: BoxDecoration(
                                  color: Colors.cyan,
                                  borderRadius: BorderRadius.circular(12)
                              ),
                              child: Center(
                                child:
                                provider.isLoading?SpinKitThreeBounce(color: Colors.cyanAccent,size: 40,) :
                                Text('Create',style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),),
                              ),
                            ),
                          ),
                        ),

                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },

      ),
    );
  }
  Future<void> userProfile(BuildContext context,File file)async{
    final provider = Provider.of<ProviderState>(context,listen: false);
    User? user = await _firebaseAuth.currentUser;

    try{
      if(user!=null){
        String id = DateTime.now().millisecondsSinceEpoch.toString();
        UploadTask uploadTask = FirebaseStorage.instance.ref().child('myProfile').child('myFile${id}').putFile(file);
// StreamSubscription detail = uploadTask.snapshotEvents.listen((snapshot) { });
        uploadTask.then((p0) => Fluttertoast.showToast(msg: 'upload Successful')).onError((error, stackTrace) => Fluttertoast.showToast(msg: error.toString()));
        TaskSnapshot taskSnapshot = await uploadTask;
        String myUrl = await taskSnapshot.ref.getDownloadURL();
        SharedPreferenceHelper.SetUrl(myUrl);

        user.updateDisplayName(usernameController.text.trim());
        user.updatePhotoURL(myUrl);
        provider.update_isLoading(false);
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>LoginPage()), (route) => false);
      }else{
        provider.update_isLoading(false);
        Fluttertoast.showToast(msg: 'please create your account');
      }
    }on FirebaseException catch(ex){
      provider.update_isLoading(false);
      Fluttertoast.showToast(msg: ex.code.toString());
      throw ex.message.toString();
    }

  }



  Future<void> UpdateProfile({required BuildContext context, File? file})async{
    User? user = _firebaseAuth.currentUser;
    String Nurl ='';
    final provider = Provider.of<ProviderState>(context,listen: false);

    if(user!.photoURL==null){
      await AnotherUploadMethod(file!);
    }
    if(file!=null  ){
      // provider.update_isLoading(true);

      Reference previousImage = await  FirebaseStorage.instance.refFromURL(user!.photoURL!);
      try{
        await previousImage.putFile(file!);
        Nurl = await previousImage.getDownloadURL();
        user.updatePhotoURL(Nurl).onError((error, stackTrace){Fluttertoast.showToast(msg: 'Unable to uplaod Something went wrong');});

        provider.update_isLoading(false);
        provider.update_forView(true);
        provider.update_isUpdate(false);
      }catch(ex){
        provider.update_isLoading(false);
        Fluttertoast.showToast(msg: 'Try Again Something went wrong');
        throw ex;
      }
    }else if(user.displayName!=usernameController.text){
      // if(user.displayName!=usernameController.text){
        user.updateDisplayName(usernameController.text.trim()).then((value){usernameController.text=user.displayName!;});
      provider.update_isLoading(false);
      provider.update_forView(true);
      provider.update_isUpdate(false);
    }else{
      provider.update_isLoading(false);
      Fluttertoast.showToast(msg: 'Make Changes to Update Profile');
    }
  }

  Future<void> deleteProfile()async{
    User? user = _firebaseAuth.currentUser;
    final provider = Provider.of<ProviderState>(context,listen: false);
    // provider.update_isLoadingDel(true);

    try{
      // user!.delete();
      dynamic credentials = EmailAuthProvider.credential(email: user!.email!, password: passwordController.text.toString());
      final result = await user.reauthenticateWithCredential(credentials);
      await result.user!.delete();
      provider.update_isLoadingDel(false);
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>SignUpPage()), (route) => false);
    }on FirebaseException catch(ex){
      provider.update_isLoadingDel(false);
      Fluttertoast.showToast(msg: ex.code.toString());
      throw ex.code;
    }
  }

  Future<void> AnotherUploadMethod(File file)async{
    User? user = _firebaseAuth.currentUser;
    final provider = Provider.of<ProviderState>(context,listen: false);

    try{
      String id = DateTime.now().millisecondsSinceEpoch.toString();
      UploadTask uploadTask = FirebaseStorage.instance.ref().child('myProfile').child('myFile${id}').putFile(file);
// StreamSubscription detail = uploadTask.snapshotEvents.listen((snapshot) { });
      uploadTask.then((p0) => Fluttertoast.showToast(msg: 'upload Successful')).onError((error, stackTrace) => Fluttertoast.showToast(msg: error.toString()));
      TaskSnapshot taskSnapshot = await uploadTask;
      String myUrl = await taskSnapshot.ref.getDownloadURL();
      SharedPreferenceHelper.SetUrl(myUrl);

      user!.updateDisplayName(user.displayName!=null?user.displayName:SharedPreferenceHelper.GetUserName());
      user.updatePhotoURL(myUrl);
      provider.update_isLoading(false);
      provider.update_forView(true);
      provider.update_isUpdate(false);
    }on FirebaseException catch(ex){
      provider.update_isLoading(false);
      Fluttertoast.showToast(msg: 'Something went wrong Try Again');
      throw ex;
    }

  }




}




