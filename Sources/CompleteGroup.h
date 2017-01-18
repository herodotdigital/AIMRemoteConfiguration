//
//  CompleteGroup.h
//
//  Created by Maciej Gad on 04.09.2015.
//  Copyright (c) 2015 All in Mobile. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 complete block called when group finishes
*/
typedef void(^CompleteBlock)(void);

/**
 wrapper for `dispatch_group_t`
*/
@interface Group : NSObject
/**
 leave a group, equivalent of `dispatch_group_leave`
*/
- (void)leave;
/**
 enter a group, equivalent of `dispatch_group_enter`
*/
- (void)enter;
/**
 called when group is complete 
 @param block block 
*/
- (void)complete:(CompleteBlock)block;
@end

/**
 Block for task, should call `[group leave]` at end of work
*/

typedef void(^TaskBlock)(Group* group);

/**
 Group of tasks (blocks) added via `addBlock` witch have common complete block called after last one is finished. Could be run parallel or serial 
*/
@interface CompleteGroup : NSObject

/**
 block called when all task are finished
*/
@property (copy, nonatomic) CompleteBlock complete;
/**
 set if group should be treated as serial queue (with only one block running at time)
*/
@property (assign, nonatomic) BOOL serialQueue;

/**
 is group running
*/
@property (readonly, nonatomic, getter=isRunning) BOOL running;
/**
has group finished already
*/
@property (readonly, nonatomic, getter=isFinished) BOOL finished;

/**
 add task as a block
 @param block block 
*/
- (void)addBlock:(TaskBlock)block;
/**
 run all tasks
*/
- (void)run;

@end

