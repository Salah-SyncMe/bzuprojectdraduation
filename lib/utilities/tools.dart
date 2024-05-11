import 'package:flutter/foundation.dart';

void printLog(msg) {
  if (kDebugMode) {
    print("BZU: $msg");
  }
}
