import 'package:flutter/material.dart';
import 'package:frontend/providers/doctors-provider.dart';
import 'package:provider/provider.dart';

class RegisterDoctor extends StatefulWidget {
  @override
  State<RegisterDoctor> createState() => _RegisterDoctorState();
}

class _RegisterDoctorState extends State<RegisterDoctor> {
  bool isLoading = false;
  bool isHide = true;
  final _formKey = GlobalKey<FormState>();
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  void submitRegister(ctx) async {
    var isValid = _formKey.currentState!.validate();

    if (!isValid) {
      return;
    }

    setState(() {
      isLoading = true;
    });
    _formKey.currentState!.save();
    try {
      final data = await Provider.of<DoctorsProvider>(ctx, listen: false)
          .registerDoctor(nameController.text, emailController.text,
              passwordController.text);
      if (data != null) {
        setState(() {
          isLoading = false;
        });
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Success'),
            content: Text("Successfully registered, you can login now!"),
          ),
        );
      }
    } catch (err) {
      setState(() {
        isLoading = false;
      });
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Error'),
          content: Text(err.toString()),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 20,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          height: MediaQuery.of(context).size.height - 50,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Text(
                    "Sign up",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Let's create your account!",
                    style: TextStyle(fontSize: 15, color: Colors.grey[700]),
                  ),
                ],
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
                            return 'Please Provide name';
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
                            return 'Please Provide email';
                          } else {
                            return null;
                          }
                        },
                        onSaved: (newValue) =>
                            emailController.text = newValue.toString().trim(),
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 0, vertical: 20),
                          label: const Text(
                            "Email Address",
                          ),
                          prefixIcon: const Icon(
                            Icons.email,
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
                      margin:
                          const EdgeInsets.only(right: 30, left: 30, top: 10),
                      child: TextFormField(
                        style: const TextStyle(fontSize: 16),
                        validator: (value) {
                          if (value == "") {
                            return 'Please Provide password';
                          } else {
                            return null;
                          }
                        },
                        onSaved: (newValue) => passwordController.text =
                            newValue.toString().trim(),
                        obscureText: isHide,
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
                              "Password",
                              style: TextStyle(),
                            ),
                            prefixIcon: const Icon(
                              Icons.lock,
                            ),
                            isDense: true,
                            labelStyle: Theme.of(context).textTheme.bodySmall,
                            suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    isHide = !isHide;
                                  });
                                },
                                icon: isHide
                                    ? const Icon(
                                        Icons.visibility_off,
                                        color: Colors.black,
                                      )
                                    : const Icon(
                                        Icons.visibility,
                                        color: Colors.black,
                                      )),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(0))),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                  ],
                ),
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
                      submitRegister(context);
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text("Already have an account?"),
                  InkWell(
                    onTap: () => Navigator.pushNamed(
                      context,
                      "/login",
                    ),
                    child: const Text(
                      " Login",
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
