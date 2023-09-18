import 'dart:developer';
import 'dart:io';

import 'package:capture/src/blocs/image_upload/image_upload.dart';
import 'package:capture/src/res/dimens.dart';
import 'package:capture/src/res/functions.dart';
import 'package:capture/src/views/suggestion/suggestions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart' as img;
import 'package:path/path.dart' as path;

import '../../res/strings.dart';

class UploadScreenView extends StatefulWidget {
  const UploadScreenView({super.key});

  @override
  State<UploadScreenView> createState() => _UploadScreenViewState();
}

class _UploadScreenViewState extends State<UploadScreenView> {
  File? image;
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: PAD_ALL_15,
          child: Column(
            children: [
              Expanded(
                child: Container(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset('assets/images/finders.svg'),
                        Text(
                          'Cbir shopper',
                          style: GoogleFonts.sigmarOne(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        captureImage();
                      },
                      child: Container(
                        padding: PAD_ALL_10,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color(0xffE6E6E6),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Take a photo",
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Icon(
                              Icons.photo_camera_outlined,
                              size: 24,
                              color: Color(0xff999999),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 15),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        uploadImage();
                      },
                      child: Container(
                        padding: PAD_ALL_10,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color(0xffE6E6E6),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Add a photo",
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Icon(
                              Icons.add_photo_alternate_outlined,
                              size: 24,
                              color: Color(0xff999999),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: 25),
              Visibility(
                visible: isLoading,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Processing Image",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      height: 10,
                      width: 10,
                      child: CircularProgressIndicator(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> uploadImage() async {
    // ignore: deprecated_member_use
    final pickedFile = await img.ImagePicker().pickImage(
      source: img.ImageSource.gallery,
      imageQuality: 80,
    );

    if (pickedFile != null) {
      setState(() {
        image = File(pickedFile.path);
      });
      //final decodedImage = await decodeImageFromList(image!.readAsBytesSync());
      getUUIDIMAGE(image);
    } else {
      print('No image selected');
    }
  }

  //this is for capturing image using camera
  Future<void> captureImage() async {
    final pickedFile = await img.ImagePicker().pickImage(
      source: img.ImageSource.camera,
      imageQuality: 80,
    );

    if (pickedFile != null) {
      setState(() {
        image = File(pickedFile.path);
      });
      // Rest of your code remains the same...
      getUUIDIMAGE(image);
    } else {
      print('No image selected');
    }
  }

  //to send pictuyre to get UUID
  void getUUIDIMAGE(File? image) async {
    setState(() {
      isLoading = true;
    });

    final result = await ImageUploadFunction().paymentImage(image: image);

    if (result['message'] == "Image uploaded successfully.") {
      setState(() {
        isLoading = false;
      });

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) =>
              SuggestionScreenView(uuid: result['uuid'], imageFile: image!),
        ),
      );
    } else if (result['message'] != "Image uploaded successfully.") {
      setState(() {
        isLoading = false;
      });

      alert(
        context,
        title: const Text(
          "Could not fetch images related to uploaded image",
        ),
      );
    } else {
      alert(
        context,
        title: const Text(
          "Could not fetch images related to uploaded image",
        ),
      );
    }

    setState(() {
      isLoading = false;
    });
  }
}
