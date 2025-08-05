import 'package:flutter/material.dart';
import '../../widgets/neumorphic_components.dart';
import 'package:provider/provider.dart';
import '../providers/locale_provider.dart'; // Corrected path

class EqualizerScreen extends StatefulWidget {
  const EqualizerScreen({super.key});

  @override
  State<EqualizerScreen> createState() => _EqualizerScreenState();
}

class _EqualizerScreenState extends State<EqualizerScreen> {
  bool _isEnabled = true;
  late String _selectedPreset;

  // Frequency bands (Hz)
  final List<String> _frequencies = [
    '60',
    '170',
    '310',
    '600',
    '1K',
    '3K',
    '6K',
    '12K',
    '14K',
    '16K',
  ];

  // Current values for each band (-12 to +12 dB)
  List<double> _bandValues = List.filled(10, 0);

  List<String> _presets = []; // Will be initialized in initState

  @override
  void initState() {
    super.initState();
    // Initialize _presets and _selectedPreset based on the default locale.
    // This will be updated if the locale changes later in the build method.
    final localeProvider = Provider.of<LocaleProvider>(context, listen: false);
    _presets = _getLocalizedPresets(localeProvider);
    _selectedPreset = localeProvider.getLocalizedText('مخصص', 'Custom');
  }

  List<String> _getLocalizedPresets(LocaleProvider localeProvider) {
    return [
      localeProvider.getLocalizedText('مخصص', 'Custom'),
      localeProvider.getLocalizedText('موسيقى كلاسيكية', 'Classical'),
      localeProvider.getLocalizedText('روك', 'Rock'),
      localeProvider.getLocalizedText('بوب', 'Pop'),
      localeProvider.getLocalizedText('جاز', 'Jazz'),
      localeProvider.getLocalizedText('إلكترونية', 'Electronic'),
      localeProvider.getLocalizedText('هيب هوب', 'Hip Hop'),
      localeProvider.getLocalizedText('صوتي', 'Acoustic'),
      localeProvider.getLocalizedText('لايف', 'Live'),
      localeProvider.getLocalizedText('باس قوي', 'Bass Boost'),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LocaleProvider>(
      builder: (context, localeProvider, child) {
        // Update presets if locale changes (after initial build)
        if (_presets.isEmpty ||
            _presets[0] != localeProvider.getLocalizedText('مخصص', 'Custom')) {
          _presets = _getLocalizedPresets(localeProvider);
          _selectedPreset = localeProvider.getLocalizedText('مخصص', 'Custom');
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(
              localeProvider.getLocalizedText('الإكولايزر', 'Equalizer'),
            ),
            centerTitle: true,
            actions: [
              Switch(
                value: _isEnabled,
                onChanged: (value) {
                  setState(() {
                    _isEnabled = value;
                  });
                },
              ),
              const SizedBox(width: 16),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Enable/Disable Card
                NeumorphicContainer(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              localeProvider.getLocalizedText(
                                'تفعيل الإكولايزر',
                                'Enable Equalizer',
                              ),
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            Switch(
                              value: _isEnabled,
                              onChanged: (value) {
                                setState(() {
                                  _isEnabled = value;
                                });
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          localeProvider.getLocalizedText(
                            'قم بتفعيل الإكولايزر لتحسين جودة الصوت',
                            'Enable equalizer to enhance sound quality',
                          ),
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Presets
                Text(
                  localeProvider.getLocalizedText(
                    'الإعدادات المسبقة',
                    'Presets',
                  ),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),

                NeumorphicContainer(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: DropdownButtonFormField<String>(
                      value: _selectedPreset,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                      ),
                      items: _presets.map((preset) {
                        return DropdownMenuItem<String>(
                          value: preset,
                          child: Text(preset),
                        );
                      }).toList(),
                      onChanged: _isEnabled
                          ? (value) {
                              if (value != null) {
                                setState(() {
                                  _selectedPreset = value;
                                  _applyPreset(value, localeProvider);
                                });
                              }
                            }
                          : null,
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Frequency Bands
                Text(
                  localeProvider.getLocalizedText(
                    'النطاقات الترددية',
                    'Frequency Bands',
                  ),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),

                NeumorphicContainer(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        // dB scale indicators
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const SizedBox(width: 40),
                            ...List.generate(5, (index) {
                              int db = 12 - (index * 6);
                              return Text(
                                '${db > 0 ? '+' : ''}${db}dB',
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(color: Colors.grey[600]),
                              );
                            }),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Frequency sliders
                        SingleChildScrollView(
                          // ADDED SingleChildScrollView
                          scrollDirection:
                              Axis.horizontal, // Horizontal scrolling
                          child: SizedBox(
                            // Retained SizedBox with a null height
                            height: 300,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: List.generate(_frequencies.length, (
                                index,
                              ) {
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    // Slider
                                    Expanded(
                                      child: RotatedBox(
                                        quarterTurns: 3,
                                        child: Slider(
                                          value: _bandValues[index],
                                          min: -12,
                                          max: 12,
                                          divisions: 24,
                                          onChanged: _isEnabled
                                              ? (value) {
                                                  setState(() {
                                                    _bandValues[index] = value;
                                                    _selectedPreset = localeProvider
                                                        .getLocalizedText(
                                                          'مخصص',
                                                          'Custom',
                                                        ); // Use localized text
                                                  });
                                                }
                                              : null,
                                          activeColor: _isEnabled
                                              ? Theme.of(context).primaryColor
                                              : Colors.grey,
                                        ),
                                      ),
                                    ),

                                    const SizedBox(height: 8),

                                    // Value indicator
                                    Container(
                                      width: 32,
                                      height: 20,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Center(
                                        child: Text(
                                          '${_bandValues[index].round()}',
                                          style: const TextStyle(fontSize: 10),
                                        ),
                                      ),
                                    ),

                                    const SizedBox(height: 4),

                                    // Frequency label
                                    Text(
                                      _frequencies[index],
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                  ],
                                );
                              }),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Reset button
                Center(
                  child: NeumorphicCustomButton(
                    onPressed: _isEnabled
                        ? () => _resetEqualizer(localeProvider)
                        : null,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 12,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.refresh),
                          const SizedBox(width: 8),
                          Text(
                            localeProvider.getLocalizedText(
                              'إعادة تعيين',
                              'Reset',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Bass and Treble
                NeumorphicContainer(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          localeProvider.getLocalizedText(
                            'تحكم إضافي',
                            'Additional Controls',
                          ),
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),

                        // Bass
                        Row(
                          children: [
                            SizedBox(
                              width: 60,
                              child: Text(
                                localeProvider.getLocalizedText('باس', 'Bass'),
                              ),
                            ),
                            Expanded(
                              child: Slider(
                                value: 0,
                                min: -10,
                                max: 10,
                                divisions: 20,
                                onChanged: _isEnabled ? (value) {} : null,
                              ),
                            ),
                            const SizedBox(width: 40, child: Text('0')),
                          ],
                        ),

                        // Treble
                        Row(
                          children: [
                            SizedBox(
                              width: 60,
                              child: Text(
                                localeProvider.getLocalizedText(
                                  'تريبل',
                                  'Treble',
                                ),
                              ),
                            ),
                            Expanded(
                              child: Slider(
                                value: 0,
                                min: -10,
                                max: 10,
                                divisions: 20,
                                onChanged: _isEnabled ? (value) {} : null,
                              ),
                            ),
                            const SizedBox(width: 40, child: Text('0')),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _applyPreset(String preset, LocaleProvider localeProvider) {
    final customText = localeProvider.getLocalizedText('مخصص', 'Custom');
    final classicalText = localeProvider.getLocalizedText(
      'موسيقى كلاسيكية',
      'Classical',
    );
    final rockText = localeProvider.getLocalizedText('روك', 'Rock');
    final popText = localeProvider.getLocalizedText('بوب', 'Pop');
    final jazzText = localeProvider.getLocalizedText('جاز', 'Jazz');
    final electronicText = localeProvider.getLocalizedText(
      'إلكترونية',
      'Electronic',
    );
    final hipHopText = localeProvider.getLocalizedText('هيب هوب', 'Hip Hop');
    final acousticText = localeProvider.getLocalizedText('صوتي', 'Acoustic');
    final liveText = localeProvider.getLocalizedText('لايف', 'Live');
    final bassBoostText = localeProvider.getLocalizedText(
      'باس قوي',
      'Bass Boost',
    );

    if (preset == classicalText) {
      _bandValues = [0, 0, 0, 0, 0, 0, -2, -2, -2, -3];
    } else if (preset == rockText) {
      _bandValues = [3, 2, -2, -3, -1, 1, 3, 4, 4, 4];
    } else if (preset == popText) {
      _bandValues = [-1, 2, 3, 3, 1, -1, -1, -1, -1, -1];
    } else if (preset == jazzText) {
      _bandValues = [2, 1, 1, 2, -1, -1, 0, 1, 2, 3];
    } else if (preset == electronicText) {
      _bandValues = [2, 1, 0, 0, -1, 1, 0, 1, 2, 3];
    } else if (preset == hipHopText) {
      _bandValues = [3, 3, 1, 1, -1, -1, 1, -1, 1, 2];
    } else if (preset == acousticText) {
      _bandValues = [-2, -1, -1, 1, 2, 2, 2, 1, 0, -1];
    } else if (preset == liveText) {
      _bandValues = [-2, 0, 2, 2, 2, 2, 2, 1, 1, 1];
    } else if (preset == bassBoostText) {
      _bandValues = [6, 4, 3, 1, 0, -1, -2, -2, -2, -2];
    } else if (preset == customText) {
      // No change, as custom is usually when bands are manually adjusted
    } else {
      _bandValues = List.filled(10, 0);
    }
  }

  void _resetEqualizer(LocaleProvider localeProvider) {
    setState(() {
      _bandValues = List.filled(10, 0);
      _selectedPreset = localeProvider.getLocalizedText('مخصص', 'Custom');
    });
  }
}
