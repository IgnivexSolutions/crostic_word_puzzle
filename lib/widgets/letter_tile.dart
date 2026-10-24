import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LetterTile extends StatelessWidget {
  final String? letter;
  final int number;
  final bool isSelected;
  final bool isLinked; // Shares the same number as the currently selected cell
  final bool isSolved;
  final bool isSmall;
  final VoidCallback? onTap;

  const LetterTile({
    super.key,
    this.letter,
    required this.number,
    this.isSelected = false,
    this.isLinked = false,
    this.isSolved = false,
    this.isSmall = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final hasLetter = letter != null && letter!.isNotEmpty;
    final size = isSmall ? 30.0 : 34.0;

    // Color states matching the screenshot
    Color backgroundColor;
    Color borderColor;
    Color textColor;
    double borderWidth = 1.2;

    if (isSelected) {
      backgroundColor = const Color(0xFFFEF3C7); // Warm amber gold
      borderColor = const Color(0xFFD97706);
      borderWidth = 2.2;
      textColor = const Color(0xFF78350F);
    } else if (isLinked) {
      backgroundColor = const Color(0xFFFFFBEB); // Soft gold linkage
      borderColor = const Color(0xFFF59E0B);
      borderWidth = 1.8;
      textColor = const Color(0xFF92400E);
    } else if (isSolved) {
      backgroundColor = const Color(0xFFECFDF5); // Soft emerald solved
      borderColor = const Color(0xFFA7F3D0);
      textColor = const Color(0xFF065F46);
    } else {
      backgroundColor = Colors.white;
      borderColor = const Color(0xFFD1D5DB);
      textColor = const Color(0xFF1E293B);
    }

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOutQuad,
        width: size,
        margin: const EdgeInsets.symmetric(horizontal: 1.5, vertical: 1.5),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Letter Box
            Container(
              height: size,
              width: size,
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: borderColor, width: borderWidth),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: const Color(0xFFD97706).withOpacity(0.35),
                          blurRadius: 8.0,
                          offset: const Offset(0, 2),
                        ),
                        const BoxShadow(
                          color: Color(0xFFB45309),
                          offset: Offset(0, 2),
                        ),
                      ]
                    : [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 3.0,
                          offset: const Offset(0, 2),
                        ),
                        BoxShadow(
                          color: const Color(0xFFCBD5E1).withOpacity(0.8),
                          offset: const Offset(0, 2),
                        ),
                      ],
              ),
              child: Center(
                child: hasLetter
                    ? Text(
                        letter!.toUpperCase(),
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: isSmall ? 18.0 : 22.0,
                          fontWeight: FontWeight.w700,
                          color: textColor,
                        ),
                      )
                    : isSelected
                        ? Container(
                            width: 2.0,
                            height: isSmall ? 18.0 : 22.0,
                            color: const Color(0xFFD97706),
                          )
                        : Text(
                            '?',
                            style: GoogleFonts.spaceGrotesk(
                              fontSize: isSmall ? 16.0 : 19.0,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF94A3B8).withOpacity(0.7),
                            ),
                          ),
              ),
            ),
            const SizedBox(height: 3.0),
            // Number Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 1.0),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFFFEF3C7)
                    : isLinked
                        ? const Color(0xFFFFFBEB)
                        : Colors.transparent,
                borderRadius: BorderRadius.circular(4.0),
              ),
              child: Text(
                '$number',
                style: GoogleFonts.jetBrainsMono(
                  fontSize: isSmall ? 10.0 : 11.5,
                  fontWeight: (isSelected || isLinked) ? FontWeight.w800 : FontWeight.w600,
                  color: isSelected
                      ? const Color(0xFFB45309)
                      : isLinked
                          ? const Color(0xFFD97706)
                          : const Color(0xFF64748B),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
