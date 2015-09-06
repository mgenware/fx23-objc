//
//  Fx23Reader+Extension.h
//  Fx23
//
//  Created by Mgen on 14-5-14.
//  Copyright (c) 2014 Mgen. All rights reserved.
//

#import "Fx23Reader.h"

@interface Fx23Reader (Extension)

/* Moves forward while condition is true, and returns the string scanned */
- (NSString*)collectWhile:(BOOL (^)(unichar))predicate;
/* Moves forward while condition is true */
- (int)skipWhile:(BOOL (^)(unichar))predicate;
/* Moves to next non-whitespace character */
- (int)moveToContent;
/* Moves to next line */
- (int)skipLine;
/* Moves to next line and returns current line */
- (NSString*)collectLine;

@end
