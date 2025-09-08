import 'package:flutter_bloc/flutter_bloc.dart';

class NavigationCubit extends Cubit<int> {
  NavigationCubit() : super(0); // starts from Home (Index 0)

  void selectIndex(int newIndex) {
    emit(newIndex);
  }
}
