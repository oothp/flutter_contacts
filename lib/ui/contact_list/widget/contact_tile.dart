import 'dart:developer';

import 'package:contacts_app/data/contact.dart';
import 'package:contacts_app/ui/contact/contact_edit.dart';
import 'package:contacts_app/ui/model/contacts_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;

class ContactTile extends StatelessWidget {
  const ContactTile({Key? key, required this.contactIndex}) : super(key: key);

  final int contactIndex;

  @override
  Widget build(BuildContext context) {
    // If you don't need to rebuild the widget tree once the model's data changes
    // (when you only make changes to the model, like in this ContractCard),
    // you don't need to use ScopedModelDescendant with a builder, but only simply
    // call ScopedModel.of<T>(context) function.
    final model = ScopedModel.of<ContactsModel>(context);
    final displayedContact = model.contacts[contactIndex];

    return Slidable(
      key: const Key('somekeyidunno'),

      // start action pane (left hs).
      startActionPane: ActionPane(
        dragDismissible: false,
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) =>
                _callPhoneNumber(context, displayedContact.phoneNumber),
            backgroundColor: const Color.fromARGB(255, 245, 157, 98),
            foregroundColor: Colors.white,
            icon: Icons.call,
            label: 'Call',
          ),
          SlidableAction(
            onPressed: (context) => _sendEmail(context, displayedContact.email),
            backgroundColor: const Color.fromARGB(255, 98, 176, 245),
            foregroundColor: Colors.white,
            icon: Icons.email,
            label: 'Email',
          ),
        ],
      ),

      // The end action pane is the one at the right or the bottom side.
      endActionPane: ActionPane(
        dragDismissible: true,
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) => model.removeContact(displayedContact),
            backgroundColor: const Color(0xFFF56262),
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),
      child: _buildContent(context, displayedContact, model),
    );
  }

  Future _callPhoneNumber(BuildContext context, String number) async {
    final url = 'tel:$number';
    log(url);
    if (await url_launcher.canLaunch((url))) {
      await url_launcher.launch(url);
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Cannot make this call')));
    }
  }

  Future _sendEmail(BuildContext context, String email) async {
    final url = 'mailto:$email';
    log(url);
    if (await url_launcher.canLaunch((url))) {
      await url_launcher.launch(url);
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Unable to send email')));
    }
  }

  Container _buildContent(
      BuildContext context, Contact displayedContact, ContactsModel model) {
    return Container(
      color: Theme.of(context).canvasColor,
      child: ListTile(
          onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => ContactEdit(editedContact: displayedContact),
                ),
              ),
          title: Text(displayedContact.name),
          subtitle: Text(displayedContact.email),
          leading: _buildCircleAvatar(displayedContact),
          trailing: IconButton(
              onPressed: () => model.changeFavoriteStatus(displayedContact),
              icon: Icon(
                  displayedContact.isFavorite ? Icons.star : Icons.star_border,
                  color: displayedContact.isFavorite
                      ? Colors.amber
                      : Colors.black))),
    );
  }

  Hero _buildCircleAvatar(Contact contact) => Hero(
        tag: contact.hashCode,
        child: CircleAvatar(
          child: contact.imageFile != null
              ? ClipOval(
                  child: AspectRatio(
                      aspectRatio: 1,
                      child: Image.file(contact.imageFile!, fit: BoxFit.cover)))
              : Text(contact.name[0]),
        ),
      );
}
