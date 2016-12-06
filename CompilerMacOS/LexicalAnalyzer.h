//
//  LexicalAnalyzer.h
//  CompilerMacOS
//
//  Created by Vitaliy Yarkun on 12/3/16.
//  Copyright © 2016 Vitaliy Yarkun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LexicalAnalyzer : NSObject

@property (strong, nonatomic) NSMutableArray *literals;
@property (strong, nonatomic) NSMutableArray *bodyDataVariables;
@property (strong, nonatomic) NSMutableArray *codeDataVariables;
@property (strong, nonatomic) NSMutableArray *keywords;
@property (strong, nonatomic) NSMutableArray *symbols;
@property (strong, nonatomic) NSMutableArray *lexemes;
@property (strong, nonatomic) NSMutableArray *operators;

+ (instancetype)sharedInstance;
- (void) scanCode:(NSString *) code;

@end
