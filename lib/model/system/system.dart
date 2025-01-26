import 'package:emonitor/model/building/building.dart';
import 'package:emonitor/model/building/room.dart';
import 'package:emonitor/model/payment/payment.dart';
import 'package:emonitor/model/stakeholder/tenant.dart';
import 'package:emonitor/model/system/priceCharge.dart';
import 'package:json_annotation/json_annotation.dart';


@JsonSerializable(explicitToJson: true)
class System{
  final String id;
  List<Building> listBuilding;
  List<PriceCharge> priceChargeList;
  System({required this.id,required this.listBuilding, required this.priceChargeList});

  

  void registrationTenant(Tenant tenant, double deposit, Building buidling){
    //proccessPayment() (without consumption)
    //generate receipt
    //send receipt tenant's chatID via telegram bot
  }
  void sendMessageViaTelegramBot(String message, Tenant chatID){
    // reqeuest API in nodejss
  }
  void generateReceipt(Payment payment){
    // retrieve newConumption which newConumption's timestamp == payment.timestamp and the previoseConsumption is after newConumption timestamp
    // find package to generate reciept as png
  }
  void proccessPayment(String tenentID, Consumption? consumption,[bool lastpayment = false]){
    //firstPayment + deposit if tenant's deposit != roomPrice
    if(consumption == null){
      //calculate roomprice & rent parking if have
      //create and put Payment in the rooms and add to room.paymentList.add(newpayment)
      //generate receipt
      //update database (save receipt, save md5)
      //send receipt tenant's chatID via telegram bot
    }
    //normalPayment
    if(true){
      //calculate consumption && roomPrice, ParkingPrice, hygiene, literally everything in the price charge
      //create and put Payment in the rooms and add to room.paymentList.add(newpayment)
      //generate receipt
      //update database (save receipt, save md5)
      //send receipt tenant's chatID via telegram bot
    }
    //lastPayment
    if(lastpayment){
      //calculate only cosnumpt and hygiene
      //create and put Payment in the rooms and add to room.paymentList.add(newpayment)
      //generate receipt
      //update database (save receipt, save md5)
      //send receipt tenant's chatID via telegram bot
    }


    //sync with cloud
  }

  void addPriceCharge(PriceCharge pricecharge){
    // priceChargeList.last.endDate = DateTime.now();
    priceChargeList.add(pricecharge);
  }

  void checkTransStatus(Payment payment){
    // var md5 =  payment.transaction.md5;
    // prepare POST request with Dio 
    // check (reposone ?= null) true;
  }

  //CRUD Buidlings
  //CRUD Rooms
  //CRUD Tenants please use ID for all for of these

}