import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FormPage extends StatefulWidget {
  final dynamic docment;
  //const FormPage({super.key, this.docment} : super(key: key));
  const FormPage({Key? key, this.docment}) : super(key: key);

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final controllerName = TextEditingController();
  final controllerLoc = TextEditingController();
  final controllerPrice = TextEditingController();
  final controllerSeats = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    if (widget.docment != null) {
      controllerName.text = widget.docment['Name'];
      controllerLoc.text = widget.docment['Location'];
      controllerPrice.text = widget.docment['Price'];
      controllerSeats.text = widget.docment['Seats'];
    }
  }

  _handleSubmitAction() async {
    if (_formKey.currentState!.validate()) {
      if (widget.docment != null) {
        await FirebaseFirestore.instance
            .collection("users")
            .doc(widget.docment.id)
            .update({
          "Name": controllerName.text,
          "Location": controllerLoc.text,
          "Price": controllerPrice.text,
          "Seats": controllerSeats.text,
        });
      } else {
        await FirebaseFirestore.instance.collection("users").add({
          "Name": controllerName.text,
          "created_time": DateTime.now(),
          "Location": controllerLoc.text,
          "Price": controllerPrice.text,
          "Seats": controllerSeats.text,
          "status": 1,
        });
      }

      Navigator.pop(context);
    }
  }

  _handleSoftDelete() async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.docment.id)
        .update({"status": 2});

    print("Object has been updated!");
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Form")),
      body: Container(
        padding: const EdgeInsets.all(10.0),
        child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                    controller: controllerName,
                    validator: (text) {
                      if (text == null || text.isEmpty) {
                        return "Please check the name";
                      }
                    },
                    decoration: InputDecoration(hintText: "Name")),
                TextFormField(
                    controller: controllerLoc,
                    validator: (text) {
                      if (text == null || text.isEmpty) {
                        return "Please check the Location";
                      }
                    },
                    decoration: InputDecoration(hintText: "Location")),
                TextFormField(
                    controller: controllerSeats,
                    keyboardType: TextInputType.number,
                    validator: (text) {
                      if (text == null || text.isEmpty) {
                        return "Please check Seate Numbers";
                      }
                    },
                    decoration: InputDecoration(hintText: "Seate")),
                TextFormField(
                    controller: controllerPrice,
                    keyboardType: TextInputType.number,
                    validator: (text) {
                      if (text == null || text.isEmpty) {
                        return "Please check the Price";
                      }
                    },
                    decoration: InputDecoration(hintText: "Price")),
                ElevatedButton(
                    onPressed: _handleSubmitAction, child: Text("Submit")),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Color(0xff1fc1f3)),
                    onPressed: _handleSoftDelete,
                    child: Text("Delete"))
              ],
            )),
      ),
    );
  }
}
