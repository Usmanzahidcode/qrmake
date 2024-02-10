// import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:share_plus/share_plus.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Qr code App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
        snackBarTheme: const SnackBarThemeData(
          backgroundColor: Colors.blue,
        ),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String qrData = 'This App is made by Usman Zahid with Flutter and love!';
  void updateQrCode(String inputData) {
    setState(() {
      qrData = inputData;
    });
  }

  final GlobalKey _qrKey = GlobalKey();
  bool dirExists = false;
  String fileName = 'qr_code';
  dynamic externalDir = '/storage/emulated/0/Download/Qr_code';

  Future<void> generateImageAndSave() async {
    RenderRepaintBoundary boundary =
        _qrKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage(
      pixelRatio: 5,
    );
    ByteData? byteData =
        await (image.toByteData(format: ui.ImageByteFormat.png));
    if (byteData != null) {
      final result =
          await ImageGallerySaver.saveImage(byteData.buffer.asUint8List());
      print(result);
      if (!mounted) return;
      const snackBar = SnackBar(content: Text('QR code saved to gallery'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    // try {
    //   RenderRepaintBoundary boundary =
    //       _qrKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    //   var image = await boundary.toImage(pixelRatio: 3.0);

    //   //Drawing White Background because Qr Code is Black
    //   final whitePaint = Paint()..color = Colors.white;
    //   final recorder = PictureRecorder();
    //   final canvas = Canvas(recorder,
    //       Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()));
    //   canvas.drawRect(
    //       Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
    //       whitePaint);
    //   canvas.drawImage(image, Offset.zero, Paint());
    //   final picture = recorder.endRecording();
    //   final img = await picture.toImage(image.width, image.height);
    //   ByteData? byteData = await img.toByteData(format: ImageByteFormat.png);
    //   Uint8List pngBytes = byteData!.buffer.asUint8List();

    //   //Check for duplicate file name to avoid Override

    //   int i = 1;
    //   while (await File('$externalDir/$fileName.png').exists()) {
    //     fileName = 'qr_code_$i';
    //     i++;
    //   }

    //   // Check if Directory Path exists or not
    //   dirExists = await File(externalDir).exists();
    //   //if not then create the path
    //   if (!dirExists) {
    //     await Directory(externalDir).create(recursive: true);
    //     dirExists = true;
    //   }

    //   final file = await File('$externalDir/$fileName.png').create();
    //   await file.writeAsBytes(pngBytes);

    //   if (!mounted) return;
    //   const snackBar = SnackBar(content: Text('QR code saved to gallery'));
    //   ScaffoldMessenger.of(context).showSnackBar(snackBar);
    // } catch (e) {
    //   print(e);
    //   if (!mounted) return;
    //   const snackBar =
    //       SnackBar(content: Text('QR code cant be saved to gallery'));
    //   ScaffoldMessenger.of(context).showSnackBar(snackBar);
    // }
  }

  // void shareGeneratedImage() async {
  //   generateImageAndSave();
  //   final result = await Share.shareXFiles(
  //       [XFile('$externalDir/$fileName.png')],
  //       text:
  //           'Hey here is a Qr-Code for you! Made with Qr Make :) https://www.google.com');

  //   if (result.status == ShareResultStatus.success) {
  //     if (!mounted) return;
  //     const snackBar = SnackBar(
  //         content: Text(
  //       'QR code Shared successfully',
  //     ));
  //     ScaffoldMessenger.of(context).showSnackBar(snackBar);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        height: 65,
        notchMargin: 7,
        child: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Icon(
                Icons.code_rounded,
                size: 25,
                color: Colors.orange,
              ),
              const SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'App By',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    'Usman Zahid',
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                onChanged: updateQrCode,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.text_fields_rounded),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 10,
                  ),
                  hintText: 'Text for Qr Code:',
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 25),
                child: RepaintBoundary(
                  key: _qrKey,
                  child: Container(
                    color: Colors.white,
                    padding: EdgeInsets.all(10),
                    child: Column(
                      children: [
                        QrImageView(
                          data: qrData,
                          padding: const EdgeInsets.all(0),
                          version: QrVersions.auto,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.qr_code_2_rounded,
                              size: 25,
                              color: ui.Color.fromARGB(255, 9, 98, 171),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text('Made with', style: GoogleFonts.poppins()),
                            Text(' Qr Make',
                                style: GoogleFonts.lato(
                                    fontWeight: FontWeight.bold))
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: generateImageAndSave,
                    icon: const Icon(Icons.download_rounded),
                    label: const Text('Download'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final Uri _url = Uri.parse('https://github.com/Usmanzahidcode');
          launchUrl(_url);
        },
        elevation: 0,
        shape: const CircleBorder(eccentricity: 1.0),
        child: const Icon(Icons.info_rounded),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }
}
