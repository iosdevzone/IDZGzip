NSData+IDZGzip
================

A category on NSData that provides a simple way to gzip data.

Using the category is very straight forward.

1. Add libz.dylib to your project. 
2. Add NSData+IDZGzip.m and NSData+IDZGzip.h to your project.
3. Then you do something like this:

```objective-c
#import "NSData+IDZGzip.h"

...

// Assuming data is an NSData holding data to be compressed.
NSError* error = nil;
// gzip the data
NSData* gzippedData = [data gzip:&error];
if(!gzippedData)
{
  // Handle error
}
else
{
  // Success use gunzippedData
}
```
