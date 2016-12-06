//
//  SyntacticAnalyzer.m
//  CompilerMacOS
//
//  Created by Vitaliy Yarkun on 12/6/16.
//  Copyright © 2016 Vitaliy Yarkun. All rights reserved.
//

#import "SyntacticAnalyzer.h"
#import "OperationManager.h"
#import "Lexem.h"

@interface SyntacticAnalyzer()

@property (nonatomic, strong) OperationManager *oparationManager;

@end

@implementation SyntacticAnalyzer

+ (instancetype)sharedInstance
{
    static SyntacticAnalyzer *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[SyntacticAnalyzer alloc] init];
    });
    
    return sharedInstance;
}

-(void) analyzeCodeData:(NSArray *) code{
    self.oparationManager = [OperationManager sharedInstance];
    NSMutableArray *loopStack = [[NSMutableArray alloc] init];
    NSInteger loopCounter = 0;
    BOOL shouldAddToLoopStack = NO;
    for (Lexem *lexem in code) {
        if ([lexem.identifier isEqualToString:@"Repeat"]) {
            loopCounter++;
            shouldAddToLoopStack = YES;
        }
        
        if ([lexem.identifier isEqualToString:@"Until"]) {
            
            shouldAddToLoopStack = NO;
        }
    }
}

@end
