import 'zone.dart';
import 'evaluation_result.dart';

/// =======================================================
/// Post-operative AAA Alarm Logic
/// =======================================================
/// Returns:
/// - Zone (green / yellow / red)
/// - Reasons explaining WHY that zone is assigned
/// =======================================================

EvaluationResult evaluatePostOpAAA({
  required String consciousness, // alert / confuse / verbal / pain / unresponsive
  required int pr,
  required int rr,
  required int sbp,
  required int o2sat,

  // Cardiac / Renal
  required String mi,           // none / mild / severe
  required String urineOutput,  // normal / low / none
  required double creatinine,

  // Bleeding
  required String wound,        // none / soak / active
  required String gi,           // normal / bleeding

  // Circulation / Lab
  required int dorsalisLeft,    // 0–3
  required int dorsalisRight,   // 0–3
  required double hct,
}) {
  final List<String> reasons = [];

  // =======================
  // RED ZONE (Critical)
  // =======================

  if (consciousness == 'unresponsive' || consciousness == 'pain') {
    reasons.add('ผู้ป่วยซึม / ไม่รู้สึกตัว');
  }

  if (pr < 50 || pr > 120) {
    reasons.add('ชีพจรผิดปกติรุนแรง (PR < 50 หรือ > 120)');
  }

  if (rr < 10 || rr > 30) {
    reasons.add('อัตราการหายใจผิดปกติรุนแรง');
  }

  if (sbp <= 80 || sbp > 160) {
    reasons.add('ความดันโลหิตวิกฤต');
  }

  if (o2sat < 90) {
    reasons.add('O₂ saturation ต่ำกว่า 90%');
  }

  if (mi == 'severe') {
    reasons.add('เจ็บหน้าอกมาก สงสัย MI รุนแรง');
  }

  if (urineOutput == 'none') {
    reasons.add('ปัสสาวะไม่ออก');
  }

  if (creatinine > 1.5 && urineOutput == 'none') {
    reasons.add('ไตวายเฉียบพลันรุนแรง (Cr > 1.5 + ไม่มีปัสสาวะ)');
  }

  if (wound == 'active') {
    reasons.add('แผลผ่าตัดมี active bleeding');
  }

  if (gi == 'bleeding') {
    reasons.add('มีเลือดออกทางเดินอาหาร');
  }

  if (hct < 30) {
    reasons.add('Hct < 30% สงสัยเสียเลือดมาก');
  }

  if (dorsalisLeft == 0 || dorsalisRight == 0) {
    reasons.add('คลำชีพจรเท้าไม่ได้');
  }

  if (reasons.isNotEmpty) {
    return EvaluationResult(
      zone: Zone.red,
      reasons: reasons,
    );
  }

  // =======================
  // YELLOW ZONE (Warning)
  // =======================

  if (consciousness == 'confuse' || consciousness == 'verbal') {
    reasons.add('ผู้ป่วยเริ่มสับสน');
  }

  if ((pr >= 50 && pr <= 59) || (pr >= 101 && pr <= 120)) {
    reasons.add('ชีพจรผิดปกติเล็กน้อย');
  }

  if (rr < 14 || rr > 24) {
    reasons.add('อัตราการหายใจผิดปกติ');
  }

  if ((sbp >= 81 && sbp <= 89) || (sbp >= 141 && sbp <= 159)) {
    reasons.add('ความดันโลหิตเริ่มผิดปกติ');
  }

  if (o2sat >= 90 && o2sat <= 93) {
    reasons.add('O₂ saturation 90–93%');
  }

  if (mi == 'mild') {
    reasons.add('เริ่มมีอาการเจ็บหน้าอก');
  }

  if (urineOutput == 'low') {
    reasons.add('ปัสสาวะออกน้อย');
  }

  if (creatinine > 1.5) {
    reasons.add('Creatinine สูง');
  }

  if (wound == 'soak') {
    reasons.add('แผลผ่าตัดมีเลือดซึม');
  }

  if (hct >= 30 && hct < 33) {
    reasons.add('Hct ลดลง');
  }

  if (dorsalisLeft == 1 || dorsalisRight == 1) {
    reasons.add('ชีพจรเท้าเบาลง');
  }

  if (reasons.isNotEmpty) {
    return EvaluationResult(
      zone: Zone.yellow,
      reasons: reasons,
    );
  }

  // =======================
  // GREEN ZONE (Normal)
  // =======================

  return EvaluationResult(
    zone: Zone.green,
    reasons: [
      'สัญญาณชีพอยู่ในเกณฑ์ปกติ',
      'ไม่มีภาวะแทรกซ้อนหลังผ่าตัด',
    ],
  );
}
