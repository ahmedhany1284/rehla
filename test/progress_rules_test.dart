import 'package:flutter_test/flutter_test.dart';
import 'package:rehla/features/home/domain/rules/progress_rules.dart';

void main() {
  group('isCompleted', () {
    test('is false at 89 percent', () {
      expect(isCompleted(positionMs: 890, durationMs: 1000), isFalse);
    });

    test('is true at exactly 90 percent', () {
      expect(isCompleted(positionMs: 900, durationMs: 1000), isTrue);
    });

    test('is false when duration is 0', () {
      expect(isCompleted(positionMs: 900, durationMs: 0), isFalse);
    });
  });

  group('isUnlocked', () {
    const lessonIds = ['l1', 'l2'];

    test('the first lesson is always unlocked', () {
      expect(
        isUnlocked(index: 0, lessonIds: lessonIds, completedIds: {}),
        isTrue,
      );
    });

    test('the second lesson stays locked until the first is completed', () {
      expect(
        isUnlocked(index: 1, lessonIds: lessonIds, completedIds: {}),
        isFalse,
      );
    });

    test('the second lesson unlocks once the first is completed', () {
      expect(
        isUnlocked(index: 1, lessonIds: lessonIds, completedIds: {'l1'}),
        isTrue,
      );
    });
  });

  group('courseProgress', () {
    test('half done returns 0.5', () {
      expect(
        courseProgress(
          lessonIds: ['l1', 'l2', 'l3', 'l4'],
          completedIds: {'l1', 'l2'},
        ),
        0.5,
      );
    });

    test('an empty lesson list returns 0', () {
      expect(courseProgress(lessonIds: [], completedIds: {'l1'}), 0);
    });
  });
}
