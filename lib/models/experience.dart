/// Experience class with operator overloading
/// Demonstrates: Operator Overloading (運算子重載)
class Experience {
  final int value;

  const Experience(this.value);

  /// Factory constructor for zero experience
  factory Experience.zero() => const Experience(0);

  /// Addition operator
  Experience operator +(Experience other) => Experience(value + other.value);

  /// Subtraction operator
  Experience operator -(Experience other) => Experience(value - other.value);

  /// Greater than operator
  bool operator >(Experience other) => value > other.value;

  /// Less than operator
  bool operator <(Experience other) => value < other.value;

  /// Greater than or equal operator
  bool operator >=(Experience other) => value >= other.value;

  /// Less than or equal operator
  bool operator <=(Experience other) => value <= other.value;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Experience &&
          runtimeType == other.runtimeType &&
          value == other.value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => '$value EXP';
}
