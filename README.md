# Fx23
Text scanner, available in [Node.js](https://github.com/mgenware/fx23-node), [C#](https://github.com/mgenware/fx23-csharp) and [Objective-C](https://github.com/mgenware/fx23-objc).

# API
## Fx23Reader Class
Base scanner class.
### Properties
* `collectLineInfo` counts lineIndex and columnIndex during each read operation, default NO.
* `index` the index position of current character.
* `columnIndex` zero-based column number of current character at current line.
* `lineIndex` zero-based line number of current character.
* `visibleIndex` the index position of current character without newline characters.
* `length` total length of the string.

### Methods
* `hasNext` returns NO if no more character to read.
* `peek` returns the next character without moving the internal index.
* `next` returns the next character and move the internal index forward.
* `mark` marks a flag at current position.
* `collect` returns a sub-string from last marked position to current position.
* `nextOverride` implementated by subclass.
* `peekOverride` implementated by subclass.

## Fx23StringReader Class
A concret class derived from Fx23Reader, use this to create a scanner from a string.

### Methods
* `initWithString`, `readerWithString` initializes a Fx23Reader from an `NSString`.

## Fx23Reader (Extension)
This class adds some useful extension methods to Fx23Reader.
### Methods
* `collectWhile` moves forward while condition is true, and returns the string scanned.
* `skipWhile` moves forward while condition is true.
* `moveToContent` moves to next non-whitespace character.
* `skipLine` moves to next line.
* `collectLine` moves to next line and returns current line.

# Example
```objective-c
// the string we need to scan
NSString *str = @"   abcdef\r\na b c\nMgen123abc";

// initialize the reader
Fx23StringReader *reader = [Fx23StringReader readerWithString:str];
// counts lineIndex and columnIndex during each read operation
reader.collectLineInfo = YES;

NSLog(@"%@", @"Move to content");
[reader moveToContent];
printInfo(reader);
/*
 Reader position:
 "   abcdef\r\na b c\nMgen123abc"
  ---|------ - ------ ----------
 
 Output:
 Move to content
 Current char: 'a'
 Line: 1
 Column: 4
 Index(without newline): 3
 Index: 3
 
 */

NSLog(@"%@", @"Read until 'e'");
NSLog(@"Result -> %@", [reader collectWhile:^BOOL(unichar c) {
    return c != 'e';
}]);
printInfo(reader);
/*
 Reader position:
 "   abcdef\r\na b c\nMgen123abc"
  ---====|-- - ------ ----------
 
 Output:
 Read until 'e'
 Result -> abcd
 Current char: 'e'
 Line: 1
 Column: 8
 Index(without newline): 7
 Index: 7
 */

NSLog(@"%@", @"Get remaining characters in current line");
NSLog(@"Result -> %@", [reader collectLine]);
printInfo(reader);
/*
 Reader position:
 "   abcdef\r\na b c\nMgen123abc"
  -------==- - |----- ----------
 
 Output:
 Get remaining characters in current line
 Result -> ef
 Current char: 'a'
 Line: 2
 Column: 1
 Index(without newline): 9
 Index: 11
 
 */

NSLog(@"%@", @"Skip the whole line");
[reader skipLine];
printInfo(reader);
/*
 Reader position:
 "   abcdef\r\na b c\nMgen123abc"
  ---------- - ------ |---------
 
 Output:
 Skip the whole line
 Current char: 'M'
 Line: 3
 Column: 1
 Index(without newline): 14
 Index: 17
 
 */

NSLog(@"%@", @"Skip to first number");
NSCharacterSet *numericSet = [NSCharacterSet decimalDigitCharacterSet];
[reader skipWhile:^BOOL(unichar c) {
    return ![numericSet characterIsMember:c];
}];
printInfo(reader);
/*
 Reader position:
 "   abcdef\r\na b c\nMgen123abc"
  ---------- - ------ ----|-----
 
 Output:
 Skip to first number
 Current char: '1'
 Line: 3
 Column: 5
 Index(without newline): 18
 Index: 21
 
 */

NSLog(@"%@", @"Read all numbers");
NSLog(@"%@", [reader collectWhile:^BOOL(unichar c) {
    return [numericSet characterIsMember:c];
}]);
printInfo(reader);
/*
 Reader position:
 "   abcdef\r\na b c\nMgen123abc"
  ---------------------------|--
 
 Output:
 Read all numbers
 123
 Current char: 'a'
 Line: 3
 Column: 8
 Index(without newline): 21
 Index: 24
 
 */

NSLog(@"%@", @"Read to end using mark and collect");
[reader mark];
while ([reader hasNext]) {
    [reader next];
}
NSLog(@"Result -> %@", [reader collect]);
/*
 Reader position:
 "   abcdef\r\na b c\nMgen123abc"
  ---------------------------===
 
 Output:
 Result -> abc
 
 */
```
The `printInfo` function used by example:
```objective-c
void printInfo(Fx23StringReader *reader) {
    NSString *curChar;
    unichar c;
    if ([reader hasNext]) {
        c = [reader peek];
        curChar = [NSString stringWithCharacters:&c length:1];
    } else {
        curChar = @"End of string";
    }
    NSLog(@"Current char: '%@'\nLine: %d\nColumn: %d\nIndex(without newline): %d\nIndex: %d",
          curChar,
          reader.lineIndex + 1,
          reader.columnIndex + 1,
          reader.visibleIndex,
          reader.index);
}
```

# License
[MIT](LICENSE)
