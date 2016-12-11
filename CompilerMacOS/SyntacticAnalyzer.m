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
            if (codeDataDetected) {
                [self.codeDataElements addObject:rowElements];
                break;
            }
            
        }
    }
}
-(void) analyzeCodeData{
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
                j = 2;
                NSString *objectAtIndexJ = [[self.codeDataElements objectAtIndex:i] objectAtIndex:j];
                NSString *objectAtIndexJPlusOne = [[self.codeDataElements objectAtIndex:i] objectAtIndex:j+1];
                NSString *objectAtIndexJPlusTwo = [[self.codeDataElements objectAtIndex:i] objectAtIndex:j+2];
                
                if ([objectAtIndexJPlusOne isEqualToString:@"++"]) {
                    Lexem *firstOperand;
                    Lexem *secondOperand;
                    if (![self isInteger:objectAtIndexJ] && [self isInteger:objectAtIndexJPlusTwo]) {
                        firstOperand = [self findLexemInBodyDataByIdentidier:objectAtIndexJ];
                        firstLexem.resultValue = [self.oparationManager addOperandOne:firstOperand.resultValue toOperandTwo:objectAtIndexJPlusTwo];
                    }
                    else if (![self isInteger:objectAtIndexJ] && ![self isInteger:objectAtIndexJPlusTwo]) {
                        firstOperand = [self findLexemInBodyDataByIdentidier:objectAtIndexJ];
                        secondOperand = [self findLexemInBodyDataByIdentidier:objectAtIndexJPlusTwo];
                        firstLexem.resultValue = [self.oparationManager addOperandOne:firstOperand.resultValue toOperandTwo:secondOperand.resultValue];
                    }
                    else if ([self isInteger:objectAtIndexJ] && ![self isInteger:objectAtIndexJPlusTwo]) {
                        secondOperand = [self findLexemInBodyDataByIdentidier:objectAtIndexJPlusTwo];
                        firstLexem.resultValue = [self.oparationManager addOperandOne:objectAtIndexJ toOperandTwo:secondOperand.resultValue];
                    }
                    else {
                        firstLexem.resultValue = [self.oparationManager addOperandOne:objectAtIndexJ toOperandTwo:objectAtIndexJPlusTwo];
                    }
                }
                else if ([objectAtIndexJPlusOne isEqualToString:@"-"]) {
                    Lexem *firstOperand;
                    Lexem *secondOperand;
                    if (![self isInteger:objectAtIndexJ] && [self isInteger:objectAtIndexJPlusTwo]) {
                        firstOperand = [self findLexemInBodyDataByIdentidier:objectAtIndexJ];
                        firstLexem.resultValue = [self.oparationManager subtractOperandOne:objectAtIndexJPlusTwo fromOperandTwo:firstOperand.resultValue];
                    }
                    else if (![self isInteger:objectAtIndexJ] && ![self isInteger:objectAtIndexJPlusTwo]) {
                        firstOperand = [self findLexemInBodyDataByIdentidier:objectAtIndexJ];
                        secondOperand = [self findLexemInBodyDataByIdentidier:objectAtIndexJPlusTwo];
                        firstLexem.resultValue = [self.oparationManager subtractOperandOne:secondOperand.resultValue fromOperandTwo:firstOperand.resultValue];
                    }
                    else if ([self isInteger:objectAtIndexJ] && ![self isInteger:objectAtIndexJPlusTwo]) {
                        secondOperand = [self findLexemInBodyDataByIdentidier:objectAtIndexJPlusTwo];
                        firstLexem.resultValue = [self.oparationManager subtractOperandOne:secondOperand.resultValue fromOperandTwo:objectAtIndexJ];
                    }
                    else {
                        firstLexem.resultValue = [self.oparationManager subtractOperandOne:objectAtIndexJPlusTwo fromOperandTwo:objectAtIndexJ];
                    }
                }
                if ([objectAtIndexJPlusOne isEqualToString:@"**"]) {
                    Lexem *firstOperand;
                    Lexem *secondOperand;
                    if (![self isInteger:objectAtIndexJ] && [self isInteger:objectAtIndexJPlusTwo]) {
                        firstOperand = [self findLexemInBodyDataByIdentidier:objectAtIndexJ];
                        firstLexem.resultValue = [self.oparationManager multiplyOperandOne:firstOperand.resultValue byOperandTwo:objectAtIndexJPlusTwo];
                    }
                    else if (![self isInteger:objectAtIndexJ] && ![self isInteger:objectAtIndexJPlusTwo]) {
                        firstOperand = [self findLexemInBodyDataByIdentidier:objectAtIndexJ];
                        secondOperand = [self findLexemInBodyDataByIdentidier:objectAtIndexJPlusTwo];
                        firstLexem.resultValue = [self.oparationManager multiplyOperandOne:firstOperand.resultValue byOperandTwo:secondOperand.resultValue];
                    }
                    else if ([self isInteger:objectAtIndexJ] && ![self isInteger:objectAtIndexJPlusTwo]) {
                        secondOperand = [self findLexemInBodyDataByIdentidier:objectAtIndexJPlusTwo];
                        firstLexem.resultValue = [self.oparationManager multiplyOperandOne:objectAtIndexJ byOperandTwo:secondOperand.resultValue];
                    }
                    else {
                        firstLexem.resultValue = [self.oparationManager multiplyOperandOne:objectAtIndexJ byOperandTwo:objectAtIndexJPlusTwo];
                    }
                }
                else if ([objectAtIndexJPlusOne isEqualToString:@"Div"]) {
                    Lexem *firstOperand;
                    Lexem *secondOperand;
                    if (![self isInteger:objectAtIndexJ] && [self isInteger:objectAtIndexJPlusTwo]) {
                        firstOperand = [self findLexemInBodyDataByIdentidier:objectAtIndexJ];
                        firstLexem.resultValue = [self.oparationManager divideOperandOne:firstOperand.resultValue byOperandTwo:objectAtIndexJPlusTwo];
                    }
                    else if (![self isInteger:objectAtIndexJ] && ![self isInteger:objectAtIndexJPlusTwo]) {
                        firstOperand = [self findLexemInBodyDataByIdentidier:objectAtIndexJ];
                        secondOperand = [self findLexemInBodyDataByIdentidier:objectAtIndexJPlusTwo];
                        firstLexem.resultValue = [self.oparationManager divideOperandOne:firstOperand.resultValue byOperandTwo:secondOperand.resultValue];
                    }
                    else if ([self isInteger:objectAtIndexJ] && ![self isInteger:objectAtIndexJPlusTwo]) {
                        secondOperand = [self findLexemInBodyDataByIdentidier:objectAtIndexJPlusTwo];
                        firstLexem.resultValue = [self.oparationManager divideOperandOne:objectAtIndexJ byOperandTwo:secondOperand.resultValue];
                    }
                    else {
                        firstLexem.resultValue = [self.oparationManager divideOperandOne:objectAtIndexJ byOperandTwo:objectAtIndexJPlusTwo];
                    }
                }
                else if ([objectAtIndexJPlusOne isEqualToString:@"Mod"]) {
                    Lexem *firstOperand;
                    Lexem *secondOperand;
                    if (![self isInteger:objectAtIndexJ] && [self isInteger:objectAtIndexJPlusTwo]) {
                        firstOperand = [self findLexemInBodyDataByIdentidier:objectAtIndexJ];
                        firstLexem.resultValue = [self.oparationManager modOperandOne:firstOperand.resultValue byOperandTwo:objectAtIndexJPlusTwo];
                    }
                    else if (![self isInteger:objectAtIndexJ] && ![self isInteger:objectAtIndexJPlusTwo]) {
                        firstOperand = [self findLexemInBodyDataByIdentidier:objectAtIndexJ];
                        secondOperand = [self findLexemInBodyDataByIdentidier:objectAtIndexJPlusTwo];
                        firstLexem.resultValue = [self.oparationManager modOperandOne:firstOperand.resultValue byOperandTwo:secondOperand.resultValue];
                    }
                    else if ([self isInteger:objectAtIndexJ] && ![self isInteger:objectAtIndexJPlusTwo]) {
                        secondOperand = [self findLexemInBodyDataByIdentidier:objectAtIndexJPlusTwo];
                        firstLexem.resultValue = [self.oparationManager modOperandOne:objectAtIndexJ byOperandTwo:secondOperand.resultValue];
                    }
                    else {
                        firstLexem.resultValue = [self.oparationManager modOperandOne:objectAtIndexJ byOperandTwo:objectAtIndexJPlusTwo];
                    }
                }
                break;
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
