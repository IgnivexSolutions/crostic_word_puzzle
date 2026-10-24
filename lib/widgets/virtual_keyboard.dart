import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class VirtualKeyboard extends StatelessWidget {
  final Function(String char) onKeyTap;
  final VoidCallback onBackspace;
  final Set<String> disabledLetters; // Letters fully solved across the level

  const VirtualKeyboard({
    super.key,
    required this.onKeyTap,
    required this.onBackspace,
    this.disabledLetters = const {},
  });

  static const List<String> _row1 = ['Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P'];
  static const List<String> _row2 = ['A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L'];
  static const List<String> _row3 = ['Z', 'X', 'C', 'V', 'B', 'N', 'M'];

  Widget _buildKey(BuildContext context, String key, {double flex = 1.0}) {
    final isDisabled = disabledLetters.contains(key);

    return Expanded(
      flex: (flex * 10).toInt(),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 2.5, vertical: 3.5),
        height: 48.0,
        decoration: BoxDecoration(
          color: isDisabled ? const Color(0xFFE2E8F0) : Colors.white,
          borderRadius: BorderRadius.circular(6.5),
          boxShadow: isDisabled
              ? null
              : [
                  const BoxShadow(
                    color: Color(0xFF94A3B8),
                    offset: Offset(0, 2.5),
                  ),
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 2.0,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(6.5),
            onTap: isDisabled ? null : () => onKeyTap(key),
            child: Center(
              child: Text(
                key,
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 19.0,
                  fontWeight: FontWeight.w700,
                  color: isDisabled
                      ? const Color(0xFF94A3B8)
                      : const Color(0xFF0F172A),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBackspaceKey(BuildContext context) {
    return Expanded(
      flex: 15,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 2.5, vertical: 3.5),
        height: 48.0,
        decoration: BoxDecoration(
          color: const Color(0xFFE2E8F0),
          borderRadius: BorderRadius.circular(6.5),
          boxShadow: [
            const BoxShadow(
              color: Color(0xFF94A3B8),
              offset: Offset(0, 2.5),
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 2.0,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(6.5),
            onTap: onBackspace,
            child: const Center(
              child: Icon(
                Icons.backspace_outlined,
                size: 21.0,
                color: Color(0xFF334155),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 6.0),
      color: const Color(0xFFE2E8F0).withOpacity(0.4),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: _row1.map((k) => _buildKey(context, k)).toList(),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14.0),
            child: Row(
              children: _row2.map((k) => _buildKey(context, k)).toList(),
            ),
          ),
          Row(
            children: [
              const Spacer(flex: 7),
              ..._row3.map((k) => _buildKey(context, k)),
              _buildBackspaceKey(context),
            ],
          ),
        ],
      ),
    );
  }
}
