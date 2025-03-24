import 'package:emonitor/domain/service/monthy_report_service.dart';
import 'package:emonitor/presentation/theme/theme.dart';
import 'package:flutter/material.dart';

class BreakDownTable extends StatelessWidget {
  final IncomeBreakDown icomeBreakDown;
  const BreakDownTable({super.key, required this.icomeBreakDown});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
        color: UniColor.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text(
              "More Details",
              style: UniTextStyles.label, // This remains unchanged as per your requirement
            ),
          ),
          DataTable(
            showCheckboxColumn: false,
            columnSpacing: 200,
            columns: [
               DataColumn(label: Text('Item', style: UniTextStyles.body)),
               DataColumn(label: Text('Amount', style: UniTextStyles.body)),
               DataColumn(label: Text('Price', style: UniTextStyles.body)),
               DataColumn(label: Text('Total', style: UniTextStyles.body)),
            ],
            rows: [
              DataRow(cells: [
                DataCell(Text('Parking', style: UniTextStyles.body)),
                DataCell(Text(icomeBreakDown.parkingAmount.toString(), style: UniTextStyles.body)),
                DataCell(Text('\$${icomeBreakDown.priceCharge.rentParkingPrice}', style: UniTextStyles.body)),
                DataCell(Text('\$${icomeBreakDown.parking}', style: UniTextStyles.body)),
              ]),
              DataRow(cells: [
                DataCell(Text('Fine', style: UniTextStyles.body)),
                DataCell(Text(icomeBreakDown.fineAmount.toString(), style: UniTextStyles.body)),
                DataCell(Text('\$${icomeBreakDown.priceCharge.finePerDay}', style: UniTextStyles.body)),
                DataCell(Text('\$${icomeBreakDown.fine}', style: UniTextStyles.body)),
              ]),
              DataRow(cells: [
                 DataCell(Text('Hygiene', style: UniTextStyles.body)),
                DataCell(Text(icomeBreakDown.hygieneAmount.toString(), style: UniTextStyles.body)),
                DataCell(Text('\$${icomeBreakDown.priceCharge.hygieneFee}', style: UniTextStyles.body)),
                DataCell(Text('\$${icomeBreakDown.hygiene}', style: UniTextStyles.body)),
              ]),
              DataRow(cells: [
                 DataCell(Text('Deposit', style: UniTextStyles.body)),
                DataCell(Text("${icomeBreakDown.depositAmount.toString()} rooms", style: UniTextStyles.body)),
                 DataCell(Text('---', style: UniTextStyles.body)),
                DataCell(Text('\$${icomeBreakDown.deposit}', style: UniTextStyles.body)),
              ]),
               DataRow(cells: [
                 DataCell(Text('Room', style: UniTextStyles.body)),
                DataCell(Text("${icomeBreakDown.paidRoom.toString()} rooms", style: UniTextStyles.body)),
                 DataCell(Text('---', style: UniTextStyles.body)),
                DataCell(Text('\$${icomeBreakDown.roomTotal}', style: UniTextStyles.body)),
              ]),
            ],
          ),
        ],
      ),
    );
  }
}