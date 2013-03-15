//
//  NSData+IDZGzip.m
//  IDZGunzipDemo
//
//  Created by idz on 3/14/13.
//  Copyright (c) 2013 idz. All rights reserved.
//

#import "NSData+IDZGzip.h"
#import <zlib.h>

NSString* const IDZGzipErrorDomain = @"com.iosdeveloperzone.IDZGzip";

@implementation NSData (IDZGzip)

- (NSData*)gzip:(NSError *__autoreleasing *)error
{
    /* stream setup */
    z_stream stream;
    memset(&stream, 0, sizeof(stream));
    /* 31 below means generate gzip (16) with a window size of 15 (16 + 15) */
    int iResult = deflateInit2(&stream, Z_DEFAULT_COMPRESSION, Z_DEFLATED, 31, 8, Z_DEFAULT_STRATEGY);
    if(iResult != Z_OK)
    {
        if(error)
            *error = [NSError errorWithDomain:IDZGzipErrorDomain code:iResult userInfo:nil];
        return nil;
    }
    
    /* input buffer setup */
    stream.next_in = (Bytef*)self.bytes;
    stream.avail_in = self.length;
    
    /* output buffer setup */
    uLong nMaxOutputBytes = deflateBound(&stream, stream.avail_in);
    NSMutableData* zipOutput = [NSMutableData dataWithLength:nMaxOutputBytes];
    stream.next_out = (Bytef*)zipOutput.bytes;
    stream.avail_out = zipOutput.length;
    
    /* compress */
    iResult = deflate(&stream, Z_FINISH);
    if(iResult != Z_STREAM_END)
    {
        if(error)
            *error = [NSError errorWithDomain:IDZGzipErrorDomain code:iResult userInfo:nil];
        zipOutput = nil;
    }
    zipOutput.length = zipOutput.length - stream.avail_out;
    deflateEnd(&stream);
    return zipOutput;
}

@end
