import 'dart:math';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:event_reminder/data.dart';
import 'package:event_reminder/event.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddEventScreen extends StatefulWidget {
  const AddEventScreen({super.key, required this.db});

  final EventData db;

  @override
  State<AddEventScreen> createState() {
    return _AddEventScreenState();
  }
}

class _AddEventScreenState extends State<AddEventScreen> {
  DateTime date = DateTime.now();
  TimeOfDay time = TimeOfDay.now();
  final formKey = GlobalKey<FormState>();
  final title = TextEditingController();
  final des = TextEditingController();
  final random = Random();
  final List<String> notifs = [
    'Hey, [Event Name] is coming up soon, make sure you finish it in time. "Success is walking from failure to failure with no loss of enthusiasm." - Winston S. Churchill',
    'Hey, [Event Name] is just around the corner, make sure youre prepared. "Great things never come from comfort zones." - Anonymous',
    'Hey, [Event Name] is approaching, give it your best shot. "Success is not the key to happiness. Happiness is the key to success. If you love what you are doing, you will be successful." - Albert Schweitzer',
    'Hey, [Event Name] is looming, stay focused. "The only way to do great work is to love what you do." - Steve Jobs',
    'Hey, [Event Name] is on the horizon, keep the momentum going. "The future depends on what you do today." - Mahatma Gandhi',
    'Hey, [Event Name] is just a few days away, be confident. "Your work is going to fill a large part of your life, and the only way to be truly satisfied is to do what you believe is great work." - Steve Jobs',
    'Hey, [Event Name] is almost here, give it your all. "The harder you work for something, the greater youll feel when you achieve it." - Anonymous',
    'Hey, [Event Name] is approaching, youve got this! "Dont watch the clock; do what it does. Keep going." - Sam Levenson',
    'Hey, [Event Name] is right around the corner, prepare to shine. "Success is not the key to happiness. Happiness is the key to success. If you love what you are doing, you will be successful." - Albert Schweitzer',
    'Hey, [Event Name] is nearing, keep pushing forward. "The future depends on what you do today." - Mahatma Gandhi'
  ];

  @override
  Widget build(BuildContext context) {
    @override
    void dispose() {
      title.dispose();
      des.dispose();
      super.dispose();
    }

    void selectDate() async {
      final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: date,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
      );
      if (pickedDate != null) {
        setState(() {
          date = pickedDate;
        });
      }
    }

    void selectTime() async {
      final TimeOfDay? pickedTime =
          await showTimePicker(context: context, initialTime: time);
      if (pickedTime != null) {
        setState(() {
          time = pickedTime;
        });
      }
      await AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: (date.day * date.month + date.year) % title.text.length,
            channelKey: "eventNotif",
            title: notifs[random.nextInt(notifs.length)].replaceAll("[Event Name]", title.text)),
        schedule: NotificationCalendar(
          day: date.day,
          month: date.month,
          year: date.year,
          hour: time.hour,
          minute: time.minute,
        ),
      );

      date.subtract(const Duration(minutes: 30));
      AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: (date.day * date.month + date.year) % title.text.length,
            channelKey: "eventNotif",
            title: notifs[random.nextInt(notifs.length)].replaceAll("[Event Name]", title.text)),
        schedule: NotificationCalendar(
          day: date.day,
          month: date.month,
          year: date.year,
          hour: time.hour,
          minute: time.minute,
        ),
      );
      date.add(const Duration(minutes: 30));

      date.subtract(const Duration(days: 7));
      AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: (date.day * date.month + date.year) % title.text.length,
            channelKey: "eventNotif",
            title: notifs[random.nextInt(notifs.length)].replaceAll("[Event Name]", title.text)),
        schedule: NotificationCalendar(
          day: date.day,
          month: date.month,
          year: date.year,
          hour: time.hour,
          minute: time.minute,
        ),
      );
      date.add(const Duration(days: 7));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Event"),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(hintText: "Title"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
                controller: title,
              ),
              TextFormField(
                decoration: const InputDecoration(hintText: "Description"),
                keyboardType: TextInputType.multiline,
                minLines: 4,
                maxLines: 5,
                controller: des,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(DateFormat('yyyy-MM-dd').format(date).toString()),
                  TextButton(
                      onPressed: selectDate, child: const Text("Change Date")),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("${time.hour} : ${time.minute}"),
                  TextButton(
                      onPressed: selectTime,
                      child: const Text("Change Notification Time")),
                ],
              ),
              FilledButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Processing Data')),
                    );
                  }
                  widget.db.putData(Event(
                      title: title.text, date: date, description: des.text));
                  widget.db.updateList();
                  print(widget.db.eventList.length);
                  Navigator.pop(context);
                },
                child: const Text('Add'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
