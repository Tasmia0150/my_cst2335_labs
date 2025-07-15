import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';

class DataRepository {
  static String? loginName;
  static String? firstName;
  static String? lastName;
  static String? phoneNumber;
  static String? emailAddress;

  EncryptedSharedPreferences prefs = EncryptedSharedPreferences();

  // Add any other global/shared data here

  void loadData() async {
    final prefs = EncryptedSharedPreferences();
    DataRepository.firstName = await prefs.getString('FirstName');
    DataRepository.lastName = await prefs.getString('LastName');
    DataRepository.phoneNumber = await prefs.getString('PhoneNumber');
    DataRepository.emailAddress = await prefs.getString('EmailAddress');
  }

  void saveData() async {
    final prefs = EncryptedSharedPreferences();
    await prefs.setString('FirstName', firstName ?? '');
    await prefs.setString('LastName', lastName ?? '');
    await prefs.setString('PhoneNumber', phoneNumber ?? '');
    await prefs.setString('EmailAddress', emailAddress ?? '');
  }
}