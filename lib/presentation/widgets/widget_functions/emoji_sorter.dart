
/// Returns the [count] most frequent reactions from [reactions], in descending order.
List<String> getTopReactions(List<String> reactions, {int count = 3}) {
  if (reactions.isEmpty) return [];

  // Build and sort the entries by frequency:
  final entries = reactions
      .fold<Map<String, int>>({}, (map, r) {
        map[r] = (map[r] ?? 0) + 1;
        return map;
      })
      .entries
      .toList();

  entries.sort((a, b) => b.value.compareTo(a.value));

  // Take only up to [count] entries:
  final topEntries = entries.sublist(0, entries.length < count ? entries.length : count);

  // Extract the emoji keys:
  return topEntries.map((e) => e.key).toList();
}
