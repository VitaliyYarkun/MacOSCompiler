//
//  OperationManager.h
//  CompilerMacOS
//
//  Created by Vitaliy Yarkun on 12/6/16.
//  Copyright © 2016 Vitaliy Yarkun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OperationManager : NSObject

+ (instancetype)sharedInstance;
-(NSInteger) addOperandOne:(NSInteger) firstOperand toOperandTwo:(NSInteger) secondOperand;
-(NSInteger) subtractOperandOne:(NSInteger) firstOperand fromOperandTwo:(NSInteger) secondOperand;
-(NSInteger) multiplyOperandOne:(NSInteger) firstOperand byOperandTwo:(NSInteger) secondOperand;
-(NSInteger) divideOperandOne:(NSInteger) firstOperand byOperandTwo:(NSInteger) secondOperand;
-(NSInteger) modOperandOne:(NSInteger) firstOperand byOperandTwo:(NSInteger) secondOperand;

-(BOOL) checkIfOperandOne:(NSInteger) firstOperand isEqualToOperandTwo:(NSInteger) secondOperand;
-(BOOL) checkIfOperandOne:(NSInteger) firstOperand isNotEqualToOperandTwo:(NSInteger) secondOperand;
-(BOOL) checkIfOperandOne:(NSInteger) firstOperand isGreaterThanOperandTwo:(NSInteger) secondOperand;
-(BOOL) checkIfOperandOne:(NSInteger) firstOperand isLessThanOperandTwo:(NSInteger) secondOperand;

-(NSInteger) logicalNotOfOperand:(NSInteger) operand;
-(NSInteger) logicalAndOfOperandOne:(NSInteger) firstOperand andOperandTwo:(NSInteger) secondOperand;
-(NSInteger) logicalOrOfOperandOne:(NSInteger) firstOperand andOperandTwo:(NSInteger) secondOperand;

@end
