import 'package:event_reminder/event.dart';
import 'package:hive_flutter/hive_flutter.dart';

class EventData{
  List<Event> eventList = [];
  final Box eventBox = Hive.box("events");

  void updateList() {
    eventList = List<Event>.from(eventBox.values);
  }

  void putData(Event event) {
    eventList.add(event);
    eventBox.add(event);
    sortList();
  }

  void clearBox() {
    eventList.clear();
    eventBox.clear();
  }

  void delete(Event event)async{
    for(var e in eventList){
      if(event.title == e.title){
        eventList.remove(event);
        await eventBox.delete(event.key);
        break;
      }
    }
  }

  void sortList(){
    for(int i = 0; i < eventList.length; i++){
      for(int j = 0; j < eventList.length-1; j++){
        if(eventList[j].date.compareTo(eventList[j+1].date) > 0){
          var temp = eventList[j];
          eventList[j] = eventList[j+1];
          eventList[j+1] = temp;
        }
      }
    }
  }
}