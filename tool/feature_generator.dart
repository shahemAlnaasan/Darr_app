// tool/generate.dart
// ignore_for_file: avoid_print

// dart run tool/feature_generator.dart create_feature trans_details
// dart run tool/feature_generator.dart add_function trans_details transDetails request.json response.json
// tool/generate.dart
import 'dart:convert';
import 'dart:io';

void main(List<String> args) async {
  if (args.isEmpty) {
    print('❗ Usage:');
    print('  dart run tool/generate.dart create_feature <featureName>');
    print('  dart run tool/generate.dart add_function <featureName> <functionName> <request.json> <response.json>');
    exit(1);
  }

  final command = args[0];

  switch (command) {
    case 'create_feature':
      if (args.length < 2) {
        print('❗ Missing feature name.');
        exit(1);
      }
      final featureName = args[1];
      _createFeature(featureName);
      break;

    case 'add_function':
      if (args.length < 5) {
        print('❗ Missing arguments.');
        exit(1);
      }
      final featureName = args[1];
      final functionName = args[2];
      final requestFile = File(args[3]);
      final responseFile = File(args[4]);

      if (!requestFile.existsSync() || !responseFile.existsSync()) {
        print('❗ Request or response JSON file not found.');
        exit(1);
      }

      final requestJson = jsonDecode(requestFile.readAsStringSync()) as Map<String, dynamic>;
      final responseJson = jsonDecode(responseFile.readAsStringSync()) as Map<String, dynamic>;

      _addFunction(featureName, functionName, requestJson, responseJson);
      break;

    default:
      print('❗ Unknown command: $command');
      exit(1);
  }
}

/// ---------------- CREATE FEATURE ----------------
void _createFeature(String featureName) {
  final basePath = 'lib/features/$featureName';

  final folders = [
    '$basePath/data/data_sources',
    '$basePath/data/repositories',
    '$basePath/data/models',
    '$basePath/domain/repositories',
    '$basePath/domain/use_cases',
    '$basePath/presentation/bloc',
  ];

  for (final folder in folders) {
    final dir = Directory(folder);
    if (!dir.existsSync()) {
      dir.createSync(recursive: true);
      print('✅ Created: ${dir.path}');
    } else {
      print('⚠️ Already exists: ${dir.path}');
      return;
    }
  }

  // Create empty Bloc/Event/State files
  final blocPath = '$basePath/presentation/bloc';
  File('$blocPath/${featureName}_bloc.dart').writeAsStringSync('''
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part '${featureName}_event.dart';
part '${featureName}_state.dart';

class ${_pascal(featureName)}Bloc extends Bloc<${_pascal(featureName)}Event, ${_pascal(featureName)}State> {
  ${_pascal(featureName)}Bloc() : super(${_pascal(featureName)}State());
}
''');

  File('$blocPath/${featureName}_event.dart').writeAsStringSync('''
part of '${featureName}_bloc.dart';

sealed class ${_pascal(featureName)}Event extends Equatable {
  const ${_pascal(featureName)}Event();
  @override
  List<Object?> get props => [];
}
''');

  File('$blocPath/${featureName}_state.dart').writeAsStringSync('''
part of '${featureName}_bloc.dart';

class ${_pascal(featureName)}State extends Equatable {
  final String? errorMessage;
  const ${_pascal(featureName)}State({this.errorMessage});

    ${_pascal(featureName)}State copyWith({String? errorMessage}) {
    return ${_pascal(featureName)}State(errorMessage: errorMessage ?? this.errorMessage);
  }


  @override
  List<Object?> get props => [errorMessage];
}
''');

  print('\n🎉 Feature "$featureName" created with empty bloc!');
}

