import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:frontend/providers/doctors-provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool isHide = true;
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  bool isSubmitted = false;
  var focusNode = FocusNode();
  String text = '';
  dynamic emailValidater(value) {
    String email = value.trim.toString();
    if (email.isEmpty) {
      return "Please provide email";
    }

    return null;
  }

  dynamic passwordValidator(value) {
    String password = value.trim().toString();
    if (password.isEmpty) {
      return 'Please provide password';
    }
    return null;
  }

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  Future submitLogin(ctx) async {
    setState(() {
      isSubmitted = true;
    });
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      _formKey.currentState!.save();
      setState(() {
        isLoading = true;
      });
      try {
        final data = await Provider.of<DoctorsProvider>(ctx, listen: false)
            .loginDoctor(emailController.text, passwordController.text);
        setState(() {
          isLoading = false;
        });

        if (data != null) {
          SharedPreferences pref = await SharedPreferences.getInstance();
          pref.setString("name", data['name']);
          pref.setString("email", data['email']);
          Navigator.of(ctx).pushNamedAndRemoveUntil("/home", (route) => false);
        }
      } catch (err) {
        setState(() {
          isLoading = false;
        });
        SnackBar bar = SnackBar(
          content: Text(err.toString()),
          backgroundColor: Colors.red,
        );
        ScaffoldMessenger.of(ctx).showSnackBar(bar);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanDown: (pd) {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        key: _scaffoldKey,
        body: CustomPaint(
          child: Form(
            autovalidateMode: isSubmitted
                ? AutovalidateMode.onUserInteraction
                : AutovalidateMode.disabled,
            key: _formKey,
            child: ListView(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * .1,
                        ),
                        child: SizedBox(
                          height: 150,
                          width: 200,
                          child: Image.asset(
                            "assets/images/eye.png",
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(bottom: 40),
                        child: const Text(
                          "Login to your account",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 30),
                        child: TextFormField(
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.normal,
                          ),
                          onFieldSubmitted: (v) {
                            FocusScope.of(context).requestFocus(focusNode);
                          },
                          validator: (value) => emailValidater(value),
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
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        margin:
                            const EdgeInsets.only(right: 30, left: 30, top: 10),
                        child: TextFormField(
                          focusNode: focusNode,
                          style: const TextStyle(fontSize: 16),
                          validator: (value) => passwordValidator(value),
                          onSaved: (newValue) => passwordController.text =
                              newValue.toString().trim(),
                          onFieldSubmitted: (value) => submitLogin(context),
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
                        height: 10,
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
                              backgroundColor: Colors.transparent,
                              elevation: 0),
                          onPressed: () {
                            if (isLoading) {
                              return;
                            } else {
                              submitLogin(context);
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
                                        "logging in",
                                        style: TextStyle(color: Colors.white),
                                      )
                                    ],
                                  ),
                                )
                              : const Text(
                                  "Login",
                                  style: TextStyle(color: Colors.white),
                                ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(10),
                        child: RichText(
                          text: TextSpan(children: [
                            const TextSpan(
                                style: TextStyle(color: Colors.black54),
                                text: "Don't you have an account? "),
                            TextSpan(
                              style: const TextStyle(color: Colors.blue),
                              text: 'Register',
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.pushNamed(
                                    context,
                                    "/register-doctor",
                                  );
                                },
                            ),
                          ]),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
