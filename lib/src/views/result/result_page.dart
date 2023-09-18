import 'dart:developer';

import 'package:capture/src/data/suggestions_api.dart';
import 'package:capture/src/res/dimens.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class ResultScreenView extends StatefulWidget {
  const ResultScreenView({super.key, this.imageString});

  final String? imageString;

  @override
  State<ResultScreenView> createState() => _ResultScreenViewState();
}

class _ResultScreenViewState extends State<ResultScreenView> {
  bool showCopy = false;
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        centerTitle: true,
        title: Text(
          "Result Image Page",
          style: GoogleFonts.poppins(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
          textAlign: TextAlign.center,
          maxLines: 2,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: PAD_ALL_15,
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "The Image Results Below are ralted Images fetched that matches the image you uploaded",
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.left,
                    maxLines: 2,
                  ),
                  SizedBox(height: 20),
                  Expanded(
                    child: FutureBuilder<List<dynamic>>(
                      future: SuggestionDatabase()
                          .getRetrivalProducts(widget.imageString),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        //log("setting fund ===> ${snapshot.data.toString()}");
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (snapshot.hasError) {
                          return Text("Error: ${snapshot.error}");
                        } else if (!snapshot.hasData || snapshot.data == null) {
                          return Center(
                            child: Text("No data available"),
                          );
                        } else {
                          //log(snapshot.data.toString());
                          List<dynamic> allList = snapshot.data!;

                          return ListView.builder(
                            scrollDirection: Axis.vertical,
                            itemCount: allList.length,
                            itemBuilder: (BuildContext context, int index) {
                              final product = allList[index];

                              //log(product["poduct_photo"]);

                              return GestureDetector(
                                onTap: () {
                                  // Navigator.of(context).push(
                                  //   MaterialPageRoute(
                                  //     builder: (context) => ProductDetailsView(
                                  //         productDetails: product),
                                  //   ),
                                  // );
                                },
                                child: Container(
                                  margin: EdgeInsets.only(bottom: 15),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white,
                                    border: Border.all(
                                      width: 1.5,
                                      color: Colors.grey.shade100,
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(8),
                                        width: width,
                                        height: height * 0.5,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          //color: Colors.amber,
                                        ),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              //color: Colors.amber,
                                              border: Border.all(
                                                width: 1.5,
                                                color: Colors.grey.shade100,
                                              ),
                                            ),
                                            height: height,
                                            width: width,
                                            child: Image.network(
                                              "https://cbir.osemeke.com/${product["product_photo"].toString()}",
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            10, 0, 10, 5),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: width / 1.3,
                                              //color: Colors.amber,
                                              child: Text(
                                                product["product_title"]
                                                    .toString(),
                                                style: GoogleFonts.poppins(
                                                  fontSize: height * 0.013,
                                                  color: Colors.black87,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                                softWrap: true,
                                                maxLines: 3,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              children: [
                                                Text(
                                                  "Price: ",
                                                  style: GoogleFonts.poppins(
                                                    fontSize: height * 0.013,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.black87,
                                                  ),
                                                ),
                                                Text(
                                                  "${product['product_price']}",
                                                  style: GoogleFonts.poppins(
                                                    fontSize: height * 0.013,
                                                    fontWeight: FontWeight.w700,
                                                    color: Colors.green,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            GestureDetector(
                                              onTap: () {
                                                Clipboard.setData(
                                                  ClipboardData(
                                                    text: product['product_url']
                                                        .toString(),
                                                  ),
                                                );
                                                setState(() {
                                                  showCopy = true;
                                                });
                                              },
                                              child: Row(
                                                children: [
                                                  Text(
                                                    "Source: ",
                                                    style: GoogleFonts.poppins(
                                                      fontSize: height * 0.013,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.black87,
                                                    ),
                                                  ),
                                                  Text(
                                                    "${product['product_url']}",
                                                    style: GoogleFonts.poppins(
                                                      fontSize: height * 0.013,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: Colors.green,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(height: 10),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
              Visibility(
                visible: showCopy ? true : false,
                child: Positioned(
                  bottom: 0,
                  right: 0,
                  left: 0,
                  child: Container(
                    height: 50,
                    width: 100,
                    padding: PAD_ALL_10,
                    margin: EdgeInsets.only(
                      right: width * 0.25,
                      left: width * 0.25,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.blueGrey.shade800,
                    ),
                    child: Center(
                      child: Text(
                        "Text Copied",
                        style: GoogleFonts.beVietnamPro(
                          fontSize: height * 0.013,
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
