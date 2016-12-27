//
//  ViewController.m
//  my_first_app
//
//  Created by chengshuo on 15/2/7.
//  Copyright (c) 2015年 chengshuo. All rights reserved.
//

#import "ViewController.h"
#import "ColorMap.h"
#import "data_structure.h"
#include <time.h>

#define SX GameBoard.frame.origin.x+7
#define SY GameBoard.frame.origin.y+7
#define OSZ 42

@interface ViewController () {
    UILabel *MyLabels[4][4];
    int num_array[4][4];
    data_structure *my_queue[16];
    long long cur_score;
    long long score_target;
    ColorMap *checker;
    BOOL DidMoved,HaveSpace,HaveWon;
}

@property (weak, nonatomic) IBOutlet UILabel *ScoreBar;
@property (weak, nonatomic) IBOutlet UILabel *GameBoard;
@property (weak, nonatomic) IBOutlet UIView *TouchLayer;
@property (weak, nonatomic) IBOutlet UIView *Mask;

@end

@implementation ViewController

@synthesize ScoreBar,GameBoard,Mask,TouchLayer;

#pragma mark start

- (void) viewDidLoad {
    [self InitGame];
    [self InitRecognizer];
}

- (void) Creat {
    
    int curp=0,temp=0;
    for (int i=0;i<4;i++) {
        for (int j=0;j<4;j++) {
            if (num_array[i][j]==-1) {
                my_queue[curp].x=i;
                my_queue[curp].y=j;
                curp++;
            }
        }
    }
    temp=rand()%curp;
    num_array[my_queue[temp].x][my_queue[temp].y]=2;
    [self ChangeViews];
}

- (void)InitRecognizer {
    UISwipeGestureRecognizer *left = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(moveleft)];
    left.direction = UISwipeGestureRecognizerDirectionLeft;
    [TouchLayer addGestureRecognizer:left];
    
    UISwipeGestureRecognizer *up = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(moveup)];
    up.direction = UISwipeGestureRecognizerDirectionUp;
    [TouchLayer addGestureRecognizer:up];
    
    
    
    UISwipeGestureRecognizer *right = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(moveright)];
    right.direction = UISwipeGestureRecognizerDirectionRight;
    [TouchLayer addGestureRecognizer:right];
    
    
    UISwipeGestureRecognizer *down = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(movedown)];
    down.direction = UISwipeGestureRecognizerDirectionDown;
    [TouchLayer addGestureRecognizer:down];
    
}

- (void)InitGame {
    cur_score=0;
    score_target=2048;
    ScoreBar.text=[NSString stringWithFormat:@"score : %lli",cur_score];
    srand((unsigned)time(NULL));
    
    checker=[[ColorMap alloc]init];
    ScoreBar.layer.cornerRadius=10;
    ScoreBar.layer.masksToBounds=YES;
    GameBoard.layer.cornerRadius=10;
    GameBoard.layer.masksToBounds=YES;
    
    Mask.hidden = YES;
    
    for (int i=0;i<4;i++) {
        for (int j=0;j<4;j++) {
            MyLabels[i][j]=[[UILabel alloc]initWithFrame:CGRectMake(SX+j*(OSZ+3), SY+i*(OSZ+3), OSZ, OSZ)];
            MyLabels[i][j].layer.cornerRadius=6;
            MyLabels[i][j].layer.masksToBounds=YES;
            num_array[i][j]=-1;
            [self.view addSubview:MyLabels[i][j]];
            
        }
    }
    for (int i=0; i<16; i++) {
        my_queue[i] = [[data_structure alloc]init];
    }
    [self Creat];
}

- (void) ChangeViews {
    HaveSpace=FALSE;
    for (int i=0;i<4;i++) {
        for (int j=0;j<4;j++) {
            if (num_array[i][j]<2048) {
                MyLabels[i][j].backgroundColor=[checker getcolor:num_array[i][j]];
            }
            else {
                MyLabels[i][j].backgroundColor=RGB(255, 0, 0);
            }
            if (num_array[i][j]!=-1) {
                MyLabels[i][j].text=[NSString stringWithFormat:@"%i",num_array[i][j]];
                MyLabels[i][j].textAlignment=NSTextAlignmentCenter;
            }
            else {
                MyLabels[i][j].text=@"";
                HaveSpace=TRUE;
            }
            [self.view addSubview:MyLabels[i][j]];
        }
    }
}

#pragma mark control

- (void) MOV_L {
    for (int i=0;i<4;i++) {
        for (int j=0;j<3;j++) {
            if (num_array[i][j]==-1) {
                int t;
                for (t=j+1;t<3;t++) {
                    if (num_array[i][t]!=-1) {
                        break;
                    }
                }
                if (num_array[i][t]!=-1) {
                    num_array[i][j]=num_array[i][t];
                    num_array[i][t]=-1;
                    DidMoved=TRUE;
                }
            }
        }
        for (int j=0;j<3;j++) {
            if (num_array[i][j]==num_array[i][j+1]&&num_array[i][j]!=-1) {
                num_array[i][j]+=num_array[i][j+1];
                cur_score+=num_array[i][j]*2;
                num_array[i][j+1]=-1;
                DidMoved=TRUE;
            }
        }
        for (int j=0;j<3;j++) {
            if (num_array[i][j]==-1) {
                int t;
                for (t=j+1;t<3;t++) {
                    if (num_array[i][t]!=-1) {
                        break;
                    }
                }
                num_array[i][j]=num_array[i][t];
                num_array[i][t]=-1;
            }
        }
    }
    [self ChangeViews];
}

