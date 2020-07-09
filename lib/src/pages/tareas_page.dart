import 'package:flutter/material.dart';
import 'package:flutter_week_view/flutter_week_view.dart';
import 'package:preferencia_usuario_app/src/widgets/menu_widget.dart';


class TareasPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final da = DateTime.parse("2020-06-30 20:18:04Z");
    DateTime now = DateTime.now();
    DateTime date = DateTime(now.year, now.month, now.day);
    return Scaffold(
      drawer: MenuWidget(),
      appBar: AppBar(
        title: Text('Tareas: 071D'),
      ),
      body: WeekView(
        style: WeekViewStyle(
          dayBarBackgroundColor: Colors.white,
          // dayBarTextStyle: TextStyle(fontSize: 18),
          // hoursColumnBackgroundColor: Colors.teal[300]


        ),
        scrollToCurrentTime: true,
        minimumTime: HourMinute(hour: 6),
        maximumTime: HourMinute(hour: 20),
  dates: [date.subtract(Duration(days: 1)), 
  date, 
  date.add(Duration(days: 1)),
  da],
  events: [
    FlutterWeekViewEvent(
      title: 'An event 1',
      description: 'A description 1',
      start: date.subtract(Duration(hours: 8)),
      end: date.add(Duration(hours: 8, minutes: 30)),
      onTap: () => _showDetails(context,'Titulo de evento', 'Descripcion de evento')
    ),
    FlutterWeekViewEvent(
      title: 'An event 2',
      description: 'A description 2',
      start: date.add(Duration(hours: 19)),
      end: date.add(Duration(hours: 20)),
      backgroundColor: Colors.green
    ),
    FlutterWeekViewEvent(
      title: 'An event 3',
      description: 'A description 3',
      start: date.add(Duration(hours: 14, minutes: 30)),
      end: date.add(Duration(hours: 15, minutes: 30)),
    ),
    FlutterWeekViewEvent(
      title: 'An event 4',
      description: 'A description 4',
      start: date.add(Duration(hours: 12)),
      end: date.add(Duration(hours: 13)),
    ),
    FlutterWeekViewEvent(
      title: 'An event 5',
      description: 'A description 5',
      start: date.add(Duration(hours: 12)),
      end: date.add(Duration(hours: 13)),
      backgroundColor: Colors.grey
    ),
  ],
)

    //   body: DayView(
    //   initialTime: const HourMinute(hour: 7),
    //   date: now,
    //   events: [
    //     FlutterWeekViewEvent(
    //       title: 'An event 1',
    //       description: 'A description 1',
    //       start: date.subtract(const Duration(hours: 1)),
    //       end: date.add(const Duration(hours: 1, minutes: 30)),
    //     ),
    //     FlutterWeekViewEvent(
    //       title: 'An event 2',
    //       description: 'A description 2',
    //       start: date.add(const Duration(hours: 19)),
    //       end: date.add(const Duration(hours: 22)),
    //     ),
    //     FlutterWeekViewEvent(
    //       title: 'An event 3',
    //       description: 'A description 3',
    //       start: date.add(const Duration(hours: 23, minutes: 30)),
    //       end: date.add(const Duration(hours: 25, minutes: 30)),
    //     ),
    //     FlutterWeekViewEvent(
    //       title: 'An event 4',
    //       description: 'A description 4',
    //       start: date.add(const Duration(hours: 20)),
    //       end: date.add(const Duration(hours: 21)),
    //     ),
    //     FlutterWeekViewEvent(
    //       title: 'An event 5',
    //       description: 'A description 5',
    //       start: date.add(const Duration(hours: 20)),
    //       end: date.add(const Duration(hours: 21)),
    //     ),
    //   ],
    //   style: const DayViewStyle(currentTimeCircleColor: Colors.pink),
    // )
    );
  }

 void _showDetails(context, String titulo, String descripcion){
final myColor = Theme.of(context).accentColor;
 var alert = AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(32.0))),
            contentPadding: EdgeInsets.only(top: 10.0),
            content: Container(
              width: 300.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text(
                          titulo,
                          style: TextStyle(fontSize: 24.0),
                          textAlign: TextAlign.center,
                        ),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Divider(
                    color: Theme.of(context).primaryColor,
                    height: 4.0,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 30.0, right: 30.0),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: descripcion,
                        border: InputBorder.none,
                      ),
                      maxLines: 8,
                    ),
                  ),
                  InkWell(
                    onTap: () { Navigator.pop(context); },
                    child: Container(
                      padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                      decoration: BoxDecoration(
                        color: myColor,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(32.0),
                            bottomRight: Radius.circular(32.0)),
                      ),
                      child: Text(
                        "OK",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );

  showDialog(context: context, builder: (context) => alert);
 

}


}
