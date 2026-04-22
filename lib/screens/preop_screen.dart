import 'package:flutter/material.dart';

import '../logic/preop_alarm_logic.dart';
import '../logic/evaluation_result.dart';

import '../widgets/section_card.dart';
import '../widgets/number_field.dart';
import '../widgets/dropdown_field.dart';
import '../widgets/zone_popup.dart';

class PreOpScreen extends StatefulWidget {
  const PreOpScreen({super.key});

  @override
  State<PreOpScreen> createState() => _PreOpScreenState();
}

class _PreOpScreenState extends State<PreOpScreen> {
  // =================================================
  // STATE VARIABLES
  // =================================================

  String consciousness = 'alert';

  int pr = 0;
  int rr = 0;
  int sbp = 0;
  int o2sat = 0;

  int painScore = 0;
  int dorsalisLeft = 2;
  int dorsalisRight = 2;
  double aaaSize = 0;

  String bowel = 'normal';

  // =================================================
  // EVALUATE
  // =================================================
  void _evaluate() async {
    final result = await evaluatePreOpAAA(
      consciousness: consciousness,
      pr: pr,
      rr: rr,
      sbp: sbp,
      o2sat: o2sat,
      painScore: painScore,
      dorsalisLeft: dorsalisLeft,
      dorsalisRight: dorsalisRight,
      bowel: bowel,
      aaaSize: aaaSize,
    );

    showDialog(
      context: context,
      builder: (_) => ZonePopup(
        zone: result.zone,
        reasons: result.reasons,
      ),
    );
  }

  // =================================================
  // UI
  // =================================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),

      appBar: AppBar(
        backgroundColor: const Color(0xFFB71C1C),
        foregroundColor: Colors.white,
        title: const Text(
          'Pre-operative Assessment',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // ---------- Consciousness ----------
            SectionCard(
              title: 'Consciousness (AVPU)',
              children: [
                DropdownField(
                  label: 'Level of consciousness',
                  value: consciousness,
                  items: const [
                    DropdownMenuItem(value: 'alert', child: Text('Alert')),
                    DropdownMenuItem(value: 'confuse', child: Text('Confuse')),
                    DropdownMenuItem(value: 'verbal', child: Text('Responds to Voice')),
                    DropdownMenuItem(value: 'pain', child: Text('Responds to Pain')),
                    DropdownMenuItem(value: 'unresponsive', child: Text('Unresponsive')),
                  ],
                  onChanged: (v) =>
                      setState(() => consciousness = v ?? 'alert'),
                ),
              ],
            ),

            // ---------- Vital Signs ----------
            SectionCard(
              title: 'Vital Signs',
              children: [
                NumberField(label: 'PR (bpm)', onChanged: (v) => pr = v),
                NumberField(label: 'RR (breaths/min)', onChanged: (v) => rr = v),
                NumberField(label: 'SBP (mmHg)', onChanged: (v) => sbp = v),
                NumberField(label: 'O₂ saturation (%)', onChanged: (v) => o2sat = v),
              ],
            ),

            // ---------- AAA ----------
            SectionCard(
              title: 'AAA Assessment',
              children: [
                NumberField(
                  label: 'AAA size (cm)',
                  onChanged: (v) => setState(() => aaaSize = v.toDouble()),
                ),
                NumberField(
                  label: 'Pain score (0–10)',
                  onChanged: (v) => painScore = v,
                ),
              ],
            ),

            // ---------- Circulation ----------
            SectionCard(
              title: 'Peripheral Circulation',
              children: [
                DropdownField(
                  label: 'Dorsalis pedis (Left)',
                  value: dorsalisLeft.toString(),
                  items: const [
                    DropdownMenuItem(value: '0', child: Text('0')),
                    DropdownMenuItem(value: '1', child: Text('+1')),
                    DropdownMenuItem(value: '2', child: Text('+2')),
                    DropdownMenuItem(value: '3', child: Text('+3')),
                  ],
                  onChanged: (v) =>
                      setState(() => dorsalisLeft = int.parse(v!)),
                ),
                DropdownField(
                  label: 'Dorsalis pedis (Right)',
                  value: dorsalisRight.toString(),
                  items: const [
                    DropdownMenuItem(value: '0', child: Text('0')),
                    DropdownMenuItem(value: '1', child: Text('+1')),
                    DropdownMenuItem(value: '2', child: Text('+2')),
                    DropdownMenuItem(value: '3', child: Text('+3')),
                  ],
                  onChanged: (v) =>
                      setState(() => dorsalisRight = int.parse(v!)),
                ),
              ],
            ),

            // ---------- Bowel ----------
            SectionCard(
              title: 'Bowel Movement',
              children: [
                DropdownField(
                  label: 'Bowel',
                  value: bowel,
                  items: const [
                    DropdownMenuItem(value: 'normal', child: Text('Normal')),
                    DropdownMenuItem(value: 'no_bowel', child: Text('No bowel > 3 days')),
                    DropdownMenuItem(value: 'blood', child: Text('Bloody stool')),
                  ],
                  onChanged: (v) =>
                      setState(() => bowel = v ?? 'normal'),
                ),
              ],
            ),

            const SizedBox(height: 90),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFFD32F2F),
        onPressed: _evaluate,
        icon: const Icon(Icons.check),
        label: const Text(
          'ประเมินผล',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.centerFloat,
    );
  }
}