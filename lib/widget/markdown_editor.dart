import 'package:flutter/material.dart';
import 'package:tabnews/markdown.dart';

class MarkdownEditor extends StatefulWidget {
  const MarkdownEditor({Key? key, required this.textController})
      : super(key: key);
  final TextEditingController textController;
  @override
  State<MarkdownEditor> createState() => MarkdownEditorState();
}

class MarkdownEditorState extends State<MarkdownEditor> {
  int selectedTab = 0;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 15.0),
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(15.0),
              ),
              child: NavigationBar(
                height: 60,
                selectedIndex: selectedTab,
                onDestinationSelected: (value) =>
                    setState(() => selectedTab = value),
                destinations: const [
                  NavigationDestination(
                    label: "Edit",
                    icon: Icon(Icons.edit),
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.preview),
                    label: "Preview",
                  ),
                ],
              ),
            ),
          ),
          (selectedTab == 0
              ? Padding(
                  padding: const EdgeInsets.only(
                    right: 18.0,
                    left: 18.0,
                    top: 0,
                    bottom: 18,
                  ),
                  child: TextField(
                    controller: widget.textController,
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "Escreva um comentário...",
                    ),
                  ),
                )
              : Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: SingleChildScrollView(
                      child: Markdown(widget.textController.text),
                    ),
                  ),
                )),
        ],
      ),
    );
  }
}
