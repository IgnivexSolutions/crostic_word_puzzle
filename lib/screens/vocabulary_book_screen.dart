import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/levels_dataset.dart';
import '../models/level_data.dart';
import '../models/user_account.dart';
import '../services/sound_service.dart';

class VocabularyBookScreen extends StatefulWidget {
  final UserAccount user;

  const VocabularyBookScreen({super.key, required this.user});

  @override
  State<VocabularyBookScreen> createState() => _VocabularyBookScreenState();
}

class _VocabularyBookScreenState extends State<VocabularyBookScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _filter = '';
  final SoundService _sound = SoundService();

  List<WordDefinition> get _allAvailableWords {
    final list = <WordDefinition>[];
    for (final lvl in allGameLevels) {
      list.addAll(lvl.vocabularyList);
    }
    return list;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final words = _allAvailableWords.where((w) {
      if (_filter.isEmpty) return true;
      return w.word.toLowerCase().contains(_filter.toLowerCase()) ||
          w.definition.toLowerCase().contains(_filter.toLowerCase());
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFE8F1F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1.0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF1E293B)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Student Vocabulary Lexicon',
          style: GoogleFonts.spaceGrotesk(
            fontSize: 18.0,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF0F172A),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _searchController,
                onChanged: (val) => setState(() => _filter = val),
                decoration: InputDecoration(
                  hintText: 'Search vocabulary or definition...',
                  prefixIcon: const Icon(Icons.search_rounded),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14.0),
                    borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0),
                ),
              ),
            ),

            // Word Cards List
            Expanded(
              child: words.isEmpty
                  ? Center(
                      child: Text(
                        'No vocabulary words found.',
                        style: GoogleFonts.plusJakartaSans(color: const Color(0xFF64748B)),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      itemCount: words.length,
                      itemBuilder: (ctx, idx) {
                        final item = words[idx];
                        final isMastered = widget.user.learnedWords.contains(item.word);

                        return Container(
                          margin: const EdgeInsets.only(bottom: 12.0),
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16.0),
                            border: Border.all(
                              color: isMastered ? const Color(0xFFA7F3D0) : const Color(0xFFCBD5E1),
                              width: isMastered ? 1.5 : 1.0,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.04),
                                blurRadius: 6.0,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    item.word,
                                    style: GoogleFonts.spaceGrotesk(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w800,
                                      color: const Color(0xFF0F172A),
                                    ),
                                  ),
                                  const SizedBox(width: 8.0),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF1F5F9),
                                      borderRadius: BorderRadius.circular(6.0),
                                    ),
                                    child: Text(
                                      item.partOfSpeech,
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 11.5,
                                        fontStyle: FontStyle.italic,
                                        color: const Color(0xFF475569),
                                      ),
                                    ),
                                  ),
                                  const Spacer(),
                                  if (isMastered)
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFECFDF5),
                                        borderRadius: BorderRadius.circular(12.0),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(Icons.check_circle_rounded, color: Color(0xFF059669), size: 14),
                                          const SizedBox(width: 4.0),
                                          Text(
                                            'Mastered',
                                            style: GoogleFonts.spaceGrotesk(
                                              fontSize: 11.0,
                                              fontWeight: FontWeight.w700,
                                              color: const Color(0xFF065F46),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 6.0),
                              Text(
                                item.definition,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 13.5,
                                  height: 1.35,
                                  color: const Color(0xFF334155),
                                ),
                              ),
                              const SizedBox(height: 6.0),
                              Text(
                                '"${item.exampleSentence}"',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12.5,
                                  fontStyle: FontStyle.italic,
                                  color: const Color(0xFF64748B),
                                ),
                              ),
                              if (item.etymology.isNotEmpty) ...[
                                const SizedBox(height: 6.0),
                                Text(
                                  'Origin: ${item.etymology}',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 11.5,
                                    color: const Color(0xFF0284C7),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
