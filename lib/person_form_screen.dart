import 'package:flutter/material.dart';
import 'package:hive_example/controllers/person_controlle.dart';
import 'package:hive_example/models/person.dart';

class PersonFormScreen extends StatefulWidget {
  final Person? personData;
  const PersonFormScreen({this.personData, Key? key}) : super(key: key);

  @override
  State<PersonFormScreen> createState() => _PersonFormScreen();
}

class _PersonFormScreen extends State<PersonFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _personNameController = TextEditingController();
  final TextEditingController _personAgeController = TextEditingController();
  final TextEditingController _personContactEmailController = TextEditingController();
  final TextEditingController _personContactPhoneNumberController = TextEditingController();
  late Person _localPerson;

  @override
  void initState() {
    super.initState();
    _localPerson = widget.personData ?? Person(contactInfo: Contact());
  }

  void _submit() async {
    if (_formKey.currentState?.validate() ?? true) {
      // salva os dados
      _formKey.currentState?.save();

      PersonController controller = PersonController();
      var result = await controller.save(
        person: _localPerson,
      );
      if (result.isEmpty) {
        // ignore: use_build_context_synchronously
        Navigator.of(context).pop(true);
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                // ignore: use_build_context_synchronously
                Icon(Icons.error, color: Theme.of(context).errorColor),
                const SizedBox(width: 5),
                Flexible(child: Text(result)),
              ],
            ),
            duration: const Duration(seconds: 3),
            // ignore: use_build_context_synchronously
            backgroundColor: Theme.of(context).errorColor,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    _personNameController.text = _localPerson.name;
    _personAgeController.text = _localPerson.age == 0 ? '' : _localPerson.age.toString();
    _personContactEmailController.text = _localPerson.contactInfo?.email ?? '';
    _personContactPhoneNumberController.text = _localPerson.contactInfo?.phoneNumber ?? '';

    return Scaffold(
      appBar: AppBar(title: Text(_localPerson.id.isNotEmpty ? 'Edit Person' : 'New Person')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // name
                TextFormField(
                  keyboardType: TextInputType.text,
                  onSaved: (value) => _localPerson.name = value ?? '',
                  controller: _personNameController,
                  decoration: InputDecoration(
                    hintText: 'Person name',
                    labelText: 'Name',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(1)),
                  ),
                ),
                const SizedBox(height: 15),
                // age
                TextFormField(
                  // use text editor only if keyboardType wasn´t set.
                  keyboardType: TextInputType.number,
                  onSaved: (value) => _localPerson.age = int.tryParse(value ?? '') ?? 0,
                  controller: _personAgeController,
                  decoration: InputDecoration(
                    hintText: 'Person Age',
                    labelText: 'Age',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(1)),
                  ),
                ),
                const SizedBox(height: 15),
                // email
                TextFormField(
                  // use text editor only if keyboardType wasn´t set.
                  keyboardType: TextInputType.emailAddress,
                  onSaved: (value) => _localPerson.contactInfo?.email = value ?? '',
                  controller: _personContactEmailController,
                  decoration: InputDecoration(
                    hintText: 'Contact: e-mail',
                    labelText: 'E-mail',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(1)),
                  ),
                ),
                const SizedBox(height: 15),
                // phone number
                TextFormField(
                  // use text editor only if keyboardType wasn´t set.
                  keyboardType: TextInputType.phone,
                  onSaved: (value) => _localPerson.contactInfo?.phoneNumber = value ?? '',
                  controller: _personContactPhoneNumberController,
                  decoration: InputDecoration(
                    hintText: 'Contact: phone number',
                    labelText: 'Phone number',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(1)),
                  ),
                ),
                // buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // cancel button
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(primary: Theme.of(context).disabledColor),
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const SizedBox(width: 80, child: Text("Cancel", textAlign: TextAlign.center)),
                      ),
                    ),
                    // save button
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(primary: Theme.of(context).colorScheme.primary),
                        onPressed: _submit,
                        child: const SizedBox(width: 80, child: Text("Save", textAlign: TextAlign.center)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
