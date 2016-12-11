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
#import <Cocoa/Cocoa.h>

@interface SyntacticAnalyzer()

@property (nonatomic, strong) OperationManager *oparationManager;
@property (nonatomic, strong) NSMutableArray *codeDataElements;
@property (nonatomic, strong) LexicalAnalyzer *lexicalAnalyzer;

@property (nonatomic, strong) NSString *variableDetectedLexem;
@property (nonatomic, assign) NSInteger variableDetectedI;


@property (nonatomic, assign) NSInteger writeDetectedI;
@property (nonatomic, assign) NSInteger writeDetectedJ;

@property (nonatomic, assign) NSInteger readDetectedI;
@property (nonatomic, assign) NSInteger readDetectedJ;

@property (nonatomic, assign) NSInteger loopDetectedI;


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
    NSMutableArray *loopQueue = [[NSMutableArray alloc] init];
    self.variablesToDisplay = [[NSMutableArray alloc] init];
    [self sortCodeDataContent];
    //NSInteger loopCounter = 0;
    BOOL shouldAddToLoopStack = NO;
    for (NSInteger i = 0; i < [self.codeDataElements count]; i++) {
        for (NSInteger j = 0; j < [[self.codeDataElements objectAtIndex:i] count]; j++) {
            NSString *lexem = [[self.codeDataElements objectAtIndex:i] objectAtIndex:j];
            if ([lexem isEqualToString:@"Repeat"]) {
                //loopCounter++;
                self.loopDetectedI = i;
                
            }
            
            if ([[lexem substringToIndex:1] isEqualToString:@"_"]) {
                self.variableDetectedLexem = lexem;
                self.variableDetectedI = i;
                [self variableDetectedMethod];
 
                break;
            }
            
            if ([lexem isEqualToString:@"Read"]) {
                self.readDetectedI = i;
                self.readDetectedJ = j;
                [self readDetectedMethod];
                
                break;
            }
            
            if ([lexem isEqualToString:@"Write"]) {
                self.writeDetectedI = i;
                self.writeDetectedJ = j;
                [self writeDetectedMethod];
                
                break;
            }
            
            if ([lexem isEqualToString:@"Until"]) {
                
                shouldAddToLoopStack = NO;
                j=1;
                NSString *objectAtIndexJ = [[self.codeDataElements objectAtIndex:i] objectAtIndex:j];
                NSString *objectAtIndexJPlusOne = [[self.codeDataElements objectAtIndex:i] objectAtIndex:j+1];
                NSString *objectAtIndexJPlusTwo = [[self.codeDataElements objectAtIndex:i] objectAtIndex:j+2];
                
                
                
//                if (![self isInteger:objectAtIndexJ]) {
//                    Lexem *operand = [self findLexemInBodyDataByIdentidier:objectAtIndexJ];
//                    NSString *firstOperandString = operand.resultValue;
//                    firstOperand = [firstOperandString integerValue];
//                }
//                else{
//                    NSString *firstOperandString = objectAtIndexJ;
//                    firstOperand = [firstOperandString integerValue];
//                }
//                
//                if (![self isInteger:objectAtIndexJPlusTwo]) {
//                    Lexem *operand = [self findLexemInBodyDataByIdentidier:objectAtIndexJPlusTwo];
//                    NSString *secondOperandString = operand.resultValue;
//                    secondOperand = [secondOperandString integerValue];
//                }
//                else {
//                    NSString *secondOperandString = objectAtIndexJPlusTwo;
//                    secondOperand = [secondOperandString integerValue];
//                }
                
                if ([objectAtIndexJPlusOne isEqualToString:@"="]) {
                    if (![self isInteger:objectAtIndexJ] && ![self isInteger:objectAtIndexJPlusTwo]) {
                        if ([[self findLexemInBodyDataByIdentidier:[[self.codeDataElements objectAtIndex:i] objectAtIndex:j]].resultValue integerValue] == [[self findLexemInBodyDataByIdentidier:[[self.codeDataElements objectAtIndex:i] objectAtIndex:j+2]].resultValue integerValue]) {
                            i = self.loopDetectedI;
                        }
                    }
                    else if (![self isInteger:objectAtIndexJ] && [self isInteger:objectAtIndexJPlusTwo]) {
                        if ([[self findLexemInBodyDataByIdentidier:[[self.codeDataElements objectAtIndex:i] objectAtIndex:j]].resultValue integerValue] == [objectAtIndexJPlusTwo integerValue]) {
                            i = self.loopDetectedI;
                        }
                    }
                    else if ([self isInteger:objectAtIndexJ] && ![self isInteger:objectAtIndexJPlusTwo]) {
                        if ([objectAtIndexJ integerValue] == [[self findLexemInBodyDataByIdentidier:[[self.codeDataElements objectAtIndex:i] objectAtIndex:j+2]].resultValue integerValue]) {
                            i = self.loopDetectedI;
                        }
                    }
                }
                else if ([objectAtIndexJPlusOne isEqualToString:@"<>"]) {
                    if (![self isInteger:objectAtIndexJ] && ![self isInteger:objectAtIndexJPlusTwo]) {
                        if ([[self findLexemInBodyDataByIdentidier:[[self.codeDataElements objectAtIndex:i] objectAtIndex:j]].resultValue integerValue] != [[self findLexemInBodyDataByIdentidier:[[self.codeDataElements objectAtIndex:i] objectAtIndex:j+2]].resultValue integerValue]) {
                            i = self.loopDetectedI;
                        }
                    }
                    else if (![self isInteger:objectAtIndexJ] && [self isInteger:objectAtIndexJPlusTwo]) {
                        if ([[self findLexemInBodyDataByIdentidier:[[self.codeDataElements objectAtIndex:i] objectAtIndex:j]].resultValue integerValue] != [objectAtIndexJPlusTwo integerValue]) {
                            i = self.loopDetectedI;
                        }
                    }
                    else if ([self isInteger:objectAtIndexJ] && ![self isInteger:objectAtIndexJPlusTwo]) {
                        if ([objectAtIndexJ integerValue] != [[self findLexemInBodyDataByIdentidier:[[self.codeDataElements objectAtIndex:i] objectAtIndex:j+2]].resultValue integerValue]) {
                            i = self.loopDetectedI;
                        }
                    }
                }
                else if ([objectAtIndexJPlusOne isEqualToString:@"Lt"]) {
                    if (![self isInteger:objectAtIndexJ] && ![self isInteger:objectAtIndexJPlusTwo]) {
                        if ([[self findLexemInBodyDataByIdentidier:[[self.codeDataElements objectAtIndex:i] objectAtIndex:j]].resultValue integerValue] > [[self findLexemInBodyDataByIdentidier:[[self.codeDataElements objectAtIndex:i] objectAtIndex:j+2]].resultValue integerValue]) {
                            i = self.loopDetectedI;
                        }
                    }
                    else if (![self isInteger:objectAtIndexJ] && [self isInteger:objectAtIndexJPlusTwo]) {
                        if ([[self findLexemInBodyDataByIdentidier:[[self.codeDataElements objectAtIndex:i] objectAtIndex:j]].resultValue integerValue] > [objectAtIndexJPlusTwo integerValue]) {
                            i = self.loopDetectedI;
                        }
                    }
                    else if ([self isInteger:objectAtIndexJ] && ![self isInteger:objectAtIndexJPlusTwo]) {
                        if ([objectAtIndexJ integerValue] > [[self findLexemInBodyDataByIdentidier:[[self.codeDataElements objectAtIndex:i] objectAtIndex:j+2]].resultValue integerValue]) {
                            i = self.loopDetectedI;
                        }
                    }
                    else  {
                        if ([objectAtIndexJ integerValue] > [objectAtIndexJPlusTwo integerValue]) {
                            i = self.loopDetectedI;
                        }
                    }
                }
                else if ([objectAtIndexJPlusOne isEqualToString:@"Et"]) {
                    if (![self isInteger:objectAtIndexJ] && ![self isInteger:objectAtIndexJPlusTwo]) {
                        if ([[self findLexemInBodyDataByIdentidier:[[self.codeDataElements objectAtIndex:i] objectAtIndex:j]].resultValue integerValue] < [[self findLexemInBodyDataByIdentidier:[[self.codeDataElements objectAtIndex:i] objectAtIndex:j+2]].resultValue integerValue]) {
                            i = self.loopDetectedI;
                        }
                    }
                    else if (![self isInteger:objectAtIndexJ] && [self isInteger:objectAtIndexJPlusTwo]) {
                        if ([[self findLexemInBodyDataByIdentidier:[[self.codeDataElements objectAtIndex:i] objectAtIndex:j]].resultValue integerValue] < [objectAtIndexJPlusTwo integerValue]) {
                            i = self.loopDetectedI;
                        }
                    }
                    else if ([self isInteger:objectAtIndexJ] && ![self isInteger:objectAtIndexJPlusTwo]) {
                        if ([objectAtIndexJ integerValue] < [[self findLexemInBodyDataByIdentidier:[[self.codeDataElements objectAtIndex:i] objectAtIndex:j+2]].resultValue integerValue]) {
                            i = self.loopDetectedI;
                        }
                    }
                    else  {
                        if ([objectAtIndexJ integerValue] < [objectAtIndexJPlusTwo integerValue]) {
                            i = self.loopDetectedI;
                        }
                    }
                }
                
                break;
            }
        }

    }
}
- (NSString *) input: (NSString *) prompt defaultValue: (NSString *)defaultValue {
    NSAlert *alert = [NSAlert alertWithMessageText: prompt
                                     defaultButton:@"OK"
                                   alternateButton:@"Cancel"
                                       otherButton:nil
                         informativeTextWithFormat:@""];
    
    NSTextField *inputTextField = [[NSTextField alloc] initWithFrame:NSMakeRect(0, 0, 200, 24)];
    [inputTextField setStringValue:defaultValue];
    [alert setAccessoryView:inputTextField];
    NSInteger button = [alert runModal];
    if (button == NSAlertDefaultReturn) {
        [inputTextField validateEditing];
        return [inputTextField stringValue];
    } else if (button == NSAlertAlternateReturn) {
        return nil;
    } else {
        NSAssert1(NO, @"Invalid input dialog button %ld", button);
        return nil;
    }
}

