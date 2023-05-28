import 'dart:io';

import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:frontend/providers/doctors-provider.dart';
import 'package:frontend/providers/patients-provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class RegisterPatient extends StatefulWidget {
  @override
  State<RegisterPatient> createState() => _RegisterPatientState();
}

class _RegisterPatientState extends State<RegisterPatient> {
  bool isLoading = false;
  bool isHide = true;
  final _formKey = GlobalKey<FormState>();
  var nameController = TextEditingController();
  var ageController = TextEditingController();
  var idController = TextEditingController();
  File? _image;
  final genderController = TextEditingController();

  Future<void> submitRegister() async {
    var isValid = _formKey.currentState!.validate();

    if (!isValid) {
      return;
    }

    if (_image == null && genderController.text == "") {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Error'),
          content: Text("Gender and patient picture not selected"),
        ),
      );
      return;
    }
    if (genderController.text == "") {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Error'),
          content: Text("Gender not selected"),
        ),
      );
      return;
    }
    if (_image == null) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Error'),
          content: Text("Patient picture not selected"),
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    _formKey.currentState!.save();

    try {
      String message =
          await Provider.of<PatientsProvider>(context, listen: false)
              .registerPatient(nameController.text, idController.text,
                  ageController.text, genderController.text, _image!);
      setState(() {
        isLoading = false;
      });

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          content: Text(message),
          title: Text('Success'),
        ),
      );
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Error'),
          content: Text(error.toString()),
        ),
      );
    }
  }

  Widget bottomSheet() {
    return Container(
      height: 150.0,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          const Text('Choose Image'),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: TextButton.icon(
                    onPressed: () {
                      takePhoto(ImageSource.gallery);
                    },
                    label: const Text('Gallery'),
                    icon: const Icon(Icons.image)),
              ),
              TextButton.icon(
                onPressed: () {
                  takePhoto(ImageSource.camera);
                },
                label: const Text('Camera'),
                icon: const Icon(Icons.camera_alt),
              ),
            ],
          )
        ],
      ),
    );
  }

  dynamic passwordValidator(value) {
    String password = value.trim().toString();
    if (password.isEmpty) {
      return 'Please provide password';
    } else if (password.length < 4) {
      return "Password length should atleast be 4 character";
    }
    return null;
  }

  void takePhoto(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile?.path != null) {
      setState(() {
        _image = File(pickedFile!.path);
      });
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        height: MediaQuery.of(context).size.height - 50,
        width: double.infinity,
        child: Column(
          children: <Widget>[
            const SizedBox(
              height: 20,
            ),
            Column(
              children: const <Widget>[
                Text(
                  "Fill all patient information to register!",
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 30),
                    child: TextFormField(
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.normal,
                      ),
                      validator: (value) {
                        if (value == "") {
                          return "Please provide patient name";
                        } else {
                          return null;
                        }
                      },
                      onSaved: (newValue) =>
                          nameController.text = newValue.toString().trim(),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 0, vertical: 20),
                        label: const Text(
                          "Full Name",
                        ),
                        prefixIcon: const Icon(
                          Icons.person,
                          size: 15,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(0),
                          borderSide: BorderSide(
                              width: 1,
                              style: BorderStyle.solid,
                              color: Theme.of(context).primaryColor),
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(0)),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 30),
                    child: TextFormField(
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.normal,
                      ),
                      validator: (value) {
                        if (value == "") {
                          return "Please provide patient ID";
                        } else {
                          return null;
                        }
                      },
                      onSaved: (newValue) =>
                          idController.text = newValue.toString().trim(),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 0, vertical: 20),
                        label: const Text(
                          "Patient ID",
                        ),
                        prefixIcon: const Icon(
                          Icons.password,
                          size: 15,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(0),
                          borderSide: BorderSide(
                              width: 1,
                              style: BorderStyle.solid,
                              color: Theme.of(context).primaryColor),
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(0)),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    margin: const EdgeInsets.only(right: 30, left: 30, top: 10),
                    child: CustomDropdown(
                      borderRadius: BorderRadius.zero,
                      borderSide: BorderSide(
                          width: 1,
                          style: BorderStyle.solid,
                          color: Theme.of(context).primaryColor),
                      hintText: 'Select gender',
                      items: const ['Male', "Female"],
                      controller: genderController,
                      onChanged: (value) {
                        genderController.text = value;
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    margin: const EdgeInsets.only(right: 30, left: 30, top: 10),
                    child: TextFormField(
                      style: const TextStyle(fontSize: 16),
                      validator: (value) {
                        if (value == "") {
                          return "Please provide patient age";
                        } else {
                          return null;
                        }
                      },
                      onSaved: (newValue) =>
                          ageController.text = newValue.toString().trim(),
                      decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(0),
                            borderSide: BorderSide(
                                width: 1,
                                style: BorderStyle.solid,
                                color: Theme.of(context).primaryColor),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 0, vertical: 20),
                          label: const Text(
                            "Patient age",
                            style: TextStyle(),
                          ),
                          prefixIcon: const Icon(
                            Icons.numbers,
                          ),
                          isDense: true,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(0))),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  SizedBox(
                    height: 50,
                    child: TextButton.icon(
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (_) => bottomSheet(),
                        );
                      },
                      icon: const Icon(Icons.image),
                      label: const Text('Select Image'),
                    ),
                  ),
                  const SizedBox(width: 20),
                  _image == null
                      ? Container(
                          padding: const EdgeInsets.all(10),
                          child: const Text('Image Preview'),
                        )
                      : Container(
                          child: Image.file(_image!),
                          height: 160,
                        ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              height: 50,
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 30),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black, Colors.black],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent, elevation: 0),
                onPressed: () {
                  if (isLoading) {
                    return;
                  } else {
                    submitRegister();
                  }
                },
                child: isLoading
                    ? Container(
                        width: double.infinity,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "registering",
                              style: TextStyle(color: Colors.white),
                            )
                          ],
                        ),
                      )
                    : const Text(
                        "Register",
                        style: TextStyle(color: Colors.white),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
