import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zodart/zodart.dart';

// !IMPORTANT
// Output type definitions, fromJson and other boilerplate
// is taken care of by ZodArt code generation,
// but due the limitations of DartPad,
// code generation is not used in examples.
//
// See more at: https://pub.dev/packages/zodart

// ###########################################################
// ZodArt schema for the user form
// ###########################################################
final userSchemaMap = <String, ZBase>{
  'userName': ZString().trim().regex(r'^[a-zA-Z][\w]{1,20}$'),
  'firstName': ZString().trim().min(1).max(20),
  'lastName': ZString().trim().min(1).max(30),
};

// ###########################################################
// ZodArt helpers (handled automatically with code generation)
// ###########################################################
typedef User = ({String userName, String firstName, String lastName});

final userSchema = ZObject.withMapper(userSchemaMap, fromJson: fromJson);

User fromJson(Map<String, dynamic> json) => (
  firstName: json['firstName'],
  lastName: json['lastName'],
  userName: json['userName'],
);

// #############################
// Riverpod - user form specific
// #############################
class UserNotifier extends ZodArtFormNotifier<User> {
  @override
  FormState<User> build() => init(userSchemaMap);

  @override
  ZRes<User> parse(Map<String, dynamic> rawValue) => userSchema.parse(rawValue);
}

final userNotifierProvider = getZodArtFormNotifierProvider(UserNotifier.new);

// #########################
// ZodArt Form Application
// #########################
void main() => runApp(ProviderScope(child: ZodArtFormApp()));

class ZodArtFormApp extends StatelessWidget {
  const ZodArtFormApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('ZodArt Form Example'),
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          actions: [LanguageSelector()],
        ),
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Align(
                alignment: AlignmentGeometry.topCenter,
                child: UserForm(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class UserForm extends ConsumerWidget {
  const UserForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Form(
      child: SingleChildScrollView(
        child: Column(
          spacing: 10,
          children: [
            ZFormField(
              label: 'Username',
              schemaField: 'userName',
              provider: userNotifierProvider,
            ),
            ZFormField(
              label: 'First Name',
              schemaField: 'firstName',
              provider: userNotifierProvider,
            ),
            ZFormField(
              label: 'Last Name',
              schemaField: 'lastName',
              provider: userNotifierProvider,
            ),
            ElevatedButton(
              onPressed: () {
                final parseResult = ref
                    .read(userNotifierProvider.notifier)
                    .submit();
                final snackBar = parseResult.match(
                  (_) => SnackBar(
                    content: Text('Input is invalid'),
                    backgroundColor: Colors.red,
                  ),
                  (user) => SnackBar(
                    content: Text('Input is valid: $user'),
                    backgroundColor: Colors.green,
                  ),
                );

                ScaffoldMessenger.of(context)
                  ..clearSnackBars()
                  ..showSnackBar(snackBar);
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}

// #############################
// Generic widgets
// #############################
class ZFormField<T> extends ConsumerWidget with ZodArtField<T> {
  const ZFormField({
    required this.label,
    required this.schemaField,
    required this.provider,
    super.key,
  });

  final String label;

  @override
  final String schemaField;

  @override
  final ZFormNotifierProvider<T> provider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(provider.notifier);
    return TextFormField(
      onChanged: (val) => notifier.updateRawValue(schemaField, val),
      decoration: InputDecoration(
        labelText: label,
        errorText: ref.watch(selectError),
      ),
    );
  }
}

class LanguageSelector extends ConsumerWidget {
  const LanguageSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopupMenuButton(
      child: Row(
        children: [Text('Language'), SizedBox(width: 5), Icon(Icons.language)],
      ),
      // icon: Icon(Icons.language),
      onSelected: (val) =>
          ZLocalizationContext.current = ZIssueLocalizationService(val),
      itemBuilder: (context) => Language.values
          .map((lang) => PopupMenuItem(value: lang, child: Text(lang.name)))
          .toList(),
    );
  }
}

// #############################
// Riverpod - generic helpers
// #############################
typedef FormState<T> = ({
  ZRes<T> parsedResult,
  Map<String, dynamic> rawValue,
  bool touched,
});

typedef ZFormNotifierProvider<T> =
    NotifierProvider<ZodArtFormNotifier<T>, FormState<T>>;

NotifierProvider<N, FormState<S>> getZodArtFormNotifierProvider<
  N extends ZodArtFormNotifier<S>,
  S
>(N Function() createNotifier) => NotifierProvider(createNotifier);

mixin ZodArtField<T> {
  String get schemaField;
  ZFormNotifierProvider<T> get provider;

  Provider<String?> get selectError =>
      selectErrorForField(provider)(schemaField);
}

abstract class ZodArtFormNotifier<T> extends Notifier<FormState<T>> {
  ZRes<T> parse(Map<String, dynamic> rawValue);

  ZRes<T> submit() {
    final newParsedResult = parse(state.rawValue);

    state = (
      rawValue: state.rawValue,
      parsedResult: newParsedResult,
      touched: true,
    );

    return newParsedResult;
  }

  void updateRawValue(String property, String val) {
    final newRawValue = {...state.rawValue, property: val};

    state = (
      rawValue: newRawValue,
      parsedResult: parse(newRawValue),
      touched: state.touched,
    );
  }

  FormState<T> init(Map<String, dynamic> schemaMap) {
    final rawValue = schemaMap.map((key, _) => MapEntry(key, ''));
    final parsedResult = parse(rawValue);

    return (rawValue: rawValue, parsedResult: parsedResult, touched: false);
  }
}

Provider<String?> Function(String propertyName) selectErrorForField(
  ZFormNotifierProvider notifierProvider,
) => (String propertyName) {
  return Provider<String?>((ref) {
    return ref.watch(
      notifierProvider.select(
        (state) => switch (state.touched) {
          true => state.parsedResult.getSummaryFor(propertyName),
          false => null,
        },
      ),
    );
  });
};
