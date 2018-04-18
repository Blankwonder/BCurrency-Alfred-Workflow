//
//  NSURLSession+Currency.m
//  BCurrency
//
//  Created by Homway on 18/4/18.
//  Copyright © 2018 Yach. All rights reserved.
//

#import "NSURLSession+Currency.h"

@implementation NSURLSession (Currency)

+ (NSData *)sendSynchronousRequest:(NSURLRequest *)request
				 returningResponse:(NSURLResponse *__autoreleasing  _Nullable *)responsePtr
							 error:(NSError * _Nullable __autoreleasing *)errorPtr {
	dispatch_semaphore_t sem = dispatch_semaphore_create(0);
	__block NSData *result = nil;

	[[NSURLSession.sharedSession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {

		if (errorPtr != NULL) {
			*errorPtr = error;
		}

		if (responsePtr != NULL) {
			*responsePtr = response;
		}

		result = data;

		dispatch_semaphore_signal(sem);
	}] resume];

	dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);

	return result;
}

@end
