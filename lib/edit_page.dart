import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditPage extends StatefulWidget {
  final String title;
  final String subtitile;
  final bool titleFocus;
  final bool bodyFocus;
  const EditPage({
    super.key,
    required this.title,
    required this.subtitile,
    required this.titleFocus,
    required this.bodyFocus,
  });

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController bodyController = TextEditingController();

  void save(bool update) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList('data') ?? [];
    final String value;
    if (update == true) {
      value = '${titleController.text}/sep/${bodyController.text}';
    } else {
      value = '${widget.title}/sep/${widget.subtitile}';
    }
    if (value == "/sep/") {
      return;
    }
    data.add(value);
    prefs.setStringList('data', data);
  }

  @override
  void initState() {
    titleController.text = widget.title;
    bodyController.text = widget.subtitile;
    super.initState();
  }

  @override
  void dispose() {
    titleController.dispose();
    bodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final value = await showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8))),
                  title: const Text("Save and Exit"),
                  content: const Text("Do you want to save the file?"),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: const Text(
                          "Yes",
                          style: TextStyle(color: Colors.black),
                        )),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text(
                        "No",
                        style: TextStyle(color: Colors.black),
                      ),
                    )
                  ],
                ));
        if (value != null) {
          save(value);
          return Future.value(true);
        } else {
          return Future.value(false);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new),
            onPressed: () => showDialog(
                context: context,
                builder: (context) => AlertDialog(
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                      title: const Text("Save and Exit"),
                      content: const Text("Do you want to save the file?"),
                      actions: [
                        TextButton(
                            onPressed: () {
                              save(true);
                              Navigator.of(context).pop();
                            },
                            child: const Text(
                              "Yes",
                              style: TextStyle(color: Colors.black),
                            )),
                        TextButton(
                          onPressed: () {
                            save(false);
                            Navigator.of(context).pop();
                          },
                          child: const Text(
                            "No",
                            style: TextStyle(color: Colors.black),
                          ),
                        )
                      ],
                    )).then((value) => Navigator.of(context).pop()),
            color: Colors.black,
          ),
          shadowColor: Colors.white,
          toolbarHeight: 80,
          title: TextField(
            autofocus: widget.titleFocus,
            cursorColor: Colors.deepOrange,
            controller: titleController,
            style: const TextStyle(
                fontSize: 24, fontWeight: FontWeight.w500, letterSpacing: 0),
            maxLines: 1,
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: "Title",
              hintStyle: TextStyle(
                fontSize: 24,
                letterSpacing: 0,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: TextField(
              cursorColor: Colors.deepOrange,
              controller: bodyController,
              style: const TextStyle(
                fontSize: 18,
                wordSpacing: 2,
                letterSpacing: 0,
              ),
              autofocus: widget.bodyFocus,
              maxLines: null,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: "Write here..",
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.deepOrange,
          shape: const CircleBorder(eccentricity: 0),
          tooltip: "Save",
          onPressed: () {
            save(true);
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("File Saved!"),
              duration: Duration(seconds: 1),
            ));
          },
          child: const Icon(
            Icons.save,
          ),
        ),
      ),
    );
  }
}
