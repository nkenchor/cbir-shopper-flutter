import 'dart:developer';
import 'dart:io';

import 'package:capture/src/data/suggestions_api.dart';
import 'package:capture/src/res/dimens.dart';
import 'package:capture/src/res/strings.dart';
import 'package:capture/src/views/result/result_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SuggestionScreenView extends StatefulWidget {
  const SuggestionScreenView({super.key, this.uuid, this.imageFile});

  final String? uuid;
  final File? imageFile;

  @override
  State<SuggestionScreenView> createState() => _SuggestionScreenViewState();
}

class _SuggestionScreenViewState extends State<SuggestionScreenView> {
  String offense1 = "Choose";
  List<String> offenseData = ['fan', 'chair', 'standing fan'];

  bool isLoading = false;
  double? x1;
  double? x2;
  double? y1;
  double? y2;
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  Center(
                    child: Text(
                      "Image Suggestions",
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  Center(
                    child: Container(
                      height: 250,
                      width: width,
                      child: Image.file(widget.imageFile!),
                    ),
                  ),
                  SizedBox(height: 25),
                  FutureBuilder<dynamic>(
                      future: SuggestionDatabase()
                          .loadSuggestions(widget.uuid.toString()),
                      // future: SuggestionDatabase().loadSuggestions(
                      //     "257fac8a-5fdc-4951-8aa0-232c10eaeb79"),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: Container(
                              height: 30,
                              width: 30,
                              child: CircularProgressIndicator(),
                            ),
                          );
                        } else if (snapshot.hasError) {
                          return Text("Error: ${snapshot.error}");
                        } else if (!snapshot.hasData || snapshot.data == null) {
                          return Center(
                            child: Text("No data available"),
                          );
                        } else {
                          List<dynamic> suggestionBox = snapshot.data;

                          // List<String> allSuggestions = [];

                          // for (var classification in suggestionBox) {
                          //   List<dynamic> suggestions =
                          //       classification['suggestions'];
                          //   allSuggestions.addAll(suggestions
                          //       .map((suggestion) => suggestion.toString()));
                          // }

                          return Expanded(
                            child: Container(
                              child: ListView.builder(
                                itemCount: suggestionBox.length,
                                itemBuilder: (BuildContext context, int index) {
                                  final sugBox = suggestionBox[index];
                                  List<String> suggestions =
                                      sugBox['suggestions'].cast<String>();
                                  final boundingBox = sugBox['bounding_box'];

                                  if (boundingBox != null &&
                                      boundingBox is Map<String, dynamic>) {
                                    x1 = boundingBox['x1'];
                                    x2 = boundingBox['x2'];
                                    y1 = boundingBox['y1'];
                                    y2 = boundingBox['y2'];
                                  }

                                  return GestureDetector(
                                    onTap: () {
                                      tapSearchProductImage(sugBox['name']);
                                    },
                                    child: Container(
                                      margin: EdgeInsets.all(5),
                                      padding: EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.grey.shade100,
                                              blurRadius: 1,
                                              spreadRadius: 2)
                                        ],
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                "Name: ",
                                                style: GoogleFonts.poppins(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black87,
                                                ),
                                              ),
                                              Text(
                                                "${sugBox['name']}"
                                                    .toUpperCase(),
                                                style: GoogleFonts.poppins(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.green,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 10),
                                          Row(
                                            children: [
                                              Text(
                                                "Confidence(%): ",
                                                style: GoogleFonts.poppins(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black87,
                                                ),
                                              ),
                                              Text(
                                                "${sugBox['confidence']}",
                                                style: GoogleFonts.poppins(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.green,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 10),
                                          Row(
                                            children: [
                                              Text(
                                                "Source: ",
                                                style: GoogleFonts.poppins(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black87,
                                                ),
                                              ),
                                              Text(
                                                "${sugBox['source']}",
                                                style: GoogleFonts.poppins(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.green,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 10),
                                          Text(
                                            "Bounding Box",
                                            style: GoogleFonts.poppins(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.black,
                                                decoration:
                                                    TextDecoration.underline),
                                          ),
                                          SizedBox(height: 10),
                                          Text("x1: ${x1 ?? 'N/A'}",
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.green)),
                                          Text("x2: ${x2 ?? 'N/A'}",
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.green)),
                                          Text("y1: ${y1 ?? 'N/A'}",
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.green)),
                                          Text("y2: ${y2 ?? 'N/A'}",
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.green)),
                                          SizedBox(height: 10),
                                          Container(
                                            height: 220,
                                            width: width,
                                            child: Wrap(
                                              spacing: 8.0,
                                              children: suggestions
                                                  .map((suggestionText) {
                                                return GestureDetector(
                                                  onTap: () {
                                                    tapSearchProductImage(
                                                      suggestionText,
                                                    );
                                                  },
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            3.3),
                                                    child: IntrinsicWidth(
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          color: Colors
                                                              .grey.shade200,
                                                        ),
                                                        child: Center(
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Text(
                                                              suggestionText,
                                                              style: GoogleFonts
                                                                  .poppins(
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              }).toList(),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        }
                      })
                ],
              ),
            ),
            Visibility(
              visible: isLoading,
              child: Container(
                height: height,
                width: width,
                color: Colors.black.withOpacity(0.7),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 25,
                        width: 25,
                        child: CircularProgressIndicator(
                          color: Colors.green,
                          backgroundColor: Colors.white54,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Fetching Related Images that match\nthe uploaded Image",
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void tapSearchProductImage(String? word) async {
    setState(() {
      isLoading = true;
    });

    final result = await SuggestionDatabase()
        .searchMarketplaceProducts(widget.uuid.toString(), word);

    if (result == 200) {
      setState(() {
        isLoading = false;
      });
      log(widget.uuid.toString());
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) =>
              ResultScreenView(imageString: widget.uuid.toString()),
        ),
      );
    } else if (result != 200) {
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
