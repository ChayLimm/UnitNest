import 'package:emonitor/domain/repository/repo.dart';
import 'package:flutter/material.dart';

class TelegramService {
  static TelegramService? _instance;

  final ApiRepository repository;
  TelegramService.internal(this.repository);

  ///
  ///initialize
  ///

  static void initialize(ApiRepository repository) {
    if (_instance == null) {
      _instance = TelegramService.internal(repository);
    } else {
      throw "TelegramService is already init";
    }
  }

  ///
  /// Single Ton
  ///

  static TelegramService get instance {
    if (_instance != null) {
      return _instance!;
    } else {
      throw "Telegram service must be init";
    }
  }

  ///
  /// Event handler
  ///

  void sendReceipt(String chat_id, String photo, String text) {
    final body = {
      "receipt": {"chat_id": chat_id, "photo": photo, "caption": text}
    };

    repository.post(
      'https://unitnest-api.vercel.app/telegram',
      headers: {'Content-Type': 'application/json'},
      body: body,
    );
  }

  void sendMesage(int chat_id, String text) {
    final body = {
      "flutter_call": {"chat_id": chat_id, "text": text}
    };

    repository.post(
      'https://unitnest-api.vercel.app/telegram',
      headers: {'Content-Type': 'application/json'},
      body: body,
    );
  }
}
