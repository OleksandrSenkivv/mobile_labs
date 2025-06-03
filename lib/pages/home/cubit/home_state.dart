part of 'home_cubit.dart';

class HomeState {
  final bool isPlugOn;
  final double voltage;
  final double consumption;
  final double amper;
  final bool loggedOut;

  HomeState({
    required this.isPlugOn,
    required this.voltage,
    required this.consumption,
    required this.amper,
    this.loggedOut = false,
  });

  factory HomeState.initial() => HomeState(
    isPlugOn: false,
    voltage: 220,
    consumption: 0,
    amper: 0,
  );

  HomeState copyWith({
    bool? isPlugOn,
    double? voltage,
    double? consumption,
    double? amper,
    bool? loggedOut,
  }) {
    return HomeState(
      isPlugOn: isPlugOn ?? this.isPlugOn,
      voltage: voltage ?? this.voltage,
      consumption: consumption ?? this.consumption,
      amper: amper ?? this.amper,
      loggedOut: loggedOut ?? this.loggedOut,
    );
  }
}
