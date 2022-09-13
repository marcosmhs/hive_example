// ignore: depend_on_referenced_packages
import 'package:nanoid/nanoid.dart';

class UidGenerator {
  static String get localStorageUid {
    return 'localstorage-${nanoid(10)}';
  }
}
