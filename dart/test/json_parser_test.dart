import 'package:json_parser/json_parser.dart';
import 'package:test/test.dart';

void main() {
  test('should properly parse number', () {
    expect(parseJson('1234'), 1234);
    expect(parseJson('12.54'), 12.54);
    expect(parseJson('-20'), -20);
    expect(parseJson('1.300004e+10'), 1.300004e+10);
  });

  test('should properly parse boolean', () {
    expect(parseJson('true'), true);
    expect(parseJson('false'), false);
  });

  test('should properly parse null', () {
    expect(parseJson('null'), null);
  });

  test('should properly parse string', () {
    expect(parseJson('"some string"'), 'some string');
    expect(parseJson('"some \\n \\" \\t\\tstring"'), 'some \n " \t\tstring');
  });

  test('should properly parse arrays', () {
    expect(parseJson('[]'), []);
    expect(
      parseJson('["some string", 23.21, false]'),
      [
        'some string',
        23.21,
        false,
      ],
    );
    expect(parseJson('[[true, [false]]]'), [
      [
        true,
        [false]
      ]
    ]);
  });

  test('should properly parse objects', () {
    expect(parseJson('{}'), {});
    expect(
      parseJson('{ "key1": "some string", "num": 23.21, "bool": false }'),
      {
        'key1': 'some string',
        'num': 23.21,
        'bool': false,
      },
    );
    expect(
      parseJson('{ "key1": { "key2": { "bool": false }, "key3": 22 } }'),
      {
        'key1': {
          'key2': {
            'bool': false,
          },
          'key3': 22,
        },
      },
    );
  });

  test('should properly parse complex json', () {
    // https://opensource.adobe.com/Spry/samples/data_region/JSONDataSetSample.html
    final json = '''
      [
        {
          "id": "0001",
          "type": "donut",
          "name": "Cake",
          "ppu": 0.55,
          "batters":
            {
              "batter":
                [
                  { "id": "1001", "type": "Regular" },
                  { "id": "1002", "type": "Chocolate" },
                  { "id": "1003", "type": "Blueberry" },
                  { "id": "1004", "type": "Devil's Food" }
                ]
            },
          "topping":
            [
              { "id": "5001", "type": "None" },
              { "id": "5002", "type": "Glazed" },
              { "id": "5005", "type": "Sugar" },
              { "id": "5007", "type": "Powdered Sugar" },
              { "id": "5006", "type": "Chocolate with Sprinkles" },
              { "id": "5003", "type": "Chocolate" },
              { "id": "5004", "type": "Maple" }
            ]
        },
        {
          "id": "0002",
          "type": "donut",
          "name": "Raised",
          "ppu": 0.55,
          "batters":
            {
              "batter":
                [
                  { "id": "1001", "type": "Regular" }
                ]
            },
          "topping":
            [
              { "id": "5001", "type": "None" },
              { "id": "5002", "type": "Glazed" },
              { "id": "5005", "type": "Sugar" },
              { "id": "5003", "type": "Chocolate" },
              { "id": "5004", "type": "Maple" }
            ]
        },
        {
          "id": "0003",
          "type": "donut",
          "name": "Old Fashioned",
          "ppu": 0.55,
          "batters":
            {
              "batter":
                [
                  { "id": "1001", "type": "Regular" },
                  { "id": "1002", "type": "Chocolate" }
                ]
            },
          "topping":
            [
              { "id": "5001", "type": "None" },
              { "id": "5002", "type": "Glazed" },
              { "id": "5003", "type": "Chocolate" },
              { "id": "5004", "type": "Maple" }
            ]
        }
      ]
    ''';

    final result = [
      {
        'id': '0001',
        'type': 'donut',
        'name': 'Cake',
        'ppu': 0.55,
        'batters': {
          'batter': [
            {'id': '1001', 'type': 'Regular'},
            {'id': '1002', 'type': 'Chocolate'},
            {'id': '1003', 'type': 'Blueberry'},
            {'id': '1004', 'type': "Devil's Food"},
          ],
        },
        'topping': [
          { 'id': '5001', 'type': 'None' },
          { 'id': '5002', 'type': 'Glazed' },
          { 'id': '5005', 'type': 'Sugar' },
          { 'id': '5007', 'type': 'Powdered Sugar' },
          { 'id': '5006', 'type': 'Chocolate with Sprinkles' },
          { 'id': '5003', 'type': 'Chocolate' },
          { 'id': '5004', 'type': 'Maple' },
        ],
      },
      {
        'id': '0002',
        'type': 'donut',
        'name': 'Raised',
        'ppu': 0.55,
        'batters': {
          'batter': [
            {'id': '1001', 'type': 'Regular'},
          ],
        },
        'topping': [
          { 'id': '5001', 'type': 'None' },
          { 'id': '5002', 'type': 'Glazed' },
          { 'id': '5005', 'type': 'Sugar' },
          { 'id': '5003', 'type': 'Chocolate' },
          { 'id': '5004', 'type': 'Maple' },
        ],
      },
      {
        'id': '0003',
        'type': 'donut',
        'name': 'Old Fashioned',
        'ppu': 0.55,
        'batters': {
          'batter': [
            {'id': '1001', 'type': 'Regular'},
            {'id': '1002', 'type': 'Chocolate'},
          ],
        },
        'topping': [
          { 'id': '5001', 'type': 'None' },
          { 'id': '5002', 'type': 'Glazed' },
          { 'id': '5003', 'type': 'Chocolate' },
          { 'id': '5004', 'type': 'Maple' },
        ],
      }
    ];

    expect(parseJson(json), result);
  });
}
