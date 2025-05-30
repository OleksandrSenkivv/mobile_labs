import 'package:flutter_bloc/flutter_bloc.dart';

class CounterCubit extends Cubit<int> {
  CounterCubit() : super(0);

  void incrementBy8() => emit(state + 8);
  void decrementBy5() => emit(state - 5);
}
