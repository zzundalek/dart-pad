// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// This file has been automatically generated - please do not edit it manually.

import 'package:collection/collection.dart';

class Sample {
  final String category;
  final String icon;
  final String name;
  final String id;
  final String source;

  const Sample({
    required this.category,
    required this.icon,
    required this.name,
    required this.id,
    required this.source,
  });

  bool get isDart => category == 'Dart';

  bool get shouldList => category != 'Defaults';

  @override
  String toString() => '[$category] $name ($id)';
}

abstract final class Samples {
  static const List<Sample> all = [
    _zodart,
    _counter,
  ];

  static const Map<String, List<Sample>> categories = {
    'Dart': [_zodart],
    'Flutter': [_counter],
  };

  static Sample? getById(String? id) => all.firstWhereOrNull((s) => s.id == id);

  static String defaultSnippet({bool forFlutter = false}) =>
      getById(forFlutter ? 'flutter' : 'dart')!.source;
}

const _zodart = Sample(
  category: 'Dart',
  icon: 'dart',
  name: 'ZodArt',
  id: 'zodart',
  source: r'''
import 'package:zodart/zodart.dart';

// IMPORTANT: Output type definitions, fromJson, per-field issue handling,
// and other boilerplate can be SIGNIFICANTLY reduced using code generation.
// Code generation also provides additional type safety and improves developer experience.
//
// See more at: https://pub.dev/packages/zodart

/// Output type used as the parse result
typedef Person = ({
  String firstName,
  String lastName,
  int? age,
  bool? disabled,
});

/// Returns a [Person] from an unsafe map
Person fromJson(Map<String, dynamic> json) => (
  firstName: json['firstName'],
  lastName: json['lastName'],
  age: json['age'],
  disabled: json['disabled'],
);

/// Schema defined using ZodArt
///
/// Validates that:
/// - `firstName` is from 1 to 20 characters long
/// - `lastName` is from 1 to 30 characters long
/// - `age` is greater or equal to 0 (optional)
/// - `disabled` is present, but can be null
final personSchema = ZObject.withMapper({
  'firstName': ZString().min(1).max(20),
  'lastName': ZString().min(1).max(30),
  'age': ZInt().optional().min(0),
  'disabled': ZBool().nullable(),
}, fromJson: fromJson);

void main() {
  // Parse the value
  final res = personSchema.parse({
    'firstName': 'Zod',
    'lastName': 'Art',
    'disabled': null,
  });

  // Use simple way to access the result
  print('Parse success: ${res.isSuccess}');
  print('Parsed value: ${res.value}');

  // Or use `match` method for a more FP way
  res.match(
    (issues) => print('❌ Validation failed: ${issues.localizedSummary}'),
    (item) => print('🟢 Validation successful: $item'),
  );

  // To obtain only issues summary for `firstName` use `getSummaryFor`
  final firstNameIssueSummary = res.getSummaryFor('firstName');
  print('Person.firstName issue: $firstNameIssueSummary');
}
''',
);

const _counter = Sample(
  category: 'Flutter',
  icon: 'flutter',
  name: 'Counter',
  id: 'counter',
  source: r'''
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.blue),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;

  const MyHomePage({super.key, required this.title});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
''',
);
