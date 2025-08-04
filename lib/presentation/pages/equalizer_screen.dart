import 'package:flutter/material.dart';
import '../../widgets/neumorphic_components.dart';

class EqualizerScreen extends StatefulWidget {
  const EqualizerScreen({super.key});

  @override
  State<EqualizerScreen> createState() => _EqualizerScreenState();
}

class _EqualizerScreenState extends State<EqualizerScreen> {
  bool _isEnabled = true;
  String _selectedPreset = 'مخصص';

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
  List<double> _bandValues = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0];

  final List<String> _presets = [
    'مخصص',
    'موسيقى كلاسيكية',
    'روك',
    'بوب',
    'جاز',
    'إلكترونية',
    'هيب هوب',
    'صوتي',
    'لايف',
    'باس قوي',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الإكولايزر'),
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
                          'تفعيل الإكولايزر',
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
                      'قم بتفعيل الإكولايزر لتحسين جودة الصوت',
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Presets
            Text(
              'الإعدادات المسبقة',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
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
                    return DropdownMenuItem(value: preset, child: Text(preset));
                  }).toList(),
                  onChanged: _isEnabled
                      ? (value) {
                          if (value != null) {
                            setState(() {
                              _selectedPreset = value;
                              _applyPreset(value);
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
              'النطاقات الترددية',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
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
                      scrollDirection: Axis.horizontal, // Horizontal scrolling
                      child: SizedBox(
                        // Retained SizedBox with a null height
                        height: 300,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: List.generate(_frequencies.length, (index) {
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
                                                _selectedPreset = 'مخصص';
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
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(fontWeight: FontWeight.bold),
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
                onPressed: _isEnabled ? _resetEqualizer : null,
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.refresh),
                      SizedBox(width: 8),
                      Text('إعادة تعيين'),
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
                      'تحكم إضافي',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Bass
                    Row(
                      children: [
                        const SizedBox(width: 60, child: Text('باس')),
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
                        const SizedBox(width: 60, child: Text('تريبل')),
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
  }

  void _applyPreset(String preset) {
    switch (preset) {
      case 'موسيقى كلاسيكية':
        _bandValues = [0, 0, 0, 0, 0, 0, -2, -2, -2, -3];
        break;
      case 'روك':
        _bandValues = [3, 2, -2, -3, -1, 1, 3, 4, 4, 4];
        break;
      case 'بوب':
        _bandValues = [-1, 2, 3, 3, 1, -1, -1, -1, -1, -1];
        break;
      case 'جاز':
        _bandValues = [2, 1, 1, 2, -1, -1, 0, 1, 2, 3];
        break;
      case 'إلكترونية':
        _bandValues = [2, 1, 0, 0, -1, 1, 0, 1, 2, 3];
        break;
      case 'هيب هوب':
        _bandValues = [3, 3, 1, 1, -1, -1, 1, -1, 1, 2];
        break;
      case 'صوتي':
        _bandValues = [-2, -1, -1, 1, 2, 2, 2, 1, 0, -1];
        break;
      case 'لايف':
        _bandValues = [-2, 0, 2, 2, 2, 2, 2, 1, 1, 1];
        break;
      case 'باس قوي':
        _bandValues = [6, 4, 3, 1, 0, -1, -2, -2, -2, -2];
        break;
      default:
        _bandValues = List.filled(10, 0);
    }
  }

  void _resetEqualizer() {
    setState(() {
      _bandValues = List.filled(10, 0);
      _selectedPreset = 'مخصص';
    });
  }
}
