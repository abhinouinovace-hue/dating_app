import 'package:flutter/material.dart';
import '../../../../core/di/app_dependencies.dart';
import '../../domain/entities/language.dart';
import 'gender_screen.dart';

class LanguageScreen extends StatefulWidget {
  final String name;

  const LanguageScreen({
    super.key,
    required this.name,
  });

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  String? selectedLanguage;

  final List<Language> languages = AppDependencies.getLanguages();

  /*
    {
      'english': 'Malayalam',
      'native': 'മലയാളം',
    },
    {
      'english': 'Tamil',
      'native': 'தமிழ்',
    },
    {
      'english': 'Kannada',
      'native': 'ಕನ್ನಡ',
    },
    {
      'english': 'Hindi',
      'native': 'हिन्दी',
    },
    {
      'english': 'Telugu',
      'native': 'తెలుగు',
    },
    {
      'english': 'Marathi',
      'native': 'मराठी',
    },
  ];
  */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            color: Color(0xFF250025),
            borderRadius: BorderRadius.zero,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 18,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                const SizedBox(height: 30),

                // =========================================
                // LOGO
                // =========================================
                Center(
                  child: Image.asset(
                    'assets/images/logo.png',
                    width: 70,
                    height: 40,
                    fit: BoxFit.contain,
                    errorBuilder:
                        (context, error, stackTrace) {
                      return const Text(
                        'lokup',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 15),

                // =========================================
                // PROGRESS INDICATORS
                // =========================================
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 3,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE0C238),
                          borderRadius:
                              BorderRadius.circular(10),
                        ),
                      ),
                    ),

                    const SizedBox(width: 5),

                    Expanded(
                      child: Container(
                        height: 3,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE0C238),
                          borderRadius:
                              BorderRadius.circular(10),
                        ),
                      ),
                    ),

                    const SizedBox(width: 5),

                    Expanded(
                      child: Container(
                        height: 3,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius:
                              BorderRadius.circular(10),
                        ),
                      ),
                    ),

                    const SizedBox(width: 5),

                    Expanded(
                      child: Container(
                        height: 3,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius:
                              BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 38),

                // =========================================
                // TITLE
                // =========================================
                const Text(
                  'Choose the language you wish\nto speak in!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    height: 1.2,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 15),

                // =========================================
                // LANGUAGE LIST
                // =========================================
                Expanded(
                  child: ListView.separated(
                    padding: EdgeInsets.zero,
                    physics:
                        const NeverScrollableScrollPhysics(),
                    itemCount: languages.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final language = languages[index];

                      final isSelected =
                          selectedLanguage == language.name;

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedLanguage =
                                language.name;
                          });
                        },
                        child: Container(
                          width: double.infinity,
                          height: 34,
                          padding:
                              const EdgeInsets.symmetric(
                            horizontal: 10,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xFF4A004A)
                                : const Color(0xFF3A003A),
                            borderRadius:
                                BorderRadius.circular(7),
                            border: Border.all(
                              color: isSelected
                                  ? const Color(
                                      0xFFE0C238,
                                    )
                                  : const Color(
                                      0xFF5B0A5B,
                                    ),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Text(
                                language.name,
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 10,
                                ),
                              ),

                              const SizedBox(width: 8),

                              Text(
                                language.nativeName,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 12),

                // =========================================
                // CONTINUE BUTTON
                // =========================================
                SizedBox(
                  width: double.infinity,
                  height: 34,
                  child: ElevatedButton(
                    onPressed: () {
                      if (selectedLanguage == null) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Please select a language.',
                            ),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GenderScreen(
                            name: widget.name,
                            language: selectedLanguage!,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color(0xFFE0C238),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text(
                      'Continue',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                // =========================================
                // BOTTOM NAVIGATION ARROWS
                // =========================================
                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.center,
                  children: [

                    // Previous
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: 38,
                        height: 38,
                        decoration:
                            const BoxDecoration(
                          color: Color(0xFF560056),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.keyboard_arrow_up,
                          color: Colors.white,
                          size: 25,
                        ),
                      ),
                    ),

                    const SizedBox(width: 15),

                    // Next
                    GestureDetector(
                      onTap: () {
                        if (selectedLanguage == null) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Please select a language.',
                              ),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => GenderScreen(
                              name: widget.name,
                              language: selectedLanguage!,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        width: 38,
                        height: 38,
                        decoration:
                            const BoxDecoration(
                          color: Color(0xFF560056),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.white,
                          size: 25,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
