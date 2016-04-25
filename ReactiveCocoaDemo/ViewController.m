//
//  ViewController.m
//  ReactiveCocoaDemo
//
//  Created by lh on 15/8/26.
//  Copyright (c) 2015年 lhwhu. All rights reserved.
//

#import "ViewController.h"
#import <ReactiveCocoa.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    RACSubject *letters = [@"A B C D" componentsSeparatedByString:@" "].rac_sequence.signal;
    
    [letters subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];

    
    //For a cold signal, side effects will be performed once per subscription:
    __block unsigned subscriptions = 0;
    
    RACSignal *loggingSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        subscriptions++;
        [subscriber sendCompleted];
        return nil;
    }];
    
    loggingSignal = [loggingSignal doCompleted:^{
        NSLog(@"about to complete subscription %u", subscriptions);
    }];
    
    [loggingSignal subscribeCompleted:^{
        NSLog(@"subscription %u", subscriptions);
    }];
    
    [loggingSignal subscribeCompleted:^{
        NSLog(@"subscription %u", subscriptions);
    }];
    
//    RACSequence *mapLetters = [@"1 2 3" componentsSeparatedByString:@" "].rac_sequence;
//    //Mapping
//    RACSequence *mapped = [mapLetters map:^id(NSString *value) {
//        return [value stringByAppendingString:@"!"];
//    }];
//    
//    [mapped.signal subscribeNext:^(id x) {
//        NSLog(@"mapped %@", x);
//    }];
//    
//    RACSequence *numbers = [@"1 2 3 4 5 6" componentsSeparatedByString:@" "].rac_sequence;
//    RACSequence *filter = [numbers filter:^BOOL(NSString *value) {
//        return (value.intValue % 2) == 0;
//    }];
//    
//    [filter.signal subscribeNext:^(id x) {
//        NSLog(@"filter %@", x);
//    }];
    
//    RACSequence *letters1 = [@"A B C D E F G H I" componentsSeparatedByString:@" "].rac_sequence;
//    RACSequence *numbers1 = [@"1 2 3 4 5 6 7 8 9" componentsSeparatedByString:@" "].rac_sequence;
//    
//    RACSequence *concatenated = [letters1 concat:numbers1];
//
//    [concatenated.signal subscribeNext:^(id x) {
//        NSLog(@"concatenated %@", x);
//    }];
    
//    RACSequence *letters2 = [@"a b c" componentsSeparatedByString:@" "].rac_sequence;
//    RACSequence *numbers2 = [@"1 2 3" componentsSeparatedByString:@" "].rac_sequence;
//    
//    RACSequence *falttened = [@[letters2, numbers2].rac_sequence flatten];
//    [falttened.signal subscribeNext:^(id x) {
//        NSLog(@"falttened %@", x);
//    }];
    
//    RACSubject *letters3 = [RACSubject subject];
//    RACSubject *numbers3 = [RACSubject subject];
//    RACSignal *signalOfSignals = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
//        [subscriber sendNext:letters3];
//        [subscriber sendNext:numbers3];
//        [subscriber sendCompleted];
//        return nil;
//    }];
//    
//    RACSignal *flattend = [signalOfSignals flatten];
//    
//    [flattend subscribeNext:^(id x) {
//        NSLog(@"flattend %@",x);
//    }];
//    
//    [letters3 sendNext:@"1"];
//    [numbers3 sendNext:@"ss"];
    
    
//    RACSignal *letters4 = [@"A B C D E F G H I" componentsSeparatedByString:@" "].rac_sequence.signal;
//    
//    // The new signal only contains: 1 2 3 4 5 6 7 8 9
//    //
//    // But when subscribed to, it also outputs: A B C D E F G H I
//    RACSignal *sequenced4 = [[letters4
//                             doNext:^(NSString *letter) {
//                                 NSLog(@"%@", letter);
//                             }]
//                            then:^{
//                                return [@"1 2 3 4 5 6 7 8 9" componentsSeparatedByString:@" "].rac_sequence.signal;
//                            }];
//    
//    [sequenced4 subscribeNext:^(id x) {
//        NSLog(@"%@", x);
//    }];
//    
    
    RACSubject *letters5 = [RACSubject subject];
    RACSubject *numbers5 = [RACSubject subject];
    RACSignal *combined = [RACSignal
                           combineLatest:@[ letters5, numbers5 ]
                           reduce:^(NSString *letter, NSString *number) {
                               return [letter stringByAppendingString:number];
                           }];
    
    // Outputs: B1 B2 C2 C3
    [combined subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
    
//    
//    Note that the combined signal will only send its first value when all of the inputs have sent at least one. In the example above, @"A" was never forwarded because numbers had not sent a value yet.
//    

    [letters5 sendNext:@"A"];
    [letters5 sendNext:@"B"];
    [numbers5 sendNext:@"1"];
    [numbers5 sendNext:@"2"];
    [letters5 sendNext:@"C"];
    [numbers5 sendNext:@"3"];
    
    
    
    
    RACSubject *letters6 = [RACSubject subject];
    RACSubject *numbers6 = [RACSubject subject];
    RACSubject *signalOfSignals6 = [RACSubject subject];
    
    RACSignal *switched = [signalOfSignals6 switchToLatest];
    
    // Outputs: A B 1 D
    [switched subscribeNext:^(NSString *x) {
        NSLog(@"%@", x);
    }];
    
    [signalOfSignals6 sendNext:letters6];
    [letters6 sendNext:@"A"];
    [letters6 sendNext:@"B"];
    
    [signalOfSignals6 sendNext:numbers6];
    [letters6 sendNext:@"C"];
    [numbers6 sendNext:@"1"];
    
    [signalOfSignals6 sendNext:letters6];
    [numbers6 sendNext:@"2"];
    [letters6 sendNext:@"D"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
