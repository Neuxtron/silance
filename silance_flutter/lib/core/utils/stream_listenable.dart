import 'dart:async';

import 'package:flutter/material.dart';

class StreamListenable extends ChangeNotifier {
  late final StreamSubscription<dynamic> _sub;

  StreamListenable(Stream<dynamic> stream) {
    _sub = stream.listen((_) {
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}
