import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'form_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    // Replace with actual values
    options: FirebaseOptions(
      apiKey: "XXX",
      appId: "1:433498137165:android:80c4fe7865230c9c40b204",
      messagingSenderId: "",
      projectId: "project1-4fc08",
    ),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  _handleDeleteBook(book) async {
    await FirebaseFirestore.instance.collection("users").doc(book.id).delete();

    print("Object has been deleted!");
  }

  _handleSoftDelete(book) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(book.id)
        .update({"status": 2});

    print("Object has been updated!");
  }

  _handleMovetoEdit(book) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => FormPage(
                  docment: book,
                )));
  }

  _handleReactive(book) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(book.id)
        .update({"status": 1});

    print("Object has been updated!");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("My Home Page")),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => FormPage()));
        },
        child: Icon(Icons.add),
      ),
      body: Container(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("users")
              .where("status", isEqualTo: 1)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: Text("There are an error occured"),
              );
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.connectionState == ConnectionState.active ||
                snapshot.connectionState == ConnectionState.done) {
              final data = snapshot.requireData;
              return ListView.builder(
                  itemCount: data.size,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                        title: Text(
                          "${data.docs[index]['Name']}",
                          textScaleFactor: 1.5,
                        ),
                        subtitle: Text(
                          "${data.docs[index]['Location']}",
                          textScaleFactor: 1,
                          textHeightBehavior: TextHeightBehavior(
                            applyHeightToFirstAscent: true,
                          ),
                        ),
                        leading: Column(
                          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              "${data.docs[index]['Price']}",
                              textScaleFactor: 1,
                            ),
                            Text("${data.docs[index]['Seats']}"),
                          ],
                        ),

                        //   Text("${data.docs[index]['Price']}") ,

                        trailing: TextButton.icon(
                          onPressed: () {
                            // _handleDeleteBook(data.docs[index]);
                            _handleMovetoEdit(data.docs[index]);
                          },
                          icon: Icon(Icons.edit),
                          label: Text(
                            "Edit",
                          ),
                        ));
                  });
            }
            return Container();
          },
        ),
      ),
    );
  }
}
