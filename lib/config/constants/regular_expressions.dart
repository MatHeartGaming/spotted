final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

final passwordRegExp = RegExp(
  r'^(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{12,}$',
);

final hexColorRegExp = RegExp(r'^#(?:[0-9a-fA-F]{3}){1,2}(?:[0-9a-fA-F]{2})?$');

// Check if the VAT number has exactly 11 digits
final vatNumberRegex = RegExp(r'^\d{11}$');

// Phone Numbers
final RegExp phoneRegex = RegExp(r'^\+\d{1,3}\d{6,14}$');

// Zip Code
final zipCodeRegex = RegExp(r'^\d{5}(-\d{4})?$');
final civicNumberRegex = RegExp(r'^\d+[a-zA-Z]?$');

final emojiRegex = RegExp(
  r'[\u{1F600}-\u{1F64F}' // Emoticons
  r'\u{1F300}-\u{1F5FF}' // Symbols & Pictographs
  r'\u{1F680}-\u{1F6FF}' // Transport & Map Symbols
  r'\u{1F1E0}-\u{1F1FF}' // Flags (iOS)
  r'\u{2600}-\u{26FF}' // Miscellaneous Symbols
  r'\u{2700}-\u{27BF}' // Dingbats
  r'\u{FE00}-\u{FE0F}' // Variation Selectors
  r'\u{1F900}-\u{1F9FF}' // Supplemental Symbols and Pictographs
  r'\u{1F018}-\u{1F270}' // Various Asian characters
  r'\u{238C}-\u{2454}' // Misc items
  r'\u{1F000}-\u{1F02B}' // Mahjong tiles
  r'\u{1F0A0}-\u{1F0AE}' // Playing cards
  r'\u{1F004}' // Specific card
  r'\u{1F0CF}' // Specific card
  r'\u{1F3F3}\u{FE0F}\u{200D}\u{1F308}' // Rainbow flag
  r'\u{1F3F4}\u{200D}\u{2620}\u{FE0F}' // Pirate flag
  r']+',
  unicode: true,
);

// Allowed Paths

bool isGoingToAllowedPath(String path) {
  return true;
}

String removeEmojis(String input) {
  return input.replaceAll(emojiRegex, '');
}

bool isValidHexColor(String color) {
  return hexColorRegExp.hasMatch(color);
}

bool isValidPhoneNumber(String phoneNumber) {
  return phoneRegex.hasMatch(phoneNumber);
}

bool isEmailValid(String email) {
  return emailRegExp.hasMatch(email);
}
