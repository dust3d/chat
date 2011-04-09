//
//  GrouponGoModel.h
//  Bellyflop
//
//  Created by Jonah Grant on 4/9/11.
//  Copyright 2011 Lightbank. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GrouponGoModel : NSObject {
	id delegate;
}
@property (nonatomic, retain) id delegate;

+ (GrouponGoModel *)sharedModel;

- (void)refreshChat;

@end
