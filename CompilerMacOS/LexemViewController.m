//
//  LexemViewController.m
//  CompilerMacOS
//
//  Created by Vitaliy Yarkun on 12/3/16.
//  Copyright © 2016 Vitaliy Yarkun. All rights reserved.
//

#import "LexemViewController.h"
#import "LexicalAnalyzer.h"
#import "Lexem.h"

@interface LexemViewController () <NSTableViewDataSource, NSTableViewDelegate>

@property (weak) IBOutlet NSTableView *tableView;
@property (nonatomic, strong) LexicalAnalyzer *lexicalAnalyzer;
@end

@implementation LexemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.lexicalAnalyzer = [LexicalAnalyzer sharedInstance];
    [self.tableView reloadData];
}
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return [self.lexicalAnalyzer.lexemes  count];
}

-(void) viewWillAppear {
    [super viewWillAppear];
    [self.tableView reloadData];
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    
    NSTableCellView *cellView = [tableView makeViewWithIdentifier:tableColumn.identifier owner:self];
    
    if( [tableColumn.identifier isEqualToString:@"Number"])
    {
            cellView.textField.stringValue = [NSString stringWithFormat:@"%ld", (long)row];
            return cellView;
    }
    if( [tableColumn.identifier isEqualToString:@"Lexem"]) {
        Lexem *lexem = [self.lexicalAnalyzer.lexemes objectAtIndex:row];
        cellView.textField.stringValue = [NSString stringWithFormat:@"%@", lexem.identifier];
        return cellView;
    }
    if( [tableColumn.identifier isEqualToString:@"Comment"]) {
        Lexem *lexem = [self.lexicalAnalyzer.lexemes objectAtIndex:row];
        cellView.textField.stringValue = [NSString stringWithFormat:@"%@", lexem.catagory];
        return cellView;
    }
    
    return cellView;
}


@end
