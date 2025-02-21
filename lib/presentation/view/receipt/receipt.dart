import 'dart:io';
import 'dart:typed_data';
import 'package:emonitor/data/model/building/room.dart';
import 'package:emonitor/data/model/payment/payment.dart';
import 'package:emonitor/presentation/theme/theme.dart';
import 'package:emonitor/presentation/widgets/component.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bakong_khqr/view/bakong_khqr.dart';
import 'package:intl/intl.dart';
import 'dart:ui' as ui;
import 'package:path_provider/path_provider.dart';


class Receipt extends StatelessWidget {
  final Payment payment;
  late String invoiceID = DateFormat('HH:mm:ss.SSS').format(payment.timeStamp);
  late Consumption newConsumption;
  late Consumption preConsumption;
  late DateTime lastPaidOn;
  GlobalKey repaintKey = GlobalKey();
  //need query of building
  Receipt({super.key, required this.payment}) {
    for (var item in payment.room.consumptionList) {
      if (item.timestamp == payment.timeStamp) {
        newConsumption = item;
        break;
      }
    }
    for (var item in payment.room.consumptionList) {
      if (item.timestamp.isBefore(newConsumption.timestamp)) {
        preConsumption = item;
        lastPaidOn = item.timestamp;
        break;
      }
    }
  }

