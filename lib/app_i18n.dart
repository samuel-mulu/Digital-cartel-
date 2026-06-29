import 'game_rules.dart';

enum AppLanguage { english, amharic, tigrinya }

class AppI18n {
  AppI18n(this.language);

  final AppLanguage language;

  static const Map<String, Map<AppLanguage, String>> _strings = {
    'app_name': {
      AppLanguage.english: 'FRIENDS BINGO',
      AppLanguage.amharic: 'ፍሬንድስ ቢንጎ',
      AppLanguage.tigrinya: 'ፍረንድስ ቢንጎ',
    },
    'friends_bingo_house': {
      AppLanguage.english: 'Friends Bingo House',
      AppLanguage.amharic: 'ፍሬንድስ ቢንጎ ቤት',
      AppLanguage.tigrinya: 'ፍሬንድስ ቢንጎ ቤት',
    },
    'splash_tagline': {
      AppLanguage.english: 'Play together · Win together',
      AppLanguage.amharic: 'አብረው ይጫወቱ · አብረው ይኩሩ',
      AppLanguage.tigrinya: 'ብሓባር ተጻወቱ · ብሓባር ተዓፉ',
    },
    'settings': {
      AppLanguage.english: 'Settings',
      AppLanguage.amharic: 'ቅንብሮች',
      AppLanguage.tigrinya: 'ቅንብራት',
    },
    'app_version': {
      AppLanguage.english: 'Version',
      AppLanguage.amharic: 'ስሪት',
      AppLanguage.tigrinya: 'ስሪት',
    },
    'language': {
      AppLanguage.english: 'Language',
      AppLanguage.amharic: 'ቋንቋ',
      AppLanguage.tigrinya: 'ቋንቋ',
    },
    'close': {
      AppLanguage.english: 'Close',
      AppLanguage.amharic: 'ዝጋ',
      AppLanguage.tigrinya: 'ዕጸው',
    },
    'sort_cards': {
      AppLanguage.english: 'Sort Cards',
      AppLanguage.amharic: 'ካርዶችን ደርድር',
      AppLanguage.tigrinya: 'ካርድታት ደርድር',
    },
    'choose_game_type': {
      AppLanguage.english: 'Choose Game Type',
      AppLanguage.amharic: 'የጨዋታ አይነት ይምረጡ',
      AppLanguage.tigrinya: 'ዓይነት ጸወታ ምረጽ',
    },
    'game_picker_search_hint': {
      AppLanguage.english: 'Search by № or Amharic name',
      AppLanguage.amharic: 'ቁጥር ወይም ስም ፈልግ',
      AppLanguage.tigrinya: 'ቁጽሪ ወይም ስም ድለይ',
    },
    'done': {
      AppLanguage.english: 'Done',
      AppLanguage.amharic: 'ተጠናቋል',
      AppLanguage.tigrinya: 'ተዛዚሙ',
    },
    'total_cards': {
      AppLanguage.english: 'Total Cards',
      AppLanguage.amharic: 'ጠቅላላ ካርዶች',
      AppLanguage.tigrinya: 'ጠቕላላ ካርድታት',
    },
    'cards': {
      AppLanguage.english: 'Cards',
      AppLanguage.amharic: 'ካርዶች',
      AppLanguage.tigrinya: 'ካርድታት',
    },
    'added': {
      AppLanguage.english: 'Added',
      AppLanguage.amharic: 'ተጨምሯል',
      AppLanguage.tigrinya: 'ተወሲኹ',
    },
    'removed': {
      AppLanguage.english: 'Removed',
      AppLanguage.amharic: 'ተወግዷል',
      AppLanguage.tigrinya: 'ተኣልዩ',
    },
    'no_cartelas_added': {
      AppLanguage.english: 'No Cartelas Added',
      AppLanguage.amharic: 'ምንም ካርዴላ አልተጨመረም',
      AppLanguage.tigrinya: 'ዝኾነ ካርቴላ ኣይተወሰኸን',
    },
    'add_cartela': {
      AppLanguage.english: 'Add Cartela',
      AppLanguage.amharic: 'ካርቴላ ጨምር',
      AppLanguage.tigrinya: 'ካርቴላ ወስኽ',
    },
    'search_cartela': {
      AppLanguage.english: 'Search Cartela',
      AppLanguage.amharic: 'ካርቴላ ፈልግ',
      AppLanguage.tigrinya: 'ካርቴላ ድለ',
    },
    'cancel': {
      AppLanguage.english: 'Cancel',
      AppLanguage.amharic: 'ሰርዝ',
      AppLanguage.tigrinya: 'ሰርዝ',
    },
    'confirm_restore': {
      AppLanguage.english: 'Confirm Restore',
      AppLanguage.amharic: 'መመለስን ያረጋግጡ',
      AppLanguage.tigrinya: 'ምምላስ ኣረጋግጽ',
    },
    'confirm_reset': {
      AppLanguage.english: 'Confirm Reset',
      AppLanguage.amharic: 'ዳግም ማስጀመርን ያረጋግጡ',
      AppLanguage.tigrinya: 'ዳግማይ ምጅማር ኣረጋግጽ',
    },
    'restore': {
      AppLanguage.english: 'Restore',
      AppLanguage.amharic: 'መልስ',
      AppLanguage.tigrinya: 'ምለስ',
    },
    'reset': {
      AppLanguage.english: 'Reset',
      AppLanguage.amharic: 'ዳግም አስጀምር',
      AppLanguage.tigrinya: 'ዳግማይ ጀምር',
    },
    'bingo': {
      AppLanguage.english: 'BINGO',
      AppLanguage.amharic: 'ቢንጎ',
      AppLanguage.tigrinya: 'ቢንጎ',
    },
    'one_away': {
      AppLanguage.english: 'one away!',
      AppLanguage.amharic: 'አንድ ቀርቷል!',
      AppLanguage.tigrinya: 'ሓደ ተሪፉ!',
    },
    'english': {
      AppLanguage.english: 'English',
      AppLanguage.amharic: 'English',
      AppLanguage.tigrinya: 'English',
    },
    'amharic': {
      AppLanguage.english: 'Amharic',
      AppLanguage.amharic: 'አማርኛ',
      AppLanguage.tigrinya: 'አማርኛ',
    },
    'tigrinya': {
      AppLanguage.english: 'Tigrinya',
      AppLanguage.amharic: 'ትግርኛ',
      AppLanguage.tigrinya: 'ትግርኛ',
    },
    'mixed_join': {
      AppLanguage.english: 'Mix Game',
      AppLanguage.amharic: 'ብሓባር ጸወታ',
      AppLanguage.tigrinya: 'ብሓባር ጸወታ',
    },
    'mixed_join_hint': {
      AppLanguage.english: 'Pick one mix preset (Mix 1–14).',
      AppLanguage.amharic: 'አንድ ብሓባር ጸወታ ይምረጡ (Mix 1–14)።',
      AppLanguage.tigrinya: 'ሓደ ብሓባር ጸወታ ምረጽ (Mix 1–14)።',
    },
    'mixed_join_summary_empty': {
      AppLanguage.english: 'Tap to pick mix games',
      AppLanguage.amharic: 'ለመምረጥ ይንኩ',
      AppLanguage.tigrinya: 'ንምረጽ ጠውቕ',
    },
    'mixed_join_show_panel': {
      AppLanguage.english: 'Show mix games',
      AppLanguage.amharic: 'ጨዋታዎች አሳይ',
      AppLanguage.tigrinya: 'ጸወታታት ኣርኢ',
    },
    'mixed_join_hide_panel': {
      AppLanguage.english: 'Hide mix games',
      AppLanguage.amharic: 'ጨዋታዎች ደብቅ',
      AppLanguage.tigrinya: 'ጸወታታት ሕብእ',
    },
    'mixed_join_exit': {
      AppLanguage.english: 'Leave mix game',
      AppLanguage.amharic: 'ከብሓባር ጸወታ ውጣ',
      AppLanguage.tigrinya: 'ካብ ብሓባር ጸወታ ውጻእ',
    },
    'mixed_join_reset': {
      AppLanguage.english: 'Clear selected mix preset',
      AppLanguage.amharic: 'የተመረጠውን ብሓባር ጸወታ አጽዳ',
      AppLanguage.tigrinya: 'ዝተመረጸ ብሓባር ጸወታ ኣጽርይ',
    },
    'game_picker_reset_all': {
      AppLanguage.english: 'Reset all game choices',
      AppLanguage.amharic: 'ሁሉንም ምርጫዎች አጽዳ',
      AppLanguage.tigrinya: 'ኩሉ ምርጫታት ኣጽርይ',
    },
    'mixed_join_show_counts': {
      AppLanguage.english: 'Show count',
      AppLanguage.amharic: 'ቆጠራ አሳይ',
      AppLanguage.tigrinya: 'ቑጠራ ኣርኢ',
    },
    'mixed_join_hide_counts': {
      AppLanguage.english: 'Hide count',
      AppLanguage.amharic: 'ቆጠራ ደብቅ',
      AppLanguage.tigrinya: 'ቑጠራ ሕብእ',
    },
    'mixed_join_invalid_big_big': {
      AppLanguage.english: 'BIG games cannot be combined together',
      AppLanguage.amharic: 'BIG ጨዋታዎች አንድ ላይ ሊገናኙ አይችሉም',
      AppLanguage.tigrinya: 'BIG ጸወታታት ኣብ ሓደ ክተኣክቡ ኣይክእሉን',
    },
    'mixed_join_invalid_right_big': {
      AppLanguage.english: 'RIGHT Shape cannot combine with BIG games',
      AppLanguage.amharic: 'RIGHT Shape ከ BIG ጨዋታዎች ጋር ሊገናኝ አይችልም',
      AppLanguage.tigrinya: 'RIGHT Shape ምስ BIG ጸወታታት ክተኣክብ ኣይክእልን',
    },
    'mixed_join_min_games': {
      AppLanguage.english: 'Select at least 1 game',
      AppLanguage.amharic: 'ቢያንስ 1 ጨዋታ ይምረጡ',
      AppLanguage.tigrinya: 'ድሮ 1 ጸወታ ምረጽ',
    },
    'mixed_join_pick_preset': {
      AppLanguage.english: 'Tap a mix preset below to play',
      AppLanguage.amharic: 'ለመጫወት ከታች Mix ይምረጡ',
      AppLanguage.tigrinya: 'ንምጻወት ኣብ ታሕቲ Mix ምረጽ',
    },
    'mix_preset_01': {
      AppLanguage.english: 'Row + Column + Diagonal',
      AppLanguage.amharic: 'ዝደቀሰ + ደው ዝበለ + ዲያጎናል',
      AppLanguage.tigrinya: 'ረድፍ + ዓምዲ + ኣራት ማእዘን',
    },
    'mix_preset_02': {
      AppLanguage.english: 'Column + Row',
      AppLanguage.amharic: 'ደው ዝበለ + ዝደቀሰ',
      AppLanguage.tigrinya: 'ዓምዲ + ረድፍ',
    },
    'mix_preset_03': {
      AppLanguage.english: 'Diagonal + 2 small L',
      AppLanguage.amharic: 'ዲያጎናል + 2 ንእሽተይ ኤል',
      AppLanguage.tigrinya: 'ኣራት ማእዘን + 2 ንእሽቶ L',
    },
    'mix_preset_04': {
      AppLanguage.english: '2 Diagonal + Row',
      AppLanguage.amharic: '2 ዲያጎናል + ዝደቀሰ',
      AppLanguage.tigrinya: '2 ኣራት ማእዘን + ረድፍ',
    },
    'mix_preset_05': {
      AppLanguage.english: 'BIG T + Square',
      AppLanguage.amharic: 'ዓባይ T + ስኬር',
      AppLanguage.tigrinya: 'BIG T + ካሬ',
    },
    'mix_preset_06': {
      AppLanguage.english: 'small T + Square',
      AppLanguage.amharic: 'ንእሽተይ T + ስኬር',
      AppLanguage.tigrinya: 'ንእሽቶ T + ካሬ',
    },
    'mix_preset_07': {
      AppLanguage.english: 'BIG T + Diagonal',
      AppLanguage.amharic: 'ዓባይ T + ዲያጎናል',
      AppLanguage.tigrinya: 'BIG T + ኣራት ማእዘን',
    },
    'mix_preset_08': {
      AppLanguage.english: 'small T + Diagonal',
      AppLanguage.amharic: 'ንእሽተይ T + ዲያጎናል',
      AppLanguage.tigrinya: 'ንእሽቶ T + ኣራት ማእዘን',
    },
    'mix_preset_09': {
      AppLanguage.english: 'Cross + Square + small L',
      AppLanguage.amharic: 'መስቀል + ስኬር + ንእሽተይ ኤል',
      AppLanguage.tigrinya: 'Cross + ካሬ + ንእሽቶ L',
    },
    'mix_preset_10': {
      AppLanguage.english: 'small O + Line',
      AppLanguage.amharic: 'ንእሽተይ O + መስመር',
      AppLanguage.tigrinya: 'ንእሽቶ O + መስመር',
    },
    'mix_preset_11': {
      AppLanguage.english: '2 Lines + Square',
      AppLanguage.amharic: '2 መስመር + ስኬር',
      AppLanguage.tigrinya: '2 መስመር + ካሬ',
    },
    'mix_preset_12': {
      AppLanguage.english: 'Pyramid + Line',
      AppLanguage.amharic: 'ፒራሚድ + መስመር',
      AppLanguage.tigrinya: 'Pyramid + መስመር',
    },
    'mix_preset_13': {
      AppLanguage.english: 'RIGHT + Square',
      AppLanguage.amharic: 'ራይት + ስኬር',
      AppLanguage.tigrinya: 'RIGHT + ካሬ',
    },
    'mix_preset_14': {
      AppLanguage.english: 'BIG L + small L',
      AppLanguage.amharic: 'ዓባይ L + ንእሽተይ ኤል',
      AppLanguage.tigrinya: 'BIG L + ንእሽቶ L',
    },
    'mixed_join_invalid_excluded': {
      AppLanguage.english: 'This game cannot be used in mixed join',
      AppLanguage.amharic: 'ይህ ጨዋታ በየተደራጁ ጨዋታ መጠቀም አይችልም',
      AppLanguage.tigrinya: 'እዚ ጸወታ ኣብ ዝተወሃሃደ ጸወታ ክውዕል ኣይክእልን',
    },
    'mixed_join_max_games': {
      AppLanguage.english: 'Mix game allows at most 3 games',
      AppLanguage.amharic: 'ብሓባር ጨዋታ ከፍተኛ 3 ጨዋታዎችን ይፈቅዳል',
      AppLanguage.tigrinya: 'ብሓባር ጸወታ ዝለዓለ 3 ጸወታታት ይፈቅድ',
    },
    'mixed_join_invalid_limited_limited': {
      AppLanguage.english:
          'small X, small H, Pyramid, and 4×4 triangle cannot be combined together',
      AppLanguage.amharic:
          'small X, small H, Pyramid እና 4×4 triangle አንድ ላይ ሊገናኙ አይችሉም',
      AppLanguage.tigrinya:
          'small X, small H, Pyramidን 4×4 triangle ኣብ ሓደ ክተኣክቡ ኣይክእሉን',
    },
    'mixed_join_invalid_shape_anchor_max': {
      AppLanguage.english:
          'With BIG, RIGHT, small X, small H, Pyramid, or 4×4 triangle, pick only one other game (2 total)',
      AppLanguage.amharic:
          'ከ BIG, RIGHT, small X/H, Pyramid, 4×4 triangle ጋር አንድ ብቻ ሌላ ጨዋታ (ጠቅላላ 2)',
      AppLanguage.tigrinya:
          'ምስ BIG, RIGHT, small X/H, Pyramid, 4×4 triangle ሓደ ሌላ ጸወታ ብቻ (ድምር 2)',
    },
    'mixed_join_invalid_limited_big': {
      AppLanguage.english:
          'small X, small H, Pyramid, and 4×4 triangle cannot mix with BIG games',
      AppLanguage.amharic:
          'small X, small H, Pyramid, 4×4 triangle ከ BIG ጨዋታዎች ጋር ሊጣመሩ አይችሉም',
      AppLanguage.tigrinya:
          'small X, small H, Pyramid, 4×4 triangle ምስ BIG ጸወታታት ክተሓሓቑ ኣይክእሉን',
    },
    'game_manual': {
      AppLanguage.english: 'Manual',
      AppLanguage.amharic: 'ብኢድ',
      AppLanguage.tigrinya: 'ብኢድ',
    },
    'game_full_house': {
      AppLanguage.english: 'FULL-HOUSE',
      AppLanguage.amharic: 'ሙሉእ ገዛ',
      AppLanguage.tigrinya: 'ሙሉእ ገዛ',
    },
    'game_line': {
      AppLanguage.english: 'Line',
      AppLanguage.amharic: 'መስመር',
      AppLanguage.tigrinya: 'መስመር',
    },
    'game_columns': {
      AppLanguage.english: 'Columns',
      AppLanguage.amharic: 'ደው ዝበለ',
      AppLanguage.tigrinya: 'ደው ዝበለ',
    },
    'game_rows': {
      AppLanguage.english: 'Rows',
      AppLanguage.amharic: 'ዝደቀሰ',
      AppLanguage.tigrinya: 'ዝደቀሰ',
    },
    'game_diagonal': {
      AppLanguage.english: 'Diagonal',
      AppLanguage.amharic: 'ዲያጎናል',
      AppLanguage.tigrinya: 'ዲያጎናል',
    },
    'game_line_touches_free': {
      AppLanguage.english: 'Line touches free',
      AppLanguage.amharic: 'ፍሪ ዝነኽእ መስመር',
      AppLanguage.tigrinya: 'ፍሪ ዝነኽእ መስመር',
    },
    'game_lines_without_free': {
      AppLanguage.english: 'Lines without free',
      AppLanguage.amharic: 'ፍሪ ዘይነክእ መስመራት',
      AppLanguage.tigrinya: 'ፍሪ ዘይነክእ መስመራት',
    },
    'game_square': {
      AppLanguage.english: 'Square',
      AppLanguage.amharic: 'ስኬር',
      AppLanguage.tigrinya: 'ስኬር',
    },
    'game_rectangle': {
      AppLanguage.english: 'Rectangle',
      AppLanguage.amharic: 'ሬክታንግል',
      AppLanguage.tigrinya: 'ሬክታንግል',
    },
    'game_triangle_3x3': {
      AppLanguage.english: '3 by 3 triangle',
      AppLanguage.amharic: '3 ብ 3 ትርያንግል',
      AppLanguage.tigrinya: '3 ብ 3 ትርያንግል',
    },
    'game_triangle_4x4': {
      AppLanguage.english: '4 by 4 triangle',
      AppLanguage.amharic: '4 ብ 4 ትርያንግል',
      AppLanguage.tigrinya: '4 ብ 4 ትርያንግል',
    },
    'game_pyramid': {
      AppLanguage.english: 'Pyramid',
      AppLanguage.amharic: 'ፒራሚድ',
      AppLanguage.tigrinya: 'ፒራሚድ',
    },
    'game_big_l': {
      AppLanguage.english: 'BIG L Shape',
      AppLanguage.amharic: 'ዓባይ L',
      AppLanguage.tigrinya: 'ዓባይ L',
    },
    'game_big_t': {
      AppLanguage.english: 'BIG T',
      AppLanguage.amharic: 'ዓባይ T',
      AppLanguage.tigrinya: 'ዓባይ T',
    },
    'game_big_h': {
      AppLanguage.english: 'BIG H',
      AppLanguage.amharic: 'ዓባይ H',
      AppLanguage.tigrinya: 'ዓባይ H',
    },
    'game_big_n': {
      AppLanguage.english: 'BIG N',
      AppLanguage.amharic: 'ዓባይ N',
      AppLanguage.tigrinya: 'ዓባይ N',
    },
    'game_big_y': {
      AppLanguage.english: 'BIG Y',
      AppLanguage.amharic: 'ዓባይ Y',
      AppLanguage.tigrinya: 'ዓባይ Y',
    },
    'game_big_cross': {
      AppLanguage.english: 'BIG Cross',
      AppLanguage.amharic: 'ዓባይ መስቀል',
      AppLanguage.tigrinya: 'ዓባይ መስቀል',
    },
    'game_right': {
      AppLanguage.english: 'RIGHT',
      AppLanguage.amharic: 'ራይት',
      AppLanguage.tigrinya: 'ራይት',
    },
    'game_small_t_x': {
      AppLanguage.english: 'Small T and X shape',
      AppLanguage.amharic: 'ንእሽቶ T ምስ X',
      AppLanguage.tigrinya: 'ንእሽቶ T ምስ X',
    },
    'game_small_t': {
      AppLanguage.english: 'Small T',
      AppLanguage.amharic: 'ንእሽቶ T',
      AppLanguage.tigrinya: 'ንእሽቶ T',
    },
    'game_small_x': {
      AppLanguage.english: 'Small X',
      AppLanguage.amharic: 'ንእሽቶ X',
      AppLanguage.tigrinya: 'ንእሽቶ X',
    },
    'game_small_h': {
      AppLanguage.english: 'Small H',
      AppLanguage.amharic: 'ንእሽቶ H',
      AppLanguage.tigrinya: 'ንእሽቶ H',
    },
    'game_small_cross': {
      AppLanguage.english: 'Small + (cross)',
      AppLanguage.amharic: 'ንእሽቶ + (መስቀል)',
      AppLanguage.tigrinya: 'ንእሽቶ + (መስቀል)',
    },
    'game_small_l': {
      AppLanguage.english: 'Small L',
      AppLanguage.amharic: 'ንእሽቶ L',
      AppLanguage.tigrinya: 'ንእሽቶ L',
    },
    'game_half_house': {
      AppLanguage.english: 'Half House',
      AppLanguage.amharic: 'ፍርቂ ገዛ',
      AppLanguage.tigrinya: 'ፍርቂ ገዛ',
    },
    'game_small_o': {
      AppLanguage.english: 'Small O',
      AppLanguage.amharic: 'ንእሽቶ O',
      AppLanguage.tigrinya: 'ንእሽቶ O',
    },
    'game_mixed_join': {
      AppLanguage.english: 'Mix Game',
      AppLanguage.amharic: 'ብሓባር ጸወታ',
      AppLanguage.tigrinya: 'ብሓባር ጸወታ',
    },
    'mixed_join_prefix': {
      AppLanguage.english: 'Mixed',
      AppLanguage.amharic: 'የተደራጁ',
      AppLanguage.tigrinya: 'ዝተወሃሃደ',
    },
  };

