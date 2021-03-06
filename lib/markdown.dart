import 'package:flutter/material.dart';
import 'package:flutter_highlighter/themes/atom-one-light.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:flutter_highlighter/flutter_highlighter.dart';
import 'package:flutter_highlighter/themes/atom-one-dark.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class Markdown extends StatelessWidget {
  const Markdown(this.body) : super(key: null);
  final String body;
  @override
  Widget build(BuildContext context) {
    return MarkdownBody(
      // CHAOS ALLERT!
      data: body
          .replaceAll(RegExp("\\<(\\/)?(bold|strong)\\>"), "**")
          .replaceAll(RegExp("\\<h1\\>"), "# ")
          .replaceAll(RegExp("\\<h2\\>"), "## ")
          .replaceAll(RegExp("\\<h3\\>"), "### ")
          .replaceAll(RegExp("\\<h4\\>"), "#### ")
          .replaceAll(RegExp("\\<h5\\>"), "##### ")
          .replaceAll(RegExp("\\<h6\\>"), "###### ")
          .replaceAll(RegExp("\\<\\/*.\\>"), ""),
      inlineSyntaxes: [md.InlineHtmlSyntax()],
      builders: {
        'code': CodeElementBuilder(),
      },
      extensionSet: md.ExtensionSet(
        md.ExtensionSet.gitHubFlavored.blockSyntaxes,
        [md.EmojiSyntax(), ...md.ExtensionSet.gitHubFlavored.inlineSyntaxes],
      ),
      styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
        blockquote: const TextStyle(color: Colors.transparent),
        blockquotePadding: const EdgeInsets.all(10),
        blockquoteDecoration: BoxDecoration(
          border: Border.all(
            color: MediaQueryData.fromWindow(WidgetsBinding.instance.window)
                        .platformBrightness
                        .name ==
                    "dark"
                ? Colors.grey[500]!
                : Colors.grey[900]!,
            width: 1,
          ),
          color: MediaQuery.of(context).platformBrightness.name == "light"
              ? const Color(0xfffafafa)
              : const Color(0xff282c34),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
      ),
      selectable: true,
      onTapLink: (text, href, title) async {
        if (href == null) {
          return;
        }
        if (!await canLaunchUrlString(href)) {
          return;
        }
        if (!await launchUrlString(href)) {
          throw 'Could not launch $href';
        }
      },
    );
  }
}

class CodeElementBuilder extends MarkdownElementBuilder {
  @override
  Widget? visitElementAfter(md.Element element, TextStyle? preferredStyle) {
    var language = '';

    if (element.attributes['class'] != null) {
      String lg = element.attributes['class'] as String;
      language = lg.substring(9);
    }
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: MediaQueryData.fromWindow(WidgetsBinding.instance.window)
                      .platformBrightness
                      .name ==
                  "dark"
              ? Colors.grey[500]!
              : Colors.grey[900]!,
          width: 1,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: HighlightView(
          // The original code to be highlighted
          element.textContent,

          // Specify language
          // It is recommended to give it a value for performance
          language: language,

          // Specify highlight theme
          // All available themes are listed in `themes` folder
          theme: MediaQueryData.fromWindow(WidgetsBinding.instance.window)
                      .platformBrightness ==
                  Brightness.light
              ? atomOneLightTheme
              : atomOneDarkTheme,

          // Specify padding
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),

          // Specify text style
          textStyle: GoogleFonts.jetBrainsMono(),
        ),
      ),
    );
  }
}
