import 'package:flutter/material.dart';
import 'package:tabnews/data_structures/post.dart';
import 'package:tabnews/widget/screens/post_screen.dart';

class PostEntry extends StatefulWidget {
  final String username;
  final String slug;
  final Post initialPost;
  const PostEntry(
      {super.key,
      required this.username,
      required this.slug,
      required this.initialPost});
  @override
  PostEntryState createState() {
    return PostEntryState();
  }
}

class PostEntryState extends State<PostEntry> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.all(15),
        title: Padding(
          padding: const EdgeInsets.only(bottom: 15.0),
          child: Hero(
            tag: "post${widget.username}${widget.slug}",
            child: Text(
              widget.initialPost.title!,
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
        ),
        subtitle: Text(
          "${widget.initialPost.tabcoins} tabcoins · ${widget.initialPost.children_deep_count} comentário${widget.initialPost.children_deep_count != 1 ? "s" : ""} · ${widget.initialPost.username}",
          style: const TextStyle(fontSize: 13),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PostScreen(
                  username: widget.username,
                  slug: widget.slug,
                  title: widget.initialPost.title!),
            ),
          );
        },
      ),
    );
  }
}
