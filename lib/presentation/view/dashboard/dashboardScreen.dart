import 'package:emonitor/domain/model/building/building.dart';
import 'package:emonitor/domain/model/building/room.dart';
import 'package:emonitor/domain/model/payment/payment.dart';
import 'package:emonitor/domain/model/payment/transaction.dart';
import 'package:emonitor/domain/model/stakeholder/tenant.dart';
import 'package:emonitor/domain/service/room_service.dart';
import 'package:emonitor/presentation/Provider/Setting/setting_provider.dart';
import 'package:emonitor/presentation/Provider/main/monthly_report_provider.dart';
import 'package:emonitor/presentation/Provider/main/room_provider.dart';
import 'package:emonitor/presentation/theme/theme.dart';
import 'package:emonitor/presentation/view/MonthlyReport/widget/income_break_down.dart';
import 'package:emonitor/presentation/view/dashboard/widget/Invoice_list.dart';
import 'package:emonitor/presentation/view/dashboard/widget/dashboardWidget.dart';
import 'package:emonitor/presentation/view/dashboard/widget/unpaid_list.dart';
import 'package:emonitor/presentation/widgets/button/button.dart';
import 'package:emonitor/presentation/widgets/component.dart';
import 'package:emonitor/presentation/widgets/payment/payment_diaglog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});



  @override
  Widget build(BuildContext context) {
    DateTime todayDate = DateTime.now();
    String formattedDate = DateFormat('MMMM dd, yyyy').format(todayDate);
    String dayOfWeek = DateFormat('EEEE').format(todayDate);

    final roomProvider = context.read<RoomProvider>();
    roomProvider.refreshRoomsPayment();

    return Consumer3<MonthlyReportProvider, SettingProvider, RoomProvider>(
      builder: (context, reportProvider, settingProvider, roomProvider, child) {
        ///
        /// Render data
        ///
        List<Room> availableRoom = [];
        List<Room> unpaidRoom = [];
        List<Room> pendingRoom = [];
        List<Room> paidRoom = [];

        // print("##########rebuild dasboard");

        for (Building building in settingProvider.repository.rootData!.listBuilding) {
          // Fetch available rooms and add to availableRoom list
          List<Room> availableRooms = RoomService.instance.availableRoom(building: building, dateTime: DateTime.now()) ?? [];
          availableRoom.addAll(availableRooms);

          // Fetch unpaid rooms and add to unpaidRoom list
          List<Room> unpaidRooms = RoomService.instance.unPaid(building: building, dateTime: DateTime.now());
          unpaidRoom.addAll(unpaidRooms);

          // Fetch pending rooms and add to pendingRoom list
          List<Room> pendingRooms = RoomService.instance.pending(building: building, dateTime: DateTime.now());
          pendingRoom.addAll(pendingRooms);

          // Fetch paid rooms and add to paidRoom list
          List<Room> paidRooms = RoomService.instance.paid(building: building, dateTime: DateTime.now());
          paidRoom.addAll(paidRooms);
        }

        return Scaffold(
          backgroundColor: UniColor.backGroundColor,
          body: Stack(
            children: [
             
              RefreshIndicator(
                onRefresh: () async {
                    roomProvider.refreshRoomsPayment();
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(), // Ensure it's always scrollable
                  child: Container(
                    color: UniColor.backGroundColor,
                    padding: const EdgeInsets.only(top: 20, left: 10, right: 40),
                    child: Column(
                      children: [
                        // Top section
                        _buildHeader(
                          context,
                          settingProvider.landlord.username,
                          settingProvider.landlord.phoneNumber,
                          formattedDate,
                          dayOfWeek,
                        ),
                        // Dashboard content
                        IncomeCard(data: reportProvider.getIncome()),
                        const SizedBox(height: 10),
                        Column(
                          children: [
                            // Income graph and its breakdown
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.15,
                              child: GridView.count(
                                physics: const NeverScrollableScrollPhysics(), // Disable GridView scrolling
                                shrinkWrap: true,
                                crossAxisCount: 4,
                                crossAxisSpacing: 10,
                                childAspectRatio: 2.2,
                                children: [
                                  buildPaymentStatusCard("Available", availableRoom.length),
                                  buildPaymentStatusCard("Unpaid", unpaidRoom.length, UniColor.red),
                                  buildPaymentStatusCard("Pending", pendingRoom.length, UniColor.yellow),
                                  buildPaymentStatusCard("Paid", paidRoom.length, UniColor.green),
                                ],
                              ),
                            ),
                            // The list of invoice and unpaid
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: UniColor.white,
                                    ),
                                    child: const InvoiceList(),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: UniColor.white,
                                    ),
                                    child: const UnpaidList(),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
               if (roomProvider.isLoading) ...[
                loading(),
              ],
            ],
          ),
        );
      },
    );
  }
}
// in this screen i have used the following widgets
// 1. buildHeader (in this file)
// 2. customFloatingButton (from component.dart)
// 3. buildBuildingPaymentSummary[line 18] (from dashboardwidget.dart)
// 4. buildBreakdownCard [line 48](from dashboardwidget.dart)
// 5. buildPaymentStatusCard [line 97](from dashboardwidget.dart)
// 6. invoice[line 152] (from dashboardwidget.dart)
// 7. listUnpaid[line 217] (from dashboardwidget.dart)


// the header of the dashboard
Widget _buildHeader(BuildContext context,String username, String phoneNumber, String formattedDate,String dayOfWeek) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Profile Information
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text("Hello, ",style: UniTextStyles.label),
                Text(username,style: UniTextStyles.label),

            ],),
            Text(phoneNumber,style:  UniTextStyles.body.copyWith(color: UniColor.neutral)),
          ],
        ),

        // Date Information
        Column(
          children: [
            Text(formattedDate,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            Text(dayOfWeek,
                style: const TextStyle(color: Colors.grey, fontSize: 12)),
          ],
        ),
        UniButton(context: context, label: "test", trigger: (){
          final roomProvider=context.read<RoomProvider>();
          ///tennat sample
          Tenant sampleTenant = Tenant(chatID: "1065582966", identifyID: "0123465", userName: "Cheng ChayLim", contact: "0853242343", deposit: 100);//1065582966 lim
          // Room? roomTenant = FinderService.instance.getRoomWithChatID("1065582966"); //lim
          final roomTenant = Room(name: "A003", price: 100,tenant: sampleTenant,roomStatus: Availibility.taken);
          roomTenant.consumptionList.add(Consumption(waterMeter: 250, electricityMeter: 2115,timestamp: DateTime(DateTime.now().year, DateTime.now().month - 1, DateTime.now().day)));
          roomTenant.paymentList.add(Payment(timeStamp: DateTime(2025, 3, 6),roomPrice: 100, parkingAmount: 0, parkingFee: 0, hygiene: 1, tenantChatID:  "1065582966", totalPrice: 120, roomID: roomTenant.id, deposit: 100, transaction: TransactionKHQR(qr: "kk",md5: "fdd")));
          roomProvider.repository.rootData!.listBuilding.first.roomList.add(roomTenant);
          
          // print(roomTenant.consumptionList.last.waterMeter);
          // roomProvider.repository.rootData!.listBuilding.first.roomList.add(roomTenant);
          // roomProvider.repository.rootData!.listBuilding.first.roomList.first.consumptionList.add(Consumption(waterMeter: 100, electricityMeter: 100,timestamp: DateTime(DateTime.now().year, DateTime.now().month - 1, DateTime.now().day)));
          // roomProvider.repository.rootData!.listBuilding.first.roomList.first.tenant = sampleTenant;
          // roomProvider.repository.rootData!.listBuilding.first.roomList.first.roomStatus = Availibility.taken;
          // print();
        }, buttonType: ButtonType.tertiary)
        ,
        UniButton(context: context, 
        label: "Make Payment", 
        trigger: ()async{
          bool isPaid = await showDialog(
              context: context,
              builder: (context) =>  PaymentDialog(),
            );

          if(isPaid){
            showCustomSnackBar(context, message: "Payment Successfully", backgroundColor: UniColor.green);
          }else{
            showCustomSnackBar(context, message: "Payment failed", backgroundColor: UniColor.red);

          }

        }, 
        buttonType: ButtonType.primary
        )
      ],
    ),
  );
}
