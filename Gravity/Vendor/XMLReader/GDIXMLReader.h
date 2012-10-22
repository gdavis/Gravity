//
//  XMLReader.h
//
//

#import <Foundation/Foundation.h>

@interface GDIXMLReader : NSObject <NSXMLParserDelegate>

+ (NSDictionary *)dictionaryForPath:(NSString *)path error:(NSError **)errorPointer;
+ (NSDictionary *)dictionaryForXMLData:(NSData *)data error:(NSError **)errorPointer;
+ (NSDictionary *)dictionaryForXMLString:(NSString *)string error:(NSError **)errorPointer;

@end

@interface NSDictionary (GDIXMLReaderNavigation)

- (id)retrieveForPath:(NSString *)navPath;

@end