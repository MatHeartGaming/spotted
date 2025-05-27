import 'package:flutter/services.dart';

void smallVibration() {
  HapticFeedback.lightImpact();
}

void mediumVibration() {
  HapticFeedback.mediumImpact();
}

void hardVibration() {
  HapticFeedback.heavyImpact();
}
