import 'package:contacts_app/ui/contact/contact_create.dart';
import 'package:contacts_app/ui/contact_list/widget/contact_tile.dart';
import 'package:contacts_app/ui/model/contacts_model.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
// import 'package:scoped_model/scoped_model.dart';

class ContactListPage extends StatefulWidget {
  const ContactListPage({Key? key}) : super(key: key);

  @override
  _ContactListPageState createState() => _ContactListPageState();
  // State<ContactListPage> createState() => _ContactListPageState();
}

class _ContactListPageState extends State<ContactListPage> {
  // runs when the widget is initialized
  // @override
  // void initState() {
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contacts'),
      ),
      body: ScopedModelDescendant<ContactsModel>(
        // runs when notifyListeners() is called from the model.
        builder: (context, child, model) => ListView.builder(
          itemCount: model.contacts.length,
          itemBuilder: (context, index) => ContactTile(contactIndex: index),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.person_add),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const ContactCreate()),
          );
        },
      ),
    );
  }
}
