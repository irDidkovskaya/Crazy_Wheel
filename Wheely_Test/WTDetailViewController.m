//
//  WTViewController.m
//  Wheely_Test
//
//  Created by Irina Didkovskaya on 1/10/14.
//  Copyright (c) 2014 Irina. All rights reserved.
//

#import "WTDetailViewController.h"

#define OFF_SET 10
#define MAX_HEIGHT 10000

@interface WTDetailViewController ()
@property (nonatomic, strong) IBOutlet UITextView *detailTextView;
@property (nonatomic, strong) IBOutlet UILabel *headerLabel;
@end

@implementation WTDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    UIBarButtonItem *backBarBtn = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(backAction:)];
    self.navigationController.navigationBar.topItem.backBarButtonItem = backBarBtn;
    
    self.title = self.item.title;
    
    self.headerLabel.text = self.item.title;
    self.detailTextView.text = self.item.itemText;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self sizeToFitHeaderLabel:self.headerLabel forText:self.headerLabel.text];
    [self sizeToFitTextView:self.detailTextView forText:self.detailTextView.text];
}

- (void)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)sizeToFitTextView:(UITextView *)textView forText:(NSString *)text
{
    CGRect rect = textView.frame;
    float textHeight = [self heightOfText:text inContainerWidth:textView.frame.size.width];
    if (textHeight < textView.superview.frame.size.height)
    {
        rect.size.height = textHeight;
    } else {
        rect.size.height = textView.superview.frame.size.height;
    }
    textView.contentSize = CGSizeMake(rect.size.width, textHeight);
    textView.frame = rect;
    [self.view updateConstraints];
}

- (void)sizeToFitHeaderLabel:(UILabel *)label forText:(NSString *)text
{
    CGRect rect = label.frame;
    float parentViewHeight = label.superview.frame.size.height;
    float textHeight = [self heightOfText:text inContainerWidth:label.frame.size.width]+OFF_SET*2;
    if (textHeight < parentViewHeight)
    {
        rect.size.height = textHeight;
        rect.origin.y = (parentViewHeight - textHeight)/2;
    } else {
        rect.size.height = textHeight;
        rect.origin.y = OFF_SET;
        
        CGRect rectParentView = label.superview.frame;
        rectParentView.size.height = textHeight+OFF_SET*2;
        label.superview.frame = rectParentView;
    }
    
    label.frame = rect;
    label.superview.translatesAutoresizingMaskIntoConstraints = YES;
    label.translatesAutoresizingMaskIntoConstraints = YES;
}


- (float)heightOfText:(NSString *)text inContainerWidth:(float)width
{
    CGRect textRect = [text boundingRectWithSize:CGSizeMake(width, MAX_HEIGHT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16]} context:nil];
    return textRect.size.height;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
