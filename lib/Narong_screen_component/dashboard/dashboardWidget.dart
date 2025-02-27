import 'package:emonitor/presentation/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

// green online bullet point : i used in the income pie chart
Widget greenBulletPoint() {
  return Container(
    width: 5,
    height: 5,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: UniColor.green,
    ),
  );
}

// the list of building summary : i used in the incoe pie chart
Widget buildBuildingPaymentSummary() {
  return Container(
    // color: Colors.blue,
    child: SizedBox(
      height: 30,
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        title: Row(
          children: [
            greenBulletPoint(),
            SizedBox(width: 5),
            Text(
              "Builiding B",
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        trailing: Text(
          "11/15 paid",
          style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: UniColor.neutralDark),
        ),
      ),
    ),
  );
}

// the breakdown card (contain linear indicator): i used in the breakdown card
Widget buildBreakdownCard() {
  return Container(
    width: 200,
    decoration: BoxDecoration(
        border:
            Border(right: BorderSide(color: UniColor.neutralLight, width: 1))),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Room total",
          style: TextStyle(fontSize: 12),
        ),
        Text(
          "\$" + "600.00",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        LinearPercentIndicator(
          width: 200.0,
          lineHeight: 5.0,
          percent: 0.9,
          barRadius: Radius.circular(3),
          progressColor: UniColor.primary,
          padding: EdgeInsets.zero,
        ),
        SizedBox(
          width: 200,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "22 rooms",
                style: TextStyle(
                    color: UniColor.neutral,
                    fontSize: 12,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                "\$" + "2262.50",
                style: TextStyle(fontSize: 12),
              )
            ],
          ),
        )
      ],
    ),
  );
}

Widget buildPaymentStatusCard() {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    width: 200,
    decoration: BoxDecoration(
        color: UniColor.white, borderRadius: BorderRadius.circular(10)),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Available",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: UniColor.neutral),
            ),
            Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: UniColor.neutralDark),
                child: Icon(
                  Icons.bed,
                  color: UniColor.white,
                  size: 15,
                ))
          ],
        ),
        RichText(
          text: TextSpan(children: [
            TextSpan(
                text: "2",
                style: TextStyle(
                  fontSize: 18,
                  color: UniColor.neutralDark,
                  fontWeight: FontWeight.bold,
                )),
            TextSpan(
                text: "Rooms",
                style: TextStyle(
                  fontSize: 12,
                  color: UniColor.neutralLight,
                  fontWeight: FontWeight.bold,
                )),
          ]),
        ),
      ],
    ),
  );
}

// from chaylim
Widget listUnpaid() {
  return Expanded(
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 16),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Unpaid Rooms",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    child: Row(
                      children: [
                        Icon(
                          Icons.keyboard_arrow_down,
                          size: 16,
                        ),
                        Text(
                          "Latest",
                          style: TextStyle(fontSize: 10),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            paymentStatusListTile(
                iconData: Icons.circle,
                title: "A001",
                subtitle: "Building",
                status: "A",
                trailing: "14/02/2025"),
            paymentStatusListTile(
                iconData: Icons.circle,
                title: "A001",
                subtitle: "Building",
                status: "A",
                trailing: "14/02/2025"),
            paymentStatusListTile(
                iconData: Icons.circle,
                title: "A001",
                subtitle: "Building",
                status: "A",
                trailing: "14/02/2025"),
          ],
        ),
      ),
    ),
  );
}

Widget invoice() {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
    ),
    child: SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Invoices",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              GestureDetector(
                onTap: () {
                  // Handle tap
                },
                child: Container(
                  child: Row(
                    children: [
                      Icon(Icons.keyboard_arrow_down, size: 16),
                      Text("Latest", style: TextStyle(fontSize: 10)),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Text("Today",
              style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey)),
          SizedBox(height: 5),
          customeListTile(
              iconData: Icons.receipt_long,
              title: "Invoice#143241234",
              subtitle: "RoomA002",
              status: "Paid",
              trailing: "123.4"),
          customeListTile(
              iconData: Icons.receipt_long,
              title: "Invoice#143241234",
              subtitle: "RoomA002",
              status: "Paid",
              trailing: "123.4"),
          customeListTile(
              iconData: Icons.receipt_long,
              title: "Invoice#143241234",
              subtitle: "RoomA002",
              status: "Paid",
              trailing: "123.4"),
          // Add more items as needed
        ],
      ),
    ),
  );
}

Widget customeListTile(
    {required IconData iconData,
    required String title,
    required String subtitle,
    required String status,
    required String trailing}) {
  return ListTile(
    contentPadding: EdgeInsets.symmetric(horizontal: 4),
    leading: Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: Color(0xFFE4EFFB),
      ),
      child: Icon(
        iconData,
        size: 26,
      ),
    ),
    title: Text(
      title,
      style: TextStyle(fontWeight: FontWeight.w500),
    ),
    subtitle: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          subtitle,
          style: TextStyle(fontSize: 10),
        ),
        SizedBox(
          width: 4,
        ),
        Text(
          status,
          style: TextStyle(color: UniColor.green, fontSize: 10),
        ),
      ],
    ),
    trailing: Text(
      "\$${trailing}",
      style: TextStyle(
          fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black),
    ),
  );
}

Widget paymentStatusListTile(
    {required IconData iconData,
    required String title,
    required String subtitle,
    required String status,
    required String trailing}) {
  return ListTile(
    contentPadding: EdgeInsets.symmetric(horizontal: 4),
    leading: Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
      ),
      child: Icon(
        iconData,
        size: 26,
        color: Colors.redAccent,
      ),
    ),
    title: Text(
      title,
      style: TextStyle(fontWeight: FontWeight.w500),
    ),
    subtitle: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          subtitle,
          style: TextStyle(fontSize: 10),
        ),
        SizedBox(
          width: 4,
        ),
        Text(
          status,
          style: TextStyle(fontSize: 10),
        ),
      ],
    ),
    trailing: Text(
      "${trailing}",
      style: TextStyle(
          fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black),
    ),
  );
}
