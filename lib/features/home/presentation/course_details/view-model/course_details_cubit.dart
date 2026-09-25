import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rehla/features/home/domain/entities/course.dart';
import 'package:rehla/features/home/domain/usecases/get_course_details_usecase.dart';

part 'course_details_state.dart';

class CourseDetailsCubit extends Cubit<CourseDetailsState> {
  CourseDetailsCubit(this._getCourseDetailsUseCase)
    : super(const CourseDetailsState());

  final GetCourseDetailsUseCase _getCourseDetailsUseCase;

  Future<void> load(String courseId) async {
    emit(state.copyWith(status: CourseDetailsStatus.loading));
    final result = await _getCourseDetailsUseCase(courseId);
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: CourseDetailsStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (details) {
        final hasLessons = details.sections.any(
          (section) => section.lessons.isNotEmpty,
        );
        if (!hasLessons) {
          emit(
            state.copyWith(status: CourseDetailsStatus.empty, details: details),
          );
          return;
        }
        emit(
          state.copyWith(status: CourseDetailsStatus.loaded, details: details),
        );
      },
    );
  }
}
