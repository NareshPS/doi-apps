class ConstantsService {
  static const targetLanguages = ['th', 'vt'];
  static const languageNames = {
    'th': 'Thai',
    'vt': 'Vietnamese',
    'en': 'English',
  };

  static const subtitleSources = {
    'th': {
      'Thai': 'assets/subtitles/the.expanse.s06e06.babylons.ashes.th.srt',
      'English': 'assets/subtitles/the.expanse.s06e06.babylons.ashes.en.srt',
    },
    'vt': {
      'Vietnamese': 'assets/subtitles/the.expanse.s04e09.saeculum.vt.srt',
      'English': 'assets/subtitles/the.expanse.s04e09.saeculum.en.srt',
    },
  };

  static String languageName(String code) => languageNames[code] ?? 'Unknown';
}
