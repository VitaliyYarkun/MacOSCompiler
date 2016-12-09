//
//  ViewController.m
//  CompilerMacOS
//
//  Created by Vitaliy Yarkun on 12/3/16.
//  Copyright © 2016 Vitaliy Yarkun. All rights reserved.
//

#import "ViewController.h"
#import "LexicalAnalyzer.h"
#import "SyntacticAnalyzer.h"
#import "Lexem.h"

@interface ViewController ()

@property (nonatomic, strong) IBOutlet NSTextView *textView;
@property (nonatomic, strong) LexicalAnalyzer *lexicalAnalyzer;
@property (nonatomic, strong) SyntacticAnalyzer *syntacticAnalyzer;
@property (unsafe_unretained) IBOutlet NSTextView *consoleView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.lexicalAnalyzer = [LexicalAnalyzer sharedInstance];
    self.syntacticAnalyzer = [SyntacticAnalyzer sharedInstance];
    self.textView.textColor = [NSColor blackColor];
    self.textView.automaticSpellingCorrectionEnabled = NO;
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

- (IBAction)lexicalAnalysisAction:(NSButton *)sender {
    [self.lexicalAnalyzer scanCode:[self.textView string]];
}

- (IBAction)syntacticAnalysisAction:(NSButton *)sender {
    [self.syntacticAnalyzer analyzeCodeData];
    NSMutableString *resultString = [[NSMutableString alloc] init];
    for (Lexem *lexem in self.lexicalAnalyzer.bodyDataVariables) {
        [resultString appendFormat:@"%@ = %@\n", lexem.identifier, lexem.resultValue];
    }
    [self.consoleView setString:resultString];
    
}

@end
