import 'package:flutter_test/flutter_test.dart';
import 'package:rehla/features/home/domain/entities/course.dart';

void main() {
  test('course lesson count sums every section', () {
    const course = Course(
      id: 'c1',
      title: 'Anatomy',
      instructor: 'Sara',
      thumbnail: 'assets/logo/logo.png',
      sections: [
        Section(
          id: 's1',
          title: 'Bones',
          lessons: [
            Lesson(id: 'l1', title: 'Bones', durationSec: 10, video: 'a'),
            Lesson(id: 'l2', title: 'Joints', durationSec: 10, video: 'b'),
          ],
        ),
        Section(
          id: 's2',
          title: 'Muscles',
          lessons: [
            Lesson(id: 'l3', title: 'Types', durationSec: 10, video: 'c'),
          ],
        ),
      ],
    );

    expect(course.lessonCount, 3);
  });
}