  Future<String?> capturePngAndSave() async {
  try {
    // Capture PNG bytes
    RenderRepaintBoundary boundary = repaintKey.currentContext!
        .findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage(pixelRatio: 3.0);
    ByteData? byteData =
        await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List? pngBytes = byteData?.buffer.asUint8List();

    if (pngBytes == null) {
      print("❌ Failed to capture PNG.");
      return null;
    }

    // Get app directory to save the file
    Directory directory = await getApplicationDocumentsDirectory();
    String folderPath = '${directory.path}/my_images';
    Directory(folderPath).createSync(recursive: true);

    // Define the file path
    String filePath = '$folderPath/$invoiceID.png';

    // Save the file
    File file = File(filePath);
    await file.writeAsBytes(pngBytes);

    print('✅ Image saved at: $filePath');

    return filePath;
  } catch (e) {
    print("❌ Error capturing or saving PNG: $e");
    return null;
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        color: UniColor.backGroundColor,
        child: Center(
          child: SingleChildScrollView(
            child: 
            Column(
              children: [
                RepaintBoundary(
                  key: repaintKey,
                  child: Container(
                    height: 1000,
                    width: 800,
                    color: UniColor.white,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        //head line color blue
                        Container(
                          width: double.infinity,
                          height: 14,
                          decoration: BoxDecoration(
                            color: UniColor.primary,
                          ),
                        ),
                        //Content
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(flex: 300, child: header()),
                                Expanded(
                                  flex: 110,
                                  child: tenantInfo(),
                                ),
                                Expanded(
                                    flex: 600,
                                    child: Container(
                                      child: body(),
                                    ))
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ElevatedButton(onPressed:()async{
                 String? path = await capturePngAndSave();
                 print("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%");
                 print(path);
              }, child: const Text("save pic"))
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget header() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        // first row
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //UnitNest
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.check_box,
                        color: UniColor.primary,
                      ),
                      Text(
                        "UnitNest",
                        style:UniTextStyles.heading)
                    ],
                  ),
                  Text(
                    "${payment.timeStamp.day}/${payment.timeStamp.month}/${payment.timeStamp.year}",
                    style: UniTextStyles.body,
                  )
                ],
              ),
              //Invoice Code
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Invoice",
                    style: UniTextStyles.body
                  ),
                  Text(
                    "#INV$invoiceID",
                    style: UniTextStyles.body
                  )
                ],
              )
            ],
          ),
        ),
        // second row
        Expanded(
          child: Container(
              margin: const EdgeInsets.symmetric(vertical: 5),
              padding: const EdgeInsets.symmetric(horizontal: 30),
              decoration: const BoxDecoration(color: Color(0xFFE6EDF6)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      customeText("Building : Need to be done"),
                      customeText("Room : ${payment.room.name}")
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      customeText("Floor count : 6"),
                      customeText("Floor : 2")
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      customeText("Address : Toul Kork, PhnomPenh, Cambodia"),
                      customeText("Room Type : Null")
                    ],
                  )
                ],
              )),
        ),
        customeDivider(),
      ],
    );
  }

  Widget tenantInfo() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              customeText("Tenant's Name :\t${payment.tenant.userName}"),
              customeText("Phone Number  :\t${payment.tenant.contact}"),
              customeText("IdentifyID    :\t${payment.tenant.identifyID}"),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              customeText("Tenant's ID  :\t${payment.tenant.id}"),
              customeText(
                  "Last Paid On :\t dummyData"), //${DateFormat('DD/MM/YYY').format(lastPaidOn)}
              customeText(
                  "Issue Date   :\t${DateFormat('dd/MM/yyyy').format(payment.timeStamp)}"),
            ],
          ),
        ],
      ),
    );
  }

  Widget body() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          customeDivider(),
          //title
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Tax Invoice",
                style: UniTextStyles.heading,
              )
            ],
          ),
          Row(
            children: [
              //calculation
              Expanded(
                  flex: 600,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      customeDivider(),
                      Table(
                        children: [
                          TableRow(children: [
                            TableCell(
                                child: customeText("ITEM",
                                    color: UniColor.neutral, isBold: false)),
                            TableCell(
                                child: customeText("NEW",
                                    color: UniColor.neutral, isBold: false)),
                            TableCell(
                                child: customeText("OLD",
                                    color: UniColor.neutral, isBold: false)),
                            TableCell(
                                child: customeText("TOTAL",
                                    color: UniColor.neutral, isBold: false)),
                          ])
                        ],
                      ),
                      customeDivider(),
                      Table(
                        children: [
                          build4CellRow("Water", "110", "100", "10 m3"),
                          build4CellRow("Electricity", "110", "100", "10 Kwh"),
                        ],
                      ),
                      customeDivider(),
                      Table(
                        children: [
                          TableRow(children: [
                            TableCell(
                                child: customeText("NO.",
                                    color: UniColor.neutral, isBold: false)),
                            TableCell(
                                child: customeText("ITEM",
                                    color: UniColor.neutral, isBold: false)),
                            TableCell(
                                child: customeText("QTY",
                                    color: UniColor.neutral, isBold: false)),
                            TableCell(
                                child: customeText("PRICE",
                                    color: UniColor.neutral, isBold: false)),
                            TableCell(
                                child: customeText("Total",
                                    color: UniColor.neutral, isBold: false)),
                          ])
                        ],
                      ),
                      customeDivider(),
                      Table(
                        children: [
                          build5CellRow("1", "Water", "10", "\$2", "\$20"),
                          build5CellRow(
                              "2", "Electricity", "10", "\$2", "\$20"),
                          build5CellRow("3", "Hygiene", "1", "\$1", "\$1"),
                          build5CellRow(
                              "4", "Rent Parking", "\$1", "\$10", "\$10"),
                          build5CellRow("5", "Room", "1", "\$100", "\$100"),
                        ],
                      ),
                      customeDivider(),
                      Table(children: [
                        build5CellRow(" ", " ", " ", "SUB TOTAL", "\$151"),
                        build5CellRow(" ", " ", " ", "TAX (10%)", "\$15.1"),
                      ]),
                      Divider(
                        color:  UniColor.primary,
                        thickness: 1,
                        indent: 250,
                      ),
                      Table(children: [
                        build5CellRow(" ", " ", " ", "TOTAL", "\$166.1"),
                      ]),
                    ],
                  )),
              //KHQR
              const Expanded(
                  flex: 340,
                  child: Center(
                    child: BakongKhqrView(
                      merchantName: 'ChayLim',
                      amount: "0",
                      qrString: "none",
                      width: 200,
                    ),
                  ))
            ],
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: Divider(
              thickness: 1,
              color: UniColor.primary,
            ),
          ),
          //Footer
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Thank you for choosing us! \nWe appreciate your support.",
                style: UniTextStyles.body,
              ),
              Text(
                "www.Unitnest.com",
                style: UniTextStyles.body.copyWith(color: UniColor.primary),
              ),
              Text(
                "unitnestoffical@gmail.com",
                style: UniTextStyles.body.copyWith(color: UniColor.primary),
              ),
            ],
          )
        ],
      ),
    );
  }

  TableRow build4CellRow(String col1, String col2, String col3, String col4,
      {Color color = Colors.black, bool isBold = false}) {
    return TableRow(
      children: [
        TableCell(child: customeText(col1, color: color, isBold: isBold)),
        TableCell(child: customeText(col2, color: color, isBold: isBold)),
        TableCell(child: customeText(col3, color: color, isBold: isBold)),
        TableCell(child: customeText(col4, color: color, isBold: isBold)),
      ],
    );
  }

  TableRow build5CellRow(
      String col1, String col2, String col3, String col4, String col5,
      {Color color = Colors.black, bool isBold = false}) {
    return TableRow(
      children: [
        TableCell(child: customeText(col1, color: color, isBold: isBold)),
        TableCell(child: customeText(col2, color: color, isBold: isBold)),
        TableCell(child: customeText(col3, color: color, isBold: isBold)),
        TableCell(child: customeText(col4, color: color, isBold: isBold)),
        TableCell(child: customeText(col5, color: color, isBold: isBold)),
      ],
    );
  }

  Widget customeText(String text, {Color color = Colors.black, isBold = true}) {
    return Text(
      text,
      style: TextStyle(
          fontSize: 10,
          color: color,
          fontWeight: isBold ? FontWeight.bold : FontWeight.w400),
    );
  }

  Widget customeDivider() {
    return const Divider(
      color: Color(0xFFE6EDF6),
      thickness: 1,
    );
  }
}
