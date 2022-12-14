// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, file_names, slash_for_doc_comments, avoid_print, camel_case_types, no_leading_underscores_for_local_identifiers, prefer_if_null_operators, invalid_use_of_visible_for_testing_member, constant_identifier_names, void_checks, avoid_init_to_null, missing_return, duplicate_ignore, depend_on_referenced_packages, prefer_typing_uninitialized_variables, sdk_version_constructor_tearoffs, use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopping_app/DataBase/DB_Helper/databse_Helper.dart';
import 'package:shopping_app/DataBase/Model/user_Model.dart';
import 'package:shopping_app/Screens/Login/LoginScreen.dart';
import 'package:shopping_app/Screens/ProfileScreen/MapScreen.dart';

class Profile extends StatefulWidget {
  const Profile({Key key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  // File _image;
  // String myImagePath;
  //
  // Future getImage(ImageSource sorce) async {
  //   try {
  //     final image = await ImagePicker().pickImage(source: sorce);
  //     if (image == null) return;
  //
  //     //  final imageTemporary = File(image.path);
  //     final imagePermanent = await saveFilePermanently(image.path);
  //
  //     setState(() {
  //       // ignore: unnecessary_this
  //       this._image = imagePermanent;
  //     });
  //   } on PlatformException catch (e) {
  //     // ignore: avoid_print
  //     print("error $e");
  //   }
  // }
  //
  // Future<File> saveFilePermanently(String imagePath) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   final directory = await getApplicationDocumentsDirectory();
  //   final name = path.basename(imagePath);
  //   final image = File("${directory.path}/$name");
  //   setState(() {
  //     prefs.setString("profilImage", image.path);
  //   });
  //
  //   return File(imagePath).copy(image.path);
  // }
  //
  // loadImage() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   setState(() {
  //     myImagePath = prefs.getString("profilImage");
  //   });
  // }
  File _image;

  pickImage(ImageSource source) async {
    final image = await ImagePicker.platform.pickImage(source: source);

    if (image.path.isNotEmpty) {
      //final imagePermanent = await saveImagePermanently(image.path);
      setState(() {
        _image = File(image.path);
        //_image = imagePermanent;
      });
      ImageSharedPrefs.saveImageToPrefs(
          ImageSharedPrefs.base64String(await image.readAsBytes()));
    } else {
      print('Error picking image!');
      Fluttertoast.showToast(
          msg: 'Error Picking Image: $_image', timeInSecForIosWeb: 4);
    }
  }

  loadImageFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final imageKeyValue = prefs.getString(IMAGE_KEY);
    if (imageKeyValue != null) {
      final imageString = await ImageSharedPrefs.loadImageFromPrefs();
      // setState(() {
      //   _image = ImageSharedPrefs.imageFrom64BaseString(imageString);
      // });
      return imageString;
      //return _image = ImageSharedPrefs.imageFrom64BaseString(imageString);
    }
  }

  final _formKey = GlobalKey<FormState>();
  final Future<SharedPreferences> _pref = SharedPreferences.getInstance();
  DbHelper dbHelper;
  final _conDelUserId = TextEditingController();
  final _conUserName = TextEditingController();
  final _conEmail = TextEditingController();
  final _conMobile = TextEditingController();
  final _conAge = TextEditingController();
  final _conPassword = TextEditingController();

  @override
  void initState() {
    super.initState();
    getUserData();
    loadImageFromPrefs();
    // loadImage();
    dbHelper = DbHelper();
  }

  Future<void> getUserData() async {
    final SharedPreferences sp = await _pref;

    setState(() {
      // _conUserId.text = sp.getString("user_id")!;
      _conDelUserId.text = sp.getString("user_name");
      _conUserName.text = sp.getString("user_name");
      _conEmail.text = sp.getString("email");
      _conMobile.text = sp.getString("mobile");
      _conAge.text = sp.getString("age");
      _conPassword.text = sp.getString("password");
    });
  }

  update() async {
    // String uid = _conUserId.text;
    String uname = _conUserName.text;
    String email = _conEmail.text;
    String mobile = _conMobile.text;
    String age = _conAge.text;
    String passwd = _conPassword.text;

    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      UserModel user = UserModel(uname, email, mobile, age, passwd);
      await dbHelper.updateUser(user).then((value) {
        if (value == 1) {
          //   Toast.show("Successfully Updated",context);
          Fluttertoast.showToast(
              msg: 'Successfully Updated', timeInSecForIosWeb: 4);

          updateSP(user, true).whenComplete(() {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => LoginScreen()),
                (Route<dynamic> route) => false);
          });
        } else {
          // Toast.show("Error Update",context);
          Fluttertoast.showToast(msg: 'Error Update', timeInSecForIosWeb: 4);
        }
      }).catchError((error) {
        if (kDebugMode) {
          print(error);
        }
        //Toast.show("Error",context);
        Fluttertoast.showToast(msg: 'Error', timeInSecForIosWeb: 4);
      });
    }
  }

  delete() async {
    ImageSharedPrefs.emptyPrefs();
    setState(() {
      //_image = null;
    });
    //await auth.signOut();
    String delUserID = _conDelUserId.text;

    await dbHelper.deleteUser(delUserID).then((value) {
      if (value == 1) {
        // Toast.show("Successfully Deleted",context);
        Fluttertoast.showToast(
            msg: "${_conUserName.text}, Successfully SignOut",
            timeInSecForIosWeb: 4);

        updateSP(
                UserModel(
                    /*_conUserId.text,*/
                    _conUserName.text,
                    _conEmail.text,
                    _conMobile.text,
                    _conAge.text,
                    _conPassword.text),
                false)
            .whenComplete(() {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => LoginScreen()),
              (Route<dynamic> route) => false);
        });
      }
    });
  }

  Future updateSP(UserModel user, bool add) async {
    final SharedPreferences sp = await _pref;

    if (add) {
      sp.setString("user_name", user.user_name);
      sp.setString("email", user.email);
      sp.setString("mobile", user.mobile);
      sp.setString("age", user.age);
      sp.setString("password", user.password);
    } else {
      sp.remove('user_id');
      sp.remove('user_name');
      sp.remove('email');
      sp.remove('mobile');
      sp.remove('age');
      sp.remove('password');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        title: Text("Profile",
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 25)),
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: ListView(
          children: [
            SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                print("Image: $_image");
                pickImage(ImageSource.gallery);
              },
              child: CircleAvatar(
                backgroundColor: Colors.black38,
                radius: 100,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: _image != null
                            // ? NetworkImage(photo)
                            //  : FileImage(File(_image.path)),
                            // : Uri.parse(_image.path),
                            ? FileImage(_image)
                            : photo.isNotEmpty
                                ? NetworkImage(photo)
                                : AssetImage(
                                    "assets/Images/icons8-person-96.png")),
                  ),
                  // child: _image == null
                  //     ? Image.asset('assets/Images/icons8-person-96.png')
                  //     : Image.file(_image),
                ),
              ),
            ),
            SizedBox(height: 15),
            Form(
              key: _formKey,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _conUserName.text.isEmpty
                          ? Text(name,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20))
                          : Text(_conUserName.text,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20)),
                      _conEmail.text.isEmpty
                          ? Text(email,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 17))
                          : Text(_conEmail.text,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 17)),
                    ],
                  ),
                  IconButton(
                      onPressed: () {
                        //update();
                      },
                      icon: Icon(Icons.edit, color: Colors.black, size: 25))
                ],
              ),
            ),
            SizedBox(height: 10),
            Container(
              margin: EdgeInsets.all(5),
              decoration: BoxDecoration(
                boxShadow: [BoxShadow(blurRadius: 1, color: Colors.black)],
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: ListTile(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MapScreen()));
                },
                title: Text("Location",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                        fontSize: 20)),
                trailing:
                    Icon(Icons.arrow_forward, size: 20, color: Colors.black),
              ),
            ),
            SizedBox(height: 10),
            Container(
              margin: EdgeInsets.all(5),
              decoration: BoxDecoration(
                boxShadow: [BoxShadow(blurRadius: 1, color: Colors.black)],
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: ListTile(
                onTap: () {
                  // Navigator.push(context, MaterialPageRoute(builder: (context)=> Setting()));
                },
                title: Text("Setting",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                        fontSize: 20)),
                trailing:
                    Icon(Icons.arrow_forward, size: 20, color: Colors.black),
              ),
            ),
            SizedBox(height: 10),
            Container(
              margin: EdgeInsets.all(5),
              decoration: BoxDecoration(
                boxShadow: [BoxShadow(blurRadius: 1, color: Colors.black)],
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: ListTile(
                onTap: () {
                  // Navigator.push(context, MaterialPageRoute(builder: (context)=> ));
                },
                title: Text("About Us",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                        fontSize: 20)),
                trailing:
                    Icon(Icons.arrow_forward, size: 20, color: Colors.black),
              ),
            ),
            SizedBox(height: 10),
            Container(
              margin: EdgeInsets.all(5),
              decoration: BoxDecoration(
                boxShadow: [BoxShadow(blurRadius: 1, color: Colors.black)],
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: ListTile(
                onTap: delete,
                title: Text("LogOut",
                    style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w700,
                        fontSize: 20)),
                trailing:
                    Icon(Icons.arrow_forward, size: 20, color: Colors.red),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

const IMAGE_KEY = 'IMAGE_KEY';

class ImageSharedPrefs {
  static Future<bool> saveImageToPrefs(String value) async {
    print("object--->");
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return await prefs.setString(IMAGE_KEY, value);
  }

  static Future<bool> emptyPrefs() async {
    print("nshkbc");
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return await prefs.clear();
  }

  static Future<String> loadImageFromPrefs() async {
    print("dhshbsd");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(IMAGE_KEY);
  }

  // encodes bytes list as string
  static String base64String(Uint8List data) {
    print("onject");
    return base64Encode(data);
  }

  // decode bytes from a string
  static imageFrom64BaseString(String base64String) {
    return Image.memory(
      base64Decode(base64String),
      fit: BoxFit.fill,
    );
  }
}
