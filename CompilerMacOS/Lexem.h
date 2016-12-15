//
//  Lexem.h
//  CompilerMacOS
//
//  Created by Vitaliy Yarkun on 12/4/16.
//  Copyright © 2016 Vitaliy Yarkun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Lexem : NSObject

@property (nonatomic, strong) NSString *catagory;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, assign) int16_t resultValue;
@property (nonatomic, strong) NSString *error;

@end
