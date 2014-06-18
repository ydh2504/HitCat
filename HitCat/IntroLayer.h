//
//  IntroLayer.h
//  HitCat
//
//  Created by apple01 on 2014. 5. 22..
//  Copyright __MyCompanyName__ 2014년. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"

// HelloWorldLayer
@interface IntroLayer : CCLayer
{
    CCMenuItem *gameOverImage;
}

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

@end
