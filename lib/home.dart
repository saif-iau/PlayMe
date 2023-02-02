import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:pdf_text/pdf_text.dart';

class Home extends StatefulWidget {
  Home({super.key});
  PlatformFile? file;
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  FlutterTts flutterTts = FlutterTts();

  void speak(String text) async {
    await flutterTts.setLanguage('en-US-language');
    await flutterTts.speak(text);
  }

  void stop() async {
    await flutterTts.pause();
  }

  Future<String> pickdocument() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'docx'],
      allowCompression: true,
    );

    if (result != null) {
      final String? files = result.files.single.path;
      return files!;
    } else {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    TextEditingController controller = TextEditingController();

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white70,
        appBar: AppBar(
          backgroundColor: Colors.cyan,
          title: const Text('PlayMe'),
          elevation: 3,
          leading: const Icon(Icons.play_circle),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: width * 0.05, vertical: height * 0.03),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton.icon(
                    onPressed: () async {
                      if (controller.text.isNotEmpty || controller.text != '') {
                        speak(controller.text.trim());
                      } else {
                        speak('please upload a book to play');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 25),
                        side: BorderSide()),
                    icon: const Icon(
                      Icons.play_circle_fill,
                      size: 30,
                    ),
                    label: const Text('Play'),
                  ),
                  ElevatedButton.icon(
                    onPressed: () async {
                      stop();
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 25),
                        side: BorderSide()),
                    icon: const Icon(
                      Icons.pause_circle_outline,
                      size: 30,
                    ),
                    label: const Text('Stop'),
                  ),
                  ElevatedButton.icon(
                    onPressed: () async {
                      controller.clear();
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepOrange,
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 25),
                        side: BorderSide()),
                    icon: const Icon(
                      Icons.delete_outline,
                      size: 30,
                    ),
                    label: const Text('Clear'),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      pickdocument().then((value) async {
                        if (value != '') {
                          PDFDoc doc = await PDFDoc.fromPath(value);
                          final text = await doc.text;

                          controller.text = text;
                        }
                      });
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 25),
                        side: BorderSide()),
                    icon: const Icon(
                      Icons.upload_file,
                      size: 30,
                    ),
                    label: const Text('Upload'),
                  ),
                ],
              ),
              Text(widget.file?.name.toString() ?? ''),
              Container(
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.blue)),
                height: height * 0.6,
                child: TextFormField(
                  controller: controller,
                  readOnly: true,
                  maxLines: 30,
                  decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(15),
                      border: InputBorder.none,
                      label: Text('Text here')),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
