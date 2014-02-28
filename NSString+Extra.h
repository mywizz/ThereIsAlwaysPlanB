
@interface NSString (Extra)

+ (NSString *)stringWithUUID;
- (NSString *)trim;
- (NSString *)URLEncodedString;
- (NSString *)URLDecodedString;
- (NSString *)squeezeSpaces;
- (NSString *)stringByEncodingFileName;
- (NSString *)stringByDecodingFileName;
@end
