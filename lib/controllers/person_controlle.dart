import 'package:hive_example/models/person.dart';
import 'package:hive_example/util/uid_generator.dart';
import 'package:hive_flutter/hive_flutter.dart';
//// ignore: depend_on_referenced_packages
//import 'package:path_provider/path_provider.dart';

class PersonController {
  final _boxName = 'person_box';
  late Box<dynamic> _personBox;

  final List<Person> _personList = [];

  List<Person> get personsList => [..._personList];

  Future<void> _prepareHiveBox() async {
    if (!Hive.isBoxOpen(_boxName)) {
      _personBox = await Hive.openBox(_boxName);
    } else {
      _personBox = Hive.box(_boxName);
    }
  }

  Future<void> removeBox() async {
    await _prepareHiveBox();
    await _personBox.deleteFromDisk();
  }

  Future<String> save({required Person person}) async {
    if (person.id.isEmpty) {
      return _add(person: person);
    } else {
      return _update(person: person);
    }
  }

  Future<String> _add({required Person person}) async {
    person.id = UidGenerator.localStorageUid;

    try {
      await _prepareHiveBox();
      // the put command needs to parameters:
      // key: the value that will be used to "index" the data saved
      // data: the class that should be save.
      await _personBox.put(person.id, person);
      //if (_personBox.isOpen) await _personBox.close();
    } catch (e) {
      return 'Error: $e';
    }

    return '';
  }

  Future<String> _update({required Person person}) async {
    await _prepareHiveBox();
    try {
      // because the person.id is already saved the put command will 
      // replace the existing data
      await _personBox.put(person.id, person);
      //if (_personBox.isOpen) await _personBox.close();
    } catch (e) {
      return 'Error: $e';
    }
    return '';
  }

  Future<String> remove({required String personId}) async {
    await _prepareHiveBox();
    // get command return the data based on the ID
    Person? person = _personBox.get(personId);
    if (person == null) {
      return 'Error: Person don´t found';
    }
    try {
      _personBox.delete(personId);
      // close the hive box after his use
      if (_personBox.isOpen) await _personBox.close();
    } catch (e) {
      return 'Error: $e';
    }

    return '';
  }

  Future<List<Person>> loadEntryTypeList() async {
    List<Person> result = [];
    await _prepareHiveBox();
    // values function return all data stored on the Box. 
    // By using <Person> the method will return a typed list.
    for (var item in _personBox.values) {
      result.add(item);
    }
    //if (_personBox.isOpen) await _personBox.close();
    return result;
  }
}
