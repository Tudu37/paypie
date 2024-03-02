import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:paypie/logic/provider_state.dart';
import 'package:paypie/login_pages/login_page.dart';
import 'package:paypie/pages/add_users.dart';
import 'package:paypie/profile/create_update_profile.dart';
import 'package:paypie/shared_prreference.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;


  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double  width= MediaQuery.of(context).size.width;
    User? user = _firebaseAuth.currentUser;
    return Scaffold(
      backgroundColor: Colors.cyan.shade100,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: (){
            Provider.of<ProviderState>(context,listen: false).update_forView(true);
            Navigator.push(context, MaterialPageRoute(builder: (context)=>Create_Update()));
          },
            child: Padding(
              padding: const EdgeInsets.only(left: 5),
                child: user!=null &&  user.photoURL!=null?CircleAvatar(backgroundImage: NetworkImage(user.photoURL!))
                    :Icon(Icons.account_circle)
            )
        ),
        title: user!=null && user.displayName!=null?Text('Hello ${user.displayName}'):Text('${SharedPreferenceHelper.GetUserName()}'),
        centerTitle: true,
        actions: [
          GestureDetector(
              onTap: ()async{
                showDialog(context: context, builder: (context)=>AlertDialog(
                  title: Center(child: Text('Verify')),
                  content: Text('Are you sure you want to Logout'),
                  backgroundColor: Colors.cyanAccent.shade100,
                  actions: [
                    GestureDetector(
                        onTap: ()async{await logout();},
                        child: Container(
                            height:40,width:70,
                            decoration: BoxDecoration(
                              color:Colors.cyan,
                              borderRadius: BorderRadius.circular(12)
                            ),
                            child: 
                            Center(
                                child: Text('Yes',style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold)))
                        )),
                    GestureDetector(onTap: ()async{Navigator.pop(context);},
                        child: Container(
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

              },
              child: Padding(padding:const EdgeInsets.only(right: 10),child: Icon(Icons.logout))
          )
        ],
        backgroundColor: Colors.cyanAccent.withOpacity(0.6),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 10),
        child: StreamBuilder(
          stream: _firestore.collection('Users').snapshots(),
          builder: (context,AsyncSnapshot<QuerySnapshot>snapshots){
            if(snapshots.connectionState==ConnectionState.waiting){
              return Center(child: SpinKitFadingCircle(color: Colors.cyanAccent,size: 90,),);
            }
            else if(snapshots.data!.docs.length!=0&&snapshots.hasData){
              return ListView.builder(
                physics: BouncingScrollPhysics(),
                  itemCount: snapshots.data!.docs.length,
                  itemBuilder: (context,index){
                    Map<String,dynamic> userData = snapshots.data!.docs[index].data() as Map<String,dynamic>;
                    String id = snapshots.data!.docs[index].id;
                    return userContainer(
                      height,
                      width,
                      id,
                      userData['Url'],
                      userData['Username'],
                      userData['Email'],
                      userData['Number'],
                    );
                  }
              );
            }
            else{
             return
               emptyBody(context,height,width);
               // Center(child: Text('No Data Found',style: TextStyle(color: Colors.black),),);
            }

          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.cyanAccent.shade400,
        onPressed: (){
          Provider.of<ProviderState>(context,listen: false).update_forView(false);
          Provider.of<ProviderState>(context,listen: false).update_isUpdate(false);
          Navigator.push(context, MaterialPageRoute(builder: (context)=>Add_Users(
            id: '',
            url: '',
            username: '',
            email: '',
            number: '',
          )));
        },
        child: Icon(Icons.add),
      ),
    );
  }

  // userContainer(height, width)

  Widget userContainer(
      double height,
      double width,
      String id,
      String url,
      String username,
      String email,
      String number,
      ) {
    final provider = Provider.of<ProviderState>(context,listen: false);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: GestureDetector(
        onTap: (){
          provider.update_forView(true);
          Navigator.push(context, MaterialPageRoute(builder: (context)=>Add_Users(
            id: id,
            url: url,
            username: username,
            email: email,
            number: number,
          )));
        },
        child: Container(
            height: height*0.125,
            width: width,
            decoration: BoxDecoration(
              color: Colors.cyanAccent.withOpacity(0.3),
              borderRadius: BorderRadius.circular(12),
              border: Border.fromBorderSide(
                  BorderSide(
                      color: Colors.black,
                      width: 1
                  )
              )
            ),
            child: Row(
              children: [
                SizedBox(width: 5,),
              Container(
                height: height*0.1,
                width: width*0.3,
                decoration: BoxDecoration(
                  // color: Colors.green
                ),
                child: CircleAvatar(
                  backgroundImage: NetworkImage(url),
                  // child: Icon(Icons.account_circle,size: 40),
                ),
              ),
             Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 SizedBox(height: height*0.02,),
                 Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                     child: Text(
                       // 'UserNamePankaj',
                       username,
                       style: TextStyle(color: Colors.black,fontSize: 17,fontWeight: FontWeight.bold),)
                 ),

                 Padding(
                     padding: const EdgeInsets.symmetric(vertical: 2),
                     child: Text(
                       // 'pankaj'
                       email
                       ,style: TextStyle(color: Colors.black.withOpacity(0.5),fontSize: 15),)
                 ),

            Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Text(
                  // 'pankajpaulsbg@gmail.com'
                  number
                  ,style: TextStyle(color: Colors.black.withOpacity(0.5),fontSize: 15),)
            ),
               ],
             )
            ],
            ),
          ),
      ),
    );
  }

  Widget emptyBody(BuildContext context,double height,double width){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 170,horizontal: 10),
      child: Container(
        height:height*0.14,
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            border: Border.fromBorderSide(BorderSide(color:Color.fromRGBO(137, 134, 134, 0.9) ))
        ),
        child:Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(padding:const EdgeInsets.symmetric(vertical: 10),child: Text("No Users",style: TextStyle(fontSize: 15,color:Color.fromRGBO(137, 134, 134, 0.9,) ),),),
              GestureDetector(
                onTap: (){
                  Provider.of<ProviderState>(context,listen: false).update_forView(false);
                  Provider.of<ProviderState>(context,listen: false).update_isUpdate(false);
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>Add_Users(
                    id: '',
                    url: '',
                    username: '',
                    email: '',
                    number: '',
                  )));
                },
                child: Container(
                  height: height*0.049,
                  width: width*0.43,
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(7, 127, 105, 0.9),
                      borderRadius: BorderRadius.all(Radius.circular(6))
                  ),
                  child: Center(
                    child: Text("Add New Users",style: TextStyle(color: Colors.white),),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Future<void> logout()async{
    try{
       await  _firebaseAuth.signOut()
       .then((value){
         SharedPreferenceHelper.SetisLogin(false);
         Fluttertoast.showToast(msg: 'Logout');
         Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>LoginPage()), (route) => false);
       })
       ;
    }on FirebaseException catch(ex){
      Fluttertoast.showToast(msg: 'Unable to Logout');
      throw ex.message.toString();
    }
  }
}
