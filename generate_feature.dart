import 'dart:io';

// dart generate_feature.dart home
// flutter pub run easy_localization:generate --source-dir ./assets/translations -f keys -o locale_keys.g.dart
void main(List<String> args) {
  if (args.isEmpty) {
    print('❗ Please provide a feature name.');
    exit(1);
  }

  final featureName = args[0];
  final basePath = 'lib/features/$featureName';

  final folders = [
    '$basePath/data/data_sources',
    '$basePath/data/repositories',
    '$basePath/data/models',
    '$basePath/domain/repositories',
    '$basePath/domain/use_cases',
    '$basePath/presentation/pages',
    '$basePath/presentation/widgets',
  ];

  for (final folder in folders) {
    final dir = Directory(folder);
    if (!dir.existsSync()) {
      dir.createSync(recursive: true);
      print('✅ Created: ${dir.path}');
    } else {
      print('⚠️ Already exists: ${dir.path}');
    }
  }

  print('\n🎉 Feature "$featureName" structure created!');
}
