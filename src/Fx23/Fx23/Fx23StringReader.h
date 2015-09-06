//
//  Fx23StringReader.h
//  Fx23
//
//  Created by Mgen on 14-5-14.
//  Copyright (c) 2014 Mgen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Fx23Reader.h"

@interface Fx23StringReader : Fx23Reader
{
    int _markIndex;
    NSUInteger _length;
    NSString *_innerString;
}

- (instancetype)initWithString:(NSString*)str;
+ (instancetype)readerWithString:(NSString*)str;

@end
