import 'dart:convert';

import 'package:appwrite/appwrite.dart';

class _AppConstant {
  final String endpoint = "https://cloud.appwrite.io/v1";
  final String projectId = "REPLACE WITH PROJECT ID";
  final String functionId = "REPLACE WITH FUNCTION ID";
}

class ContentService {
  Client _client = Client();

  ContentService() {
    _init();
  }

  //initialize the application
  _init() async {
    _client
        .setEndpoint(_AppConstant().endpoint)
        .setProject(_AppConstant().projectId);

    //get current session
    Account account = Account(_client);

    try {
      await account.get();
    } on AppwriteException catch (e) {
      if (e.code == 401) {
        account
            .createAnonymousSession()
            .then((value) => value)
            .catchError((e) => e);
      }
    }
  }

  Future getContentType(String selectedType) async {
    Map<String, String> data = {"type": selectedType};
    Functions functions = Functions(_client);
    try {
      var result = await functions.createExecution(
        functionId: _AppConstant().functionId,
        headers: {'x-custom-type': jsonEncode(data)},
      );
      return result.responseBody;
    } catch (e) {
      throw Exception('Error creating subscription');
    }
  }
}
