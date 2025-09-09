class ConstantsService {
  static const targetLanguages = ['th', 'vt'];
  static const languageNames = {
    'th': 'Thai',
    'vt': 'Vietnamese',
    'en': 'English',
  };

  static String languageName(String code) => languageNames[code] ?? 'Unknown';
}
