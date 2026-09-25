import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rehla/core/usecase/base_usecase.dart';
import 'package:rehla/features/home/domain/entities/course.dart';
import 'package:rehla/features/home/domain/usecases/get_courses_usecase.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this._getCoursesUseCase) : super(const HomeState());

  final GetCoursesUseCase _getCoursesUseCase;

  Future<void> getCourses() async {
    emit(state.copyWith(status: HomeStatus.loading, errorMessage: null));
    final result = await _getCoursesUseCase(const NoParameters());
    result.fold(
      (failure) => emit(
        state.copyWith(status: HomeStatus.error, errorMessage: failure.message),
      ),
      (data) {
        if (data.courses.isEmpty) {
          emit(
            state.copyWith(
              status: HomeStatus.empty,
              data: data,
              errorMessage: null,
            ),
          );
          return;
        }
        emit(
          state.copyWith(
            status: HomeStatus.loaded,
            data: data,
            errorMessage: null,
          ),
        );
      },
    );
  }
}
