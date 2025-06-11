
String formatWithSuffix(int number) {
  if (number < 1000) return number.toString();

  const suffixes = ['K', 'M', 'B', 'T', 'P', 'E'];
  double value = number.toDouble();
  int suffixIndex = 0;

  // Scale down until we're below 1000, counting how many times
  while (value >= 1000 && suffixIndex < suffixes.length) {
    value /= 1000;
    suffixIndex++;
  }

  // suffixIndex is at least 1 here, so suffixes[suffixIndex-1] is safe
  String suffix = suffixes[suffixIndex - 1];

  // Show one decimal place if value<10 and not a whole number, otherwise no decimal
  String formatted;
  if (value < 10 && value != value.floor()) {
    formatted = value.toStringAsFixed(1);
  } else {
    formatted = value.toStringAsFixed(0);
  }

  return '$formatted$suffix+';
}

