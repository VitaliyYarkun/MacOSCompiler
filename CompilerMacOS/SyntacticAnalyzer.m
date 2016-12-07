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
#import "LexicalAnalyzer.h"

@interface SyntacticAnalyzer()

@property (nonatomic, strong) OperationManager *oparationManager;
@property (nonatomic, strong) NSMutableArray *codeDataElements;
@property (nonatomic, strong) LexicalAnalyzer *lexicalAnalyzer;

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

-(void) setCodeDataElements:(NSMutableArray *)codeDataElements {
    self.codeDataElements = codeDataElements;
}

-(NSMutableArray *) codeDataElements {
    NSMutableArray *codeDataElements = [[NSMutableArray alloc] init];
    return codeDataElements;
}

-(void) sortCodeDataContent {
    self.lexicalAnalyzer = [LexicalAnalyzer sharedInstance];
    NSMutableArray *rowsWithElements = [[NSMutableArray alloc] initWithArray:self.lexicalAnalyzer.arrayOfRowsElements];
    
    BOOL codeDataDetected = NO;
    for (NSMutableArray *rowElements in rowsWithElements) {
        for (NSString *element in rowElements) {
            if ([element isEqualToString:@"CodeData"])
                codeDataDetected = YES;
            if ([element isEqualToString:@"End"])
                codeDataDetected = NO;
            if (codeDataDetected)
                [self.codeDataElements addObject:rowsWithElements];
            
        }
    }
}
-(void) analyzeCodeData{
    [self sortCodeDataContent];
    self.oparationManager = [OperationManager sharedInstance];
    NSMutableArray *loopStack = [[NSMutableArray alloc] init];
    //NSInteger loopCounter = 0;
    BOOL shouldAddToLoopStack = NO;
    for (NSInteger i = 0; i < [self.codeDataElements count]; i++) {
        for (NSInteger j = 0; j < [[self.codeDataElements objectAtIndex:i] count]; j++) {
            NSString *lexem = [[self.codeDataElements objectAtIndex:i] objectAtIndex:j];
            if ([lexem isEqualToString:@"Repeat"]) {
                //loopCounter++;
                shouldAddToLoopStack = YES;
            }
            
            if ([[lexem substringToIndex:1] isEqualToString:@"_"]) {
//                if () {
//                    <#statements#>
//                }
            }
            
            if ([lexem isEqualToString:@"Until"]) {
                
                shouldAddToLoopStack = NO;
            }
        }

    }
}

@end
