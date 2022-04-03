import 'package:contacts_app/data/contact.dart';
import 'package:contacts_app/ui/contact/widget/contact_form.dart';
import 'package:flutter/material.dart';

class ContactEdit extends StatelessWidget {
  const ContactEdit(
      {Key? key, required this.editedContact, required this.editedContactIndex})
      : super(key: key);

  final Contact editedContact;
  final int editedContactIndex;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Edit'),
        ),
        body: ContactForm(
            editedContact: editedContact,
            editedContactIndex: editedContactIndex),
      );
}
