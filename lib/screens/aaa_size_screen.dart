import 'package:flutter/material.dart';
import '../logic/zone.dart';
import '../widgets/number_field.dart';
import '../widgets/zone_popup.dart';

class AaaSizeScreen extends StatefulWidget {
  const AaaSizeScreen({super.key});

  @override
  State<AaaSizeScreen> createState() => _AaaSizeScreenState();
}

class _AaaSizeScreenState extends State<AaaSizeScreen> {
  double aaaSize = 0;

  void _evaluate() {
    final Zone zone = aaaSize >= 7 ? Zone.yellow : Zone.green;

    showDialog(
      context: context,
      builder: (_) => ZonePopup(zone: zone, reasons: [],),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AAA Size Assessment'),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'ประเมินขนาดหลอดเลือดแดงใหญ่โป่งพอง\n(Abdominal Aortic Aneurysm)',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 24),

            NumberField(
              label: 'AAA size (cm)',
              onChanged: (v) => aaaSize = v.toDouble(),
            ),

            const SizedBox(height: 16),

            const Text(
              'เกณฑ์การประเมิน\n'
              '• < 7 cm = Green\n'
              '• ≥ 7 cm = Yellow',
              style: TextStyle(color: Colors.black54),
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: _evaluate,
        icon: const Icon(Icons.straighten),
        label: const Text('ประเมินขนาด AAA'),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.centerFloat,
    );
  }
}
