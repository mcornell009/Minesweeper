//
//  basicsViewController.m
//  Minesweeper
//
//  Created by Michael Cornell on 4/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "basicsViewController.h"

@implementation basicsViewController
@synthesize resetGame;
@synthesize scoreLabel;
@synthesize timeLabel;
@synthesize endLabel;
@synthesize flagButton;
@synthesize time;
@synthesize score;
@synthesize flagging;

-(void)newGame{
    endLabel.text=nil;
    scoreLabel.text=@"Score";
    score=0;
    flagging=NO;
    [flagButton setTitle:@"Flag" forState:UIControlStateNormal];   
    int index=0;
    int yAxis=70;
    for(int y=0;y<100;y=y+10){
        int xAxis=20;
        for( int x = 1; x < 11; x++) {
            buttonArray[index] = [[UIButton alloc]init];
            buttonArray[index] = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            [buttonArray[index] setTag:index];
            [buttonArray[index] addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
            buttonArray[index].frame = CGRectMake(xAxis, yAxis, 26.0, 26.0);
            [self.view addSubview:buttonArray[index]];
            
            xAxis=xAxis+28;
            index=x+y;
        }
        yAxis=yAxis+28;
    }
    //generate bombs...
    //RECURSIVELY BOOYAH BENJAMIN
    for (int c=0;c<10;c++){
    [self generateMines:c];
    }
}
- (IBAction)flagPress:(id)sender{
    if (flagging==YES){
     flagging=NO;
        [flagButton setTitle:@"Flag" forState:UIControlStateNormal];   
    }
    else {
        flagging=YES;
        [flagButton setTitle:@"Flagging" forState:UIControlStateNormal];   
    }
}
-(void)generateMines:(int)mine{
    bombArray[mine]= (arc4random()%99);
    for (int bombs=0;bombs<mine;bombs++){
        if (bombArray[bombs]==bombArray[mine]){
            bombArray[mine]= (arc4random()%99);
            bombs=0;
        }
    }
    NSLog(@"BOMB AT %d",bombArray[mine]);
}
- (IBAction)resetPress:(id)sender {
    [self newGame];
}
- (void)buttonClicked:(UIButton*)button
{
    if (flagging==YES)[button setTitle:@"X" forState:UIControlStateNormal];
    else if ([button titleForState:UIControlStateNormal]==@"X"){
    [button setTitle:@"" forState:UIControlStateNormal];
    }
    else{
        
    if ([self isMined:button.tag]==YES){
        //hit
        [self mineHit];
    }
    else {
        //if not hit
        [self cleanHit:button];
    }
    }    
}
-(void)mineHit{
    for (int d=0;d<100;d++){
        buttonArray[d].enabled=NO;
        for (int e=0;e<10;e++){
            if (buttonArray[d].tag==bombArray[e])[buttonArray[d] setTitle:@"*" forState:UIControlStateDisabled];
        }
    }
    endLabel.text=@"GAME OVER";
}
-(void)cleanHit:(UIButton*)button{
    score++;
    scoreLabel.text=[NSString stringWithFormat:@"%d",score];
    if (score==90){
        //WIN
        endLabel.text=@"WINNER";
    }
    button.enabled=NO;
    int index=button.tag;
    if (index==0){
        //topleft corner
        int bombCount=0;   
        if ([self isMined:index+1]==YES)bombCount++;
        if ([self isMined:index+10]==YES)bombCount++;
        if ([self isMined:index+11]==YES)bombCount++;
        if (bombCount==0){
            [buttonArray[index] setTitle:@"." forState:UIControlStateNormal];
            if (buttonArray[index+1].isEnabled==YES)[self cleanHit:buttonArray[index+1]];
            if (buttonArray[index+10].isEnabled==YES)[self cleanHit:buttonArray[index+10]];
            if (buttonArray[index+11].isEnabled==YES)[self cleanHit:buttonArray[index+11]];
        }
        else{
            [buttonArray[index] setTitle:[NSString stringWithFormat:@"%i",bombCount] forState:UIControlStateNormal];
            //buttonArray[index].currentTitleColor=[UIColor redColor];
        } 
    }
    else if (index==9){
        //topright corner
        int bombCount=0;   
        if ([self isMined:index-1]==YES)bombCount++;
        if ([self isMined:index+9]==YES)bombCount++;
        if ([self isMined:index+10]==YES)bombCount++;
        if (bombCount==0){
            [buttonArray[index] setTitle:@"." forState:UIControlStateNormal];
            if (buttonArray[index-1].isEnabled==YES)[self cleanHit:buttonArray[index-1]];
            if (buttonArray[index+9].isEnabled==YES)[self cleanHit:buttonArray[index+9]];
            if (buttonArray[index+10].isEnabled==YES)[self cleanHit:buttonArray[index+10]];
        }
        else{
            [buttonArray[index] setTitle:[NSString stringWithFormat:@"%i",bombCount] forState:UIControlStateNormal];
        } 
    }
    else if (index==90){
        //bottomleft corner
        int bombCount=0;   
        if ([self isMined:index+1]==YES)bombCount++;
        if ([self isMined:index-9]==YES)bombCount++;
        if ([self isMined:index-10]==YES)bombCount++;
        if (bombCount==0){
            [buttonArray[index] setTitle:@"." forState:UIControlStateNormal];
            if (buttonArray[index+1].isEnabled==YES)[self cleanHit:buttonArray[index+1]];
            if (buttonArray[index-9].isEnabled==YES)[self cleanHit:buttonArray[index-9]];
            if (buttonArray[index-10].isEnabled==YES)[self cleanHit:buttonArray[index-10]];
        }
        else{
            [buttonArray[index] setTitle:[NSString stringWithFormat:@"%i",bombCount] forState:UIControlStateNormal];
        } 
    }
    else if (index==99){
        //bottomright corner
        int bombCount=0;   
        if ([self isMined:index-1]==YES)bombCount++;
        if ([self isMined:index-10]==YES)bombCount++;
        if ([self isMined:index-11]==YES)bombCount++;
        if (bombCount==0){
            [buttonArray[index] setTitle:@"." forState:UIControlStateNormal];
            if (buttonArray[index-1].isEnabled==YES)[self cleanHit:buttonArray[index-1]];
            if (buttonArray[index-10].isEnabled==YES)[self cleanHit:buttonArray[index-10]];
            if (buttonArray[index-11].isEnabled==YES)[self cleanHit:buttonArray[index-11]];
        }
        else{
            [buttonArray[index] setTitle:[NSString stringWithFormat:@"%i",bombCount] forState:UIControlStateNormal];
        } 
    }
    else if (index<10){
        //top row
        int bombCount=0;   
        if ([self isMined:index+1]==YES)bombCount++;
        if ([self isMined:index-1]==YES)bombCount++;
        if ([self isMined:index+9]==YES)bombCount++;
        if ([self isMined:index+10]==YES)bombCount++;
        if ([self isMined:index+11]==YES)bombCount++;
        if (bombCount==0){
            [buttonArray[index] setTitle:@"." forState:UIControlStateNormal];
            if (buttonArray[index+1].isEnabled==YES)[self cleanHit:buttonArray[index+1]];
            if (buttonArray[index-1].isEnabled==YES)[self cleanHit:buttonArray[index-1]];
            if (buttonArray[index+9].isEnabled==YES)[self cleanHit:buttonArray[index+9]];
            if (buttonArray[index+10].isEnabled==YES)[self cleanHit:buttonArray[index+10]];
            if (buttonArray[index+11].isEnabled==YES)[self cleanHit:buttonArray[index+11]];
        }
        else{
            [buttonArray[index] setTitle:[NSString stringWithFormat:@"%i",bombCount] forState:UIControlStateNormal];
        } 
    }
    else if (index>89){
        //bottom row
        int bombCount=0;   
        if ([self isMined:index+1]==YES)bombCount++;
        if ([self isMined:index-1]==YES)bombCount++;
        if ([self isMined:index-9]==YES)bombCount++;
        if ([self isMined:index-10]==YES)bombCount++;
        if ([self isMined:index-11]==YES)bombCount++;
        if (bombCount==0){
            [buttonArray[index] setTitle:@"." forState:UIControlStateNormal];
            if (buttonArray[index+1].isEnabled==YES)[self cleanHit:buttonArray[index+1]];
            if (buttonArray[index-1].isEnabled==YES)[self cleanHit:buttonArray[index-1]];
            if (buttonArray[index-9].isEnabled==YES)[self cleanHit:buttonArray[index-9]];
            if (buttonArray[index-10].isEnabled==YES)[self cleanHit:buttonArray[index-10]];
            if (buttonArray[index-11].isEnabled==YES)[self cleanHit:buttonArray[index-11]];
        }
        else{
            [buttonArray[index] setTitle:[NSString stringWithFormat:@"%i",bombCount] forState:UIControlStateNormal];
        } 
    }
    else if ((index % 10)==0){
        //leftmost column, not a corner
        int bombCount=0;   
        if ([self isMined:index+1]==YES)bombCount++;
        if ([self isMined:index-9]==YES)bombCount++;
        if ([self isMined:index+10]==YES)bombCount++;
        if ([self isMined:index-10]==YES)bombCount++;
        if ([self isMined:index+11]==YES)bombCount++;
        if (bombCount==0){
            [buttonArray[index] setTitle:@"." forState:UIControlStateNormal];
            if (buttonArray[index+1].isEnabled==YES)[self cleanHit:buttonArray[index+1]];
            if (buttonArray[index-9].isEnabled==YES)[self cleanHit:buttonArray[index-9]];
            if (buttonArray[index+10].isEnabled==YES)[self cleanHit:buttonArray[index+10]];
            if (buttonArray[index-10].isEnabled==YES)[self cleanHit:buttonArray[index-10]];
            if (buttonArray[index+11].isEnabled==YES)[self cleanHit:buttonArray[index+11]];
        }
        else{
            [buttonArray[index] setTitle:[NSString stringWithFormat:@"%i",bombCount] forState:UIControlStateNormal];
        } 
    }
    else if ((index % 10)==9){
        //rightmost column, not a corner
        int bombCount=0;   
        if ([self isMined:index-1]==YES)bombCount++;
        if ([self isMined:index+9]==YES)bombCount++;
        if ([self isMined:index+10]==YES)bombCount++;
        if ([self isMined:index-10]==YES)bombCount++;
        if ([self isMined:index-11]==YES)bombCount++;
        if (bombCount==0){
            [buttonArray[index] setTitle:@"." forState:UIControlStateNormal];
            if (buttonArray[index-1].isEnabled==YES)[self cleanHit:buttonArray[index-1]];
            if (buttonArray[index+9].isEnabled==YES)[self cleanHit:buttonArray[index+9]];
            if (buttonArray[index+10].isEnabled==YES)[self cleanHit:buttonArray[index+10]];
            if (buttonArray[index-10].isEnabled==YES)[self cleanHit:buttonArray[index-10]];
            if (buttonArray[index-11].isEnabled==YES)[self cleanHit:buttonArray[index-11]];
        }
        else{
            [buttonArray[index] setTitle:[NSString stringWithFormat:@"%i",bombCount] forState:UIControlStateNormal];
        } 
    }
    else {
        //not an edge
        int bombCount=0;   
        if ([self isMined:index+1]==YES)bombCount++;
        if ([self isMined:index-1]==YES)bombCount++;
        if ([self isMined:index+9]==YES)bombCount++;
        if ([self isMined:index-9]==YES)bombCount++;
        if ([self isMined:index+10]==YES)bombCount++;
        if ([self isMined:index-10]==YES)bombCount++;
        if ([self isMined:index+11]==YES)bombCount++;
        if ([self isMined:index-11]==YES)bombCount++;
        if (bombCount==0){
            [buttonArray[index] setTitle:@"." forState:UIControlStateNormal];
            if (buttonArray[index+1].isEnabled==YES)[self cleanHit:buttonArray[index+1]];
            if (buttonArray[index-1].isEnabled==YES)[self cleanHit:buttonArray[index-1]];
            if (buttonArray[index+9].isEnabled==YES)[self cleanHit:buttonArray[index+9]];
            if (buttonArray[index-9].isEnabled==YES)[self cleanHit:buttonArray[index-9]];
            if (buttonArray[index+10].isEnabled==YES)[self cleanHit:buttonArray[index+10]];
            if (buttonArray[index-10].isEnabled==YES)[self cleanHit:buttonArray[index-10]];
            if (buttonArray[index+11].isEnabled==YES)[self cleanHit:buttonArray[index+11]];
            if (buttonArray[index-11].isEnabled==YES)[self cleanHit:buttonArray[index-11]];
        }
        else{
            [buttonArray[index] setTitle:[NSString stringWithFormat:@"%i",bombCount] forState:UIControlStateNormal];
        } 
    }
}
-(BOOL)isMined:(int)index{
    BOOL bombed;
    for (int b=0;b<10;b++){
        if (buttonArray[index].tag==bombArray[b]){
            return bombed=YES;
        }
    }
    return bombed=NO;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self newGame];
}
- (void)viewDidUnload
{
    [self setResetGame:nil];
    [self setScoreLabel:nil];
    [self setTimeLabel:nil];
    [self setEndLabel:nil];
    [self setFlagButton:nil];
    for (int f=0;f<100;f++){
        buttonArray[f]=nil;
    }
    for (int g=0;g<10;g++){
        bombArray[g]=0;
    }
    [super viewDidUnload];

}
@end
