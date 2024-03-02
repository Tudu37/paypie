import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:paypie/pages/homepage.dart';
import 'package:paypie/shared_prreference.dart';
import 'package:paypie/sign_up_pages/signup_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<void> loginMethod()async{
    try{
      await _firebaseAuth.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim()
      ).then((value){
        if(value.user!=null){
          SharedPreferenceHelper.SetisLogin(true);
          Fluttertoast.showToast(msg: "successfully Login");
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>HomePage()), (route) => false);
        }
      });
    }on FirebaseException catch(ex){
      // throw ex.code.toString();
      Fluttertoast.showToast(msg: ex.code.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Center(
          child: Form(
            key: _key,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/login.jpg',),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: TextFormField(
                      controller: emailController,
                      cursorColor: Colors.black,
                      cursorHeight: 25,
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
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.black,width: 1)
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.black,width: 1)
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.black,width: 1)
                          )
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      cursorColor: Colors.black,
                      cursorHeight: 25,
                      validator: (value){
                        if(value==null || value.isEmpty){
                          return 'Your password';
                        }
                      },
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20
                      ),
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.password,size: 29,),
                          hintText: 'Please enter your password',
                          hintStyle: TextStyle(
                              color: Colors.black.withOpacity(0.5),
                              fontSize: 15
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.black,width: 1)
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.black,width: 1)
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.black,width: 1)
                          )
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: GestureDetector(
                      onTap: ()async{
                        if(_key.currentState!.validate()){
                          // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('successful')));
                          await loginMethod();
                        }
                      },
                      child: Container(
                        height: height*0.05,
                        width: width*0.4,
                        decoration: BoxDecoration(
                            color: Colors.cyan,
                            borderRadius: BorderRadius.circular(12)
                        ),
                        child: Center(child: Text('Login',style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),),),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('If New User Please'),
                      TextButton(onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>SignUpPage()));
                      }, child: Text("Create Your Account",style: TextStyle(fontSize: 17,fontWeight: FontWeight.w400))),
                    ],
                  ),


                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
