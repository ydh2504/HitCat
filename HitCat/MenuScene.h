//
//  MenuScene.h
//  ActionNinja
//
//  Created by mac on 11. 5. 27..
//  Copyright 2011 Mobile_x. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "SceneManager.h"
@interface MenuScene : CCScene {
	CCMenuItem *startItem;   // Game시작 버튼
	CCMenuItem *howToItem;
    CCMenuItem *creditItem;
    CCSprite *title;
	int oriented;
    CCArray *catArray;
}

@property (nonatomic, retain) CCMenuItem *startItem;
@property (nonatomic, retain) CCMenuItem *howToItem;
@property (nonatomic, retain) CCMenuItem *creditItem;


@end