//
//  OperationManager.m
//  CompilerMacOS
//
//  Created by Vitaliy Yarkun on 12/6/16.
//  Copyright © 2016 Vitaliy Yarkun. All rights reserved.
//

#import "OperationManager.h"

@implementation OperationManager

+ (instancetype)sharedInstance
{
    static OperationManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[OperationManager alloc] init];
    });
    
    return sharedInstance;
}
-(NSString *) addOperandOne:(NSString *) firstOperand toOperandTwo:(NSString *) secondOperand{
    NSInteger first = [firstOperand integerValue];
    NSInteger second = [secondOperand integerValue];
    NSInteger result = first + second;
    NSString *stringToReturn = [NSString stringWithFormat:@"%ld", (long)result];
    return stringToReturn;
}

-(NSString *) subtractOperandOne:(NSString *) firstOperand fromOperandTwo:(NSString *) secondOperand{
    NSInteger first = [firstOperand integerValue];
    NSInteger second = [secondOperand integerValue];
    NSInteger result = second - first;
    NSString *stringToReturn = [NSString stringWithFormat:@"%ld", (long)result];
    return stringToReturn;
}

-(NSString *) multiplyOperandOne:(NSString *) firstOperand byOperandTwo:(NSString *) secondOperand{
    NSInteger first = [firstOperand integerValue];
    NSInteger second = [secondOperand integerValue];
    NSInteger result = first * second;
    NSString *stringToReturn = [NSString stringWithFormat:@"%ld", (long)result];
    return stringToReturn;
}
-(NSString *) divideOperandOne:(NSString *) firstOperand byOperandTwo:(NSString *) secondOperand {
    NSInteger first = [firstOperand integerValue];
    NSInteger second = [secondOperand integerValue];
    NSInteger result = first / second;
    NSString *stringToReturn = [NSString stringWithFormat:@"%ld", (long)result];
    return stringToReturn;;
}

-(NSString *) modOperandOne:(NSString *) firstOperand byOperandTwo:(NSString *) secondOperand{
    NSInteger first = [firstOperand integerValue];
    NSInteger second = [secondOperand integerValue];
    NSInteger result = first % second;
    NSString *stringToReturn = [NSString stringWithFormat:@"%ld", (long)result];
    return stringToReturn;
}

-(BOOL) checkIfOperandOne:(NSInteger) firstOperand isEqualToOperandTwo:(NSInteger) secondOperand{
    if (firstOperand == secondOperand) 
        return YES;
    else
        return NO;
}

-(BOOL) checkIfOperandOne:(NSInteger) firstOperand isNotEqualToOperandTwo:(NSInteger) secondOperand{
    if (firstOperand != secondOperand)
        return YES;
    else
        return NO;
}

-(BOOL) checkIfOperandOne:(NSInteger) firstOperand isGreaterThanOperandTwo:(NSInteger) secondOperand{
    if (firstOperand > secondOperand)
        return YES;
    else
        return NO;
}

-(BOOL) checkIfOperandOne:(NSInteger) firstOperand isLessThanOperandTwo:(NSInteger) secondOperand{
    if (firstOperand < secondOperand)
        return YES;
    else
        return NO;
}

-(NSInteger) logicalNotOfOperand:(NSInteger) operand{
    return !operand;
}
-(NSInteger) logicalAndOfOperandOne:(NSInteger) firstOperand andOperandTwo:(NSInteger) secondOperand{
    return firstOperand && secondOperand;
}

-(NSInteger) logicalOrOfOperandOne:(NSInteger) firstOperand andOperandTwo:(NSInteger) secondOperand{
    return firstOperand || secondOperand;

}







@end
