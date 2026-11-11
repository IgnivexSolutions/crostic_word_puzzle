import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LetterTile extends StatelessWidget {
  final String? letter;
  final int number;
  final bool isSelected;
  final bool isLinked; // Shares the same number as the currently selected cell
  final bool isSolved;
  final bool isSmall;
  final bool highContrast;
  final bool openApertures;
  final VoidCallback? onTap;

  const LetterTile({
    super.key,
    this.letter,
    required this.number,
    this.isSelected = false,
    this.isLinked = false,
    this.isSolved = false,
    this.isSmall = false,
    this.highContrast = false,
    this.openApertures = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final hasLetter = letter != null && letter!.isNotEmpty;
    final size = isSmall ? 32.0 : 36.0;

    // Crisp high-visibility styling
    Color backgroundColor;
    Color borderColor;
    Color textColor;
    Color bottomRimColor;
    double borderWidth;

    if (isSelected) {
      backgroundColor = const Color(0xFFFEF3C7); // Warm amber gold
      borderColor = const Color(0xFFD97706);
      borderWidth = highContrast ? 3.0 : 2.8;
      textColor = const Color(0xFF78350F);
      bottomRimColor = const Color(0xFFB45309);
    } else if (isLinked) {
      backgroundColor = const Color(0xFFFFFBEB); // Soft gold linkage
      borderColor = const Color(0xFFF59E0B);
      borderWidth = highContrast ? 2.6 : 2.0;
      textColor = const Color(0xFF92400E);
      bottomRimColor = const Color(0xFFD97706);
    } else if (isSolved) {
      backgroundColor = const Color(0xFFECFDF5); // Soft emerald solved
      borderColor = const Color(0xFF10B981);
      borderWidth = highContrast ? 2.4 : 1.8;
      textColor = const Color(0xFF065F46);
      bottomRimColor = const Color(0xFF059669);
    } else {
      backgroundColor = Colors.white;
      borderColor = highContrast ? const Color(0xFF0F172A) : const Color(0xFF94A3B8);
      borderWidth = highContrast ? 2.4 : 1.8;
      textColor = highContrast ? Colors.black : const Color(0xFF0F172A);
      bottomRimColor = highContrast ? const Color(0xFF0F172A) : const Color(0xFFCBD5E1);
    }

    // Dynamic Typography based on Open Apertures / Dyslexia setting
    TextStyle letterTextStyle;
    if (openApertures) {
      letterTextStyle = GoogleFonts.lexend(
        fontSize: isSmall ? 18.0 : 22.0,
        fontWeight: FontWeight.w800,
        letterSpacing: 1.5,
        color: textColor,
      );
    } else {
      letterTextStyle = GoogleFonts.spaceGrotesk(
        fontSize: isSmall ? 18.0 : 22.0,
        fontWeight: FontWeight.w700,
        color: textColor,
      );
    }

    // Number Badge Styling
    Color numBgColor;
    Color numTextColor;
    Border? numBorder;

    if (isSelected) {
      numBgColor = const Color(0xFFFDE68A);
      numTextColor = const Color(0xFF78350F);
      numBorder = Border.all(color: const Color(0xFFD97706), width: 1.0);
    } else if (isLinked) {
      numBgColor = const Color(0xFFFEF3C7);
      numTextColor = const Color(0xFF92400E);
      numBorder = Border.all(color: const Color(0xFFF59E0B), width: 1.0);
    } else if (isSolved) {
      numBgColor = const Color(0xFFD1FAE5);
      numTextColor = const Color(0xFF065F46);
      numBorder = Border.all(color: const Color(0xFFA7F3D0), width: 1.0);
    } else if (highContrast) {
      numBgColor = const Color(0xFF0F172A);
      numTextColor = Colors.white;
      numBorder = null;
    } else {
      numBgColor = const Color(0xFFF1F5F9);
      numTextColor = const Color(0xFF0F172A); // Boosted bold dark digit
      numBorder = Border.all(color: const Color(0xFFCBD5E1), width: 1.0);
    }

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        curve: Curves.easeOutQuad,
        width: size,
        margin: const EdgeInsets.symmetric(horizontal: 1.5, vertical: 1.5),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Letter Box with Crisp 3D Outline
            Container(
              height: size,
              width: size,
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: borderColor, width: borderWidth),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(isSelected ? 0.15 : 0.06),
                    blurRadius: isSelected ? 6.0 : 3.0,
                    offset: const Offset(0, 2),
                  ),
                  BoxShadow(
                    color: bottomRimColor,
                    offset: const Offset(0, 2.2),
                  ),
                ],
              ),
              child: Center(
                child: hasLetter
                    ? Text(
                        letter!.toUpperCase(),
                        style: letterTextStyle,
                      )
                    : isSelected
                        ? Container(
                            width: 2.5,
                            height: isSmall ? 18.0 : 22.0,
                            color: const Color(0xFFD97706),
                          )
                        : Text(
                            '?',
                            style: GoogleFonts.spaceGrotesk(
                              fontSize: isSmall ? 16.0 : 19.0,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF94A3B8),
                            ),
                          ),
              ),
            ),
            const SizedBox(height: 3.5),
            // Boosted Number Badge
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: isSmall ? 4.0 : 5.0,
                vertical: 1.5,
              ),
              decoration: BoxDecoration(
                color: numBgColor,
                borderRadius: BorderRadius.circular(4.5),
                border: numBorder,
              ),
              child: Text(
                '$number',
                style: GoogleFonts.jetBrainsMono(
                  fontSize: isSmall ? 11.5 : 13.0,
                  fontWeight: FontWeight.w900,
                  color: numTextColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
