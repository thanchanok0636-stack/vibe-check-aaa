import 'package:flutter/material.dart';

import '../logic/postop_alarm_logic.dart';
import '../logic/evaluation_result.dart';

import '../widgets/section_card.dart';
import '../widgets/number_field.dart';
import '../widgets/dropdown_field.dart';
import '../widgets/zone_popup.dart';

class PostOpScreen extends StatefulWidget {
  const PostOpScreen({super.key});

  @override
  State<PostOpScreen> createState() => _PostOpScreenState();
}

class _PostOpScreenState extends State<PostOpScreen> {
  // =============================
  // Consciousness
  // =============================
  String consciousness = 'alert';

  // =============================
  // Vital signs
  // =============================
  int pr = 0;
  int rr = 0;
  int sbp = 0;
  int o2sat = 0;

  // =============================
  // Cardiac / Renal
  // =============================
  String mi = 'none';          // none / mild / severe
  String urineOutput = 'normal'; // normal / low / none
  double creatinine = 0;

  // =============================
  // Bleeding
  // =============================
  String wound = 'none';       // none / soak / active
  String gi = 'normal';        // normal / bleeding

  // =============================
  // Circulation / Lab
  // =============================
  int dorsalisLeft = 2;
  int dorsalisRight = 2;
  double hct = 0;

  // =============================
  // Evaluate
  // =============================
  void _evaluate() {
    final EvaluationResult result = evaluatePostOpAAA(
      consciousness: consciousness,
      pr: pr,
      rr: rr,
      sbp: sbp,
      o2sat: o2sat,
      mi: mi,
      urineOutput: urineOutput,
      creatinine: creatinine,
      wound: wound,
      gi: gi,
      dorsalisLeft: dorsalisLeft,
      dorsalisRight: dorsalisRight,
      hct: hct,
    );

    showDialog(
      context: context,
      builder: (_) => ZonePopup(
        zone: result.zone,
        reasons: result.reasons,
      ),
    );
  }

  // =============================
  // UI
  // =============================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        title: const Text(
          'Post-operative AAA Assessment',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFFB71C1C),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Consciousness
            SectionCard(
              title: 'ระดับความรู้สึกตัว (AVPU)',
              children: [
                DropdownField(
                  label: 'Consciousness',
                  value: consciousness,
                  items: const [
                    DropdownMenuItem(value: 'alert', child: Text('Alert')),
                    DropdownMenuItem(value: 'confuse', child: Text('Confuse')),
                    DropdownMenuItem(value: 'verbal', child: Text('Verbal')),
                    DropdownMenuItem(value: 'pain', child: Text('Pain')),
                    DropdownMenuItem(value: 'unresponsive', child: Text('Unresponsive')),
                  ],
                  onChanged: (v) => setState(() => consciousness = v!),
                ),
              ],
            ),

            // Vital Signs
            SectionCard(
              title: 'Vital Signs',
              children: [
                NumberField(label: 'PR (ครั้ง/นาที)', onChanged: (v) => pr = v),
                NumberField(label: 'RR (ครั้ง/นาที)', onChanged: (v) => rr = v),
                NumberField(label: 'SBP (mmHg)', onChanged: (v) => sbp = v),
                NumberField(label: 'O₂ saturation (%)', onChanged: (v) => o2sat = v),
              ],
            ),

            // Cardiac / Renal
            SectionCard(
              title: 'Cardiac / Renal',
              children: [
                DropdownField(
                  label: 'Sign of MI',
                  value: mi,
                  items: const [
                    DropdownMenuItem(value: 'none', child: Text('ไม่มีอาการ')),
                    DropdownMenuItem(value: 'mild', child: Text('เริ่มเจ็บหน้าอก')),
                    DropdownMenuItem(value: 'severe', child: Text('เจ็บหน้าอกรุนแรง')),
                  ],
                  onChanged: (v) => setState(() => mi = v!),
                ),
                DropdownField(
                  label: 'Urine Output',
                  value: urineOutput,
                  items: const [
                    DropdownMenuItem(value: 'normal', child: Text('ปกติ')),
                    DropdownMenuItem(value: 'low', child: Text('น้อย')),
                    DropdownMenuItem(value: 'none', child: Text('ไม่ออก')),
                  ],
                  onChanged: (v) => setState(() => urineOutput = v!),
                ),
                NumberField(
                  label: 'Creatinine (mg/dL)',
                  onChanged: (v) => creatinine = v.toDouble(),
                ),
              ],
            ),

            // Bleeding
            SectionCard(
              title: 'Bleeding',
              children: [
                DropdownField(
                  label: 'แผลผ่าตัด',
                  value: wound,
                  items: const [
                    DropdownMenuItem(value: 'none', child: Text('ไม่มี')),
                    DropdownMenuItem(value: 'soak', child: Text('เลือดซึม')),
                    DropdownMenuItem(value: 'active', child: Text('Active bleeding')),
                  ],
                  onChanged: (v) => setState(() => wound = v!),
                ),
                DropdownField(
                  label: 'ทางเดินอาหาร',
                  value: gi,
                  items: const [
                    DropdownMenuItem(value: 'normal', child: Text('ปกติ')),
                    DropdownMenuItem(value: 'bleeding', child: Text('ถ่ายเป็นเลือด')),
                  ],
                  onChanged: (v) => setState(() => gi = v!),
                ),
              ],
            ),

            // Circulation / Lab
            SectionCard(
              title: 'Circulation / Lab',
              children: [
                NumberField(
                  label: 'Dorsalis pulse ซ้าย (0–3)',
                  onChanged: (v) => dorsalisLeft = v,
                ),
                NumberField(
                  label: 'Dorsalis pulse ขวา (0–3)',
                  onChanged: (v) => dorsalisRight = v,
                ),
                NumberField(
                  label: 'Hct (%)',
                  onChanged: (v) => hct = v.toDouble(),
                ),
              ],
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),

      // =============================
      // Evaluate Button
      // =============================
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _evaluate,
        icon: const Icon(Icons.check_circle),
        label: const Text('ประเมิน Alarm Zone'),
        backgroundColor: const Color(0xFFB71C1C),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
