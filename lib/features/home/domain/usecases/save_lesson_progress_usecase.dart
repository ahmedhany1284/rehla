import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:rehla/core/error/failure.dart';
import 'package:rehla/core/usecase/base_usecase.dart';
import 'package:rehla/features/home/domain/repositories/course_repository.dart';

class SaveProgressParams extends Equatable {
  const SaveProgressParams({
    required this.lessonId,
    required this.positionSec,
    required this.completed,
  });

  final String lessonId;
  final int positionSec;
  final bool completed;

  @override
  List<Object> get props => [lessonId, positionSec, completed];
}

class SaveLessonProgressUseCase extends BaseUseCase<Unit, SaveProgressParams> {
  SaveLessonProgressUseCase(this.repository);

  final CourseRepository repository;

  @override
  Future<Either<Failure, Unit>> call(SaveProgressParams params) {
    return repository.saveLessonProgress(
      lessonId: params.lessonId,
      positionSec: params.positionSec,
      completed: params.completed,
    );
  }
}
