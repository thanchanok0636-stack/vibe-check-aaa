import 'package:flutter/material.dart';
import '../logic/vital_alarm_logic.dart';
import '../logic/evaluation_result.dart';
import '../logic/zone.dart';
import '../widgets/number_field.dart';
import '../widgets/zone_popup.dart';

class QuickVitalScreen extends StatefulWidget {
  const QuickVitalScreen({super.key});

  @override
  State<QuickVitalScreen> createState() => _QuickVitalScreenState();
}

class _QuickVitalScreenState extends State<QuickVitalScreen> {
  int pr = 0;
  int rr = 0;
  int sbp = 0;
  int o2sat = 0;

  String consciousness = 'A';

  final Map<String, String> consciousnessMap = {
    'A': 'Alert',
    'C': 'Confusion',
    'V': 'Responds to Voice',
    'P': 'Responds to Pain',
    'U': 'Unresponsive',
  };

  EvaluationResult? result;

  void _recalculate() {
    if (pr == 0 || rr == 0 || sbp == 0 || o2sat == 0) {
      setState(() => result = null);
      return;
    }

    setState(() {
      result = evaluateVitalOnly(
        pr: pr,
        rr: rr,
        sbp: sbp,
        o2sat: o2sat,
        consciousness: consciousness,
      );
    });
  }

  Color _zoneColor(Zone zone) {
    switch (zone) {
      case Zone.green:
        return Colors.green;
      case Zone.yellow:
        return Colors.orange;
      case Zone.red:
        return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        title: const Text('Quick Vital Assessment'),
        backgroundColor: const Color(0xFFB71C1C),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            // 🔥 Consciousness (ตัวเต็ม)
            DropdownButtonFormField<String>(
              value: consciousness,
              decoration: const InputDecoration(
                labelText: 'Consciousness',
              ),
              items: consciousnessMap.entries
                  .map((entry) => DropdownMenuItem(
                        value: entry.key,
                        child: Text('${entry.key} - ${entry.value}'),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  consciousness = value!;
                  _recalculate();
                });
              },
            ),

            const SizedBox(height: 12),

            NumberField(
              label: 'PR (bpm)',
              onChanged: (v) {
                pr = v;
                _recalculate();
              },
            ),
            NumberField(
              label: 'RR (ครั้ง/นาที)',
              onChanged: (v) {
                rr = v;
                _recalculate();
              },
            ),
            NumberField(
              label: 'SBP (mmHg)',
              onChanged: (v) {
                sbp = v;
                _recalculate();
              },
            ),
            NumberField(
              label: 'O₂ saturation (%)',
              onChanged: (v) {
                o2sat = v;
                _recalculate();
              },
            ),

            const SizedBox(height: 24),

            if (result != null)
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (_) => ZonePopup(
                      zone: result!.zone,
                      reasons: result!.reasons,
                    ),
                  );
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: _zoneColor(result!.zone).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: _zoneColor(result!.zone),
                      width: 2,
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        result!.zone.name.toUpperCase(),
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: _zoneColor(result!.zone),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'แตะเพื่อดูเหตุผล',
                        style: TextStyle(color: Colors.grey),
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
}