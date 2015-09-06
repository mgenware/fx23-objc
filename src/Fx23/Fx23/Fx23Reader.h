//
//  Fx23Reader.h
//  Fx23
//
//  Created by Mgen on 14-5-14.
//  Copyright (c) 2014 Mgen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Fx23Reader : NSObject
{
    unichar _prevChar;
}

/* Counts lineIndex and columnIndex during each read operation, default NO */
@property (nonatomic, assign) BOOL collectLineInfo;
/* The index position of current character */
@property (nonatomic, assign, readonly) int index;
/* Zero-based column number of current character at current line */
@property (nonatomic, assign, readonly) int columnIndex;
/* Zero-based line number of current character */
@property (nonatomic, assign, readonly) int lineIndex;
/* The index position of current character without newline characters */
@property (nonatomic, assign, readonly) int visibleIndex;

/* Total length of the string */
- (NSUInteger)length;

/* Returns NO if no more character to read */
- (BOOL)hasNext;
/* Returns the next character without moving the internal index */
- (unichar)peek;
/* Returns the next character and move the internal index forward */
- (unichar)next;

/* Marks a flag at current position */
- (void)mark;
/* Returns a sub-string from last marked position to current position */
- (NSString*)collect;

/* Implementated by subclass */
- (unichar)nextOverride;
/* Implementated by subclass */
- (unichar)peekOverride;

@end
