class ValidatorHelper {
  static bool _isEmailValid(String email) {
    final emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
    return emailRegex.hasMatch(email);
  }

  static String? email(String? email) {
    if (email == null || email.isEmpty) {
      return 'Email is required';
    }
    if (!_isEmailValid(email)) {
      return 'Email format is invalid';
    }
    return null;
  }

  static String? password(String? password) {
    if (password == null || password.isEmpty) {
      return 'Password is required';
    }
    if (password.length < 6) {
      return 'Password must be 6 characters';
    }
    return null;
  }

  static String? question(String? question) {
    if (question == null || question.isEmpty) {
      return 'Question is required';
    }
    return null;
  }

  static String? answer(String? answer) {
    if (answer == null || answer.isEmpty) {
      return 'Answer is required';
    }
    return null;
  }
}
