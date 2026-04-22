import 'package:flutter/material.dart';
import '../logic/zone.dart';

class ZonePopup extends StatelessWidget {
  final Zone zone;

  /// Optional: list of reasons why this zone was triggered
  /// (ถ้ายังไม่ส่งมาก็จะแสดงคำอธิบายมาตรฐาน)
  final List<String>? reasons;

  const ZonePopup({
    super.key,
    required this.zone,
    this.reasons,
  });

  @override
  Widget build(BuildContext context) {
    final _ZoneUI ui = _mapZoneUI(zone);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---------- HEADER ----------
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: ui.color.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(ui.icon, color: ui.color, size: 28),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    ui.title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: ui.color,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // ---------- DESCRIPTION ----------
            Text(
              ui.description,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 16),

            // ---------- WHY THIS ZONE ----------
            Text(
              'เหตุผลประกอบการประเมิน',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),

            _buildReasonList(),

            const SizedBox(height: 20),

            // ---------- ACTION ----------
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: ui.color.withOpacity(0.08),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Text(
                ui.action,
                style: TextStyle(
                  fontSize: 14,
                  color: ui.color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ---------- CLOSE ----------
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('ปิด'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --------------------------------------------------
  // Reasons
  // --------------------------------------------------
  Widget _buildReasonList() {
    final list = reasons ?? _defaultReasons(zone);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: list
          .map(
            (r) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('• ', style: TextStyle(fontSize: 14)),
                  Expanded(
                    child: Text(
                      r,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }

  // --------------------------------------------------
  // Default reasons (Pre-op oriented)
  // --------------------------------------------------
  List<String> _defaultReasons(Zone zone) {
    switch (zone) {
      case Zone.green:
        return [
          'สัญญาณชีพอยู่ในเกณฑ์ปกติ',
          'ผู้ป่วยรู้สึกตัวดี (Alert)',
          'Pain score อยู่ในระดับต่ำ',
          'ไม่มีสัญญาณบ่งชี้ภาวะ AAA rupture',
        ];

      case Zone.yellow:
        return [
          'สัญญาณชีพเริ่มเบี่ยงเบนจากค่าปกติ',
          'Pain score เพิ่มขึ้น',
          'ขนาด AAA ≥ 7 cm',
          'ควรเฝ้าระวังอาการอย่างใกล้ชิด',
        ];

      case Zone.red:
        return [
          'สัญญาณชีพผิดปกติรุนแรง',
          'ระดับความรู้สึกตัวเปลี่ยนแปลง',
          'Pain score สูงหรือมีอาการปวดรุนแรง',
          'เสี่ยงภาวะ AAA rupture',
        ];
    }
  }

  // --------------------------------------------------
  // Zone UI mapping
  // --------------------------------------------------
  _ZoneUI _mapZoneUI(Zone zone) {
    switch (zone) {
      case Zone.green:
        return _ZoneUI(
          title: 'Green Zone',
          description: 'อาการคงที่ ยังไม่พบสัญญาณอันตราย',
          action:
              'ให้การพยาบาลตามปกติ บันทึกสัญญาณชีพทุก 4 ชั่วโมง และติดตามอาการตาม Care map',
          color: Colors.green,
          icon: Icons.check_circle,
        );

      case Zone.yellow:
        return _ZoneUI(
          title: 'Yellow Zone',
          description: 'พบสัญญาณเตือน ควรเฝ้าระวังใกล้ชิด',
          action:
              'รายงานแพทย์ (Resident 1–2) และติดตามอาการทุก 30 นาที – 2 ชั่วโมง แต่ในกรณีที่ urine ออกน้อยต่อเนื่องมาจาก ICU และไม่มีความผิดปกติเพิ่มขึ้นให้ติดตามค่า Creatinine และอาการเป็นระยะ',
          color: Colors.orange,
          icon: Icons.warning_amber_rounded,
        );

      case Zone.red:
        return _ZoneUI(
          title: 'Red Zone',
          description: 'ภาวะวิกฤต เสี่ยงอันตราย',
          action:
              'รายงานแพทย์เร่งด่วนทันที (Resident 3–4 / Fellow อาจต้องเตรียม O2 cannular/mask, G/M PRC, Plt , FFP หรือเจาะ Lab CBC BUN Cr Electrolyte PT PTT INR หากอาการเปลี่ยนแปลงอย่างรวดเร็ว)',
          color: Colors.red,
          icon: Icons.error,
        );
    }
  }
}

// --------------------------------------------------
// Helper class
// --------------------------------------------------
class _ZoneUI {
  final String title;
  final String description;
  final String action;
  final Color color;
  final IconData icon;

  _ZoneUI({
    required this.title,
    required this.description,
    required this.action,
    required this.color,
    required this.icon,
  });
}
