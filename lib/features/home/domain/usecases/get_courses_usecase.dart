import 'package:dartz/dartz.dart';
import 'package:rehla/core/error/failure.dart';
import 'package:rehla/core/usecase/base_usecase.dart';
import 'package:rehla/features/home/domain/entities/course.dart';
import 'package:rehla/features/home/domain/repositories/course_repository.dart';

class GetCoursesUseCase extends BaseUseCase<HomeData, NoParameters> {
  GetCoursesUseCase(this.repository);

  final CourseRepository repository;

  @override
  Future<Either<Failure, HomeData>> call(NoParameters parameters) async {
    final coursesResult = await repository.getCourses();
    return coursesResult.fold(
      (failure) async => Left(failure),
      (courses) async {
        final continueResult = await repository.getContinueWatching();
        return continueResult.fold(
          (failure) => Left<Failure, HomeData>(failure),
          (continueWatching) => Right(
            HomeData(
              courses: courses,
              continueWatching: continueWatching,
            ),
          ),
        );
      },
    );
  }
}
