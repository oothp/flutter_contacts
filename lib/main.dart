import 'package:contacts_app/ui/contact_list/contact_list_page.dart';
import 'package:contacts_app/ui/model/contacts_model.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  // this widget is the root of our app
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScopedModel(
      model: ContactsModel(),
      child: MaterialApp(
          title: 'Contacts',
          theme: ThemeData(primarySwatch: Colors.teal),
          home: const ContactListPage()),
    );
  }
}