/// ---------------- ADD FUNCTION ----------------
void _addFunction(
  String featureName,
  String functionName,
  Map<String, dynamic> requestJson,
  Map<String, dynamic> responseJson,
) {
  final className = _pascal(functionName);
  final camelFunc = _camel(functionName);
  final camelFeature = _camel(featureName);

  final basePath = 'lib/features/$featureName';

  // 1. Model
  final modelFile = File('$basePath/data/models/${functionName}_response.dart');
  final modelContent = _generateModel(className, responseJson);
  modelFile.writeAsStringSync(modelContent);
  print('✅ Model created: ${modelFile.path}');

  // 2. Repository interface
  final repoFile = File('$basePath/domain/repositories/${featureName}_repository.dart');
  if (!repoFile.existsSync()) {
    repoFile.writeAsStringSync('''
abstract class ${_pascal(camelFeature)}Repository {
  DataResponse<${className}Response> $camelFunc({required ${className}Params params});
}
''');
  } else {
    final content = repoFile.readAsStringSync();
    if (!content.contains('$functionName(')) {
      final updated = content.replaceFirst(
        RegExp(r'}\s*$'),
        '  DataResponse<${className}Response> $functionName({required ${className}Params params});\n}',
      );
      repoFile.writeAsStringSync(updated);
    }
  }
  print('✅ Repository updated: ${repoFile.path}');

  // 3. Usecase
  final usecaseFile = File('$basePath/domain/use_cases/${functionName}_usecase.dart');
  usecaseFile.writeAsStringSync('''
import '../../../../common/consts/typedef.dart';
import '../../data/models/${functionName}_response.dart';
import '../repositories/${featureName}_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class ${className}Usecase {
  final ${_pascal(featureName)}Repository ${camelFeature}Repository;

  ${className}Usecase({required this.${camelFeature}Repository});

  DataResponse<${className}Response> call({required ${className}Params params}) {
    return ${camelFeature}Repository.$camelFunc(params: params);
  }
}

class ${className}Params with Params {
  ${requestJson.entries.map((e) => 'final String ${e.key};').join('\n  ')}

  ${className}Params({${requestJson.entries.map((e) => 'required this.${e.key}').join(', ')}});

  @override
  BodyMap getBody() => {
    ${requestJson.entries.map((e) => '"${e.key}": ${e.key},').join('\n    ')}
  };
}
''');
  print('✅ Usecase created: ${usecaseFile.path}');

  // 4. Repository Implementation
  final repoImpFile = File('$basePath/data/repositories/${featureName}_repository_imp.dart');
  if (!repoImpFile.existsSync()) {
    repoImpFile.writeAsStringSync('''
import 'package:injectable/injectable.dart';
import '../../domain/repositories/${featureName}_repository.dart';
import '../data_sources/${featureName}_remote_data_source.dart';
import '../../domain/use_cases/${functionName}_usecase.dart';
import '../models/${functionName}_response.dart';

@Injectable(as: ${_pascal(featureName)}Repository)
class ${_pascal(featureName)}RepositoryImp implements ${_pascal(featureName)}Repository {
  final ${_pascal(featureName)}RemoteDataSource ${camelFeature}RemoteDataSource;

  ${_pascal(featureName)}RepositoryImp({required this.${camelFeature}RemoteDataSource});

  @override
  DataResponse<${className}Response> $camelFunc({required ${className}Params params}) {
    return ${camelFeature}RemoteDataSource.$camelFunc(params: params);
  }
}
''');
  } else {
    final content = repoImpFile.readAsStringSync();
    if (!content.contains('$functionName(')) {
      final updated = content.replaceFirst(
        RegExp(r'}\s*$'),
        '  @override\n  DataResponse<${className}Response> $functionName({required ${className}Params params}) {\n'
        '    return ${camelFeature}RemoteDataSource.$functionName(params: params);\n  }\n}',
      );
      repoImpFile.writeAsStringSync(updated);
    }
  }
  print('✅ RepositoryImp updated: ${repoImpFile.path}');

  // 5. DataSource
  final dataSourceFile = File('$basePath/data/data_sources/${featureName}_remote_data_source.dart');
  if (!dataSourceFile.existsSync()) {
    dataSourceFile.writeAsStringSync('''
import 'package:injectable/injectable.dart';
import '../../../../common/network/api_handler.dart';
import '../../../../common/network/http_client.dart';
import '../../domain/use_cases/${functionName}_usecase.dart';
import '../models/${functionName}_response.dart';

@injectable
class ${_pascal(featureName)}RemoteDataSource with ApiHandler {
  final HTTPClient httpClient;

  ${_pascal(featureName)}RemoteDataSource({required this.httpClient});

  Future<Either<Failure, ${className}Response>> $camelFunc({required ${className}Params params}) async {
    return handleApiCall(
      apiCall: () => httpClient.post(AppEndPoint.$camelFunc, data: params.getBody()),
      fromJson: (json) => ${className}Response.fromJson(json),
    );
  }
}
''');
  } else {
    final content = dataSourceFile.readAsStringSync();
    if (!content.contains('$functionName(')) {
      final updated = content.replaceFirst(
        RegExp(r'}\s*$'),
        '  Future<Either<Failure, ${className}Response>> $functionName({required ${className}Params params}) async {\n'
        '    return handleApiCall(\n'
        '      apiCall: () => httpClient.post(AppEndPoint.${functionName}, data: params.getBody()),\n'
        '      fromJson: (json) => ${className}Response.fromJson(json),\n'
        '    );\n  }\n}',
      );
      dataSourceFile.writeAsStringSync(updated);
    }
  }
  print('✅ DataSource updated: ${dataSourceFile.path}');

  // // 6. Bloc update
  // _updateBloc(basePath, featureName, functionName, className);
  // print('✅ Bloc updated!');
}

