import 'package:shared_preferences/shared_preferences.dart';

class HelperPrefs {
  static String sharedPreferenceFullNameKey = 'FUllNAMEKEY';
  static String sharedPreferenceUserImageKey = 'USERIMAGEKEY';
  static String sharedPreferenceUserIdKey = 'USERIDKEY';
   static String sharedPreferenceUserEmailKey = 'USEREMAILKEY';

//saving data to prefs
  static Future<bool> saveFullNameInPrefs(String fullName) async {
    SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    return sharedPrefs.setString(sharedPreferenceFullNameKey, fullName);
  }

  static Future<bool> saveUserImageInPrefs(String userImageUrl) async {
    SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    return sharedPrefs.setString(sharedPreferenceUserImageKey, userImageUrl);
  }

  static Future<bool> saveUserIdInPrefs(String userImageId) async {
    SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    return sharedPrefs.setString(sharedPreferenceUserIdKey, userImageId);
  }
    static Future<bool> saveUserEmailInPrefs(String userEmail) async {
    SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    return sharedPrefs.setString(sharedPreferenceUserEmailKey, userEmail);
  }


//getting data from the prefs
  static Future<String> getFullNameInPrefs() async {
    SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    return sharedPrefs.getString(sharedPreferenceFullNameKey);
  }

  static Future<String> getUserImageInPrefs() async {
    SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    return sharedPrefs.getString(sharedPreferenceUserImageKey);
  }

  static Future<String> getUserIdInPrefs() async {
    SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    return sharedPrefs.getString(sharedPreferenceUserIdKey);
  }

  static Future<String> getUserEmailInPrefs() async {
    SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    return sharedPrefs.getString(sharedPreferenceUserEmailKey);
  }

  //clear prefs

  static Future<bool> clearSharedPrefs() async {
    SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    return await sharedPrefs.clear();
  }
}
