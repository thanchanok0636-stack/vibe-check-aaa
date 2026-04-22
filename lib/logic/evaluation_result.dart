import 'zone.dart';

class EvaluationResult {
  final Zone zone;
  final List<String> reasons;

  EvaluationResult({
    required this.zone,
    required this.reasons,
  });
}
