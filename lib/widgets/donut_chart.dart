import 'package:flutter/material.dart';

class DonutChart extends StatelessWidget {
  final String title;
  final num value;
  final int maxValue;
  final Color color;
  final String unit;

  String _formatValue(num val) {
        // Pindahkan fungsi _formatNumber ke dalam sini atau buat seperti ini
        if ((val - val.toInt()).abs() < 1e-6) {
            return val.toInt().toString();
        }
        return val.toStringAsFixed(1);
    }

  const DonutChart({
    super.key,
    required this.title,
    required this.value,
    required this.maxValue,
    required this.color,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    final formattedText = _formatValue(value);
    double percentage = value / maxValue;
    if (percentage > 1.0) percentage = 1.0;

    final double strokeWidth = title.contains('Rain Sensor') ? 12 : 8;

    final double valueFontSize = title.contains('Rain Sensor') ? 30 : 28;

    final bool isRainSensor = title.contains('Rain Sensor');

    final Color valueColor = isRainSensor
        ? const Color(0xFF900000)
        : const Color(0xFF00798C);

    final Color unitColor = valueColor;
    return Expanded(
      child: Card(
        elevation: 2,

        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 100,
                    height: 100,
                    child: CircularProgressIndicator(
                      value: percentage,
                      strokeWidth: strokeWidth,
                      backgroundColor: Colors.grey[200],
                      valueColor: AlwaysStoppedAnimation<Color>(color),
                    ),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        formattedText,
                        style: TextStyle(
                          fontSize: valueFontSize,
                          fontWeight: FontWeight.bold,
                          color: valueColor,
                        ),
                      ),

                      if (unit.isNotEmpty)
                        Text(
                          unit,
                          style: TextStyle(
                            fontSize: valueFontSize,
                            fontWeight: FontWeight.bold,
                            color: unitColor,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
