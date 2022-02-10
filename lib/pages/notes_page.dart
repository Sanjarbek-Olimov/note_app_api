import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../services/hive_service.dart';
import '../services/notes_model.dart';
import 'package:easy_localization/easy_localization.dart';

class NotesPage extends StatefulWidget {
  static const String id = "notes_page";

  const NotesPage({Key? key}) : super(key: key);

  @override
  _NotesPageState createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  bool isLight = true;
  String _chosenValue = "EN";
  List<Note> listofNotes = [];
  List<Note> listofNotestoDelete = [];
  TextEditingController noteController = TextEditingController();

  // #create_notes
  void _createNotes() {
    String text = noteController.text.toString().trim();
    listofNotes.add(Note(date: DateTime.now().toString(), notes: text));
    listofNotes.sort((a, b) => b.date!.compareTo(a.date!));
    _storeNotes();
  }

  // #store_notes
  void _storeNotes() {
    String notes = Note.encode(listofNotes);
    HiveDB.storeNotes(notes);
  }

  // #laod_everything_saved
  void loadEverything() {
    listofNotes = Note.decode(HiveDB.loadNotes());
    listofNotes.sort((a, b) => b.date!.compareTo(a.date!));
    isLight = HiveDB.loadMode();
    _chosenValue = HiveDB.loadLang();
  }

  // #dark_light_mode_saver
  void _changeMode() {
    setState(() {
      isLight = !isLight;
    });
    HiveDB.storeMode(isLight);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadEverything();
    setState(() {});
  }

