import 'dart:typed_data';
import 'package:emonitor/domain/model/building/room.dart';
import 'package:emonitor/domain/model/payment/payment.dart';
import 'package:emonitor/domain/model/payment/transaction.dart';
import 'package:emonitor/domain/model/system/priceCharge.dart';
import 'package:emonitor/domain/service/finder_service.dart';
import 'package:emonitor/domain/service/khqr_service.dart';
import 'package:emonitor/domain/service/payment_service.dart';
import 'package:emonitor/presentation/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bakong_khqr/view/bakong_khqr.dart';
import 'package:intl/intl.dart';
import 'dart:ui' as ui;


class ShowReceiptDialog extends StatelessWidget {
  final Payment payment;
  Consumption? newConsumption;
  Consumption? preConsumption;
  DateTime? lastPaidOn;
  Room? room;
  GlobalKey repaintKey = GlobalKey();
  //need query of building
  ShowReceiptDialog({super.key, required this.payment}) {

    preConsumption ??= Consumption(waterMeter: 0, electricityMeter: 0);
    newConsumption ??= Consumption(waterMeter: 0, electricityMeter: 0);
    lastPaidOn = DateTime.now();
    // payment = FinderService.instance.findRoomByID("1590243306")!.paymentList.last;
    print("find room");
    room = FinderService.instance.findRoomByID(payment.roomID);
    if(room == null){
      throw "room can not be found in RECEIPT dialog";
    }
    print("find new consumption");
    for (var item in room!.consumptionList) {
      if (item.timestamp == payment.timeStamp) {
        newConsumption = item;
        break;
      }
    }
    if(newConsumption != null){
       for (var item in room!.consumptionList) {
        if (item.timestamp.isBefore(newConsumption!.timestamp)) {
          preConsumption = item;
          lastPaidOn = item.timestamp;
          break;
        }
      }
    } 
   
  }
  Future<TransactionKHQR> requestKHQR() async {
    return KhqrService.instance.requestKHQR(payment.totalPrice);
  }

