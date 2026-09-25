import 'package:flutter_test/flutter_test.dart';
import 'package:rehla/features/home/domain/entities/course.dart';

void main() {
  test('course lesson count sums every section', () {
    const course = Course(
      id: 'c1',
      title: LocalizedString(ar: 'تشريح', en: 'Anatomy'),
      instructor: LocalizedString(ar: 'سارة', en: 'Sara'),
      thumbnail: 'assets/logo/logo.png',
      sections: [
        Section(
          id: 's1',
          title: LocalizedString(ar: 'عظام', en: 'Bones'),
          lessons: [
            Lesson(
              id: 'l1',
              title: LocalizedString(ar: 'عظام', en: 'Bones'),
              durationSec: 10,
              video: 'a',
            ),
            Lesson(
              id: 'l2',
              title: LocalizedString(ar: 'مفاصل', en: 'Joints'),
              durationSec: 10,
              video: 'b',
            ),
          ],
        ),
        Section(
          id: 's2',
          title: LocalizedString(ar: 'عضلات', en: 'Muscles'),
          lessons: [
            Lesson(
              id: 'l3',
              title: LocalizedString(ar: 'أنواع', en: 'Types'),
              durationSec: 10,
              video: 'c',
            ),
          ],
        ),
      ],
    );

    expect(course.lessonCount, 3);
  });
}
