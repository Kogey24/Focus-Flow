enum SessionStatus {
  active,
  paused,
  completed,
  abandoned;

  String get value => name;

  static SessionStatus fromValue(String value) {
    return SessionStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () => SessionStatus.active,
    );
  }
}
