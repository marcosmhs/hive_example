import 'package:flutter/material.dart';
import 'package:hive_example/controllers/person_controlle.dart';
import 'package:hive_example/models/person.dart';
import 'package:hive_example/person_form_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  // #step 1 - initiate flutter on your app
  await Hive.initFlutter();

  // #step 6 - register the ContactAdpter (created by hive on person.g class) in your main file.
  Hive.registerAdapter(ContactAdapter());
  // #step 7 - register the PersonAdpter (created by hive on person.g class) in your main file.
  Hive.registerAdapter(PersonAdapter());

  // The class PersonAdapter will be explain on the next steps

  runApp(const MaterialApp(home: HiveExample()));
}

class HiveExample extends StatefulWidget {
  const HiveExample({Key? key}) : super(key: key);

  @override
  State<HiveExample> createState() => _HiveExampleState();
}

class _HiveExampleState extends State<HiveExample> {
  late PersonController controller = PersonController();
  List<Person> _personList = [];

  @override
  void initState() {
    super.initState();
    refreshPersonList();
  }

  void openPersonForm({Person? person}) async {
    bool result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PersonFormScreen(personData: person)),
    );
    if (result) refreshPersonList();
  }

  void refreshPersonList() async {
    //await controller.loadEntryTypeList();
    controller.loadEntryTypeList().then((value) {
      setState(() => _personList = value);
    });
  }

  Widget personCard({required Person person}) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.person, size: 35),
        title: Text('${person.name} (${person.age.toString()}y)'),
        subtitle: SizedBox(
          child: Column(
            children: [
              Row(children: [
                const Icon(Icons.email, size: 15),
                const SizedBox(width: 10),
                Text(person.contactInfo == null ? '' : person.contactInfo!.email),
              ]),
              Row(children: [
                const Icon(Icons.phone, size: 15),
                const SizedBox(width: 10),
                Text(person.contactInfo == null ? '' : person.contactInfo!.phoneNumber),
              ]),
            ],
          ),
        ),
        trailing: SizedBox(
          height: MediaQuery.of(context).size.height * 0.9,
          width: MediaQuery.of(context).size.width * 0.24,
          child: Row(
            children: [
              IconButton(
                onPressed: () => openPersonForm(person: person),
                icon: const Icon(Icons.edit),
              ),
              IconButton(
                onPressed: () async {
                  var result = await controller.remove(personId: person.id);
                  if (result.isNotEmpty) {
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
                  refreshPersonList();
                },
                icon: Icon(Icons.delete, color: Theme.of(context).errorColor),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hive Example',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Hive Example'),
          actions: [
            ElevatedButton.icon(
              onPressed: () => refreshPersonList(),
              label: const Text('Refresh'),
              icon: const Icon(Icons.refresh),
            ),
          ],
        ),
        body: SizedBox(
          height: MediaQuery.of(context).size.height * 0.8,
          child: SingleChildScrollView(
            physics: const ScrollPhysics(),
            child: ListView.builder(
              itemCount: _personList.length,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (ctx, index) {
                return personCard(person: _personList[index]);
              },
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => openPersonForm(),
          icon: const Icon(Icons.create),
          label: const Text('New'),
        ),
      ),
    );
  }
}
