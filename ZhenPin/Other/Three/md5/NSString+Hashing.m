

#import "NSString+Hashing.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (NSString_Hashing)

- (NSString *)MD5Hash
{
	const char *cStr = [self UTF8String];
	unsigned char result[16];
	CC_MD5(cStr, strlen(cStr), result);
	return [NSString stringWithFormat:
			@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
			result[0], result[1], result[2], result[3], 
			result[4], result[5], result[6], result[7],
			result[8], result[9], result[10], result[11],
			result[12], result[13], result[14], result[15]];
}

@end

/*
在swift工程中随便建一个objective-c类，会提示你生成一个Bridging-Header，点YES，然后删除刚才建立的objective-c类，只留下[工程名]-Bridging-Header.h文件。

在[工程名]-Bridging-Header.h文件写入：
#import <CommonCrypto/CommonDigest.h>

然后写一个生成md5的函数：
func md5String(str:String) -> String{
    var cStr = (str as NSString).UTF8String
    var buffer = UnsafeMutablePointer<UInt8>.alloc(16)
    CC_MD5(cStr,(CC_LONG)(strlen(cStr)), buffer)
    var md5String = NSMutableString.string()
    for var i = 0; i < 16; ++i{
        md5String.appendFormat("%X2", buffer)
    }
    
    free(buffer)
    return md5String
}
*/