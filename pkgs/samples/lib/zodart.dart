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
