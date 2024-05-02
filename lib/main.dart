import 'package:flutter/material.dart';
import 'src/app.dart';
import 'src/settings/settings_controller.dart';
import 'src/settings/settings_service.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      home: HomePageSate(),
    );
  }
}

class Note {

  final String title;
  final String body;
  final DateTime date;

  Note(this.title, this.body, this.date);

}

class HomePageSate extends StatefulWidget {
  const HomePageSate({super.key});

  @override
  State<HomePageSate> createState() => _MainPage();
}

class _MainPage extends State<HomePageSate> {

  final textController = TextEditingController();

    List<Note> myNotes = [
    Note('Note 1', 'Body of Note 1', DateTime.now()),
    Note('Note 2', 'Body of Note 2', DateTime.now()),
    Note('Note 3', 'Body of Note 3', DateTime.now()),
    Note('Note 4', 'Body of Note', DateTime.now()),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal[400],
        title : Text("My Note App")
      ),
      body: Center(
        child: ListView.builder(
          itemCount: myNotes.length,
          itemBuilder: (BuildContext context, int index){
            return ListTile(
              title:Text(myNotes[index].title.toString()),
              subtitle : Text(myNotes[index].body.length > 25? myNotes[index].body.substring(0, 25) + "..." : myNotes[index].body),
              onTap: (){
                  Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NoteDetailPage(note: myNotes[index]),
                        ),
                      );
              },
              onLongPress: (){
                showDialog(
                  context: context, 
                  builder: (BuildContext context){
                    return AlertDialog(
                        title : Text("Supprimer"),
                        content: Text("Voulez vous vraiment supprimer"),
                        actions : <Widget>[
                           ElevatedButton(
                            onPressed: (){
                              setState(() {
                                myNotes.removeAt(index);
                              });
                            },
                            child : const Text("Supprimer")
                          )
                        ]
                    );
                  }
                );   
              },
            );
          },
        )
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        backgroundColor: Colors.teal[400],
        onPressed: () {
          showDialog(
            context: context, 
            builder: (BuildContext context){
              return AlertDialog(
                title : const Text("Ajouter une note"),
                content: TextField(
                  decoration: const InputDecoration(hintText: "Titre de la note"),
                  controller: textController,
                ),
                actions : <Widget>[
                   ElevatedButton(
                    onPressed: (){
                    
                    }, 
                    child: const Text("Cancel")
                  ),
                  ElevatedButton(
                    onPressed: (){
                      if(textController.text.isNotEmpty){
                        setState(() {
                          myNotes.add(Note("Houda DEBZA" , textController.text , DateTime.now()));
                          textController.clear();
                        });
                      }
                    }, 
                    child: const Text("Confirm")
                  )
                ]
              );
            }
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

class NoteDetailPage extends StatefulWidget {
  final Note note;

  bool isPlaying = false;


  NoteDetailPage({required this.note});

  @override
  _NoteDetailPageState createState() => _NoteDetailPageState();
}

class _NoteDetailPageState extends State<NoteDetailPage> {

  bool isPlaying = false;
  final FlutterTts flutterTts = FlutterTts();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.note.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.note.body,
              style: TextStyle(fontSize: 18.0),
            ),
            Text(
              'Date: ${widget.note.date.toString()}',
              style: TextStyle(fontSize: 16.0),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    if (isPlaying) {
                      flutterTts.stop();
                      setState(() {
                        isPlaying = false;
                      });
                    }
                  },
                  child: Text("Stop"),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (isPlaying) {
                      flutterTts.pause();
                      setState(() {
                        isPlaying = false;
                      });
                    } else {
                      flutterTts.speak(widget.note.body);
                      setState(() {
                        isPlaying = true;
                      });
                    }
                  },
                  child: Text(isPlaying ? 'Pause' : 'Play'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

