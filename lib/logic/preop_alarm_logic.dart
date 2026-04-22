import 'zone.dart';
import 'evaluation_result.dart';

Future<EvaluationResult> evaluatePreOpAAA({
  required String consciousness, // alert / confuse / verbal / pain / unresponsive
  required int pr,
  required int rr,
  required int sbp,
  required int o2sat,

  required int painScore,
  required int dorsalisLeft,
  required int dorsalisRight,
  required String bowel,

  required double aaaSize,
}) async {
  final List<String> redReasons = [];

  // ==================================================
  // 🔴 RED ZONE
  // ==================================================

  // Consciousness
  if (consciousness == 'unresponsive' ||
      consciousness == 'verbal' ||
      consciousness == 'pain') {
    redReasons.add('ระดับความรู้สึกตัวผิดปกติรุนแรง (AVPU)');
  }

  // Vital signs
  if (pr < 50 || pr > 120) {
    redReasons.add('PR < 50 หรือ > 120 ครั้ง/นาที');
  }

  if (rr > 30) {
    redReasons.add('RR > 30 ครั้ง/นาที');
  }

  if (sbp <= 80 || sbp > 160) {
    redReasons.add('SBP ≤ 80 หรือ > 160 mmHg');
  }

  if (o2sat < 90) {
    redReasons.add('O₂ sat < 90%');
  }

  // AAA related
  if (painScore >= 7) {
    redReasons.add('ปวดท้องรุนแรง (Pain ≥ 7)');
  }

  if (dorsalisLeft == 0 || dorsalisRight == 0) {
    redReasons.add('คลำชีพจรเท้าไม่ได้');
  }

  if (bowel == 'blood') {
    redReasons.add('ถ่ายอุจจาระเป็นเลือด');
  }

  if (redReasons.isNotEmpty) {
    return EvaluationResult(zone: Zone.red, reasons: redReasons);
  }

  // ==================================================
  // 🟡 YELLOW ZONE
  // ==================================================
  final List<String> yellowReasons = [];

  // Consciousness
  if (consciousness == 'confuse') {
    yellowReasons.add('สับสน (Confusion)');
  }

  // Vital signs
  if ((pr >= 50 && pr <= 59) || (pr >= 101 && pr <= 120)) {
    yellowReasons.add('PR 50–59 หรือ 101–120 ครั้ง/นาที');
  }

  if (rr < 14 || rr > 24) {
    yellowReasons.add('RR < 14 หรือ > 24 ครั้ง/นาที');
  }

  if ((sbp >= 81 && sbp <= 89) || (sbp >= 141 && sbp <= 159)) {
    yellowReasons.add('SBP 81–89 หรือ 141–159 mmHg');
  }

  if (o2sat >= 90 && o2sat <= 93) {
    yellowReasons.add('O₂ sat 90–93%');
  }

  // AAA related
  if (painScore >= 4 && painScore <= 6) {
    yellowReasons.add('ปวดท้องปานกลาง (Pain 4–6)');
  }

  if (dorsalisLeft == 1 || dorsalisRight == 1) {
    yellowReasons.add('คลำชีพจรเท้าเบาลง');
  }

  if (bowel == 'no_bowel') {
    yellowReasons.add('ไม่ถ่ายอุจจาระ > 3 วัน');
  }

  if (aaaSize >= 7) {
    yellowReasons.add('AAA ≥ 7 cm (เสี่ยงสูง)');
  }

  if (yellowReasons.isNotEmpty) {
    return EvaluationResult(zone: Zone.yellow, reasons: yellowReasons);
  }

  // ==================================================
  // 🟢 GREEN ZONE
  // ==================================================
  return EvaluationResult(
    zone: Zone.green,
    reasons: ['อาการและสัญญาณชีพอยู่ในเกณฑ์ปกติ'],
  );
}