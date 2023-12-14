import 'dart:async';
import 'package:flutter/material.dart';
import 'package:notes/edit_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String>? data;
  final List<Color> myColors = [
    Colors.cyan.shade100,
    Colors.brown.shade100,
    Colors.purple.shade100,
    Colors.lightGreen.shade100,
    Colors.pink.shade100,
    Colors.amber.shade100,
    Colors.redAccent.shade100,
  ];

  void read() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await Future.delayed(const Duration(milliseconds: 500))
        .then((value) => setState(() {
              data = prefs.getStringList('data') ?? [];
            }));
  }

  void removeDataAt(int index) async {
    data!.removeAt(index);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList("data", data!);
  }

  @override
  void initState() {
    read();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.sizeOf(context).height;
    return Scaffold(
      body: (data == null)
          ? const Center(
              child: CircularProgressIndicator(
              color: Colors.deepOrange,
            ))
          : CustomScrollView(
              slivers: [
                SliverAppBar(
                  collapsedHeight: height * 0.125,
                  backgroundColor: Colors.white10,
                  expandedHeight: height * 0.3,
                  flexibleSpace: const FlexibleSpaceBar(
                      titlePadding: EdgeInsets.all(30),
                      centerTitle: true,
                      title: Text(
                        "Rainbow Notes 🌈",
                        style: TextStyle(color: Colors.black, fontSize: 24),
                      )),
                ),
                SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    sliver: SliverGrid.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 24,
                                crossAxisSpacing: 16,
                                childAspectRatio: 0.8),
                        itemCount: data!.length,
                        itemBuilder: (context, index) {
                          final List<String> cont =
                              data![data!.length - index - 1].split("/sep/");
                          return ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.grey,
                              backgroundColor: myColors[index % 7],
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                            onPressed: () {
                              Future.delayed(
                                      const Duration(milliseconds: 300), () {})
                                  .then((_) {
                                removeDataAt(data!.length - index - 1);
                                return Navigator.of(context)
                                    .push(MaterialPageRoute(
                                        builder: (context) => EditPage(
                                              title: cont[0],
                                              subtitile: cont[1],
                                              titleFocus: false,
                                              bodyFocus: false,
                                            )))
                                    .then((value) => {read()});
                              });
                            },
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Align(
                                      alignment: Alignment.centerRight,
                                      child: PopupMenuButton(
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(8))),
                                        itemBuilder: (context) => const [
                                          PopupMenuItem(
                                              value: 0, child: Text("Edit")),
                                          PopupMenuItem(
                                              value: 1, child: Text("Delete")),
                                        ],
                                        icon: const Icon(
                                          Icons.more_vert,
                                        ),
                                        onSelected: (value) {
                                          if (value == 0) {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) {
                                              removeDataAt(
                                                  data!.length - index - 1);
                                              return EditPage(
                                                title: cont[0],
                                                subtitile: cont[1],
                                                titleFocus: false,
                                                bodyFocus: true,
                                              );
                                            })).then((value) => {read()});
                                          } else {
                                            Future.delayed(const Duration(
                                                    milliseconds: 200))
                                                .then((value) => showDialog(
                                                    context: context,
                                                    builder:
                                                        (context) =>
                                                            AlertDialog(
                                                              shape: const RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              8))),
                                                              title: const Text(
                                                                  "Delete"),
                                                              content: const Text(
                                                                  "Do you want to delete the file?"),
                                                              actions: [
                                                                TextButton(
                                                                    onPressed:
                                                                        () {
                                                                      removeDataAt(data!
                                                                              .length -
                                                                          index -
                                                                          1);
                                                                      Future.delayed(const Duration(
                                                                              milliseconds:
                                                                                  500))
                                                                          .then(
                                                                              (value) {
                                                                        setState(
                                                                            () {});
                                                                        Navigator.of(context)
                                                                            .pop();
                                                                        ScaffoldMessenger.of(context)
                                                                            .showSnackBar(const SnackBar(
                                                                          content:
                                                                              Text("Deleted Successfully!"),
                                                                          duration:
                                                                              Duration(seconds: 1),
                                                                        ));
                                                                      });
                                                                    },
                                                                    child:
                                                                        const Text(
                                                                      "Yes",
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.black),
                                                                    )),
                                                                TextButton(
                                                                  onPressed: () =>
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop(),
                                                                  child:
                                                                      const Text(
                                                                    "No",
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .black),
                                                                  ),
                                                                )
                                                              ],
                                                            )));
                                          }
                                        },
                                      )),
                                  if (cont[0] != "")
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 16.0),
                                      child: Text(
                                        cont[0],
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black),
                                      ),
                                    ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: Text(
                                      cont[1],
                                      maxLines: 6,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          letterSpacing: 0.1,
                                          fontWeight: FontWeight.w300,
                                          color: Colors.black),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }))
              ],
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepOrange,
        shape: const CircleBorder(eccentricity: 0),
        tooltip: "Create",
        onPressed: () => Navigator.of(context)
            .push(MaterialPageRoute(
                builder: (context) => const EditPage(
                      title: "",
                      subtitile: "",
                      titleFocus: true,
                      bodyFocus: false,
                    )))
            .then((value) {
          read();
        }),
        child: const Icon(
          Icons.create_outlined,
        ),
      ),
    );
  }
}
