import 'dart:io';

import 'package:filesystem_picker/filesystem_picker.dart';
import 'package:flutter/material.dart';
import 'package:gogdl_flutter/gogdl_flutter.dart';

class GameDownloadModal extends StatefulWidget {
  const GameDownloadModal({
    super.key,
    required this.gameDetails,
    required this.gameBuilds,
  });
  final GogDbGameDetails gameDetails;
  final Future<List<GameBuild>> gameBuilds;

  @override
  State<GameDownloadModal> createState() => _GameDownloadModalState();
}

class _GameDownloadModalState extends State<GameDownloadModal> {
  final TextEditingController _installationPathController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 600,
      height: 400,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text("Installation path: "),
              Expanded(
                child: TextField(controller: _installationPathController),
              ),
              IconButton(
                icon: Icon(Icons.folder),
                onPressed: () async {
                  String? path = await FilesystemPicker.openDialog(
                    context: context,
                    title: "Select installation path",
                    fsType: FilesystemType.folder,
                    rootDirectory: Directory("/home"),
                  );
                  if (path != null) {
                    _installationPathController.text = path;
                  }
                },
              ),
            ],
          ),
          Expanded(
            child: FutureBuilder<List<GameBuild>>(
              future: widget.gameBuilds,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else {
                  List<GameBuild> builds = snapshot.data!;
                  return Container(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: ListView.builder(
                      itemCount: builds.length,
                      itemBuilder: (context, index) {
                        GameBuild build = builds[index];
                        return ListTile(
                          title: Text(gogGetBuildName(build: build)),
                          subtitle: Text(gogGetBuildDate(build: build)),
                          trailing: IconButton(
                            icon: Icon(Icons.download),
                            onPressed: () async {},
                          ),
                        );
                      },
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
