class RegExps {
  RegExp email = RegExp(r'(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$)');
  RegExp password = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#$&*~]).{8,}$');
  RegExp uppercase = RegExp('[A-Z]');
  RegExp lowercase = RegExp('[a-z]');
  RegExp number = RegExp('[0-9]');
  RegExp specialCharacter = RegExp(r'[!@#$&*~]');
  RegExp spacingTwoDigit = RegExp('.{2}');
  RegExp urlRegExp = RegExp(r'^(https?://)?([\w.-]+)\.([a-z.]{2,6})([/\w .-]*)*/?$');
}
