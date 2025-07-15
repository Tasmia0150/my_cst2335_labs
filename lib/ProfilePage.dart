import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'Repository.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  var loginName = DataRepository.loginName;

  DataRepository storage = DataRepository();

  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _phoneNumberController;
  late TextEditingController _emailAddressController;

  @override
  void initState() {
    super.initState();

    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _phoneNumberController = TextEditingController();
    _emailAddressController = TextEditingController();

    Future.delayed(const Duration(milliseconds: 100), () {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Welcome Back, $loginName")));
    });

    _firstNameController.text = DataRepository.firstName ?? '';
    _lastNameController.text = DataRepository.lastName ?? '';
    _phoneNumberController.text = DataRepository.phoneNumber ?? '';
    _emailAddressController.text = DataRepository.emailAddress ?? '';

    _firstNameController.addListener(() {
      DataRepository.firstName = _firstNameController.text;
      storage.saveData();
    });

    _lastNameController.addListener(() {
      DataRepository.lastName = _lastNameController.text;
      storage.saveData();
    });

    _phoneNumberController.addListener(() {
      DataRepository.phoneNumber = _phoneNumberController.text;
      storage.saveData();
    });

    _emailAddressController.addListener(() {
      DataRepository.emailAddress = _emailAddressController.text;
      storage.saveData();
    });
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneNumberController.dispose();
    _emailAddressController.dispose();

    super.dispose();
  }

  void _launchURL(String url) {
    Uri uri = Uri.parse(url);
    canLaunchUrl(uri).then((itCan) {
      if (!itCan) {
        launchUrl(uri);
      } else {
        showAlertDialog(
          'Unsupported URL',
          'This URL is not supported on this device',
        );
      }
    });
  }

  void showAlertDialog(String title, String message) {
    showDialog<String>(
      context: context,
      builder:
          (BuildContext context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: <Widget>[
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(Colors.white70),
              foregroundColor: WidgetStateProperty.all(Colors.blue),
            ),
            child: Text("Ok"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Profile Page")),
      body: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          children: <Widget>[
            Text(
              'Welcome Back, ${DataRepository.loginName}',
              style: TextStyle(fontSize: 30, color: Colors.blue),
              textAlign: TextAlign.right,
            ),

            SizedBox(height: 8),

            TextField(
              controller: _firstNameController,
              decoration: const InputDecoration(
                hintText: "Type here",
                border: OutlineInputBorder(),
                labelText: "First Name",
              ),
            ),

            SizedBox(height: 8),

            TextField(
              controller: _lastNameController,
              decoration: const InputDecoration(
                hintText: "Type here",
                border: OutlineInputBorder(),
                labelText: "Last Name",
              ),
            ),

            SizedBox(height: 8),

            Row(
              children: [
                Flexible(
                  child: TextField(
                    controller: _phoneNumberController,
                    decoration: const InputDecoration(
                      hintText: "Type here",
                      border: OutlineInputBorder(),
                      labelText: "Phone Number",
                    ),
                  ),
                ),

                TextButton(
                  onPressed:
                      () => _launchURL('tel: ${_phoneNumberController.text}'),
                  style: ButtonStyle(),
                  child: Icon(Icons.phone),
                ),

                TextButton(
                  onPressed:
                      () => _launchURL('sms: ${_phoneNumberController.text}'),
                  style: ButtonStyle(),
                  child: Icon(Icons.sms),
                ),
              ],
            ),

            SizedBox(height: 8),

            Row(
              children: [
                Flexible(
                  child: TextField(
                    controller: _emailAddressController,
                    decoration: const InputDecoration(
                      hintText: "Type here",
                      border: OutlineInputBorder(),
                      labelText: "Email address",
                    ),
                  ),
                ),

                TextButton(
                  onPressed:
                      () =>
                      _launchURL('mailto: ${_emailAddressController.text}'),
                  style: ButtonStyle(),
                  child: Icon(Icons.email),
                ),
              ],
            ),

            SizedBox(height: 8),


          ],
        ),
      ),
    );
  }
}