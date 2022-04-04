import 'dart:io';

import 'package:contacts_app/data/contact.dart';
import 'package:contacts_app/data/db/app_database.dart';
import 'package:contacts_app/ui/model/contacts_model.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scoped_model/scoped_model.dart';
import 'dart:developer';

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

  File? _contactImageFile;

  bool get isEditMode => widget.editedContact != null;
  bool get imageSelected => _contactImageFile != null;

  @override
  void initState() {
    super.initState();
    _contactImageFile = widget.editedContact?.imageFile;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            _buildContactPicture(),
            const SizedBox(height: 18.0),
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
    // AppDatabase.instance.database.
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      _formKey.currentState?.save();

      final newOrEditedContact = Contact(
        name: _name,
        email: _email,
        phoneNumber: _phoneNumber,
        isFavorite: widget.editedContact?.isFavorite ?? false,
        imageFile: _contactImageFile,
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

  Widget _buildContactPicture() {
    log('image file: $_contactImageFile');

    final halfScreenDiameter = MediaQuery.of(context).size.width / 4;
    return Hero(
      // tag zero or empty string or whatever, doesn't matter.
      // animation wont happen if there's no matching tag
      tag: widget.editedContact?.hashCode ?? 0,
      child: GestureDetector(
        onTap: _onContactPictureTapped,
        child: CircleAvatar(
          radius: halfScreenDiameter,
          child: imageSelected
              ? ClipOval(
                  child: AspectRatio(
                      aspectRatio: 1,
                      child: Image.file(_contactImageFile!, fit: BoxFit.cover)))
              : isEditMode
                  ? Text(widget.editedContact?.name[0] ?? '',
                      style: TextStyle(fontSize: halfScreenDiameter))
                  : Icon(Icons.person, size: halfScreenDiameter),
        ),
      ),
    );
  }

  void _onContactPictureTapped() async {
    final xfile = await ImagePicker().pickImage(source: ImageSource.gallery);
    final File? imageFile = xfile != null ? File(xfile.path) : null;
    setState(() {
      _contactImageFile = imageFile;
    });
    // log('image path ---------> ${imageFile?.path}');
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
