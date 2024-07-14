import 'package:vira_datry/pages/create_note_page.dart';
import 'package:vira_datry/pages/edit_note_page.dart';
import 'package:vira/provider/note_provider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLayout = false;

  void _toggleLayout() {
    // NoteService().getAllNotes();
    setState(() {
      isLayout = !isLayout;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NoteProvider>().fetchNotes().onError(
        (error, stackTrace) {
          Fluttertoast.showToast(msg: error.toString());
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateNotePage(),
            ),
          );
        },
        child: Icon(
          Icons.add,
          size: 30,
          color: Colors.blue,
        ),
      ),
      appBar: AppBar(
        toolbarHeight: 80,
        title: Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "ADIMAS NOTES",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                    wordSpacing: 2,
                    letterSpacing: 2),
              ),
              GestureDetector(
                onTap: _toggleLayout,
                child: Icon(
                  isLayout ? Icons.grid_view_rounded : Icons.list_alt_outlined,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Consumer<NoteProvider>(
        builder: (context, data, child) {
          if (data.isLoading) {
            return const Center(
                child: CircularProgressIndicator(
              color: Colors.blue,
            ));
          } else {
            if (data.getNotes.isEmpty) {
              return Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/empty.png",
                      height: 100,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Nothing is Here",
                      style: TextStyle(
                          fontSize: 18,
                          color: Color(0xFF4D5270),
                          fontWeight: FontWeight.w400),
                    )
                  ],
                ),
              );
            } else {
              return Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: 30),
                child: ListView.builder(
                  physics: BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  itemCount: data.getNotes.length,
                  itemBuilder: (context, index) {
                    return Dismissible(
                      key: UniqueKey(),
                      direction: DismissDirection.endToStart,
                      onDismissed: (direction) {
                        setState(() {
                          data.removeNote(data.getNotes[index].id ?? '');
                        });
                      },
                      background: Container(
                        margin: const EdgeInsets.symmetric(vertical: 17),
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.only(right: 20),
                        color: Colors.red,
                        child: Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                      ),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    EditNotePage(note: data.getNotes[index]),
                              ));
                        },
                        child: Container(
                          width: double.infinity,
                          margin: EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                              color: Colors.blue[200],
                              borderRadius: BorderRadius.circular(15)),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            // padding: const EdgeInsets.fromLTRB(20.0, 30, 20, 15),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    (data.getNotes[index].title ?? '')
                                            .isNotEmpty
                                        ? Text(
                                            (data.getNotes[index].title ?? ''),
                                            style: TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black),
                                            maxLines: 2,
                                          )
                                        : const SizedBox(),
                                  ],
                                ),
                                (data.getNotes[index].description ?? '')
                                        .isNotEmpty
                                    ? Text(
                                        data.getNotes[index].description ?? '',
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black54,
                                            height: 1.5),
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                      )
                                    : const SizedBox(),
                                const SizedBox(height: 10),
                                Text(
                                  data.getNotes[index].createdAt.toString(),
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey[600]),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            }
          }
        },
      ),
    );
  }
}
