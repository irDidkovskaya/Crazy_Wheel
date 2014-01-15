//
//  WTMainCell.m
//  Wheely_Test
//
//  Created by Irina Didkovskaya on 1/13/14.
//  Copyright (c) 2014 Irina. All rights reserved.
//

#import "WTMainCell.h"
#import "WTRoundView.h"

@interface WTMainCell()
@property (nonatomic, strong) IBOutlet WTRoundView *mainContainer;
@property (nonatomic, strong) WTRoundView *testBackgroundView;
@property (nonatomic, strong) UIImageView *arrowImageView;
@end

@implementation WTMainCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)layoutSubviews
{
    [super layoutSubviews];
// count text height

    
    self.detailTextLabel.font = [UIFont italicSystemFontOfSize:14];
    self.detailTextLabel.textColor = [UIColor grayColor];
    self.detailTextLabel.numberOfLines = 0;
    self.detailTextLabel.textAlignment = NSTextAlignmentJustified;
    CGRect rectText = [self.detailTextLabel.text boundingRectWithSize:CGSizeMake(self.contentView.frame.size.width - 50, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: self.detailTextLabel.font} context:nil];

    self.textLabel.font = [UIFont boldSystemFontOfSize:16];
    CGRect rectTextLabel = self.textLabel.frame;
    rectTextLabel.origin.x = 25;
    rectTextLabel.origin.y = 20;
    self.textLabel.frame = rectTextLabel;
    
//set up detailTextLabel new height and width
    CGRect rect = self.detailTextLabel.frame;
    rect.size.width = self.contentView.frame.size.width - 60;
    rect.size.height = rectText.size.height;
    rect.origin.y = rectTextLabel.origin.y + rectTextLabel.size.height + 5;
    rect.origin.x = 25;
    self.detailTextLabel.frame = rect;


    [self.arrowImageView removeFromSuperview];
    [self.testBackgroundView removeFromSuperview];
    
//set up roundCorner BG woth Stroke
    self.testBackgroundView = [[WTRoundView alloc] initWithFrame:CGRectMake(10, 10, self.bounds.size.width-20, self.bounds.size.height-20)];
    self.testBackgroundView.userInteractionEnabled = NO;
    self.testBackgroundView.backgroundColor = UIColor.clearColor;
    [self.contentView insertSubview:self.testBackgroundView belowSubview:self.textLabel];
    
//set up arrow
    self.arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow"]];
    self.arrowImageView.frame = CGRectMake(self.testBackgroundView.frame.size.width - 17, (self.testBackgroundView.frame.size.height-18)/2, 11, 18);
    [self.testBackgroundView addSubview:self.arrowImageView];
    
}




@end
