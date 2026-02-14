bool isEmailValid(String email) {
  const pattern = r'^[\w-]+(\.[\w-]+)*@([a-zA-Z0-9-]+\.)+[a-zA-Z]{2,7}$';
  final regex = RegExp(pattern);
  return regex.hasMatch(email);
}

bool isPasswordValid(String password) {
  const pattern = r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$';
  final regex = RegExp(pattern);
  return regex.hasMatch(password);
}

bool isNameValid(String name) {
  final usernameRegExp = RegExp(r'^[a-zA-Z0-9_]+$');
  return usernameRegExp.hasMatch(name) && name.isNotEmpty;
}

bool isPhoneNumberValid(String val) {
  return RegExp(r'^\+996 \(\d{3}\) \d{2}-\d{2}-\d{2}$').hasMatch(val);
}
