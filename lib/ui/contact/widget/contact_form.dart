import 'package:contacts_app/data/contact.dart';
import 'package:contacts_app/ui/model/contacts_model.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class ContactForm extends StatefulWidget {
  ContactForm({Key? key, this.editedContact, this.editedContactIndex})
      : super(key: key);

  Contact? editedContact;
  int? editedContactIndex;

  @override
  _ContactFormState createState() => _ContactFormState();
}

class _ContactFormState extends State<ContactForm> {
  final _formKey = GlobalKey<FormState>();

  late String _name;
  late String _email;
  late String _phoneNumber;

  bool get isEditMode => widget.editedContact != null;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            TextFormField(
              onSaved: (newValue) => _name = newValue ??= '',
              validator: _validateName,
              initialValue: widget.editedContact?.name,
              decoration: InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
            ),
            // return log('form value: $newValue');
            const SizedBox(height: 12.0),
            TextFormField(
              onSaved: (newValue) => _email = newValue ??= '-',
              validator: _validateEmail,
              initialValue: widget.editedContact?.email,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
            ),
            const SizedBox(height: 12.0),
            TextFormField(
              onSaved: (newValue) => _phoneNumber = newValue ??= '-',
              validator: _validatePhoneNumber,
              initialValue: widget.editedContact?.phoneNumber,
              decoration: InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
            ),
            const SizedBox(height: 12.0),

            ElevatedButton(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const <Widget>[
                    Text('SAVE CONTACT'),
                    Icon(Icons.person, size: 18.0)
                  ]),
              onPressed: () {
                // accessing form thru form key
                _onSaveContactButtonPressed();
              },
            )
          ],
        ),
      ),
    );
  }

  void _onSaveContactButtonPressed() {
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      _formKey.currentState?.save();

      final newOrEditedContact = Contact(
        name: _name,
        email: _email,
        phoneNumber: _phoneNumber,
        isFavorite: widget.editedContact?.isFavorite ?? false,
      );
      if (isEditMode) {
        ScopedModel.of<ContactsModel>(context)
            .updateContact(newOrEditedContact, widget.editedContactIndex);
      } else {
        ScopedModel.of<ContactsModel>(context).addContact(newOrEditedContact);
      }
      //pop stack
      Navigator.of(context).pop();
    }
  }

  String? _validateName(String? value) {
    return value != null && value.isEmpty ? 'Enter a name' : null;
  }

  String? _validateEmail(String? value) {
    final emailRegex = RegExp(
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");

    if (value == null) {
      return null;
    } // when is it null ffs

    return value.isEmpty
        ? 'Enter an email'
        : !emailRegex.hasMatch(value)
            ? 'Enter a valid email address'
            : null; // no error - all good.
  }

  String? _validatePhoneNumber(String? value) {
    final phoneRegex = RegExp(r'[!@#<>?":_`~;[\]\\|=+)(*&^%0-9-]');

    if (value == null) {
      return null;
    } // meh

    return value.isEmpty
        ? 'Enter a phone number'
        : !phoneRegex.hasMatch(value)
            ? "Enter a valid phone number"
            : null;
  }
}
