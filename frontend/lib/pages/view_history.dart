import 'package:flutter/material.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/providers/patients-provider.dart';
import 'package:provider/provider.dart';

class ViewHistory extends StatefulWidget {
  const ViewHistory({super.key});

  @override
  State<ViewHistory> createState() => _ViewHistoryState();
}

class _ViewHistoryState extends State<ViewHistory> {
  var nameController = TextEditingController();
  var idController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  var data;

  void submitForm(ctx) async {
    var isValid = _formKey.currentState!.validate();

    if (!isValid) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    _formKey.currentState!.save();
    try {
      data = await Provider.of<PatientsProvider>(ctx, listen: false)
          .findPatient(nameController.text, idController.text);
      setState(() {
        isLoading = false;
      });
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

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            padding: const EdgeInsets.all(10),
            child: const Text(
              "View patient history by name and ID",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(
            height: 20,
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
                  return "Please provide patient name";
                } else {
                  return null;
                }
              },
              onChanged: (_) {
                setState(() {
                  data = null;
                });
              },
              onSaved: (newValue) =>
                  nameController.text = newValue.toString().trim(),
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 0, vertical: 20),
                label: const Text(
                  "Patient name",
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
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(0)),
              ),
            ),
          ),
          const SizedBox(height: 25),
          Container(
            margin: const EdgeInsets.only(right: 30, left: 30, top: 10),
            child: TextFormField(
              onChanged: (_) {
                setState(() {
                  data = null;
                });
              },
              style: const TextStyle(fontSize: 16),
              validator: (value) {
                if (value == "") {
                  return "Please provide ID";
                } else {
                  return null;
                }
              },
              onSaved: (newValue) =>
                  idController.text = newValue.toString().trim(),
              decoration: InputDecoration(
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
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 0, vertical: 20),
                label: const Text(
                  "Patient ID",
                  style: TextStyle(),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(0),
                ),
              ),
            ),
          ),
          const SizedBox(height: 25),
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
                  submitForm(context);
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
                            "Searching....",
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      ),
                    )
                  : const Text(
                      "Search",
                      style: TextStyle(color: Colors.white),
                    ),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          data != null
              ? Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    color: Color(0xFFffffff),
                    borderRadius: BorderRadius.all(
                      Radius.circular(5),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 4.0, // soften the shadow
                        spreadRadius: 1.0, //extend the shadow
                        offset: Offset(
                          1.0, // Move to right 5  horizontally
                          1.0, // Move to bottom 5 Vertically
                        ),
                      )
                    ],
                  ),
                  child: data != null
                      ? Column(
                          children: [
                            Row(
                              children: [
                                const Text(
                                  'Name: ',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(data['name'],
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                            Divider(),
                            Row(
                              children: [
                                const Text(
                                  'ID: ',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  data['id'],
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Divider(),
                            Row(
                              children: [
                                const Text(
                                  'Gender: ',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  data['gender'],
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Divider(),
                            Row(
                              children: [
                                const Text(
                                  'Age: ',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  data['age'],
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Divider(),
                            Image.network(
                              '$imageUrl/${(data['picture']).toString().replaceAll('\\', "/")}',
                              width: double.infinity,
                              height: MediaQuery.of(context).size.height * .5,
                            ),
                          ],
                        )
                      : Container(),
                )
              : Container(),
          SizedBox(
            height: 15,
          )
        ],
      ),
    );
  }
}
