(class_definition
  body: (block . (expression_statement (string) @docs)))

(function_definition
  body: (block . (expression_statement (string) @docs)))

((expression_statement (assignment)) . (expression_statement (string) @docs))

