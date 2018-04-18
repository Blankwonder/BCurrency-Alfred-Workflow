//
//  NSURLSession+Currency.h
//  BCurrency
//
//  Created by Homway on 18/4/18.
//  Copyright © 2018 Yach. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSURLSession (Currency)

+ (nullable NSData *)sendSynchronousRequest:(NSURLRequest *)request
						  returningResponse:(NSURLResponse * _Nullable * _Nullable)response
									  error:(NSError **)error;

@end

NS_ASSUME_NONNULL_END
