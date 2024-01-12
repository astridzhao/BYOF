/// Recipe Model.
class Recipe {
  final int id;
  final String title;
  final List<String> ingredients;
  final List<String> instructions;
  final DateTime saveAt;

  const Recipe({
    required this.id,
    required this.title,
    required this.ingredients,
    required this.instructions,
    required this.saveAt,
  });

  static Recipe fromMap(Map<String, dynamic> map) {
    var ingredients = (map['ingredients'] as String).split(',');
    var instructions = (map['instructions'] as String).split(';');
    var saveAt = DateTime.fromMillisecondsSinceEpoch(map['saveAt'] as int);
    return Recipe(
      id: map['id'] as int,
      title: map['title'] as String,
      ingredients: ingredients,
      instructions: instructions,
      saveAt: saveAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'ingredients': ingredients.join(','),
      'instructions': instructions.join(';'),
      'saveAt': saveAt.millisecondsSinceEpoch,
    };
  }

  @override
  String toString() {
    return """
Recipe {
  id: $id,
  title: $title,
  ingredients: [${ingredients.join(', ')}],
  instructions: [
    ${instructions.map((e) => "e").join('\n')}
  ],
}
    """;
  }
}
