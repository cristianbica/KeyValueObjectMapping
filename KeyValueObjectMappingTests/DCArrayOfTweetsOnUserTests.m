//
//  DCArrayOfTweetsOnUserTests.m
//  DCKeyValueObjectMappingTests
//
//  Created by Diego Chohfi on 4/16/12.
//  Copyright (c) 2012 dchohfi. All rights reserved.
//

#import "DCArrayOfTweetsOnUserTests.h"
#import "DCKeyValueObjectMapping.h"
#import "DCArrayMapping.h"
#import "DCParserConfiguration.h"
#import "Tweet.h"
#import "User.h"

@interface DCArrayOfTweetsOnUserTests()

@property(nonatomic, strong) NSMutableDictionary *jsonParsed;

@end

@implementation DCArrayOfTweetsOnUserTests
@synthesize jsonParsed;

-(void)setUp{
    [super setUp];
    NSString *caminhoJson = [[NSBundle 
                              bundleForClass: [self class]] 
                             pathForResource:@"user" 
                             ofType:@"json"];
    
    NSData *data = [NSData dataWithContentsOfFile:caminhoJson];
    
    NSError *error;
    jsonParsed = [NSJSONSerialization JSONObjectWithData:data
                                                 options:NSJSONReadingMutableContainers 
                                                   error:&error];
}

- (void)atestShouldCreateAnUserWithTweets {
    
    DCArrayMapping *mapper = [DCArrayMapping mapperForClassElements:[Tweet class] 
                                                       forAttribute:@"tweets" 
                                                            onClass:[User class]];
    
    DCParserConfiguration *configuration = [DCParserConfiguration configuration];
    [configuration addArrayMapper:mapper];
    
    DCKeyValueObjectMapping *parser = [DCKeyValueObjectMapping mapperForClass:[User class] 
                                                             andConfiguration:configuration];
    User *user = [parser parseDictionary:jsonParsed];
    STAssertNotNil(user.tweets, @"Tweets should not be nil");
    STAssertEquals((int)user.tweets.count, 2, @"Should have 2 tweets on array of tweets");
}

- (void) testShouldCreateUserWithNilOnTweetsArray{
    DCObjectMapping *objectMapping = [DCObjectMapping mapKeyPath:@"tweets_nullable" 
                                                     toAttribute:@"tweets"
                                                         onClass:[User class]];
    
    DCArrayMapping *mapper = [DCArrayMapping mapperForClass:[Tweet class] 
                                                  onMapping:objectMapping];
    
    DCParserConfiguration *configuration = [DCParserConfiguration configuration];
    [configuration addArrayMapper:mapper];
    
    NSMutableDictionary *copy = [jsonParsed mutableCopy];
    [copy removeObjectForKey:@"tweets"];
    
    DCKeyValueObjectMapping *parser = [DCKeyValueObjectMapping mapperForClass:[User class]
                                                             andConfiguration:configuration];

    User *user = [parser parseDictionary:copy];
    STAssertNil(user.tweets, @"Tweets should be nil");
}

- (void) testShouldCreateUserWithEmptyTweetsOnArray{
    DCObjectMapping *objectMapping = [DCObjectMapping mapKeyPath:@"tweets_empty" 
                                                     toAttribute:@"tweets"
                                                         onClass:[User class]];
    
    DCArrayMapping *mapper = [DCArrayMapping mapperForClass:[Tweet class] 
                                                  onMapping:objectMapping];
    
    DCParserConfiguration *configuration = [DCParserConfiguration configuration];
    [configuration addArrayMapper:mapper];
    
    NSMutableDictionary *copy = [jsonParsed mutableCopy];
    [copy removeObjectForKey:@"tweets"];
    
    DCKeyValueObjectMapping *parser = [DCKeyValueObjectMapping mapperForClass:[User class]
                                                             andConfiguration:configuration];
    
    User *user = [parser parseDictionary:copy];
    STAssertNil(user.tweets, @"Tweets should be nil");
}

@end
