
#import "NSString+Extra.h"


#define FILENAME_RESERVED_CHARS CFSTR("/\\0")


@implementation NSString (Extra)

+(NSString*)stringWithUUID
{
    CFUUIDRef uuidObj = CFUUIDCreate(nil);
    NSString *uuidString = (__bridge_transfer NSString*)CFUUIDCreateString(nil, uuidObj);
    CFRelease(uuidObj);
    return uuidString;
}

-(NSString *)trim
{
	return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

-(NSString *)squeezeSpaces
{
	NSString *str = self;
    while ([str rangeOfString:@"  "].location != NSNotFound)
	{
        str = [str stringByReplacingOccurrencesOfString:@"  " withString:@" "];
    }
    return str;
}

-(NSString *)URLEncodedString
{
	return (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (__bridge CFStringRef)self, NULL, CFSTR("!*'();:@&=+$,/?%#[]"), kCFStringEncodingUTF8);
}

-(NSString*)URLDecodedString
{
	return (__bridge NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault, (__bridge CFStringRef)self, CFSTR(""), kCFStringEncodingUTF8);
}

- (NSString *) stringByEncodingFileName
{
	if (!self || ![self length]) {
		return nil;
	}
	NSString *result = [NSString stringWithString:self];
	if (result.length >= 256)
	{
		result = [result substringToIndex: 250];
	}
	return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes( NULL,
																(CFStringRef)result,
																(CFSTR(" ")),
																FILENAME_RESERVED_CHARS,
																kCFStringEncodingUTF8
																));
}

- (NSString *)stringByDecodingFileName
{
	if (!self || ![self length]) {
		return nil;
	}
	
	return (NSString *) CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapesUsingEncoding ( NULL,
																				  (CFStringRef)self,
																				  (CFSTR("")),
																				  kCFStringEncodingUTF8
																				  ));
}
@end
