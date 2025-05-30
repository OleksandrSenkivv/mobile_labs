class ProfileState {
  final Map<String, String>? user;
  final bool isEditing;
  final String? error;

  ProfileState({
    required this.user,
    required this.isEditing,
    required this.error,
  });

  ProfileState copyWith({
    Map<String, String>? user,
    bool? isEditing,
    String? error,
  }) {
    return ProfileState(
      user: user ?? this.user,
      isEditing: isEditing ?? this.isEditing,
      error: error,
    );
  }
}
