import 'package:zodart/zodart.dart';

// !IMPORTANT
// Output type definitions, fromJson and other boilerplate
// is taken care of by ZodArt code generation,
// but due the limitations of DartPad, 
// code generation is not used in examples.
//
// See more at: https://pub.dev/packages/zodart


/// Person schema map
final personSchemaMap = <String, ZBase>{
  'firstName': ZString().min(1).max(20),
  'lastName': ZString().min(1).max(30),
  'age': ZInt().optional().min(0),
};

void main() {
  final parseSuccess = personSchema.parse({
    'firstName': 'Zod',
    'lastName': 'Art',
  });

  print(parseSuccess.value);

  final parseError = personSchema.parse({
    'firstName': 'ZodArt',
    'lastName': '',
    'age': -1
  });

  // For a more functional style, use `.match(...)`
  if(parseError.isSuccess) {
     print(parseError.value);
  } else {
    print(parseError.issueSummary);
  }
}


// #############################################################
// Helpers - handled automatically with ZodArt code generation
// #############################################################

typedef Person = ({
  String firstName,
  String lastName,
  int? age,
});

Person fromJson(Map<String, dynamic> json) => (
  firstName: json['firstName'],
  lastName: json['lastName'],
  age: json['age'],
);

final personSchema = ZObject.withMapper(personSchemaMap, fromJson: fromJson);
