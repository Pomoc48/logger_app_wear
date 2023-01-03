import 'dart:convert';

import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart';
import 'package:log_app_wear/functions.dart';
import 'package:log_app_wear/models/list.dart';

Future<Map> getToken() async {
  String? refreshToken = GetStorage().read("refreshToken");
  if (refreshToken == null) {
    return {"success": false};
  }

  Response response = await post(
    Uri.parse("https://loggerapp.lukawski.xyz/refresh/"),
    headers: {"Rtoken": refreshToken},
  );

  return loginResult(response: response);
}

Future<Map> getLists({required String token}) async {
  Response response = await makeRequest(
    url: "https://loggerapp.lukawski.xyz/lists/",
    headers: {"Token": token},
    type: RequestType.get,
  );

  if (response.statusCode == 403) {
    return await getLists(token: await renewToken());
  }

  dynamic decoded = jsonDecode(utf8.decode(response.bodyBytes));
  if (decoded == null) return {"data": [], "token": token};

  List<ListOfItems> lists = [];
  for (Map element in decoded) {
    lists.add(ListOfItems.fromMap(element));
  }

  return {"data": lists, "token": token};
}

Future<Map> loginResult({
  required Response response,
  bool save = false,
}) async {
  Map map = jsonDecode(utf8.decode(response.bodyBytes));

  if (response.statusCode == 200) {
    if (save) await GetStorage().write("refreshToken", map["refresh_token"]);
    return {"success": true, "token": map["token"]};
  }

  return {"success": false, "message": map["message"]};
}

Future<void> forgetSavedToken() async {
  await GetStorage().remove("refreshToken");
}
