//
//  RemoteConfiguration.m
//
//  Created by Maciej Gad on 14.09.2016.
//  Copyright © 2016 All in Mobile. All rights reserved.
//

#import "RemoteConfiguration.h"
#import "JSONDocumentsBoundleProvider.h"
#import "ConfigurableApiRequest.h"
#import "NSDictionary+safeValue.h"
#import "UIColor+HexString.h"
#import "CompleteGroup.h"
//#import <AFNetworking.h>
#import "UIImage+loadFromData.h"
#import "JSONDocumentsProvider.h"
#import "EXTScope.h"

static NSString * const kColorKeyFormat = @"colors.%@";
static NSString * const kPatternKeyFormat = @"patterns.%@";

@interface NSString (localPath)
- (NSString *)localPath;
@end

@interface Configuration ()
@property (strong, nonatomic) NSDictionary *value;
@property (strong, nonatomic) NSCache<NSString *, UIColor *> *colorCache;
@property (strong, nonatomic) NSMutableSet<NSString *> *notexistingColor;
@end


@implementation Configuration

- (id)objectForKeyedSubscript:(id)key {
    return [self.value safeValueForKey:key];
}

- (UIColor *)colorWithName:(NSString *)name {
    if (name == nil) {
        return nil;
    }
    if ([self.notexistingColor containsObject:name]) {
        return nil;
    }
    UIColor *color = [self.colorCache objectForKey:name];
    if (color) {
        return color;
    }
    NSString *key = [NSString stringWithFormat:kColorKeyFormat, name];
    NSString *colorHex = self[key];
    
    if (colorHex) {
        color = [colorHex color];
    }
    
    if (color == nil) {
        @synchronized (self) {
            [self.notexistingColor addObject:name];
        }
        return nil;
    }
    
    [self.colorCache setObject:color forKey:name];
    
    return color;
}

- (UIColor *)patternWithName:(NSString *)key {
    if (key == nil) {
        return nil;
    }
    NSString *name = [NSString stringWithFormat:kPatternKeyFormat, key];
    if ([self.notexistingColor containsObject:name]) {
        return nil;
    }
    
    UIColor *color = [self.colorCache objectForKey:name];
    if (color) {
        return color;
    }

    if (self[name]) {
        UIImage *patternImage = [UIImage imageWithData:[NSData dataWithContentsOfFile:[key localPath]] scale:[UIScreen mainScreen].scale];
        if (patternImage) {
            color = [UIColor colorWithPatternImage:patternImage];
        }
    }
    
    if (color == nil) {
        @synchronized (self) {
            [self.notexistingColor addObject:name];
        }
        return nil;
    }
    
    [self.colorCache setObject:color forKey:name];
    
    return color;
}

- (void)setValue:(NSDictionary *)value {
    @synchronized (self) {
        [_colorCache removeAllObjects];
        [_notexistingColor removeAllObjects];
        _value = value;
    }
}

- (NSCache<NSString *, UIColor *> *)colorCache {
    if(_colorCache) {
        return _colorCache;
    }
    _colorCache = [NSCache new];
    return _colorCache;
}

- (NSMutableSet<NSString *> *)notexistingColor {
    if (_notexistingColor) {
        return _notexistingColor;
    }
    _notexistingColor = [NSMutableSet new];
    return _notexistingColor;
}

@end

@interface FutureConfiguration : Configuration

@property (strong, nonatomic) ConfigurableApiRequest *fetchThemeApiRequest;
@property (strong, nonatomic) CompleteGroup *patternFetchGroup;
@property (copy, nonatomic) CompleteBlock completeFetch;

- (instancetype)initWithLocalName:(NSString *)fileName remote:(NSString *)url;

@end

@interface RemoteConfiguration ()
@property (strong, nonatomic) FutureConfiguration *future;

@end


@implementation RemoteConfiguration

+ (void)setup {
    [self sharedInstace];
}

+ (instancetype)sharedInstace {
    static dispatch_once_t onceToken;
    static RemoteConfiguration *instance;
    dispatch_once(&onceToken, ^{
        NSString *fileName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"themeFileName"];
        NSString *remoteUrl = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"themeRemotePath"];
        instance = [[RemoteConfiguration alloc] initWithLocalName:fileName remote:remoteUrl];
    });
    return instance;

}

- (instancetype)initWithLocalName:(NSString *)fileName remote:(NSString *)url {
    self = [super init];
    self.value = [JSONDocumentsBoundleProvider dictionaryFrom:fileName];
    self.future = [[FutureConfiguration alloc] initWithLocalName:fileName remote:url];
    return self;
}

+ (UIColor *)colorWithName:(NSString *)name {
    return [[self sharedInstace] colorWithName:name];
}

+ (UIColor *)patternWithName:(NSString *)key {
    return [[self sharedInstace] patternWithName:key];
}

@end

@implementation FutureConfiguration

- (instancetype)initWithLocalName:(NSString *)fileName remote:(NSString *)url{
    self = [super init];
    self.fetchThemeApiRequest = [[ConfigurableApiRequest alloc] initWithPath:url];
//    self.fetchThemeApiRequest.cachePolicy = CachePolicyIgnoreCache;
    @weakify(self);
    self.fetchThemeApiRequest.success = ^(NSDictionary *response) {
        @strongify(self);
        if (![response isKindOfClass:[NSDictionary class]]) {
            return;
        }
        self.value = response;
        [JSONDocumentsBoundleProvider writeJSON:response toFile:fileName];
        [self fetchPatterns:response];
    };
    self.fetchThemeApiRequest.failure = ^(NSError *error) {
        @strongify(self);
        self.value = nil;
    };
    [self.fetchThemeApiRequest get];
    return self;
}

- (void)fetchPatterns:(NSDictionary *)response {
    NSDictionary *patterns = response[@"patterns"];
    if (![patterns isKindOfClass:[NSDictionary class]]) {
        return;
    }
    if ([patterns count] == 0) {
        return;
    }
    self.patternFetchGroup = [CompleteGroup new];

    @weakify(self);
    self.patternFetchGroup.complete = ^{
        @strongify(self);
        if (self.completeFetch) {
            self.completeFetch();
            self.completeFetch = nil;
        }
        
    };
    
    NSString *basePath = [self.fetchThemeApiRequest.path stringByDeletingLastPathComponent];
    
    [patterns enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *obj, BOOL * stop) {
        [self.patternFetchGroup addBlock:^(Group *group) {
            NSString *path = [basePath stringByAppendingPathComponent:obj];
            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:path]];
            NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                if (data) {
                    NSString *path = [key localPath];
                    UIImage *image = [UIImage safeImageWithData:data scale:[UIScreen mainScreen].scale];
                    NSData *imageData = UIImageJPEGRepresentation(image, 0.9);
                    [imageData writeToFile:path atomically:YES];
                }
                [group leave];
            }];
            [dataTask resume];
        }];
    }];
    [self.patternFetchGroup run];
}


@end

@implementation NSString (localPath)

- (NSString *)localPath {
    NSString *fileName = [NSString stringWithFormat:@"pattern_%@.jpg",self];
    return [[JSONDocumentsProvider applicationDocumentsDirectory] URLByAppendingPathComponent:fileName].path;
}

@end

