//
//  CompleteGroup.m
//
//  Created by Maciej Gad on 04.09.2015.
//  Copyright (c) 2015 All in Mobile. All rights reserved.
//

#import "CompleteGroup.h"

@interface DispatchGroup : NSObject
@property (strong, nonatomic) dispatch_group_t dispatchGroup;
@property (assign, atomic) NSInteger enters;
- (void)leave;
- (void)enter;
- (void)complete:(CompleteBlock)block;

@end

@interface Group ()

@property (weak, nonatomic) DispatchGroup *dispatchGroup;

- (instancetype)initWithDispatchGroup:(DispatchGroup *)dispatchGroup;

@end


@interface CompleteGroup ()

@property (strong, nonatomic) NSMutableArray *blocks;
@property (strong, nonatomic) DispatchGroup *dispatchGroup;
@property (strong, nonatomic) Group *group;
@property (assign, nonatomic, getter=isRunning) BOOL running;
@property (assign, nonatomic, getter=isFinished) BOOL finished;
@end

@implementation CompleteGroup

- (void)addBlock:(TaskBlock)block {
    if (!block) {
        return;
    }
    [self.blocks addObject:block];
}

- (void)run {
    self.running = YES;
    self.finished = NO;
    if (self.serialQueue) {
        [self serialRun];
    } else {
        [self parallelRun];
    }
}

- (void)parallelRun {
    self.dispatchGroup = [DispatchGroup new];
    self.group = [[Group alloc] initWithDispatchGroup:self.dispatchGroup];
    [self.group enter];
    for (TaskBlock block in [self.blocks copy]) {
        [self.group enter];
        block(self.group);
    }
    [self.group leave];
    __weak __typeof(self) weakSelf = self;
    [self.group complete:^{
        [weakSelf finsh];
    }];
}

- (void)serialRun {
    self.dispatchGroup = [DispatchGroup new];
    self.group = [[Group alloc] initWithDispatchGroup:self.dispatchGroup];
    [self.group enter];
    TaskBlock firstBlock = [self.blocks firstObject];
    if (!firstBlock) {
        [self.group leave];
        [self finsh];
        return;
    }
    [self.blocks removeObject:firstBlock];
    firstBlock(self.group);
    __weak __typeof(self) weakSelf = self;
    [self.group complete:^{
        [weakSelf serialRun];
    }];
}

- (void)finsh {
    self.running = NO;
    if (self.complete) {
        self.complete();
    }
    self.finished = YES;
}

- (NSMutableArray *)blocks {
    if (_blocks) {
        return _blocks;
    }
    _blocks = [NSMutableArray new];
    return _blocks;
}

@end

@implementation Group

- (instancetype)initWithDispatchGroup:(DispatchGroup *)dispatchGroup {
    self = [super init];
    if (self) {
        self.dispatchGroup = dispatchGroup;
    }
    return self;
}

- (void)enter {
    [self.dispatchGroup enter];
}

- (void)leave {
    if (self.dispatchGroup == nil) {
        NSLog(@"BUM CRASH!!!");
    }
    [self.dispatchGroup leave];
}

- (void)complete:(CompleteBlock)block {
    [self.dispatchGroup complete:block];
}

@end


@implementation DispatchGroup

- (instancetype)init {
    self = [super init];
    if (self) {
        self.dispatchGroup = dispatch_group_create();
    }
    return self;
}

- (void)enter {
    @synchronized(self) {
        self.enters ++;
        NSLog(@"enter group %@", self.dispatchGroup);
        dispatch_group_enter(self.dispatchGroup);
    }
}


- (void)leave {
    @synchronized(self) {
        if (self.enters > 0) {
            self.enters --;
            NSLog(@"leave group %@", self.dispatchGroup);
            dispatch_group_leave(self.dispatchGroup);
        } else {
            NSLog(@"BUM CRASH!!!");
        }
    }
}

- (void)complete:(CompleteBlock)block {
    dispatch_group_notify(self.dispatchGroup, dispatch_get_main_queue(), ^{
        if (block) {
            block();
        }
    });
}

@end