  /// Maps stable internal [GameRule.name] values to i18n keys.
  static const Map<String, String> gameNameToI18nKey = {
    'Manual': 'game_manual',
    'FULL-HOUSE': 'game_full_house',
    'line': 'game_line',
    'Columns': 'game_columns',
    'Rows': 'game_rows',
    'Diagonal': 'game_diagonal',
    'LIne touches free': 'game_line_touches_free',
    'lines with out free': 'game_lines_without_free',
    'Square': 'game_square',
    'Rectangule': 'game_rectangle',
    '2 triangle': 'game_triangle_3x3',
    '4 by 4 triangle': 'game_triangle_4x4',
    'Pyramid': 'game_pyramid',
    'BIG L Shape': 'game_big_l',
    'BIG T': 'game_big_t',
    'BIG H': 'game_big_h',
    'BIG N': 'game_big_n',
    'BIG Y': 'game_big_y',
    'BIG Cross': 'game_big_cross',
    'RIGHT Shape': 'game_right',
    'small T shape and X shape': 'game_small_t_x',
    'small T': 'game_small_t',
    'small X': 'game_small_x',
    'small H': 'game_small_h',
    'small + (cross)': 'game_small_cross',
    'small L': 'game_small_l',
    'Half House': 'game_half_house',
    'small O': 'game_small_o',
    'Mixed Join': 'game_mixed_join',
  };

