import 'package:contacts_app/data/contact.dart';
import 'package:contacts_app/ui/contact/contact_edit.dart';
import 'package:contacts_app/ui/model/contacts_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:scoped_model/scoped_model.dart';

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
      // startActionPane: ActionPane(
      //   // A motion is a widget used to control how the pane animates.
      //   motion: const ScrollMotion(),
      //
      //   // A pane can dismiss the Slidable.
      //   dismissible: DismissiblePane(
      //     onDismissed: () => _showToast(context, "on dismissed"),
      //     closeOnCancel: true,
      //   ),
      //
      //   // All actions are defined in the children parameter.
      //   children: [
      //     // A SlidableAction can have an icon and/or a label.
      //     SlidableAction(
      //       onPressed: (context) => _showToast(context, 'action1'),
      //       backgroundColor: const Color(0xFFFE4A49),
      //       foregroundColor: Colors.white,
      //       icon: Icons.delete,
      //       label: 'Delete',
      //     ),
      //     SlidableAction(
      //       onPressed: (context) => _showToast(context, 'action2'),
      //       backgroundColor: const Color(0xFF21B7CA),
      //       foregroundColor: Colors.white,
      //       icon: Icons.share,
      //       label: 'Share',
      //     ),
      //   ],
      // ),

      // The end action pane is the one at the right or the bottom side.
      endActionPane: ActionPane(
        dragDismissible: true,
        motion: const ScrollMotion(),
        children: [
          // SlidableAction(
          //   // An action can be bigger than the others.
          //   onPressed: (context) => _showToast(context, 'action4'),
          //   backgroundColor: const Color(0xFF0392CF),
          //   foregroundColor: Colors.white,
          //   icon: Icons.save,
          //   label: 'Save',
          // ),
          SlidableAction(
            onPressed: (context) => model.removeContact(contactIndex),
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

  Container _buildContent(
      BuildContext context, Contact displayedContact, ContactsModel model) {
    return Container(
      color: Theme.of(context).canvasColor,
      child: ListTile(
          onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => ContactEdit(
                      editedContact: displayedContact,
                      editedContactIndex: contactIndex),
                ),
              ),
          title: Text(displayedContact.name),
          subtitle: Text(displayedContact.email),
          trailing: IconButton(
              onPressed: () => model.changeFavouriteStatus(contactIndex),
              icon: Icon(
                  displayedContact.isFavorite ? Icons.star : Icons.star_border,
                  color: displayedContact.isFavorite
                      ? Colors.amber
                      : Colors.black))),
    );
  }

  void _showToast(BuildContext context, String msgText) {
    final txt = msgText;
    var scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(txt),
        action: SnackBarAction(
            label: 'UNDO', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }
}