/// ---------------- MODEL GENERATION ----------------
String _generateModel(String className, Map<String, dynamic> json) {
  final fields = json.entries
      .map((e) {
        final type = e.value == null
            ? 'String?'
            : (e.value is int
                  ? 'int'
                  : e.value is double
                  ? 'double'
                  : 'String');
        return '  final $type ${e.key};';
      })
      .join('\n');

  final fromJson = json.entries
      .map((e) {
        return '      ${e.key}: json["${e.key}"],';
      })
      .join('\n');

  final toJson = json.entries
      .map((e) {
        return '      "${e.key}": ${e.key},';
      })
      .join('\n');

  return '''
class ${className}Response {
$fields

  ${className}Response({${json.keys.map((k) => 'required this.$k').join(', ')}});

  factory ${className}Response.fromJson(Map<String, dynamic> json) => ${className}Response(
$fromJson
  );

  Map<String, dynamic> toJson() => {
$toJson
  };
}
''';
}

/// ---------------- BLOC UPDATE ----------------
// void _updateBloc(String basePath, String featureName, String functionName, String className) {
//   final blocPath = '$basePath/presentation/bloc';
//   final blocFile = File('$blocPath/${featureName}_bloc.dart');

//   if (!blocFile.existsSync()) return;

//   var blocContent = blocFile.readAsStringSync();
//   final blocClassName = '${_pascal(featureName)}Bloc';

//   // 1) Add usecase field if missing
//   if (!blocContent.contains('final ${className}Usecase ${functionName}Usecase;')) {
//     blocContent = blocContent.replaceAllMapped(
//       RegExp(r'(class ' + blocClassName + r' extends Bloc<.*> {)'),
//       (m) => '${m[1]}\n  final ${className}Usecase ${functionName}Usecase;',
//     );
//   }

//   // 2) Add constructor injection + on<Event> registration
//   if (!blocContent.contains('on<Get${className}Event>(_onGet${className}Event);')) {
//     blocContent = blocContent.replaceAllMapped(
//       RegExp(r'(' + blocClassName + r'\([^)]*\)\s*:\s*super\(.*\)\s*{)'),
//       (m) => '${m[1]}\n    on<Get${className}Event>(_onGet${className}Event);',
//     );
//   }

//   // 3) Add event handler method before final class closing brace
//   if (!blocContent.contains('_onGet${className}Event')) {
//     blocContent = blocContent.replaceFirstMapped(
//       RegExp(r'(}\s*)$'), // last closing brace of the class
//       (m) =>
//           '  Future<void> _onGet${className}Event(Get${className}Event event, Emitter<${_pascal(featureName)}State> emit) async {\n'
//           '    emit(state.copyWith(${functionName}Status: Status.loading));\n'
//           '    final result = await ${functionName}Usecase(params: event.params);\n'
//           '    result.fold(\n'
//           '      (failure) => emit(state.copyWith(${functionName}Status: Status.failure, ${functionName}Error: failure.message)),\n'
//           '      (response) => emit(state.copyWith(${functionName}Status: Status.success, ${functionName}Response: response)),\n'
//           '    );\n'
//           '  }\n'
//           '\n${m[1]}',
//     );
//   }

//   blocFile.writeAsStringSync(blocContent);
// }

String _camel(String input) {
  final pascal = _pascal(input);
  return pascal[0].toLowerCase() + pascal.substring(1);
}

/// ---------------- HELPERS ----------------
String _pascal(String text) => text.split('_').map((w) => w[0].toUpperCase() + w.substring(1)).join();