-(void) readDetectedMethod {
    NSInteger i = self.readDetectedI;
    NSInteger j = self.readDetectedJ;
    NSString *objectAtIndexJPlusOne = [[self.codeDataElements objectAtIndex:i] objectAtIndex:j+1];
    Lexem *firstLexem = [self findLexemInBodyDataByIdentidier:objectAtIndexJPlusOne];
    NSString *displayMessage = [NSString stringWithFormat:@"Please input the Int16 number to save in variable %@, default value will be 0", firstLexem.identifier];
    firstLexem.resultValue = [self input:displayMessage defaultValue:@"0"];
}

-(void) writeDetectedMethod {
    NSInteger i = self.writeDetectedI;
    NSInteger j = self.writeDetectedJ;
    NSString *objectAtIndexJPlusOne = [[self.codeDataElements objectAtIndex:i] objectAtIndex:j+1];
    Lexem *firstLexem = [self findLexemInBodyDataByIdentidier:objectAtIndexJPlusOne];
    Lexem *lexemToDisplay = [[Lexem alloc] init];
    lexemToDisplay.catagory = firstLexem.catagory;
    lexemToDisplay.type = firstLexem.type;
    lexemToDisplay.identifier = firstLexem.identifier;
    lexemToDisplay.resultValue = firstLexem.resultValue;
    lexemToDisplay.error = firstLexem.error;
    [self.variablesToDisplay addObject:lexemToDisplay];
}

-(void) variableDetectedMethod{
    Lexem *firstLexem = [self findLexemInBodyDataByIdentidier:self.variableDetectedLexem];
    NSInteger j = 2;
    NSInteger i = self.variableDetectedI;
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
