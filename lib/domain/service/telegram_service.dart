import 'package:emonitor/domain/repository/repo.dart';
import 'package:flutter/material.dart';

class TelegramService {

  static TelegramService? _instance;

  final ApiRepository repository;
  TelegramService.internal(this.repository);

  ///
  ///initialize
  ///

  static void initialize(ApiRepository repository){
    if(_instance == null){
      _instance = TelegramService.internal(repository);
    }else{
      throw "TelegramService is already init";
    }
  }

  ///
  /// Single Ton
  /// 

  static TelegramService get instance {
    if(_instance != null){
      return _instance!;
    }else{
      throw "Telegram service must be init";
    }
  }

  ///
  /// Event handler
  /// 

  void sendMessageViaTelegramBot(String chat_id, NetworkImage photo, String text){
   final body = {
        "receipt": {
          "chat_id": chat_id,
          "photo": photo,
          "text": text
        }
      };

  repository.post(
    'https://unitnest-api.vercel.app/telegram',
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

  }
}