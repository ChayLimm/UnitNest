import 'package:emonitor/domain/model/Notification/notification.dart';
import 'package:emonitor/domain/model/building/room.dart';
import 'package:emonitor/domain/model/payment/payment.dart';
import 'package:emonitor/domain/model/payment/transaction.dart';
import 'package:emonitor/domain/model/stakeholder/landlord.dart';
import 'package:emonitor/domain/model/stakeholder/tenant.dart';
import 'package:emonitor/domain/model/system/priceCharge.dart';

void main(){

  //dummy data
    Tenant tenant = Tenant(identifyID: "11111", userName: "ChayLim", contact: "012345", deposit: 100, chatID: '');
    Room room = Room(name: "A001", price: 100);
    TransactionKHQR transaction = TransactionKHQR(qr: "QR13413241234", md5: "MD51341324123");
    Payment dummyData = Payment(tenant: tenant, room: room, deposit: 0, transaction: transaction, parkingAmount: 1, parkingFee: 1, hygiene: 1, totalPrice: 10);

 
   List<PriceCharge> priceChargeList =  [PriceCharge(electricityPrice: 1, waterPrice: 1, hygieneFee: 1, finePerDay: 1, fineStartOn: 1, rentParkingPrice: 1,startDate: DateTime.now())];
    LandlordSettings landlordSettings = LandlordSettings(
      bakongAccount: BakongAccount(bakongID: "chayd@acld.com", username: "Cheng ChayLim", location:"Phnom Penh"), 
      priceChargeList: priceChargeList,
      );
    Landlord landlord = Landlord(username: "ChayLim", phoneNumber: "012341234",settings: landlordSettings);

  // final register =  Notification(
  //   chatID: "1234124",
  //   systemID: "this is the id",
  //   dataType: NotificationType.registration,
  //   notifyData: NotifyRegistration(
  //     chatID: "chatID", 
  //     name: "name", 
  //     phone: "phonenumber", 
  //     idIdentification: "idIdentification", 
  //     registerOnDate: DateTime.now()
  //     )
  //   );

  //   final json = register.toJson();

  //   print(json['dataType']);

    // print(register.toJson());

    // final requestPayment = Notification(
    //   chatID: "Chatid", 
    //   systemID: "systemID", 
    //   dataType: NotificationType.paymentRequest,
    //   notifyData: NotifyPaymentRequest(
    //     requestDateOn: DateTime.now(), 
    //     water: 0, 
    //     electricity: 0, 
    //     waterAccuracy: 0, 
    //     electricityAccuracy: 0, 
    //     photo1URL: "photo1URL", 
    //     photo2URL: "photo2URL"
    //     )
    //   );
    // print(requestPayment.toJson()["dataType"]);

    Payment(
      parkingAmount: parkingAmount, 
      parkingFee: parkingFee, 
      hygiene: hygiene, 
      tenant: Tenant(chatID: chatID, identifyID: identifyID, userName: userName, contact: contact, deposit: deposit), 
      totalPrice: totalPrice, 
      room: Room(name: "A01", price: 1), 
      deposit: 1, 
      transaction: TransactionKHQR(qr: qr, md5: md5)
      )

   }