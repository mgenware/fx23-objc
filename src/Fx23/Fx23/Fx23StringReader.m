//
//  Fx23StringReader.m
//  Fx23
//
//  Created by Mgen on 14-5-14.
//  Copyright (c) 2014 Mgen. All rights reserved.
//

#import "Fx23StringReader.h"

@implementation Fx23StringReader

- (instancetype)initWithString:(NSString*)str {
    self = [super init];
    if (!self)
        return nil;
    
    _innerString = str;
    _length = str.length;
    return self;
}

+ (instancetype)readerWithString:(NSString*)str {
    return [[Fx23StringReader alloc] initWithString:str];
}

- (NSUInteger)length {
    return _length;
}

- (unichar)nextOverride {
    return [_innerString characterAtIndex:self.index];
}

- (unichar)peekOverride {
    return [self nextOverride];
}

- (void)mark {
    _markIndex = self.index;
}

- (NSString *)collect {
    if (_markIndex == self.index) {
        return nil;
    }
    return [_innerString substringWithRange:NSMakeRange(_markIndex, self.index - _markIndex)];
}

@end
