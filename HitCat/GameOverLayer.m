
//
//  GameOverLayer.m
//  Fly Hunter
//
//  Created by JungTong 51310 on 2014. 5. 2..
//  Copyright 2014년 __MyCompanyName__. All rights reserved.
//

#import "GameOverLayer.h"


@implementation GameOverLayer


-(id) init{
    appDelegate = (AppController *)[[UIApplication sharedApplication] delegate];
    if(self = [super init]){
        CGSize size = [[CCDirector sharedDirector] winSize];
        CCSprite *background = [CCSprite spriteWithFile:@"gameover-hd.png"];
        [background setPosition:ccp(size.width/2,size.height/2)];
        [self addChild:background z:0];
        
        gameOverImage = [CCMenuItemImage itemFromNormalImage:@"gameover_score.png"
                                               selectedImage:@"gameover_score.png"
                                                      target:self
                                                    selector:@selector(gameOverDone:)];
        //gameOverImage.position = ccp(size.width/2 ,size.height/2);
        //id Cakeaction1 = [CCMoveTo actionWithDuration:5 position:ccp(size.width * 2/3, size.height/3)];
        //id Cakeaction2 = [CCMoveTo actionWithDuration:5 position:ccp(size.width/3, size.height/3)];
        //id CheckactionSeq = [CCSequence actions: Cakeaction1, Cakeaction2, nil];
        //id CheckationRepeat = [CCRepeatForever actionWithAction:CheckactionSeq];
        //[cakeImage runAction:CheckationRepeat];
        //[self addChild:gameOverImage z:1];
        
        
        //        [[CCTextureCache sharedTextureCache] removeUnusedTextures];
        
        //	 againImage = [CCMenuItemImage itemFromNormalImage:@"btn_white.png"
        //	 selectedImage:@"btn_white.png"
        //	 target:self
        //	   selector:@selector(gameOverDone:)];
        CCMenu *menu = [CCMenu menuWithItems: gameOverImage, nil];
        menu.position = CGPointMake(size.width/2, size.height/2);
        [self addChild:menu z:10];
        
        
        
        
        NSInteger gameScore = appDelegate.gameScore;
        //int gameScore = [GameLayer ]
        
        //NSLog(@"score-gameover %d", game.score);
        
        //화면에 점수를 표시할 레이블 생성 score변수의 값을 받아와서 화면에 나타냅니다.
        CCLabelTTF *LblScore = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d",gameScore] fontName:@"Marker Felt" fontSize:15];
        
        //레이블의 색상을 지정합니다.
        LblScore.color = ccc3(255,255,255);
        
        //레이블의 anchorPoint와 위치를 지정합니다.
        LblScore.anchorPoint = ccp(0, 0.5f);
        LblScore.position =ccp(size.width/2+22,size.height/2-35);
        
        //레이블을 GameLayer의 자식으로 추가하고 z 값을 9로 지정합니다.
        [self addChild:LblScore z:15];
        
    }
    return self;
}

- (void)gameOverDone:(id)sender {
    [[CCTextureCache sharedTextureCache] removeUnusedTextures];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene:[MenuScene node] withColor:ccWHITE]];
}



@end