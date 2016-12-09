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

-(void) sortCodeDataContent {
    self.lexicalAnalyzer = [LexicalAnalyzer sharedInstance];
    NSMutableArray *rowsWithElements = [[NSMutableArray alloc] initWithArray:self.lexicalAnalyzer.arrayOfRowsElements];
    self.codeDataElements = [[NSMutableArray alloc] init];
    BOOL codeDataDetected = NO;
    for (NSMutableArray *rowElements in rowsWithElements) {
        for (NSString *element in rowElements) {
            if ([element isEqualToString:@"CodeData"])
                codeDataDetected = YES;
            if ([element isEqualToString:@"End"])
                codeDataDetected = NO;
            if (codeDataDetected)
                [self.codeDataElements addObject:rowElements];
            
        }
    }
}
-(void) analyzeCodeData{
    self.resultVariablesArray = [[NSMutableArray alloc] init];
    self.oparationManager = [OperationManager sharedInstance];
    NSMutableArray *loopStack = [[NSMutableArray alloc] init];
    [self sortCodeDataContent];
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
                Lexem *firstLexem = [self findLexemInBodyDataByIdentidier:lexem];
                
                for (NSInteger k = 2; k < [[self.codeDataElements objectAtIndex:i] count] - 2; k++) {
                    NSString *objectAtIndexK = [[self.codeDataElements objectAtIndex:i] objectAtIndex:k];
                    
                    if ([self isInteger:objectAtIndexK] && k==2) {
                        firstLexem.resultValue = objectAtIndexK;
                    }
                    else if ([objectAtIndexK isEqualToString:@"_"] && k==2){
                        Lexem *anotherLexem = [self findLexemInBodyDataByIdentidier:objectAtIndexK];
                        firstLexem.resultValue = anotherLexem.resultValue;
                    }
                    else {
                        NSString *objectAtIndexKPlusOne = [[self.codeDataElements objectAtIndex:i] objectAtIndex:k+1];
                        if ([objectAtIndexK isEqualToString:@"++"] && [[objectAtIndexKPlusOne substringToIndex:1] isEqualToString:@"_"])
                        {
                            Lexem *anotherLexem = [self findLexemInBodyDataByIdentidier:objectAtIndexKPlusOne];
                            firstLexem.resultValue = [self.oparationManager addOperandOne:firstLexem.resultValue toOperandTwo:anotherLexem.resultValue];
                            k++;
                        }
                        else if ([objectAtIndexK isEqualToString:@"++"] && [self isInteger:objectAtIndexKPlusOne])
                        {
                            firstLexem.resultValue = [self.oparationManager addOperandOne:firstLexem.resultValue toOperandTwo:objectAtIndexKPlusOne];
                            k++;
                        }
                        else if ([objectAtIndexK isEqualToString:@"-"] && [[objectAtIndexKPlusOne substringToIndex:1] isEqualToString:@"_"])
                        {
                            Lexem *anotherLexem = [self findLexemInBodyDataByIdentidier:objectAtIndexKPlusOne];
                            firstLexem.resultValue = [self.oparationManager subtractOperandOne:anotherLexem.resultValue fromOperandTwo:firstLexem.resultValue];
                            k++;
                        }
                        else if ([objectAtIndexK isEqualToString:@"-"] && [self isInteger:objectAtIndexKPlusOne])
                        {
                            firstLexem.resultValue = [self.oparationManager subtractOperandOne:objectAtIndexKPlusOne fromOperandTwo:firstLexem.resultValue];
                            k++;
                        }
                    }
                    
                }
                [self.resultVariablesArray addObject:firstLexem];
            }
            
            if ([lexem isEqualToString:@"Until"]) {
                
                shouldAddToLoopStack = NO;
            }
        }

    }
}

- (BOOL)isInteger:(NSString *)toCheck {
    if([toCheck intValue] != 0) {
        return true;
    } else if([toCheck isEqualToString:@"0"]) {
        return true;
    } else {
        return false;
    }
}

-(Lexem *) findLexemInBodyDataByIdentidier:(NSString *) identifier {
    for (Lexem *lexemObj in self.lexicalAnalyzer.bodyDataVariables) {
        if ([lexemObj.identifier isEqualToString:identifier]) {
            return lexemObj;
        }
    }
    return nil;
}

@end
