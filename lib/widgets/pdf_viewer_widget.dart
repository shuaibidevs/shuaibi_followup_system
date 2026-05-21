import 'dart:ui_web' as ui;
import 'package:flutter/material.dart';
import 'package:web/web.dart' as web;

class PdfViewerWidget extends StatefulWidget {
  final String pdfUrl;

  const PdfViewerWidget({super.key, required this.pdfUrl});

  @override
  State<PdfViewerWidget> createState() => _PdfViewerWidgetState();
}

class _PdfViewerWidgetState extends State<PdfViewerWidget> {
  late final String viewId;

  @override
  void initState() {
    super.initState();

    viewId = 'pdf-viewer-${DateTime.now().millisecondsSinceEpoch}';

    ui.platformViewRegistry.registerViewFactory(viewId, (int id) {
      final iframe =
          web.HTMLIFrameElement()
            ..src = widget.pdfUrl
            ..style.border = 'none'
            ..width = '100%'
            ..height = '100%';

      return iframe;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('PDF Viewer')),
      body: HtmlElementView(viewType: viewId),
    );
  }
}
