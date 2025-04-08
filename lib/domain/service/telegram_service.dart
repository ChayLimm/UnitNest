import 'package:emonitor/domain/repository/repo.dart';
import 'package:emonitor/global_url.dart';

class TelegramService {
  static TelegramService? _instance;

  final ApiRepository repository;
  TelegramService.internal(this.repository);

  ///
  ///initialize
  ///
  String url = "${global_url+"/telegram"}";

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

  Future<void> sendReceipt(String chat_id, String photo, String text)async {
    final body = {
      "receipt": {"chat_id": chat_id, "photo": photo, "caption": text}
    };

    await repository.post(
      url,//'https://unitnest-api.vercel.app/telegram',
      headers: {'Content-Type': 'application/json'},
      body: body,
    );
  }

  Future<void> sendMesage(int chat_id, String text) async{
    final body = {
      "flutter_call": {"chat_id": chat_id, "text": text}
    };

   await repository.post(
      url,//'https://unitnest-api.vercel.app/telegram',
      headers: {'Content-Type': 'application/json'},
      body: body,
    );
  }

  Future<void> sendReminder(int chat_id, String text)async{
    final body = {
      "reminder": {"chat_id": chat_id, "text": text}
    };

     await repository.post(
      url, //'https://unitnest-api.vercel.app/telegram',
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

  }
}
