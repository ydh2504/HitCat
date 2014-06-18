//
//  MenuScene.m
//  ActionNinja
//
//  Created by mac on 11. 5. 27..
//  Copyright 2011 Mobile_x. All rights reserved.
//

#import "MenuScene.h"
#import "GameLayer.h"
#import "HowToLayer.h"
#import "IntroLayer.h"
#import "CreditLayer.h"

@implementation MenuScene

@synthesize startItem, howToItem, creditItem;

-(id) init{
    if(self = [super init]){
        NSLog(@"메뉴");
        CGSize size = [[CCDirector sharedDirector] winSize];
        CCSprite *background = [CCSprite spriteWithFile:@"main-hd.png"];
        [background setPosition:ccp(size.width/2,size.height/2)];
        [self addChild:background z:0];
        CCSprite *backgroundTF = [CCSprite spriteWithFile:@"BOX2-hd.png"];
        [backgroundTF setPosition:ccp(size.width/2, size.height/2)];
//        [backgroundTF setScale:1.1f];
        [self addChild:backgroundTF z:1];
        //Start 버튼
        startItem = [CCMenuItemImage itemWithNormalImage:@"start.png"
                                                selectedImage:@"start.png"
                                                       target:self
                                                     selector:@selector(newGame:)];
        
        startItem.position = ccp(size.width/2, size.height/2);
        [startItem setAnchorPoint:ccp(0.5f, 0.5f)];
       
        id scaleUpDown1 = [CCCallFuncN actionWithTarget:self selector:@selector(moveUpDown:)];
		id action1 = [CCSequence actions:scaleUpDown1, nil];
		[startItem runAction:action1];

        //How TO 버튼
        howToItem = [CCMenuItemImage itemWithNormalImage:@"howto.png"
                                                 selectedImage:@"howto.png"
                                                        target:self
                                                      selector:@selector(howToCall:)];
        
        howToItem.position = ccp(size.width/4 - 20,size.height/2);
        [startItem setAnchorPoint:ccp(0.5f, 0.5f)];
   
        id scaleUpDown2 = [CCCallFuncN actionWithTarget:self selector:@selector(moveUpDown:)];
		id action2 = [CCSequence actions:scaleUpDown2, nil];
		[howToItem runAction:action2];
        
        
        creditItem = [CCMenuItemImage itemWithNormalImage:@"credit.png"
                                            selectedImage:@"credit.png"
                                                   target:self
                                                 selector:@selector(creditCall:)];
        
        creditItem.position = ccp(size.width*3/4 + 20,size.height/2);
        [creditItem setAnchorPoint:ccp(0.5f, 0.5f)];
        
        id scaleUpDown3 = [CCCallFuncN actionWithTarget:self selector:@selector(moveUpDown:)];
		id action3 = [CCSequence actions:scaleUpDown3, nil];
		[creditItem runAction:action3];
        
        CCMenu *menu = [CCMenu menuWithItems:self.howToItem, self.startItem, self.creditItem, nil];
        menu.position = CGPointZero;
        [self addChild:menu z:10];
        
        
        [self schedule:@selector(createCat1) interval:0.7];
        [self schedule:@selector(createCat2) interval:0.6];

        
    }
    return self;
}

-(void)newGame:(id) sender{
//    [SceneManager goGame];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[GameLayer node]]];
}
-(void)howToCall:(id)sender{
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[HowToLayer node]]];
}

-(void)creditCall:(id)sender{
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[CreditLayer node]]];
}

-(void)moveUpDown:(id)sender
{
	//NSLog(@"menuMove1 sender=%@", sender);
//	[self moveUpDown:sender withOffset:60];
    
    // CCMoveBy에 의해 상대적인 위치로 이동한다
	id moveUp = [CCMoveBy actionWithDuration:0.5 position:ccp(0 , 3)];
	id moveDown = [CCMoveBy actionWithDuration:0.5 position:ccp(0 , -3)];
	// 아래위 움직임을 반복한다
	id moveUpDown = [CCSequence actions:moveUp, moveDown, nil];
	
	[sender runAction:[CCRepeatForever actionWithAction:moveUpDown]];
}
-(CGPoint)getStartPosition {
    
    int starty=410;
    
    // arc4random()은 랜덤으로 정수인 값을 줍니다.
    // 'arc4random()%x' 이면 0에서 x-1 값중에 하나를 줍니다.
    // x 좌표가 -30 에서 509 중에 나오도록 랜덤을 설정합니다.
    // 새 sprite 크기를 계산해서 화면에 안 보이게 하기 위해 화면 x 범위 (0 ~ 480) 보다 더 크게 잡았습니다.
    int startx = 0 ;
    
    // 위에서 설정한 랜덤값이 0 보다 크고 480보다 작다면, 즉 x좌표가 화면에 보일 수 있는 위치 안이라면 안보이도록 y 좌표를 400으로 합니다.(화면의 y 범위는 0 ~ 320 입니다.)
    // x값이 화면에서 안 보이는 위치에 있다면 y 좌표를 100에서 299중에 랜덤인 값으로 설정합니다.
    
    startx = arc4random()%600 +220;
    
    
    // 랜덤으로 주어진 값을 반환합니다.
    return ccp(startx, starty);
}