  String t(String key) {
    final entry = _strings[key];
    if (entry == null) return key;
    return entry[language] ?? entry[AppLanguage.english] ?? key;
  }

  String gameDisplayName(String internalRuleName) {
    final preset = staticMixPresetById(internalRuleName);
    if (preset != null) {
      return t(preset.i18nKey);
    }
    final key = gameNameToI18nKey[internalRuleName];
    if (key == null) return internalRuleName;
    return t(key);
  }

  static String catalogDisplayName(String internalRuleName) {
    return gameDisplayNameFor(AppLanguage.amharic, internalRuleName);
  }

  static String gameDisplayNameFor(
    AppLanguage language,
    String internalRuleName,
  ) {
    return AppI18n(language).gameDisplayName(internalRuleName);
  }

  /// Amharic-only label for the game catalog and status card.
  String gameDisplayNameBilingual(String internalRuleName) {
    return catalogDisplayName(internalRuleName);
  }

  /// Amharic-only label for narrow catalog layouts.
  String gameDisplayNameBilingualLines(String internalRuleName) {
    return catalogDisplayName(internalRuleName);
  }

  String gameCatalogListLabel(int catalogIndex, String internalRuleName) {
    return '$catalogIndex. ${catalogDisplayName(internalRuleName)}';
  }

  String gameCatalogListLabelLines(int catalogIndex, String internalRuleName) {
    return '$catalogIndex.\n${catalogDisplayName(internalRuleName)}';
  }
}

