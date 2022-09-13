import 'package:hive/hive.dart';

// #step 2 - Create the file that will controll the hive annotation.
//           That file will be created automatically;
part 'person.g.dart';

// #step 3 - Indicate to each class and hive ID with @HiveType
// #step 4 - Indicate to each field in app classes the field ID, that ID should be unique in the class, using @HiveField
// #step 5 - execute the command 'flutter packages pub run build_runner build' on your terminal
//           You should execute this command on every change on fields and classes that will be stored in a Hive Box.
//           Importante: before you execute the command you may need to delete the files with .g.dart.
// #step 6 - register the ContactAdpter (created by hive on person.g class) in your main file.
// #step 7 - register the PersonAdpter (created by hive on person.g class) in your main file.
//           those adapters are responsabile to convert the Dart class into json data to be storage in Hive boxes.
//           they also are used to convert the json data into class when you read stored data.

@HiveType(typeId: 0)
class Contact {
  @HiveField(0)
  late String email;
  @HiveField(1)
  late String phoneNumber;

  Contact({
    this.email = '',
    this.phoneNumber = '',
  });
}

@HiveType(typeId: 1)
class Person {
  @HiveField(0)
  late String id;
  @HiveField(1)
  late String name;
  @HiveField(2)
  late int age;
  @HiveField(3)
  late Contact? contactInfo;

  Person({
    this.id = '',
    this.name = '',
    this.age = 0,
    this.contactInfo,
  });
}
