class ChartPoint {
  final String label;

  final double value;

  const ChartPoint({
    required this.label,
    required this.value,
  });

  factory ChartPoint.fromMap(Map<String, dynamic> map) {
    return ChartPoint(
      label: map["label"].toString(),
      value: (map["value"] as num).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "label": label,
      "value": value,
    };
  }
}