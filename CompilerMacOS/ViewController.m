//
//  ViewController.m
//  CompilerMacOS
//
//  Created by Vitaliy Yarkun on 12/3/16.
//  Copyright © 2016 Vitaliy Yarkun. All rights reserved.
//

#import "ViewController.h"
#import "LexicalAnalyzer.h"

@interface ViewController ()

@property (nonatomic, strong) IBOutlet NSTextView *textView;
@property (nonatomic, strong) LexicalAnalyzer *lexicalAnalyzer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.lexicalAnalyzer = [LexicalAnalyzer sharedInstance];
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
    
}

@end