  // #first_alert_dialog
  void _androidDialog() {
    showGeneralDialog(
        barrierDismissible: true,
        barrierLabel: '',
        context: context,
        transitionBuilder: (context, a1, a2, widget) {
          return Transform.scale(
            scale: a1.value,
            child: Opacity(
              opacity: a1.value,
              child: AlertDialog(
                backgroundColor:
                    isLight ? Colors.grey.shade100 : Colors.grey.shade900,
                contentPadding:
                    const EdgeInsets.fromLTRB(24.0, 10.0, 24.0, 10.0),
                title: Text("new note".tr(),
                    style: TextStyle(
                      color: isLight ? Colors.black : Colors.grey.shade300,
                    )),
                content: TextField(
                  style: TextStyle(
                      color: isLight ? Colors.black : Colors.grey.shade300),
                  maxLines: 10,
                  controller: noteController..clear(),
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.zero,
                      hintText: "enter note".tr(),
                      hintStyle: const TextStyle(color: Colors.grey),
                      border: const OutlineInputBorder(
                          borderSide: BorderSide.none)),
                ),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "cancel".tr(),
                        style:
                            const TextStyle(color: Colors.blue, fontSize: 16),
                      )),
                  TextButton(
                      onPressed: () {
                        _createNotes();
                        Navigator.pop(context);
                        noteController.clear();
                        setState(() {});
                      },
                      child: Text(
                        "save".tr(),
                        style:
                            const TextStyle(color: Colors.blue, fontSize: 16),
                      )),
                ],
              ),
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (BuildContext context, Animation<double> animation,
            Animation<double> secondaryAnimation) {
          return const SizedBox();
        });
  }

  // #delete_alert_dialog
  void _androidDialogToDelete(void Function() function) {
    showGeneralDialog(
        barrierDismissible: true,
        barrierLabel: '',
        context: context,
        transitionBuilder: (context, a1, a2, widget) {
          return Transform.scale(
            scale: a1.value,
            child: Opacity(
              opacity: a1.value,
              child: AlertDialog(
                backgroundColor:
                    isLight ? Colors.grey.shade100 : Colors.grey.shade900,
                contentPadding:
                    const EdgeInsets.fromLTRB(24.0, 10.0, 24.0, 10.0),
                title: Text("confirm delete".tr(args: [selected.toString()]),
                    style: TextStyle(
                      color: isLight ? Colors.black : Colors.grey.shade300,
                    )),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "cancelDelete".tr(),
                        style:
                            const TextStyle(color: Colors.blue, fontSize: 16),
                      )),
                  TextButton(
                      onPressed: function,
                      child: Text(
                        "delete".tr(),
                        style:
                            const TextStyle(color: Colors.blue, fontSize: 16),
                      )),
                ],
              ),
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (BuildContext context, Animation<double> animation,
            Animation<double> secondaryAnimation) {
          return const SizedBox();
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor:
                isLight ? Colors.grey.shade100 : Colors.grey.shade900,
            appBar: AppBar(
              elevation: 0,
              backgroundColor: isLight ? Colors.blue : Colors.blueGrey.shade900,
              title: Text(
                "appbar".tr(),
                style: const TextStyle(color: Colors.white),
              ),
              actions: [
                // #language_picker
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  alignment: Alignment.center,
                  child: DropdownButton<String>(
                    alignment: Alignment.centerRight,
                    underline: Container(),
                    isDense: true,
                    value: _chosenValue,
                    items: <String>[
                      'EN',
                      'РУ',
                      'O\'Z',
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Center(child: Text(value)),
                      );
                    }).toList(),
                    onChanged: (String? value) async {
                      setState(() {
                        _chosenValue = value!;
                        if (_chosenValue == "EN") {
                          context.setLocale(const Locale('en', 'US'));
                        } else if (_chosenValue == "РУ") {
                          context.setLocale(const Locale('ru', 'RU'));
                        } else {
                          context.setLocale(const Locale('uz', 'UZ'));
                        }
                      });
                      HiveDB.storeLang(_chosenValue);
                    },
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),

                // #theme_mode_changer
                IconButton(
                    onPressed: () {
                      _changeMode();
                      setState(() {});
                    },
                    icon: Icon(
                      isLight ? Icons.dark_mode : Icons.light_mode,
                      color: Colors.white,
                    )),
              ],
            ),
            body: listofNotes.isEmpty
                ? Center(
                    child: Text(
                      "center".tr(),
                      style: TextStyle(
                          color: isLight ? Colors.black : Colors.grey.shade300,
                          fontSize: 20),
                    ),
                  )
                : ListView.builder(
                    itemCount: listofNotes.length,
                    itemBuilder: (context, index) {
                      return _notes(index, context);
                    }),
            floatingActionButton: FloatingActionButton(
              backgroundColor: isLight ? Colors.blue : Colors.blueGrey.shade900,
              elevation: 0,
              onPressed: _androidDialog,
              child: const Icon(
                Icons.add,
                size: 35,
                color: Colors.white,
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.endDocked,

            // #select_counter_remover
            bottomNavigationBar: BottomAppBar(
              color: isLight ? Colors.blue : Colors.blueGrey.shade900,
              shape: const CircularNotchedRectangle(),
              child: Container(
                height: 55,
                padding: const EdgeInsets.only(left: 15, right: 80),
                alignment: Alignment.centerLeft,
                child: isLongPressed
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "selected".tr(args: [selected.toString()]),
                            style: const TextStyle(
                                color: Colors.white, fontSize: 25),
                          ),
                          IconButton(
                              onPressed: () {
                                if (selected != 0) {
                                  _androidDialogToDelete(() {
                                    for (int i = 0;
                                        i < listofNotestoDelete.length;
                                        i++) {
                                      listofNotes.removeWhere((element) =>
                                          element == listofNotestoDelete[i]);
                                    }
                                    _storeNotes();
                                    enabled = true;
                                    isLongPressed = false;
                                    selected = 0;
                                    setState(() {});
                                    Navigator.pop(context);
                                  });
                                }
                              },
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.white,
                              ))
                        ],
                      )
                    : Container(),
              ),
            ));
  }

  int selected = 0;
  bool enabled = true;
  bool isLongPressed = false;

  Widget _notes(int index, BuildContext context) {
    return Slidable(
      enabled: enabled,

      // #delete_note
      startActionPane: ActionPane(
        extentRatio: 0.3,
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            backgroundColor: Colors.red,
            label: "delete".tr(),
            onPressed: (BuildContext context) {
              setState(() {
                selected = 1;
              });
              _androidDialogToDelete(() {
                listofNotes.removeAt(index);
                _storeNotes();
                loadEverything();
                setState(() {});
                Navigator.pop(this.context);
              });
            },
            icon: Icons.delete,
          ),
        ],
      ),

      // #note_view_and_selector
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15),
        margin: const EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey.shade300))),
        child: WillPopScope(
          onWillPop: () async {
            if (isLongPressed) {
              setState(() {
                enabled = true;
                isLongPressed = false;
                selected = 0;
              });
              loadEverything();
              return false;
            } else {
              if (Platform.isAndroid) {
                SystemNavigator.pop();
              } else {
                exit(0);
              }
              return false;
            }
          },
          child: GestureDetector(
            onTap: () {
              setState(() {
                if (isLongPressed) {
                  listofNotes[index].isSelected =
                      !listofNotes[index].isSelected;
                  listofNotes[index].isSelected ? selected++ : selected--;
                  listofNotestoDelete = listofNotes
                      .where((element) => element.isSelected)
                      .toList();
                } else {
                  // #edit_note
                  showGeneralDialog(
                      barrierDismissible: true,
                      barrierLabel: '',
                      context: context,
                      transitionBuilder: (context, a1, a2, widget) {
                        return Transform.scale(
                          scale: a1.value,
                          child: Opacity(
                            opacity: a1.value,
                            child: AlertDialog(
                              backgroundColor: isLight
                                  ? Colors.grey.shade100
                                  : Colors.grey.shade900,
                              contentPadding: const EdgeInsets.fromLTRB(
                                  24.0, 10.0, 24.0, 10.0),
                              title: Text("edit note".tr(),
                                  style: TextStyle(
                                    color: isLight
                                        ? Colors.black
                                        : Colors.grey.shade300,
                                  )),
                              content: TextField(
                                maxLines: 10,
                                style: TextStyle(
                                    color: isLight
                                        ? Colors.black
                                        : Colors.grey.shade300),
                                controller: noteController
                                  ..text = listofNotes[index].notes!,
                                decoration: const InputDecoration(
                                    contentPadding: EdgeInsets.zero,
                                    hintText: "Enter your note!",
                                    hintStyle: TextStyle(color: Colors.grey),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide.none)),
                              ),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      "cancel".tr(),
                                      style: const TextStyle(
                                          color: Colors.blue, fontSize: 16),
                                    )),
                                TextButton(
                                    onPressed: () {
                                      listofNotes[index].notes =
                                          noteController.text;
                                      listofNotes[index].date =
                                          DateTime.now().toString();
                                      _storeNotes();
                                      loadEverything();
                                      Navigator.pop(context);
                                      noteController.clear();
                                      setState(() {});
                                    },
                                    child: Text(
                                      "save".tr(),
                                      style: const TextStyle(
                                          color: Colors.blue, fontSize: 16),
                                    )),
                              ],
                            ),
                          ),
                        );
                      },
                      transitionDuration: const Duration(milliseconds: 200),
                      pageBuilder: (BuildContext context,
                          Animation<double> animation,
                          Animation<double> secondaryAnimation) {
                        return const SizedBox();
                      });
                }
              });
            },
            onLongPress: () {
              HapticFeedback.vibrate();
              setState(() {
                enabled = false;
                isLongPressed = true;
                listofNotes[index].isSelected = true;
                selected = 1;
                listofNotestoDelete =
                    listofNotes.where((element) => element.isSelected).toList();
              });
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.circle,
                      size: 12,
                      color: Colors.transparent,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      listofNotes[index].date!.substring(0, 16),
                      style: TextStyle(
                          color: isLight ? Colors.black : Colors.grey.shade300),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 25,
                      child: Icon(
                        Icons.circle,
                        size: 12,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                        child: Text(
                      listofNotes[index].notes!,
                      style: TextStyle(
                          fontSize: 20,
                          color: isLight ? Colors.black : Colors.grey.shade300),
                    )),
                    isLongPressed
                        ? Icon(
                            listofNotes[index].isSelected
                                ? Icons.check_circle
                                : Icons.circle_outlined,
                            color: Colors.grey.shade400,
                            size: 20,
                          )
                        : Container()
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
