//
//  Fx23Reader+Extension.m
//  Fx23
//
//  Created by Mgen on 14-5-14.
//  Copyright (c) 2014 Mgen. All rights reserved.
//

#import "Fx23Reader+Extension.h"

@implementation Fx23Reader (Extension)

- (NSString *)collectWhile:(BOOL (^)(unichar))predicate {
    if (!predicate) {
        return nil;
    }
    
    [self mark];
    while ([self hasNext] && predicate([self peek])) {
        [self next];
    }
    return [self collect];
}

- (int)skipWhile:(BOOL (^)(unichar))predicate {
    if (!predicate) {
        return 0;
    }
    
    int count = 0;
    while ([self hasNext] && predicate([self peek])) {
        [self next];
        count++;
    }
    return count;
}

- (int)moveToContent {
    return [self skipWhile:^BOOL(unichar c) {
        return [[NSCharacterSet whitespaceAndNewlineCharacterSet] characterIsMember:c];
    }];
}

- (int)moveOverNewline {
    if ([self hasNext]) {
        unichar c = [self peek];
        if (c == '\r') {
            [self next];
            
            if ([self hasNext] && [self peek] == '\n') {
                [self next];
                return 2;
            }
            return 1;
        }
        else if (c == '\n') {
            [self next];
            return 1;
        }
    }
    return 0;
}

- (int)skipLine {
    int re = [self skipWhile:^BOOL(unichar c) {
        return c != '\n' && c != '\r';
    }];
    [self moveOverNewline];
    return re;
}

- (NSString*)collectLine {
    NSString *re = [self collectWhile:^BOOL(unichar c) {
        return c != '\n' && c != '\r';
    }];
    [self moveOverNewline];
    return re;
}


@end
