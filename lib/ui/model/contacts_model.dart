import 'package:contacts_app/data/contact.dart';
import 'package:faker/faker.dart';
import 'package:scoped_model/scoped_model.dart';

class ContactsModel extends Model {
  final List<Contact> _contacts = List.generate(
    4,
    (index) => Contact(
      name: faker.person.name(),
      email: faker.internet.email(),
      phoneNumber: faker.randomGenerator.integer(1000000).toString(),
    ),
  );

  // property get only
  List<Contact> get contacts => _contacts;

  void addContact(Contact contact) {
    _contacts.add(contact);
    notifyListeners();
  }

  void updateContact(Contact contact, int? contactIndex) {
    if (contactIndex != null) {
      _contacts[contactIndex] = contact;
      notifyListeners();
    }
  }

  void removeContact(int contactIndex) {
    _contacts.removeAt(contactIndex);
    notifyListeners();
  }

  void changeFavouriteStatus(int index) {
    _contacts[index].isFavorite = !_contacts[index].isFavorite;
    _sortContacts();
    notifyListeners();
  }

  void _sortContacts() {
    _contacts.sort((a, b) {
      int comparisonResult;

      comparisonResult = _compareBasedOnFavStatus(a, b);

      // if the favourite status of two contacts is identical,
      // secondary, alphabetical sorting kicks in.
      if (comparisonResult == 0) {
        comparisonResult = _compareAlphabetically(a, b);
      }
      return comparisonResult;
    });
  }

  int _compareBasedOnFavStatus(Contact a, Contact b) {
    if (a.isFavorite) {
      return -1; // contact-one Before contact-two
    } else if (b.isFavorite) {
      return 1;
    } else {
      return 0; // no change in position.
    }
  }

  int _compareAlphabetically(Contact a, Contact b) => a.name.compareTo(b.name);
}