- (void) MOV_R {
    for (int i=0;i<4;i++) {
        for (int j=3;j>0;j--) {
            if (num_array[i][j]==-1) {
                int t;
                for (t=j-1;t>0;t--) {
                    if (num_array[i][t]!=-1) {
                        break;
                    }
                }
                if (num_array[i][t]!=-1) {
                    num_array[i][j]=num_array[i][t];
                    num_array[i][t]=-1;
                    DidMoved=TRUE;
                }
            }
        }
        for (int j=3;j>0;j--) {
            if (num_array[i][j]==num_array[i][j-1]&&num_array[i][j]!=-1) {
                num_array[i][j]+=num_array[i][j-1];
                cur_score+=num_array[i][j]*2;
                num_array[i][j-1]=-1;
                DidMoved=TRUE;
            }
        }
        for (int j=3;j>0;j--) {
            if (num_array[i][j]==-1) {
                int t;
                for (t=j-1;t>0;t--) {
                    if (num_array[i][t]!=-1) {
                        break;
                    }
                }
                num_array[i][j]=num_array[i][t];
                num_array[i][t]=-1;
            }
        }
    }
    [self ChangeViews];
}

- (void) MOV_D {
    for (int j=0;j<4;j++) {
        for (int i=3;i>0;i--) {
            if (num_array[i][j]==-1) {
                int t;
                for (t=i-1;t>0;t--) {
                    if (num_array[t][j]!=-1) {
                        break;
                    }
                }
                if (num_array[t][j]!=-1) {
                    num_array[i][j]=num_array[t][j];
                    num_array[t][j]=-1;
                    DidMoved=TRUE;
                }
            }
        }
        for (int i=3;i>0;i--) {
            if (num_array[i][j]==num_array[i-1][j]&&num_array[i][j]!=-1) {
                num_array[i][j]+=num_array[i-1][j];
                cur_score+=num_array[i][j]*2;
                num_array[i-1][j]=-1;
                DidMoved=TRUE;
            }
        }
        for (int i=3;i>0;i--) {
            if (num_array[i][j]==-1) {
                int t;
                for (t=i-1;t>0;t--) {
                    if (num_array[t][j]!=-1) {
                        break;
                    }
                }
                num_array[i][j]=num_array[t][j];
                num_array[t][j]=-1;
            }
        }
    }
    [self ChangeViews];
}

- (void) MOV_U {
    for (int j=0;j<4;j++) {
        for (int i=0;i<3;i++) {
            if (num_array[i][j]==-1) {
                int t;
                for (t=i+1;t<3;t++) {
                    if (num_array[t][j]!=-1) {
                        break;
                    }
                }
                if (num_array[t][j]!=-1) {
                    num_array[i][j]=num_array[t][j];
                    num_array[t][j]=-1;
                    DidMoved=TRUE;
                }
            }
        }
        for (int i=0;i<3;i++) {
            if (num_array[i][j]==num_array[i+1][j]&&num_array[i][j]!=-1) {
                num_array[i][j]+=num_array[i+1][j];
                cur_score+=num_array[i][j]*2;
                num_array[i+1][j]=-1;
                DidMoved=TRUE;
            }
        }
        for (int i=0;i<3;i++) {
            if (num_array[i][j]==-1) {
                int t;
                for (t=i+1;t<3;t++) {
                    if (num_array[t][j]!=-1) {
                        break;
                    }
                }
                num_array[i][j]=num_array[t][j];
                num_array[t][j]=-1;
            }
        }
    }
    [self ChangeViews];
}

- (void)movedown {
    [self MOV_D];
    if ([self CheckCondition]) {
        [self Creat];
    }
}

- (void)moveleft {
    [self MOV_L];
    if ([self CheckCondition]) {
        [self Creat];
    }
}

- (void)moveup {
    [self MOV_U];
    if ([self CheckCondition]) {
        [self Creat];
    }
}

- (void)moveright {
    [self MOV_R];
    if ([self CheckCondition]) {
        [self Creat];
    }
}

#pragma mark check

- (BOOL) CheckCondition {
    //true should creat new
    //false not creat
    ScoreBar.text=[NSString stringWithFormat:@"score : %lli",cur_score];
    if (DidMoved) {
        DidMoved = FALSE;
        for (int i=0;i<4;i++) {
            for (int j=0;j<4;j++) {
                if (num_array[i][j]>=score_target) {
                    //win
                    HaveWon = TRUE;
                    [self ShowInfo:@"You win!"];
                    return FALSE;
                }
            }
        }
        return TRUE;
    }
    if (!HaveSpace && ![self CanMerge]) {
        //lose
        [self ShowInfo:@"You lose!"];
    }
    return FALSE;
}

- (BOOL) CanMerge {
    for (int i=0;i<3;i++) {
        for (int j=0;j<4;j++) {
            if (num_array[i][j]==num_array[i+1][j]) {
                return TRUE;
            }
        }
    }
    for (int i=0;i<4;i++) {
        for (int j=0;j<3;j++) {
            if (num_array[i][j]==num_array[i][j+1]) {
                return TRUE;
            }
        }
    }
    return FALSE;
}
#pragma mark info
- (void) ShowInfo:(NSString *)info {
    Mask.hidden = NO;
    UIAlertView *alertview = [[UIAlertView alloc]initWithTitle: info message:@"Do you want to continue?" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
    [alertview show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            break;
        case 1:
            Mask.hidden = YES;
            if (HaveWon) {
                HaveWon = FALSE;
                score_target *= 2;
                [self Creat];
            }
            else {
                [self Restart];
            }
            break;
        default:
            break;
    }
}

#pragma mark restart

- (void) Restart {
    for (int i=0;i<4;i++) {
        for (int j=0;j<4;j++) {
            num_array[i][j]=-1;
        }
    }
    cur_score=0;
    ScoreBar.text=[NSString stringWithFormat:@"score : %lli",cur_score];
    score_target=2048;
    [self Creat];
}

@end
