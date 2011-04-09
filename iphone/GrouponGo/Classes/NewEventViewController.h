//
//  NewEventViewController.h
//  libPusher
//
//  Created by Luke Redpath on 23/04/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"

@interface NewEventViewController : UIViewController {
  UITextView *textView;
  id<GrouponGoDelegate> delegate;
}
@property (nonatomic, retain) IBOutlet UITextView *textView;
@property (nonatomic, assign) id<GrouponGoDelegate> delegate;

- (IBAction)sendEvent:(id)sender;
@end
