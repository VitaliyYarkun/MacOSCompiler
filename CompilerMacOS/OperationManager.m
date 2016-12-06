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
-(NSInteger) addOperandOne:(NSInteger) firstOperand toOperandTwo:(NSInteger) secondOperand{
    return firstOperand + secondOperand;
}

-(NSInteger) subtractOperandOne:(NSInteger) firstOperand fromOperandTwo:(NSInteger) secondOperand{
    return secondOperand - firstOperand;
}

-(NSInteger) multiplyOperandOne:(NSInteger) firstOperand byOperandTwo:(NSInteger) secondOperand{
    return firstOperand * secondOperand;
}
-(NSInteger) divideOperandOne:(NSInteger) firstOperand byOperandTwo:(NSInteger) secondOperand {
    return firstOperand / secondOperand;
}

-(NSInteger) modOperandOne:(NSInteger) firstOperand byOperandTwo:(NSInteger) secondOperand{
    return firstOperand % secondOperand;
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
