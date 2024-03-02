import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:paypie/logic/provider_state.dart';
import 'package:paypie/pages/homepage.dart';
import 'package:provider/provider.dart';

class Add_Users extends StatefulWidget {
  String id;
  String url;
  String username;
  String email;
  String number;
   Add_Users({
     required this.id,
     required this.url,
     required this.username,
     required this.email,
     required this.number,
     Key? key
   }) : super(key: key);

  @override
  State<Add_Users> createState() => _Add_UsersState();
}

class _Add_UsersState extends State<Add_Users> {

  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  FirebaseFirestore _firestore = FirebaseFirestore.instance;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<ProviderState>(context,listen: false).file=null;
    if(Provider.of<ProviderState>(context,listen: false).forView){
      usernameController.text = widget.username;
      emailController.text = widget.email;
      phoneController.text = widget.number;
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    usernameController.dispose();
    emailController.dispose();
    phoneController.dispose();
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
                        Align(
                          alignment: Alignment.topLeft,
                          child: GestureDetector(
                            onTap: (){
                              provider.update_forView(false);
                              provider.update_isUpdate(false);
                              Navigator.pop(context);
                              },
                              child: Icon(Icons.arrow_back,color: Colors.black,size: 35,)
                          ),
                        ),
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
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(widget.url),
                              // child: Icon(Icons.account_circle,size: 40),
                            ),
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
                              image: provider.file==null?
                              DecorationImage(
                                image: NetworkImage(widget.url), fit: BoxFit.cover,
                              ):
                              new DecorationImage(
                                image: new FileImage(provider.file!),
                                fit: BoxFit.cover,
                              )
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
                                /*ClipRRect(
                                    borderRadius:BorderRadius.circular(20),
                                    child:provider.file==null ? Image.asset('assets/ac_bg.png',
                                      fit: BoxFit.cover,)
                                        :
                                    Image.file(provider.file!, fit: BoxFit.cover,)
                                ),*/
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
                            readOnly: provider.forView?true:  !provider.isUpdate?false: !provider.noChange,
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

                        Padding(
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
                        ),



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
                                    await Update(context: context,file:provider.file!=null?provider.file:null );
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
                                //delete Method
                                if(!provider.isLoadingDel){
                                  provider.update_isLoadingDel(true);

                                  await delete();
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
                                  await addUsers(context,provider.file!);
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
  Future<void> addUsers(BuildContext context,File file)async{
    final provider = Provider.of<ProviderState>(context,listen: false);
    // provider.update_isLoading(true);

   // provider.update_fileId();
   String id = DateTime.now().millisecondsSinceEpoch.toString();
    UploadTask uploadTask = FirebaseStorage.instance.ref().child('myFolder').child('myFile${id}').putFile(file);
    // StreamSubscription detail = uploadTask.snapshotEvents.listen((snapshot) { });
    uploadTask.then((p0) => Fluttertoast.showToast(msg: 'upload Successful')).onError((error, stackTrace) => Fluttertoast.showToast(msg: error.toString()));
    TaskSnapshot taskSnapshot = await uploadTask;
    String myUrl = await taskSnapshot.ref.getDownloadURL();

    // provider.IncrementId();
    Map<String,dynamic> data ={
      'Username':usernameController.text.trim(),
      'Email':emailController.text.trim(),
      'Number':phoneController.text.trim(),
      'Url':myUrl
    };
    try{
      _firestore.collection('Users').doc(id).set(data)
      .then((value) {
        provider.update_isLoading(false);
        Fluttertoast.showToast(msg: "Your data is successfully Created");
          Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePage()));
      })
      ;
    }on FirebaseException catch(ex){
      provider.update_isLoading(false);
      Fluttertoast.showToast(msg: ex.code.toString());
    }
   
  }



  Future<void> Update({required BuildContext context, File? file})async{
     String Nurl ='';
     final provider = Provider.of<ProviderState>(context,listen: false);
    if(file!=null){
      // provider.update_isLoading(true);

     Reference previousImage = await  FirebaseStorage.instance.refFromURL(widget.url);
     try{
       await previousImage.putFile(file);
       Nurl = await previousImage.getDownloadURL();
     }catch(ex){
       Fluttertoast.showToast(msg: ex.toString());
       throw ex;
     }
    }

    Map<String,dynamic> data ={
      'Username':usernameController.text.trim(),
      'Email':emailController.text.trim(),
      'Number':phoneController.text.trim(),
      'Url':file==null?widget.url:Nurl
    };
    try{
      _firestore.collection('Users').doc(widget.id).update(data)
      .then((value){
        provider.update_isLoading(false);
        Fluttertoast.showToast(msg: "Your data is successfully Updated");
        Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePage()));
      });
    }on FirebaseException catch(ex){
      provider.update_isLoading(false);
      Fluttertoast.showToast(msg: ex.code.toString());
    }
  }

  Future<void> delete()async{
    final provider = Provider.of<ProviderState>(context,listen: false);
    // provider.update_isLoadingDel(true);
    try{
      _firestore.collection('Users').doc(widget.id).delete()
      .then((value){
        provider.update_isLoadingDel(false);
        Fluttertoast.showToast(msg: 'Successfully Deleted');
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>HomePage()), (route) => false);
      })
    ;
    }on FirebaseException catch(ex){
      provider.update_isLoadingDel(false);
      Fluttertoast.showToast(msg: ex.code.toString());
      throw ex.code;
    }
  }
}
