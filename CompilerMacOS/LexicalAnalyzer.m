//
//  LexicalAnalyzer.m
//  CompilerMacOS
//
//  Created by Vitaliy Yarkun on 12/3/16.
//  Copyright © 2016 Vitaliy Yarkun. All rights reserved.
//

#import "LexicalAnalyzer.h"
#import "Global.h"
#import "Keyword.h"
#import "Variable.h"
#import "Operator.h"
#import "Symbol.h"
#import "Literal.h"

@interface LexicalAnalyzer ()

@property (strong, nonatomic) NSString* programCode;
@property (strong, nonatomic) NSMutableArray *incorrectElements;

@end

@implementation LexicalAnalyzer
#pragma mark - Lexical Analyzer instance creation
+ (instancetype)sharedInstance
{
    static LexicalAnalyzer *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[LexicalAnalyzer alloc] init];
    });
    
    return sharedInstance;
}

#pragma mark - Analyze whole code
- (void) scanCode:(NSString *) code
{
    self.arrayOfRowsElements = [[NSMutableArray alloc]  init];
    self.keywords = [[NSMutableArray alloc] init];
    self.operators = [[NSMutableArray alloc] init];
    self.bodyDataVariables = [[NSMutableArray alloc] init];
    self.codeDataVariables = [[NSMutableArray alloc] init];
    self.symbols = [[NSMutableArray alloc] init];
    self.lexemes = [[NSMutableArray alloc] init];
    self.literals = [[NSMutableArray alloc] init];
    self.incorrectElements = [[NSMutableArray alloc] init];

    self.programCode = code;
    
    [self saveSeperateWords];
    [self saveKeywordsToArray];
    [self analyzeVariables];
    
    //[self saveOperatorsToArray];
    //[self saveLiteralsToArray];
    //[self saveVariablesToArray];
    
}

-(void) saveSeperateWords
{
    NSArray *allRows = [self.programCode componentsSeparatedByString:@"\n"];
    
    NSMutableArray *discardedElements = [NSMutableArray array];
    NSMutableArray *rows = [[NSMutableArray alloc] initWithArray:allRows];
    for (NSString *row in rows) {
        if ([row isEqualToString:@""])
            [discardedElements addObject:row];
        if ([row containsString:@"//"])
            [discardedElements addObject:row];
    }
    [rows removeObjectsInArray:discardedElements];
    
//    for (NSString* row in rows) {
//        NSArray *elementsSeparatedBySlash = [[NSArray alloc] initWithArray:[row componentsSeparatedByString:@" "]];
//        //elementsSeparatedBySlash = [row componentsSeparatedByString:@" "];
//        NSLog(@"%@", [elementsSeparatedBySlash firstObject]);
//    }
//    NSInteger counter = 0;
//    NSMutableArray *rowsThatContainComments = [[NSMutableArray alloc] init];
//    NSMutableArray *separatedElemtsOfTheRow = [[NSMutableArray alloc] init];
//    for (; counter <= [rows count]; counter++) {
//        if ([[rows objectAtIndex:counter] containsString:@"//"]) {
//            NSArray *elementsSeparatedBySlash = [[rows objectAtIndex:counter] componentsSeparatedByString:@"//"];
//            [rowsThatContainComments addObject:[rows objectAtIndex:counter]];
//            [separatedElemtsOfTheRow addObject:elementsSeparatedBySlash];
//        }
//    }
    
    for (NSString* row in rows) {
        NSArray *elements = [row componentsSeparatedByString:@" "];
        NSMutableArray *rowItems = [[NSMutableArray alloc] initWithArray:elements];
        NSMutableArray *mutableRowComponents = [[NSMutableArray alloc] initWithArray:rowItems];
        [self.arrayOfRowsElements addObject:mutableRowComponents];
    }
    [self deleteSpaceElements];
    
}

-(void) deleteSpaceElements {
    NSMutableArray *elementsToDelete = [[NSMutableArray alloc] init];
    for (NSMutableArray *elements in self.arrayOfRowsElements) {
        for (NSString *element in elements) {
            if ([element isEqualToString:@""])
                [elementsToDelete addObject:element];
        }
    }
    for (NSMutableArray *elements in self.arrayOfRowsElements) {
        [elements removeObjectsInArray:elementsToDelete];
    }
}

