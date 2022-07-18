import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tabnews/api/login.dart';
import 'package:tabnews/global_states/global_user.dart';
import 'package:tabnews/markdown.dart';
import 'package:tabnews/widget/markdown_editor.dart';
import 'package:tabnews/widget_factories/appbar.dart';
import 'package:tabnews/data_structures/post.dart';
import '../../api/fetch_api.dart';
import '../comments.dart';

class PostScreen extends StatefulWidget {
  final String username;
  final String slug;
  final String title;
  PostScreen(
      {super.key,
      required this.username,
      required this.slug,
      required this.title});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final _markdownEditorController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    User? user = context.watch<GlobalUser>().globalUser;
    List<Post> justPostedComments = [];
    return Scaffold(
      appBar: appbar(context),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                bottom: 40.0,
                top: 40.0,
                right: 10,
                left: 10,
              ),
              child: Hero(
                tag: 'post${widget.username}${widget.slug}',
                child: Text(
                  widget.title,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
            ),
            FutureBuilder(
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var post = snapshot.data! as Post;
                  return Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Markdown(post.body!),
                          ),
                        ),
                        if (user != null)
                          MarkdownEditor(
                            textController: _markdownEditorController,
                            onChanged: (value) {
                              setState(() {});
                            },
                          ),
                        if (user != null)
                          ElevatedButton(
                            onPressed: _markdownEditorController.text.isEmpty
                                ? null
                                : () async {
                                    final body = _markdownEditorController.text;
                                    setState(() {
                                      _markdownEditorController.text = "";
                                    });
                                    final newComment = await post.comment(body);
                                    setState(() {
                                      justPostedComments.add(newComment!);
                                    });
                                  },
                            child: const Text('Responder'),
                          ),
                        Comments(comments: justPostedComments),
                        CommentsLoader(
                            username: widget.username, slug: widget.slug),
                      ],
                    ),
                  );
                }
                if (snapshot.hasError) {
                  return const Center(
                    child: Text("Não foi possivel carregar o post!"),
                  );
                }

                return const Center(child: CircularProgressIndicator());
              },
              future: fetchPost(widget.username, widget.slug),
            ),
          ],
        ),
      ),
    );
  }
}
