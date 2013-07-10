//
//  ABOverlaysTests.m
//  ABOverlaysTests
//
//  Created by Adam Barrett on 2013-07-10.
//  Copyright (c) 2013 Adam Barrett. All rights reserved.
//

#import "Kiwi.h"
#import "ABOverlay.h"

SPEC_BEGIN(ABOverlaysSpecs)

describe(@"ABOverlay", ^{
    
    describe(@"Initialization", ^{
        
        it(@"should be all initialized and such", ^{
            
            ABOverlay *overlay = [ABOverlay new];
            
            [[overlay shouldNot] beNil];
            
        });
        
    });
    
});

SPEC_END