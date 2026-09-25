bool isCompleted({required int positionMs, required int durationMs}) {
  if (durationMs <= 0) return false;
  return positionMs / durationMs >= 0.9;
}

bool isUnlocked({
  required int index,
  required List<String> lessonIds,
  required Set<String> completedIds,
}) {
  if (index == 0) return true;
  return completedIds.contains(lessonIds[index - 1]);
}

double courseProgress({
  required List<String> lessonIds,
  required Set<String> completedIds,
}) {
  if (lessonIds.isEmpty) return 0;
  final completed = lessonIds.where(completedIds.contains).length;
  return completed / lessonIds.length;
}
