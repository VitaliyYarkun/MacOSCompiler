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
-(int16_t) addOperandOne:(int16_t) firstOperand toOperandTwo:(int16_t) secondOperand{
    int16_t result = firstOperand + secondOperand;
    return result;
}

-(int16_t) subtractOperandOne:(int16_t) firstOperand fromOperandTwo:(int16_t) secondOperand{
    int16_t result = secondOperand - firstOperand;
    return result;
}

-(int16_t) multiplyOperandOne:(int16_t) firstOperand byOperandTwo:(int16_t) secondOperand{
    int16_t result = firstOperand * secondOperand;
    return result;
}
-(int16_t) divideOperandOne:(int16_t) firstOperand byOperandTwo:(int16_t) secondOperand {
    int16_t result = firstOperand / secondOperand;
    return result;;
}

-(int16_t) modOperandOne:(int16_t) firstOperand byOperandTwo:(int16_t) secondOperand{
    int16_t result = firstOperand % secondOperand;
    return result;
}

-(BOOL) checkIfOperandOne:(int16_t) firstOperand isEqualToOperandTwo:(int16_t) secondOperand{
    if (firstOperand == secondOperand) 
        return YES;
    else
        return NO;
}

-(BOOL) checkIfOperandOne:(int16_t) firstOperand isNotEqualToOperandTwo:(int16_t) secondOperand{
    if (firstOperand != secondOperand)
        return YES;
    else
        return NO;
}

-(BOOL) checkIfOperandOne:(int16_t) firstOperand isGreaterThanOperandTwo:(int16_t) secondOperand{
    if (firstOperand > secondOperand)
        return YES;
    else
        return NO;
}

-(BOOL) checkIfOperandOne:(int16_t) firstOperand isLessThanOperandTwo:(int16_t) secondOperand{
    if (firstOperand < secondOperand)
        return YES;
    else
        return NO;
}

-(int16_t) logicalNotOfOperand:(int16_t) operand{
    return !operand;
}
-(int16_t) logicalAndOfOperandOne:(int16_t) firstOperand andOperandTwo:(int16_t) secondOperand{
    return firstOperand && secondOperand;
}

-(int16_t) logicalOrOfOperandOne:(int16_t) firstOperand andOperandTwo:(int16_t) secondOperand{
    return firstOperand || secondOperand;

}


@end
