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
-(NSString *) addOperandOne:(NSString *) firstOperand toOperandTwo:(NSString *) secondOperand;
-(NSString *) subtractOperandOne:(NSString *) firstOperand fromOperandTwo:(NSString *) secondOperand;
-(NSString *) multiplyOperandOne:(NSString *) firstOperand byOperandTwo:(NSString *) secondOperand;
-(NSString *) divideOperandOne:(NSString *) firstOperand byOperandTwo:(NSString *) secondOperand;
-(NSString *) modOperandOne:(NSString *) firstOperand byOperandTwo:(NSString *) secondOperand;

-(BOOL) checkIfOperandOne:(NSInteger) firstOperand isEqualToOperandTwo:(NSInteger) secondOperand;
-(BOOL) checkIfOperandOne:(NSInteger) firstOperand isNotEqualToOperandTwo:(NSInteger) secondOperand;
-(BOOL) checkIfOperandOne:(NSInteger) firstOperand isGreaterThanOperandTwo:(NSInteger) secondOperand;
-(BOOL) checkIfOperandOne:(NSInteger) firstOperand isLessThanOperandTwo:(NSInteger) secondOperand;

-(NSInteger) logicalNotOfOperand:(NSInteger) operand;
-(NSInteger) logicalAndOfOperandOne:(NSInteger) firstOperand andOperandTwo:(NSInteger) secondOperand;
-(NSInteger) logicalOrOfOperandOne:(NSInteger) firstOperand andOperandTwo:(NSInteger) secondOperand;

@end
