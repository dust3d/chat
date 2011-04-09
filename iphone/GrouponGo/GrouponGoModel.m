//
//  GrouponGoModel.m
//  Bellyflop
//
//  Created by Jonah Grant on 4/9/11.
//  Copyright 2011 Lightbank. All rights reserved.
//

#import "GrouponGoModel.h"

@interface GrouponGoModel (PrivateMethods)

- (BOOL) isValidDelegateForSelector:(SEL)selector;

@end

@implementation GrouponGoModel

@synthesize delegate;

static GrouponGoModel *sharedModel = nil;

+ (GrouponGoModel *) sharedModel {
    @synchronized(self) {
        if (sharedModel == nil) {
            sharedModel = [[GrouponGoModel alloc] init];
        }
    }
    return sharedModel;
}

- (id)init {
    self = [super init];
    if (self) {

    }
    return self;
}

- (void)refreshChat
{
	GrouponGoRequest *request = [GrouponGoRequest requestWithURL:@"http://go.groupon.com/"]
}

@end
