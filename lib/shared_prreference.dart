
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceHelper{

  static final SharedPreferenceHelper _instance = SharedPreferenceHelper._ctor();

  factory SharedPreferenceHelper() {
    return _instance;
  }
  SharedPreferenceHelper._ctor();


  static late SharedPreferences prefs;

  static Future<void> initialise()async{
    prefs = await SharedPreferences.getInstance();
  }

  static void SetUserName(String username)async{
    prefs.setString('Username', username);
  }

  static String GetUserName(){
    return prefs.getString('Username')??'Users';
  }

  static void SetUrl(String url)async{
    prefs.setString('Url', url);
  }

  static String GetUrl(){
    return prefs.getString('Url')??'';
  }

  static void SetisLogin(bool value){
    prefs.setBool('Value', value);
  }

  static bool GetisLogin(){
    return prefs.getBool('Value')??false;
  }

}