-(void) saveKeywordsToArray
{
    
    //NSMutableArray *discardedItems = [NSMutableArray array];
    for (NSMutableArray *rowComponents in self.arrayOfRowsElements)
    {
        [self checkForAllowedKeywords:rowComponents];
        //for (NSString *rowComponent in rowComponents)
        //{
//            for (NSString *allowedKeyword in allowedKeywords)
//            {
//                if ([rowComponent isEqualToString:allowedKeyword])
//                {
//                    [self.keywords addObject:rowComponent];
//                    [discardedItems addObject:rowComponent];
//                }
//                
//            }
            
        //}
//        if (discardedItems.count == 1) {
//            [rowComponents removeObject:discardedItems.firstObject];
//        }
//        
//        else if (discardedItems.count > 1) {
//            [rowComponents removeObjectsInArray:discardedItems];
//        }
//        
//        [discardedItems removeAllObjects];
    }
    
}

-(void) checkForAllowedKeywords:(NSMutableArray *) rowComponents {
    NSString *previousElement = @"";
    for (NSInteger i = 0; i < [rowComponents count]; i++) {
        BOOL isAdded = NO;
        if (i==0) {
            if (![[rowComponents objectAtIndex:i] isEqualToString:@"Name"]) {
                #warning implement error
            }
        }
        if ([[rowComponents objectAtIndex:i] isEqualToString:@"Name"]) {
            Keyword *keyword = [[Keyword alloc] init];
            keyword.catagory = @"Keyword";
            keyword.type = @"Name";
            keyword.identifier = @"Name";
            keyword.resultValue = @"";
            [self.keywords addObject:keyword];
            [self.lexemes addObject:keyword];
            
            Variable *variable = [[Variable alloc] init];
            variable.catagory = @"Variable";
            variable.type = previousElement;
            variable.identifier = [rowComponents objectAtIndex:i+1];
            variable.resultValue = @"";
            [self.lexemes addObject:variable];
            i++;
            isAdded = YES;
        }

        if ([[rowComponents objectAtIndex:i] isEqualToString:@"BodyData"]) {
            Keyword *keyword = [[Keyword alloc] init];
            keyword.catagory = @"Keyword";
            keyword.type = @"BodyData";
            keyword.identifier = @"BodyData";
            keyword.resultValue = @"";
            [self.keywords addObject:keyword];
            [self.lexemes addObject:keyword];
            isAdded = YES;

        }
        if ([[rowComponents objectAtIndex:i] isEqualToString:@"CodeData"]) {
            Keyword *keyword = [[Keyword alloc] init];
            keyword.catagory = @"Keyword";
            keyword.type = @"CodeData";
            keyword.identifier = @"CodeData";
            keyword.resultValue = @"";
            [self.keywords addObject:keyword];
            [self.lexemes addObject:keyword];
            isAdded = YES;
            
        }
        
        if ([[rowComponents objectAtIndex:i] isEqualToString:@"Int16_t"]) {
//            BOOL checkIfCorrect = NO;
//            if ([[[rowComponents objectAtIndex:i+1] substringToIndex:1] isEqualToString:@"_"]) {
//                checkIfCorrect = YES;
//            }
//            else {
//                checkIfCorrect = NO;
//                #warning - Implement error of input
//            }
//            
//            if ([[rowComponents objectAtIndex:i+2] isEqualToString:@":="]) {
//                checkIfCorrect = YES;
//            }
//            else {
//                checkIfCorrect = NO;
//                #warning - Implement error of input
//            }
//            
//            if (checkIfCorrect) {
            Keyword *keyword = [[Keyword alloc] init];
            keyword.catagory = @"Keyword";
            keyword.type = @"Int16_t";
            keyword.identifier = @"Int16_t";
            keyword.resultValue = @"";
            previousElement = @"Int16_t";
            [self.keywords addObject:keyword];
            [self.lexemes addObject:keyword];

            
            Variable *variable = [[Variable alloc] init];
            variable.catagory = @"Variable";
            variable.type = @"Int16_t";
            variable.identifier = [rowComponents objectAtIndex:i+1];
            variable.resultValue = [rowComponents objectAtIndex:i+3];
            [self.bodyDataVariables addObject:variable];
            [self.lexemes addObject:variable];

            
            Operator *operator = [[Operator alloc] init];
            operator.catagory = @"Operator";
            operator.type = @"Assignment";
            operator.identifier = @":=";
            operator.resultValue = @"";
            [self.operators addObject:operator];
            [self.lexemes addObject:operator];
            
            Literal *literal = [[Literal alloc] init];
            literal.catagory = @"Literal";
            literal.type = @"Int16_t";
            literal.identifier = [rowComponents objectAtIndex:i];
            literal.resultValue = [rowComponents objectAtIndex:i];

            [self.literals addObject:literal];
            [self.lexemes addObject:literal];


            i += 3;
            isAdded = YES;
        }
        
        if ([[rowComponents objectAtIndex:i] isEqualToString:@"Repeat"]) {
            Keyword *keyword = [[Keyword alloc] init];
            keyword.catagory = @"Keyword";
            keyword.type = @"Loop";
            keyword.identifier = @"Repeat";
            keyword.resultValue = @"";
            [self.keywords addObject:keyword];
            [self.lexemes addObject:keyword];
            isAdded = YES;
        }
        if ([[rowComponents objectAtIndex:i]  isEqual: @"++"]) {
            Operator *operator = [[Operator alloc] init];
            operator.catagory = @"Operator";
            operator.type = @"Math";
            operator.identifier = @"++";
            operator.resultValue = @"";
            [self.operators addObject:operator];
            [self.lexemes addObject:operator];
            isAdded = YES;
        }
        if ([[rowComponents objectAtIndex:i]  isEqualToString: @"-"]) {
            Operator *operator = [[Operator alloc] init];
            operator.catagory = @"Operator";
            operator.type = @"Math";
            operator.identifier = @"--";
            operator.resultValue = @"";
            [self.operators addObject:operator];
            [self.lexemes addObject:operator];
            isAdded = YES;
        }
        
        if ([[rowComponents objectAtIndex:i] isEqualToString:@"Until"]) {
            Keyword *keyword = [[Keyword alloc] init];
            keyword.catagory = @"Keyword";
            keyword.type = @"Loop";
            keyword.identifier = @"Until";
            keyword.resultValue = @"";
            [self.keywords addObject:keyword];
            [self.lexemes addObject:keyword];
            isAdded = YES;
        }
        
        if ([[[rowComponents objectAtIndex:i] substringToIndex:1] isEqual:@"_"]) {
            Variable *variable = [[Variable alloc] init];
            variable.catagory = @"Variable";
            variable.type = @"Int16_t";
            variable.identifier = [rowComponents objectAtIndex:i];
            variable.resultValue = @"";
            [self.codeDataVariables addObject:variable];
            //[self.lexemes addObject:variable];
            isAdded = YES;
        }
        
        if ([self isInteger:[rowComponents objectAtIndex:i]]) {
            Literal *literal = [[Literal alloc] init];
            literal.catagory = @"Literal";
            literal.type = @"Int16_t";
            literal.identifier = [rowComponents objectAtIndex:i];
            literal.resultValue = [rowComponents objectAtIndex:i];
            
            [self.literals addObject:literal];
            [self.lexemes addObject:literal];
            isAdded = YES;
        }
        
        if ([[rowComponents objectAtIndex:i] isEqualToString:@"End"]) {
            Keyword *keyword = [[Keyword alloc] init];
            keyword.catagory = @"Keyword";
            keyword.type = @"Block end";
            keyword.identifier = @"End";
            keyword.resultValue = @"";
            
            [self.keywords addObject:keyword];
            [self.lexemes addObject:keyword];
            isAdded = YES;
        }
        
        if ([[rowComponents objectAtIndex:i] isEqualToString:@"Read"]) {
            Keyword *keyword = [[Keyword alloc] init];
            keyword.catagory = @"Keyword";
            keyword.type = @"I/O function";
            keyword.identifier = @"Read";
            keyword.resultValue = @"";
            
            [self.keywords addObject:keyword];
            [self.lexemes addObject:keyword];
            isAdded = YES;
        }
        if ([[rowComponents objectAtIndex:i] isEqualToString:@"Write"]) {
            Keyword *keyword = [[Keyword alloc] init];
            keyword.catagory = @"Keyword";
            keyword.type = @"I/O function";
            keyword.identifier = @"Write";
            keyword.resultValue = @"";
            
            [self.keywords addObject:keyword];
            [self.lexemes addObject:keyword];
            isAdded = YES;
        }
        if ([[rowComponents objectAtIndex:i]  isEqual: @"**"]) {
            Operator *operator = [[Operator alloc] init];
            operator.catagory = @"Operator";
            operator.type = @"Math";
            operator.identifier = @"**";
            operator.resultValue = @"";
            [self.operators addObject:operator];
            [self.lexemes addObject:operator];
            isAdded = YES;
            
        }
        if ([[rowComponents objectAtIndex:i]  isEqual: @"Div"]) {
            Operator *operator = [[Operator alloc] init];
            operator.catagory = @"Operator";
            operator.type = @"Math";
            operator.identifier = @"Div";
            operator.resultValue = @"";
            [self.operators addObject:operator];
            [self.lexemes addObject:operator];
            isAdded = YES;
            
        }
        if ([[rowComponents objectAtIndex:i]  isEqual: @"Mod"]) {
            Operator *operator = [[Operator alloc] init];
            operator.catagory = @"Operator";
            operator.type = @"Math";
            operator.identifier = @"Div";
            operator.resultValue = @"";
            [self.operators addObject:operator];
            [self.lexemes addObject:operator];
            isAdded = YES;
            
        }
        if ([[rowComponents objectAtIndex:i]  isEqual: @"="]) {
            Operator *operator = [[Operator alloc] init];
            operator.catagory = @"Operator";
            operator.type = @"Compare operator";
            operator.identifier = @"=";
            operator.resultValue = @"";
            [self.operators addObject:operator];
            [self.lexemes addObject:operator];
            isAdded = YES;
        }
        if ([[rowComponents objectAtIndex:i]  isEqual: @"<>"]) {
            Operator *operator = [[Operator alloc] init];
            operator.catagory = @"Operator";
            operator.type = @"Compare operator";
            operator.identifier = @"<>";
            operator.resultValue = @"";
            [self.operators addObject:operator];
            [self.lexemes addObject:operator];
            isAdded = YES;
        }
        if ([[rowComponents objectAtIndex:i]  isEqual: @"Lt"]) {
            Operator *operator = [[Operator alloc] init];
            operator.catagory = @"Operator";
            operator.type = @"Compare operator";
            operator.identifier = @"Lt";
            operator.resultValue = @"";
            [self.operators addObject:operator];
            [self.lexemes addObject:operator];
            isAdded = YES;
        }
        if ([[rowComponents objectAtIndex:i]  isEqual: @"Et"]) {
            Operator *operator = [[Operator alloc] init];
            operator.catagory = @"Operator";
            operator.type = @"Compare operator";
            operator.identifier = @"Et";
            operator.resultValue = @"";
            [self.operators addObject:operator];
            [self.lexemes addObject:operator];
            isAdded = YES;
        }
        if ([[rowComponents objectAtIndex:i]  isEqual: @"!"]) {
            Operator *operator = [[Operator alloc] init];
            operator.catagory = @"Operator";
            operator.type = @"Boolean operator";
            operator.identifier = @"!";
            operator.resultValue = @"";
            [self.operators addObject:operator];
            [self.lexemes addObject:operator];
            isAdded = YES;
        }
        if ([[rowComponents objectAtIndex:i]  isEqual: @"&"]) {
            Operator *operator = [[Operator alloc] init];
            operator.catagory = @"Operator";
            operator.type = @"Boolean operator";
            operator.identifier = @"&";
            operator.resultValue = @"";
            [self.operators addObject:operator];
            [self.lexemes addObject:operator];
            isAdded = YES;
        }
        if ([[rowComponents objectAtIndex:i]  isEqual: @"|"]) {
            Operator *operator = [[Operator alloc] init];
            operator.catagory = @"Operator";
            operator.type = @"Boolean operator";
            operator.identifier = @"|";
            operator.resultValue = @"";
            [self.operators addObject:operator];
            [self.lexemes addObject:operator];
            isAdded = YES;
        }
        if (!isAdded) {
            if (![[rowComponents objectAtIndex:i]  isEqual: @":="]) {
                Keyword *incorrectKeyword = [[Keyword alloc] init];
                incorrectKeyword.identifier = [rowComponents objectAtIndex:i];
                incorrectKeyword.error = @"Unrecognized user input";
                [self.incorrectElements addObject:incorrectKeyword];
                [self.lexemes addObject:incorrectKeyword];
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

-(void) analyzeVariables {
    for (Variable *variable in self.bodyDataVariables) {
        if (![[variable.identifier substringToIndex:1] isEqualToString:@"_"]) {
            variable.error = @"Incorrect variable name declaration";
            [self.incorrectElements addObject:variable];
            [self.lexemes addObject:variable];
        }
    }
    BOOL variableIsFound = NO;
    for (Variable *codeVariable in self.codeDataVariables) {
        for (Variable *bodyVariable in self.bodyDataVariables) {
            if (![codeVariable.identifier isEqualToString:bodyVariable.identifier])
                variableIsFound = NO;
            else{
                variableIsFound = YES;
                break;
            }
        }
        if (!variableIsFound) {
            codeVariable.error = @"Variable is not declared in BodyData block";
            [self.incorrectElements addObject:codeVariable];
            [self.lexemes addObject:codeVariable];
        }
    }
}










@end
