bool isEmailValid(String email) {
  // Regular expression pattern to validate email addresses
  const pattern = r'^[\w-]+(\.[\w-]+)*@([a-zA-Z0-9-]+\.)+[a-zA-Z]{2,7}$';

  // Create a RegExp object with the pattern
  final regex = RegExp(pattern);

  // Use the RegExp object to match the email against the pattern
  return regex.hasMatch(email);
}

bool isPasswordValid(String password) {
  // Regular expression pattern to validate passwords
  const pattern = r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$';

  // Create a RegExp object with the pattern
  final regex = RegExp(pattern);

  // Use the RegExp object to match the password against the pattern
  return regex.hasMatch(password);
}

bool isNameValid(String name) {
  final usernameRegExp = RegExp(r'^[a-zA-Z0-9_]+$');
  return usernameRegExp.hasMatch(name) && name.isNotEmpty;
}

bool isPhoneNumberValid(String val) {
  return RegExp(r'^\+996 \(\d{3}\) \d{2}-\d{2}-\d{2}$').hasMatch(val);
}
