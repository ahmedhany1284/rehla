part of 'course_details_cubit.dart';

enum CourseDetailsStatus { initial, loading, loaded, empty, error }

const _undefined = Object();

class CourseDetailsState extends Equatable {
  const CourseDetailsState({
    this.status = CourseDetailsStatus.initial,
    this.details,
    this.errorMessage,
  });

  final CourseDetailsStatus status;
  final CourseDetails? details;
  final String? errorMessage;

  CourseDetailsState copyWith({
    CourseDetailsStatus? status,
    Object? details = _undefined,
    Object? errorMessage = _undefined,
  }) {
    return CourseDetailsState(
      status: status ?? this.status,
      details: identical(details, _undefined)
          ? this.details
          : details as CourseDetails?,
      errorMessage: identical(errorMessage, _undefined)
          ? this.errorMessage
          : errorMessage as String?,
    );
  }

  @override
  List<Object?> get props => [status, details, errorMessage];
}