- (void)createCat1 {
    
    // 파랑 새 이미지를 bird 라는 스프라이트로 지정합니다.
    CCSprite *cat = [CCSprite spriteWithFile:@"yellowCat0001.png"];
    
    // bird 스프라이트의 위치를 지정합니다.
    [cat setPosition:[self getStartPosition]];
    
    // bird 스프라이트를 생성하고  z 값은 5로 설정합니다.
    [self addChild:cat z:0];
    
    // birdArray 배열에 bird를 넣습니다.
    [catArray addObject:cat];
    
    //bird 객체의 retainCount를 1 감소시킵니다,
    //[bird release];
    
    //애니메이션 객체 flyAnimation을 생성합니다.
    CCAnimation *catAnimation = [CCAnimation animation];
    
    //이미지를 반복문으로 불러와서(blue_fly0001.png부터 blue_fly0016.png까지) 프레임에 넣고 이것을 다시 애니메이션 객체 flyAnimation에 넣습니다.
    for(NSInteger i = 1; i < 5; i++) {
        [catAnimation addSpriteFrameWithFilename:[NSString       stringWithFormat:@"yellowCat%04d.png",i]];
    }
    [catAnimation setDelayPerUnit:0.1f];
    
    //flyAnimation의 프레임당 시간 간격을 0.08초로 지정합니다.
    
    
    //flyAnimation을 Animate하는 flyAnimate를 정의합니다.
    id catAnimate = [CCAnimate actionWithAnimation:catAnimation];
    
    // flyAnimate를 무한 반복하는 액션 actionFlyrepeat를 만듭니다.
    id actionCatrepeat = [CCRepeatForever actionWithAction:catAnimate];
    
    //flyAnimate를 한 번 실행하는 액션 actionFlyrepeat를 만듭니다.
    //id actionFlyrepeat = [CCSequence actions:flyAnimate, nil];
    //bird 스프라이트가 actionFlyrepeat 액션을 수행하도록 합니다.
    [cat runAction:actionCatrepeat];
    
    // 2초간 (300,160)으로 직선 이동하는 액션 actionMoveTo를 만듭니다.
    id actionMoveTo    = [CCMoveBy actionWithDuration:5.0f position:ccp(-528,-440)];
    
    id moveComplete = [CCCallFuncN actionWithTarget:self selector:@selector(removeBird:)];
    
    id seqAction = [CCSequence actions:actionMoveTo,moveComplete, nil];
    //bird 스프라이트가 actionMoveTo 액션을 수행하도록 합니다.
    [cat runAction:seqAction];
}

- (void)createCat2 {
    
    // 파랑 새 이미지를 bird 라는 스프라이트로 지정합니다.
    CCSprite *cat = [CCSprite spriteWithFile:@"blackCat0001.png"];
    
    // bird 스프라이트의 위치를 지정합니다.
    [cat setPosition:[self getStartPosition]];
    
    // bird 스프라이트를 생성하고  z 값은 5로 설정합니다.
    [self addChild:cat z:0];
    
    // birdArray 배열에 bird를 넣습니다.
    [catArray addObject:cat];
    
    //bird 객체의 retainCount를 1 감소시킵니다,
    //[bird release];
    
    //애니메이션 객체 flyAnimation을 생성합니다.
    CCAnimation *catAnimation = [CCAnimation animation];
    
    //이미지를 반복문으로 불러와서(blue_fly0001.png부터 blue_fly0016.png까지) 프레임에 넣고 이것을 다시 애니메이션 객체 flyAnimation에 넣습니다.
    for(NSInteger i = 1; i < 5; i++) {
        [catAnimation addSpriteFrameWithFilename:[NSString       stringWithFormat:@"blackCat%04d.png",i]];
    }
    [catAnimation setDelayPerUnit:0.1f];
    
    //flyAnimation의 프레임당 시간 간격을 0.08초로 지정합니다.
    
    
    //flyAnimation을 Animate하는 flyAnimate를 정의합니다.
    id catAnimate = [CCAnimate actionWithAnimation:catAnimation];
    
    // flyAnimate를 무한 반복하는 액션 actionFlyrepeat를 만듭니다.
    id actionCatrepeat = [CCRepeatForever actionWithAction:catAnimate];
    
    //flyAnimate를 한 번 실행하는 액션 actionFlyrepeat를 만듭니다.
    //id actionFlyrepeat = [CCSequence actions:flyAnimate, nil];
    //bird 스프라이트가 actionFlyrepeat 액션을 수행하도록 합니다.
    [cat runAction:actionCatrepeat];
    
    // 2초간 (300,160)으로 직선 이동하는 액션 actionMoveTo를 만듭니다.
    id actionMoveTo    = [CCMoveBy actionWithDuration:5.0f position:ccp(-528,-440)];
    
    id moveComplete = [CCCallFuncN actionWithTarget:self selector:@selector(removeBird:)];
    
    id seqAction = [CCSequence actions:actionMoveTo,moveComplete, nil];
    //bird 스프라이트가 actionMoveTo 액션을 수행하도록 합니다.
    [cat runAction:seqAction];
}

-(void)removeBird:(CCSprite*)bird {
    [bird stopAllActions];
    // removeChild란 addChild 한 객체를 지워주는 매개변수입니다.
    // bird를 제거함으로서 메모리가 불필요하게 쌓이는 것을 막습니다.
    //    [lblScore setString:[NSString stringWithFormat:@"%d",gameScore]];
    [self removeChild:bird cleanup:YES];
    
}

- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}
@end

