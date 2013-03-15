//
//  NSData+IDZGzip.h
//  IDZGunzipDemo
//
//  Created by idz on 3/14/13.
//  Copyright (c) 2013 idz. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString* const IDZGzipErrorDomain;

@interface NSData (IDZGzip)

- (NSData*)gzip:(NSError**)error;

@end
