import 'zone.dart';
import 'evaluation_result.dart';

EvaluationResult evaluateVitalOnly({
  required int pr,
  required int rr,
  required int sbp,
  required int o2sat,
  required String consciousness,
}) {
  List<String> reasons = [];

  Zone zone = Zone.green;

  // -------------------------------
  // 🔴 RED ZONE (วิกฤต)
  // -------------------------------
  if (sbp <= 80 || pr > 160) {
    zone = Zone.red;
    reasons.add('SBP < 80 mmHg , > 160 mmHg (Shock)');
  }

  if (o2sat < 90) {
    zone = Zone.red;
    reasons.add('O₂ saturation < 90%');
  }

  if (pr < 50 || pr > 120) {
    zone = Zone.red;
    reasons.add('PR critical (<40 or >130)');
  }

  if (rr < 10 || rr > 30) {
    zone = Zone.red;
    reasons.add('RR critical (<10 or >30)');
  }

  if (consciousness == 'P' || consciousness == 'U') {
    zone = Zone.red;
    reasons.add('Decreased consciousness (P/U)');
  }

  // -------------------------------
  // 🟡 YELLOW ZONE (เฝ้าระวัง)
  // -------------------------------
  if (zone != Zone.red) {
    if ((sbp >= 81 && sbp <= 89) || (sbp >= 141 && sbp <= 159)) {
      zone = Zone.yellow;
      reasons.add('SBP borderline (81–89 และ 141-159)');
    }

    if (o2sat >= 90 && o2sat <= 93) {
      zone = Zone.yellow;
      reasons.add('O₂ saturation borderline (90–93%)');
    }

    if ((pr >= 50 && pr <= 59) || (pr >= 100 && pr <= 120)) {
      zone = Zone.yellow;
      reasons.add('PR abnormal');
    }

    if ((rr < 14 || rr > 24)) {
      zone = Zone.yellow;
      reasons.add('RR abnormal');
    }

    if (consciousness == 'V' || consciousness == 'C') {
      zone = Zone.yellow;
      reasons.add('Altered consciousness (V/C)');
    }
  }

  // -------------------------------
  // 🟢 GREEN ZONE (ปกติ)
  // -------------------------------
  if (zone == Zone.green) {
    reasons.add('Stable vital signs');
  }

  return EvaluationResult(
    zone: zone,
    reasons: reasons,
  );
}