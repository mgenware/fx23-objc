//
//  main.m
//  Fx23
//
//  Created by Mgen on 14-5-14.
//  Copyright (c) 2014年 Mgen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Fx23StringReader.h"
#import "Fx23Reader+Extension.h"

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

int main(int argc, const char * argv[]) {
    @autoreleasepool {
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
    }
    return 0;
}

