import 'package:fergog/provider/gog_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gogdl_flutter/src/rust/api/games_downloader.dart';

class DownloadScreen extends StatelessWidget {
  const DownloadScreen({
    super.key,
    required this.fileList,
    required this.sessionCode,
  });

  final List<FileDownload> fileList;
  final String sessionCode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Downloading"),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 8),
        child: Consumer(
          builder: (BuildContext context, WidgetRef ref, Widget? child) {
            final downloadProgress = ref.watch(
              downloadStatusProvider((
                sessionCode: sessionCode,
                downloads: fileList,
              )),
            );
            return downloadProgress.when(
              loading: () => Center(child: CircularProgressIndicator()),
              error: (error, stackTrace) =>
                  Center(child: Text('Error: $error')),
              data: (data) =>
                  LinearProgressIndicator(value: data.percentage / 100),
            );
          },
        ),
      ),
    );
  }
}
