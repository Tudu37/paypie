import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:paypie/logic/provider_state.dart';
import 'package:paypie/login_pages/login_page.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:paypie/profile/create_update_profile.dart';
import 'package:paypie/shared_prreference.dart';
import 'package:provider/provider.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {

  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<void> signupMethod()async{
    final provider=Provider.of<ProviderState>(context,listen: false);
    try{
      provider.update_isLoading(true);
     await _firebaseAuth.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim()
      ).then((value){
        if(value.user!=null){
          provider.update_isLoading(false);
          SharedPreferenceHelper.SetUserName(usernameController.text.toString());
          Fluttertoast.showToast(msg: "successfully Created Account");
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>Create_Update()), (route) => false);
        }
      });
    }on FirebaseException catch(ex){
      // throw ex.message.toString();
      provider.update_isLoading(false);
      Fluttertoast.showToast(msg: ex.code);
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Form(
            key: _key,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(height:120,child: Image.asset('assets/Signup.jpg',)),
                SizedBox(height: 15,),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: TextFormField(
                    controller: usernameController,
                    cursorColor: Colors.black,
                    cursorHeight: 25,
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
                      }else if(value.length<6){
                        return 'password should be atleast above 6 character';
                      }else{
                        return null;
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
                        SharedPreferenceHelper.SetUserName(usernameController.text.trim());
                        await signupMethod();
                      }
                    },
                    child: Container(
                      height: height*0.05,
                      width: width*0.4,
                      decoration: BoxDecoration(
                       color: Colors.cyan,
                        borderRadius: BorderRadius.circular(12)
                      ),
                      child: Center(child: Provider.of<ProviderState>(context).isLoading?
                      SpinKitFadingCircle(color: Colors.cyanAccent):
                      Text('Sign Up',style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),),),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Already have an Account'),
                    TextButton(onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginPage()));
                    }, child: Text("Login",style: TextStyle(fontSize: 17,fontWeight: FontWeight.w400),)),
                  ],
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
