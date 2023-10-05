import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:event_reminder/addEvent.dart';
import 'package:event_reminder/data.dart';
import 'package:event_reminder/event.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<StatefulWidget> {
  final EventData db = EventData();
  bool firstBuild = true;

  void deleteEvent(Event event) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Are you sure you want to delete this event ?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text(
              "No",
            ),
          ),
          FilledButton(
            onPressed: () {
              db.delete(event);
              db.updateList();
              Navigator.popUntil(context, (route) => false);
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (ctx) => const HomeScreen()))
                  .then((value) => setState(() {}));
            },
            child: const Text(
              "Yes",
            ),
          ),
        ],
      ),
    );
    AwesomeNotifications().dismiss(
        (event.date.day * event.date.month + event.date.year) %
            event.title.length);
  }

  void checkEvents() {
    for (var event in db.eventList) {
      if (DateTime.now().difference(event.date).inDays <= 2 && DateTime.now().difference(event.date).inDays >= 1) {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text("Have you finished ${event.title} ?"),
            actions: [
              FilledButton(
                onPressed: () {
                  deleteEvent(event);
                  setState(() {});
                },
                child: const Text("Yes"),
              ),
              TextButton(
                onPressed: () {Navigator.of(context).pop();},
                child: const Text("No"),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  void initState() {
    db.updateList();
    db.sortList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    db.sortList();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (firstBuild) {
        firstBuild = false;
        checkEvents();
      }
    });
    return Scaffold(
      appBar: AppBar(
        title: Stack(
          children: [
            Image.asset(
              "lib/plane.png",
              alignment: Alignment.centerLeft,
            ),
            const Text("Upcoming Events"),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(
                        builder: ((ctx) => AddEventScreen(
                              db: db,
                            ))))
                    .then((value) => setState(() {}));
              },
              icon: const Icon(Icons.add))
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 30, top: 30),
            child: Text(
              DateFormat('d MMMM, y').format(DateTime.now()),
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 30,
            ),
            child: Text(
              "Upcoming Events",
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: ListView.separated(
                separatorBuilder: (context, index) => const SizedBox(
                  height: 10,
                ),
                itemCount: db.eventList.length,
                itemBuilder: ((context, index) => Card(
                      child: ListTile(
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(db.eventList[index].title),
                            Text(DateFormat('d MMMM, y')
                                .format(db.eventList[index].date)),
                          ],
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        tileColor: (db.eventList[index].date.isAfter(
                                DateTime.now().add(const Duration(days: 1))))
                            ? Theme.of(context).colorScheme.primaryContainer
                            : Colors.redAccent,
                        trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              deleteEvent(db.eventList[index]);
                            }),
                      ),
                    )),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