 Future<Uint8List?> capturePNG() async {
    print("capturePNG() started");
    try {
        print("repaintKey: ${repaintKey.currentState}"); // Check if the key is valid
        print("repaintKey.currentContext: ${repaintKey.currentContext}");
        final boundary = repaintKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
        print("boundary: $boundary");
        print("Calling toImage()");
        final image = await boundary.toImage(pixelRatio: 3.0);
        print("toImage() successful");
        final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
        final pngBytes = byteData?.buffer.asUint8List();
        print("capturePNG() finished successfully");
        return pngBytes;
    } on Exception catch (e) {
        print("Error in capturePNG(): $e"); // Print the full exception
        return null;
    }
}



  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Container(
        width: double.infinity,
        color: UniColor.backGroundColor,
        child: Center(
          child:  Row(
              children: [
               RepaintBoundary(
                  key: repaintKey,
                  child: Container(
                    height: 700,
                    width: 500,
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
                                Expanded(
                                  flex: 300, child: header()),
                                Expanded(
                                  flex: 150,
                                  child: tenantInfo(),
                                ),
                                Expanded(
                                    flex: 600,
                                    child: Container(
                                      child: body(),
                                    )
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
               Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                onPressed:()async{
                 Navigator.pop(context,null);
              }, 
              child: const Text("Reject")),
                  ElevatedButton(
                onPressed:()async{
                 Uint8List? pngBytes = await capturePNG();
                 Navigator.pop(context,pngBytes);
              }, 
              child: const Text("Approve"))
                ],
               )
              ],
            ),
        
        ),
      )
  ,
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
                    "#INV${payment.timeStamp.millisecond}",
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
                      customeText("Building : "),
                      customeText("Room : ${room!.name}")
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
        // customeDivider(),
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
              customeText("Tenant's Name :\t${room!.tenant!.userName}"),
              customeText("Phone Number  :\t${room!.tenant!.contact}"),
              customeText("IdentifyID    :\t${room!.tenant!.identifyID}"),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              customeText("Tenant's ID  :\t${room!.tenant!.id}"),
              customeText("Last Paid On :\t ${DateFormat('dd/MM/yyyy').format(preConsumption!.timestamp)}"), //${DateFormat('DD/MM/YYY').format(lastPaidOn)}
              customeText("Issue Date   :\t${DateFormat('dd/MM/yyyy').format(payment.timeStamp)}"),
            ],
          ),
        ],
      ),
    );
  }

  Widget body() {
     ///
    /// Render data
    /// 
    PriceCharge? priceCharge = PaymentService.instance.getPriceChargeFor(payment.timeStamp);

    double waterUsage = newConsumption!.waterMeter - preConsumption!.waterMeter;
    double electricityUsage = newConsumption!.electricityMeter - preConsumption!.electricityMeter;

    double waterTotal = priceCharge!.waterPrice * waterUsage;
    double electricityTotal = priceCharge.electricityPrice * electricityUsage;
    

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              //calculation
              Expanded(
                flex: 5,
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
                          build4CellRow(1,"Water", newConsumption!.waterMeter.toString(), preConsumption!.waterMeter.toString(), "${newConsumption!.waterMeter - preConsumption!.waterMeter}"),
                          build4CellRow(2,"Electricity", newConsumption!.electricityMeter.toString(), preConsumption!.electricityMeter.toString(), "${newConsumption!.electricityMeter - preConsumption!.electricityMeter}"),
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
                          build5CellRow(1,"1", "Water", "$waterUsage m³", "\$ ${priceCharge.waterPrice}", "\$ $waterTotal"),
                          build5CellRow(1,"2", "Electricity", "$electricityUsage m³", "\$ ${priceCharge.electricityPrice}", "\$ $electricityTotal"),
                          build5CellRow(3,"3", "Hygiene","1", "\$ ${priceCharge.hygieneFee}", "\$ ${priceCharge.hygieneFee}"),
                          build5CellRow(4,"4", "Parking space", "${payment.parkingAmount}", "\$ ${priceCharge.rentParkingPrice}", "\$10"),
                          build5CellRow(5,"5", "Room", "1", "\$ ${payment.roomPrice}", "\$100"),
                        ],
                      ),
                      customeDivider(),
                      Table(children: [
                        build5CellRow(6," ", " ", " ", "SUB TOTAL", "\$ ${payment.totalPrice}"),
                        build5CellRow(7," ", " ", " ", "FINE ", "\$ ${payment.fine}"),
                      ]),
                      Divider(
                        color:  UniColor.primary,
                        thickness: 1,
                        indent: 250,
                      ),
                      Table(children: [
                        build5CellRow(8," ", " ", " ", "TOTAL", "\$ ${ payment.totalPrice + payment.fine}"),
                      ]),
                    ],
                  )),
              //KHQR
              Expanded(
                flex: 3,
              child: 
                  BakongKhqrView(
                      width: 150,
                      merchantName: "UnitNest",
                      amount: "${payment.totalPrice}",
                      qrString: payment.transaction.qr),
              
              )
            ],
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: Divider(
              thickness: 1,
              color: UniColor.primary,
            ),
          ),
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

  TableRow build4CellRow(int index, String col1, String col2, String col3, String col4,
    {Color color = Colors.black, bool isBold = false}) {
  return TableRow(
    key: ValueKey(index), // Unique key for each row (using index)
    children: [
      TableCell(key: ValueKey('$index-col1'), child: customeText(col1, color: color, isBold: isBold)),
      TableCell(key: ValueKey('$index-col2'), child: customeText(col2, color: color, isBold: isBold)),
      TableCell(key: ValueKey('$index-col3'), child: customeText(col3, color: color, isBold: isBold)),
      TableCell(key: ValueKey('$index-col4'), child: customeText(col4, color: color, isBold: isBold)),
    ],
  );
}

TableRow build5CellRow(int index, String col1, String col2, String col3, String col4, String col5,
    {Color color = Colors.black, bool isBold = false}) {
  return TableRow(
    key: ValueKey(index), // Unique key for each row (using index)
    children: [
      TableCell(key: ValueKey('$index-col1'), child: customeText(col1, color: color, isBold: isBold)),
      TableCell(key: ValueKey('$index-col2'), child: customeText(col2, color: color, isBold: isBold)),
      TableCell(key: ValueKey('$index-col3'), child: customeText(col3, color: color, isBold: isBold)),
      TableCell(key: ValueKey('$index-col4'), child: customeText(col4, color: color, isBold: isBold)),
      TableCell(key: ValueKey('$index-col5'), child: customeText(col5, color: color, isBold: isBold)),
    ],
  );
}

  Widget customeText(String text, {Color color = Colors.black, isBold = true}) {
    return Text(text,
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
