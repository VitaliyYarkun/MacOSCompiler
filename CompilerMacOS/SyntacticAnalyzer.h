//
//  SyntacticAnalyzer.h
//  CompilerMacOS
//
//  Created by Vitaliy Yarkun on 12/6/16.
//  Copyright © 2016 Vitaliy Yarkun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SyntacticAnalyzer : NSObject

@property (nonatomic, strong) NSMutableArray *variablesToDisplay;

+ (instancetype)sharedInstance;
-(void) analyzeCodeData;

@end
