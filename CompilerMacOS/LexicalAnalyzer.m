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

@interface LexicalAnalyzer ()

@property (strong, nonatomic) NSString* programCode;
@property (strong, nonatomic) NSMutableArray *arrayOfRowsElements;

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
    self.operators = [NSMutableArray array];
    self.variables = [NSMutableArray array];
    self.symbols = [NSMutableArray array];
    self.programCode = code;
    
    [self saveSeperateWords];
    [self saveKeywordsToArray];
    [self saveOperatorsToArray];
    [self saveLiteralsToArray];
    [self saveVariablesToArray];
    
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
        NSArray *rowItems = [row componentsSeparatedByString:@" "];
        NSMutableArray *mutableRowComponents = [[NSMutableArray alloc] initWithArray:rowItems];
        [self.arrayOfRowsElements addObject:mutableRowComponents];
    }
    
}

-(void) saveKeywordsToArray
{
    
    NSMutableArray *discardedItems = [NSMutableArray array];
    for (NSMutableArray *rowComponents in self.arrayOfRowsElements)
    {
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
        if (discardedItems.count == 1) {
            [rowComponents removeObject:discardedItems.firstObject];
        }
        
        else if (discardedItems.count > 1) {
            [rowComponents removeObjectsInArray:discardedItems];
        }
        
        [discardedItems removeAllObjects];
    }
    
}

-(void) checkForAllowedKeywords:(NSMutableArray *) rowComponents {
    NSString *previousElement = @"";
    for (NSInteger i = 0; i <= [rowComponents count]; i++) {
        if ([[rowComponents objectAtIndex:i] isEqualToString:@"Name"]) {
            Keyword *keyword = [[Keyword alloc] init];
            keyword.catagory = @"Keyword";
            keyword.type = @"Name";
            keyword.identifier = [rowComponents objectAtIndex:i+1];
            keyword.value = @"";
            [self.keywords addObject:keyword];
            
            Variable *variable = [[Variable alloc] init];
            variable.catagory = @"Variable";
            variable.type = previousElement;
            variable.identifier = [rowComponents objectAtIndex:i+1];
            variable.value = @"";
            [self.variables addObject:variable];
            i++;
        }

        if ([[rowComponents objectAtIndex:i] isEqualToString:@"BodyData"]) {
            Keyword *keyword = [[Keyword alloc] init];
            keyword.catagory = @"Keyword";
            keyword.type = @"BodyData";
            keyword.identifier = @"";
            keyword.value = @"";
            [self.keywords addObject:keyword];
        }
        if ([[rowComponents objectAtIndex:i] isEqualToString:@"{"]) {
            Symbol *symbol = [[Symbol alloc] init];
            symbol.catagory = @"Symbol";
            symbol.type = @"OpenBlock";
            symbol.identifier = @"{";
            symbol.value = @"";
            [self.symbols addObject:symbol];
        }
        if ([[rowComponents objectAtIndex:i] isEqualToString:@"Int16_t"]) {
            BOOL checkIfCorrect = NO;
            if ([[[rowComponents objectAtIndex:i+1] substringToIndex:1] isEqualToString:@"_"]) {
                checkIfCorrect = YES;
            }
            else {
                checkIfCorrect = NO;
                #warning - Implement error of input
            }
            
            if ([[rowComponents objectAtIndex:i+2] isEqualToString:@":="]) {
                checkIfCorrect = YES;
            }
            else {
                checkIfCorrect = NO;
                #warning - Implement error of input
            }
            
            if (checkIfCorrect) {
                Keyword *keyword = [[Keyword alloc] init];
                keyword.catagory = @"Keyword";
                keyword.type = @"Int16_t";
                keyword.identifier = [rowComponents objectAtIndex:i+1];
                keyword.value = @"";
                previousElement = @"Int16_t";
                [self.keywords addObject:keyword];
                
                Variable *variable = [[Variable alloc] init];
                variable.catagory = @"Variable";
                variable.type = [rowComponents objectAtIndex:i];
                variable.identifier = [rowComponents objectAtIndex:i+1];
                variable.value = [rowComponents objectAtIndex:i+3];
                [self.variables addObject:variable];
                
                Operator *operator = [[Operator alloc] init];
                operator.catagory = @"Operator";
                operator.type = @"Assignment";
                operator.identifier = @":=";
                operator.value = @"";
                [self.operators addObject:operator];
            }
            
        }
    }
}

-(void) saveOperatorsToArray
{
    
    NSMutableArray *discardedItems = [NSMutableArray array];
    for (NSMutableArray *rowComponents in self.arrayOfRowsElements)
    {
        for (NSString *rowComponent in rowComponents)
        {
            for (NSString *allowedKeyword in allowedOperators)
            {
                if ([rowComponent isEqualToString:allowedKeyword])
                {
                    [self.operators addObject:rowComponent];
                    [discardedItems addObject:rowComponent];
                }
                
            }
            
        }
        if (discardedItems.count == 1) {
            [rowComponents removeObject:discardedItems.firstObject];
        }
        
        else if (discardedItems.count > 1) {
            [rowComponents removeObjectsInArray:discardedItems];
        }
        
        [discardedItems removeAllObjects];
    }
    
}

- (void) saveLiteralsToArray
{
    self.literals = [NSMutableArray array];
    NSMutableArray *discardedItems = [NSMutableArray array];
    for (NSMutableArray *rowComponents in self.arrayOfRowsElements)
    {
        for (NSString *rowComponent in rowComponents)
        {
            if ([self isInteger:rowComponent])
            {
                [self.literals addObject:rowComponent];
                [discardedItems addObject:rowComponent];
            }
            
        }
        if (discardedItems.count == 1) {
            [rowComponents removeObject:discardedItems.firstObject];
        }
        
        else if (discardedItems.count > 1) {
            [rowComponents removeObjectsInArray:discardedItems];
        }
        
        [discardedItems removeAllObjects];
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

- (void) saveVariablesToArray
{
    
    NSMutableArray *discardedItems = [NSMutableArray array];
    for (NSMutableArray *rowComponents in self.arrayOfRowsElements)
    {
        for (NSString *rowComponent in rowComponents)
        {
            if ([[rowComponent substringToIndex:1]  isEqual: @"_"])
            {
                [self.variables addObject:rowComponent];
                [discardedItems addObject:rowComponent];
            }
            
        }
        if (discardedItems.count == 1) {
            [rowComponents removeObject:discardedItems.firstObject];
        }
        
        else if (discardedItems.count > 1) {
            [rowComponents removeObjectsInArray:discardedItems];
        }
        
        [discardedItems removeAllObjects];
    }
    
}
@end
