import 'package:flutter/material.dart';
import 'package:flutter_application_sfdc_idp/Bouncing.dart';
import 'package:flutter_application_sfdc_idp/Colors.dart';
import 'package:flutter_application_sfdc_idp/CommonAppbar.dart';
import 'package:flutter_application_sfdc_idp/CommonColor.dart';
import 'package:flutter_application_sfdc_idp/CommonText.dart';
import 'package:flutter_application_sfdc_idp/Utility.dart';

class ApplyGrivence extends StatefulWidget {
  const ApplyGrivence({Key? key, required this.listdata}) : super(key: key);
  final List listdata;
  @override
  State<ApplyGrivence> createState() => _ApplyGrivenceState();
}

class _ApplyGrivenceState extends State<ApplyGrivence> {
  bool isdata = true;
  bool isloading = false;
  Utility utility = Utility();
  List grivencecomponentlist = [];
  TextEditingController commentcontroller = TextEditingController();
  @override
  void initState() {
    super.initState();
    utility.GetUserdata().then((value) => {
          grivencecomponentlist = widget.listdata,

          setState(() {})
          // getApplyGrivencelist(),
        });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppbar(
        title: 'Apply grievances',
        appBar: AppBar(),
        widgets: const [],
      ),
      // ignore: avoid_unnecessary_containers
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // const SizedBox(height: 10),

            Expanded(
              // Use ListView.builder

              child: ListView.builder(
                  shrinkWrap: true,
                  // the number of items in the list
                  physics: const BouncingScrollPhysics(),
                  itemCount: grivencecomponentlist.length,

                  // display each item of the product list
                  itemBuilder: (context, index) {
                    //debugPrint('Indexvalue' + index.toString());
                    // debugPrint('modellength' +
                    //     permissionModel.detail.length.toString());

                    return Card(
                      margin: const EdgeInsets.all(10),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(10), // if you need this
                        side: BorderSide(
                          color: Colors.grey.withOpacity(0.5),
                          width: 1,
                        ),
                      ),
                      elevation: 3,
                      // In many cases, the key isn't mandatory
                      key: UniqueKey(),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Row(
                              // ignore: prefer_const_literals_to_create_immutables
                              children: [
                                const Expanded(
                                  flex: 1,
                                  child: CommonText(
                                    text: "DATE",
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: CommonText(
                                    text: grivencecomponentlist[index]['date']
                                        .toString(),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              // ignore: prefer_const_literals_to_create_immutables
                              children: [
                                const Expanded(
                                  flex: 1,
                                  child: CommonText(
                                    text: "Type",
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: CommonText(
                                    text: grivencecomponentlist[index]['name']
                                        .toString(),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                                // margin: const EdgeInsets.only(
                                //     top: 5, right: 10, left: 10),
                                child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                " Add Comments",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: HexColor(Colorscommon.greencolor)),
                              ),
                            )),
                            Container(
                              padding: const EdgeInsets.only(
                                  top: 10, bottom: 0, left: 0, right: 0),
                              child: TextField(
                                controller: commentcontroller,
                                maxLines: null,
                                cursorColor: HexColor(Colorscommon.greycolor),
                                // controller: descriptioncontroller,
                                style: TextStyle(
                                    color: HexColor(Colorscommon.greycolor),
                                    fontFamily: "TomaSans-Regular"),
                                decoration: const InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.black)),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.black)),
                                  hintText: 'Please Enter Comments',
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Bouncing(
                              onPress: () {},
                              child: Row(
                                children: [
                                  SizedBox(
                                    // margin: const EdgeInsets.only(
                                    //     top: 5, bottom: 2, left: 2),
                                    // width: 100,
                                    height: 40,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: HexColor(Colorscommon.greencolor),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                      ),
                                      //  RaisedButton(
                                      //   color: HexColor(Colorscommon.greencolor),
                                      //   shape: RoundedRectangleBorder(
                                      //       borderRadius:
                                      //           BorderRadius.circular(5)),
                                      child: const Text(
                                        "Upload Attachments",
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                      onPressed: () {

                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
            ),
            Bouncing(
              onPress: () {},
              child: Container(
                margin: const EdgeInsets.only(top: 10, bottom: 10),
                width: 100,
                height: 40,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: HexColor(Colorscommon.greencolor),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                  ),
                  //                                 RaisedButton(
                  // color: HexColor(Colorscommon.greencolor),
                  // shape: RoundedRectangleBorder(
                  //     borderRadius: BorderRadius.circular(5)),
                  child: const Text(
                    "Submit",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () {},
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
