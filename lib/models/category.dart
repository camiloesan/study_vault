class Category {
  final int categoryId;
  final String name;

  const Category({
    required this.categoryId, 
    required this.name,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'category_id': int categoryId,
        'name': String name,
      } =>
        Category(
          categoryId: categoryId,
          name: name,
        ),
      _ => throw const FormatException('Failed to load category.'),
    };
  }
}