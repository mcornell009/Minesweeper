//
//  basicsViewController.h
//  Minesweeper
//
//  Created by Michael Cornell on 4/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

NSInteger bombArray[10];
UIButton *buttonArray[100];

@interface basicsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *resetGame;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *endLabel;
@property (weak, nonatomic) IBOutlet UIButton *flagButton;
@property int time;
@property int score;
@property BOOL flagging;
-(void)newGame;
-(void)buttonClicked:(UIButton*)button;
-(void)mineHit;
-(void)cleanHit:(UIButton*)button;
-(void)generateMines:(int)mine;
-(BOOL)isMined:(int)index;


@end