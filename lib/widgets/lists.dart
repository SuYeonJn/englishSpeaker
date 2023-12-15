import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ListWidget extends StatefulWidget {
  const ListWidget({super.key, required this.source});
  final source;
  @override
  State<ListWidget> createState() => _ListWidgetState();
}

class _ListWidgetState extends State<ListWidget> {
  @override
  Widget build(BuildContext context) {
    List sourceList = widget.source.keys.toList();

    return ListView.builder(
      itemCount: widget.source.length,
      itemBuilder: ((_, index) {
        return Card(
          child: ListTile(
            title: Text(sourceList[index]),
            onTap: () async {
              if (!await launchUrl(
                Uri.parse(widget.source[sourceList[index]]),
                mode: LaunchMode.externalApplication,
              )) {
                throw Exception(
                    'Could not launch ${Uri.parse(widget.source[sourceList[index]])}');
              }
            },
          ),
        );
      }),
    );
  }
}
