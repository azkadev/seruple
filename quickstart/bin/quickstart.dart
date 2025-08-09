
import 'dart:io';

import 'package:seruple/core/core.dart' show Seruple;
 

Future<String> ask({
  required String text,
}) async {
  while (true) {
    print("");

    stdout.write("${text}?: ");
    // print("${text}?: ");
    final String? input = stdin.readLineSync();
    if (input != null && input.trim().isNotEmpty) {
      return input.trim();
    }
  }
}

void main(List<String> args) async {
  print("start");
  final Seruple seruple = Seruple();

  seruple.ensureInitialized();

  // atur log menjadi 0
  // karena tidak mungkin akan log di production mode
  //
  seruple.invokeSync({
    "@type": "setLogVerbosityLevel",
    "new_verbosity_level": 0,
  });

  seruple.on("update", (Map update) async {
    print(update);
  });
 

  await seruple.initialized();
  print("program started");
  final newClientId = seruple.createClient();

  await seruple.invoke({
    "@type": "getAuthorizationState",
    "@client_id": newClientId,
  });
}

