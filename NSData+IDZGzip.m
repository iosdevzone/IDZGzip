//
//  NSData+IDZGzip.m
//
// Copyright (c) 2013 iOSDeveloperZone.com
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
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
