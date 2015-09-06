//
//  Fx23Reader.m
//  Fx23
//
//  Created by Mgen on 14-5-14.
//  Copyright (c) 2014 Mgen. All rights reserved.
//

#import "Fx23Reader.h"

@implementation Fx23Reader

- (instancetype)init {
    self = [super init];
    if (!self)
        return nil;
    
    return self;
}

- (BOOL)hasNext {
    return _index < [self length];
}

- (unichar)peek {
    return [self peekOverride];
}

- (unichar)next {
    unichar next = [self nextOverride];
    if (_collectLineInfo) {
        switch (next) {
            case '\r': {
                _lineIndex++;
                _columnIndex = 0;
                break;
            }
            case '\n': {
                // checking for windows '\r\n'
                if (_prevChar != '\r') {
                    _lineIndex++;
                    _columnIndex = 0;
                }
                break;
            }
            default: {
                _columnIndex++;
                _visibleIndex++;
                break;
            }
        }
    } //end of if (_collectLineInfo)
    _prevChar = next;
    _index++;
    return next;
}

- (void)mark {
}

- (NSString*)collect {
    return nil;
}

- (unichar)nextOverride {
    return -1;
}

- (unichar)peekOverride {
    return -1;
}

- (NSUInteger)length {
    return 0;
}

@end
