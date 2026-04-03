class AppValidators {
  AppValidators._();

  static String? phone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Telefon raqam kiritilishi shart';
    }
    // + belgisini olib tashlang (prefixText + qo'shadi)
    final clean = value.replaceAll('+', '').trim();
    if (!RegExp(r'^\d+$').hasMatch(clean)) {
      return 'Faqat raqam kiriting';
    }
    if (clean.length != 12) {
      return 'Telefon raqam 12 ta raqamdan iborat bo\'lishi kerak';
    }
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Parol kiritilishi shart';
    }
    if (value.length < 6) {
      return 'Parol kamida 6 ta belgidan iborat bo\'lishi kerak';
    }
    return null;
  }

  static String? fullName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Ism kiritilishi shart';
    }
    if (value.trim().length < 3) {
      return 'Ism kamida 3 ta belgidan iborat bo\'lishi kerak';
    }
    return null;
  }

  static String? required(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Bu maydon to\'ldirilishi shart';
    }
    return null;
  }
}