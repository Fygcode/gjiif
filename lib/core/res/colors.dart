import 'dart:ui';

class AppColor {
  // -------------------- Primary Colors --------------------
  static const Color primary = Color(0xFF86031F); // Deep Blue (enhanced for more trust)
  static const Color onPrimary = Color(0xFFFFFFFF); // White text on primary
  static const Color primaryContainer = Color(0xFF6A98D6); // Light Blue (for containers)
  static const Color onPrimaryContainer = Color(0xFF1A3E83); // Dark text for containers

  // -------------------- Secondary Colors --------------------
  static const Color secondary = Color(0xFFF4D175); // Rich Purple (for royalty)
  static const Color onSecondary = Color(0xFFFFFFFF); // White text on secondary
  static const Color secondaryContainer = Color(0xFFD8B1F4); // Light Purple for container
  static const Color onSecondaryContainer = Color(0xFF6B28D2); // Dark text for secondary container

  // -------------------- Tertiary Colors --------------------
  static const Color tertiary = Color(0xFFFCF4CB); // Gold Accent (Royal, premium)
  static const Color onTertiary = Color(0xFFFFFFFF); // White text on tertiary
  static const Color tertiaryContainer = Color(0xFFFFF4C2); // Soft Gold for containers
  static const Color onTertiaryContainer = Color(0xFFDAA520); // Dark text for tertiary container

  // -------------------- Neutral Colors --------------------
  static const Color background = Color(0xffFDF7DF); // Light, clean background
  static const Color onBackground = Color(0xFF2D3748); // Dark Text for contrast
  static const Color surface = Color(0xFFFFFFFF); // White Surface (clean and fresh)
  static const Color onSurface = Color(0xFF2D3748); // Dark Text on Surface

  static const Color surfaceVariant = Color(0xFFE9ECEF); // Light Grey Surface (for variation)
  static const Color onSurfaceVariant = Color(0xFF4A5568); // Darker Grey for contrast

  // -------------------- Feedback Colors --------------------
  static const Color error = Color(0xFFDC2626); // Red for Errors
  static const Color onError = Color(0xFFFFFFFF);
  static const Color errorContainer = Color(0xFFFECACA); // Light Red
  static const Color onErrorContainer = Color(0xFF7F1D1D);

  static const Color success = Color(0xFF22C55E); // Green for Success
  static const Color warning = Color(0xFFFACC15); // Yellow for Warnings
  static const Color info = Color(0xFF0EA5E9); // Info Blue

  static const Color grey = Color(0xFF787878); // Info Blue

  // -------------------- Borders and Dividers --------------------
  static const Color border = Color(0xFFD1D5DB); // Light Grey Border
  static const Color divider = Color(0xFFE5E7EB); // Divider Lines

  // -------------------- TextField Colors --------------------
  static const Color focusColor = Color(0xFF2563EB); // Blue Focus
  static const Color disabled = Color(0xFF9CA3AF); // Disabled Grey
  static const Color lightGrey = Color(0xFFF3F4F6); // Light Grey Background


  // -------------------- Gradient Colors --------------------
  static const List<Color> primaryGradient = [
    Color(0xFF3B82F6), // Blue Start
    Color(0xFF6B28D2), // Purple End
  ];

  static const List<Color> neutralGradient = [
    Color(0xFFF4F6FA), // Light Start
    Color(0xFFE9ECEF), // Light End
  ];

  // -------------------- Miscellaneous Colors --------------------
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);

  static const Color textPrimary = Color(0xFF581728);



  static const Color gradientGold1 = Color(0xFFE9A83D);
  static const Color gradientGold2 = Color(0xFFFFFFA6);

  static const Color gradient1 = Color(0xFFFFDF8A);
  static const Color gradient2 = Color(0xFFF8B500);

  static const Color gradient3 = Color(0xFFD9D9D9);
  static const Color gradient4 = Color(0xFFFAFAFA);

  static const Color shimmerBase = Color(0xFFE0E0E0); // Shimmer Loading Base
  static const Color shimmerHighlight = Color(0xFFF5F5F5); // Shimmer Highlight

  // -------------------- Elevation Shadow Colors --------------------
  static const Color shadowLight = Color(0x1A000000); // Light Shadow
  static const Color shadowDark = Color(0x33000000); // Dark Shadow
}
