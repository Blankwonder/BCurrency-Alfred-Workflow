//
//  main.m
//  BCurrency
//
//  Created by Blankwonder on 2018/4/17.
//  Copyright © 2018 Yach. All rights reserved.
//

#import <Foundation/Foundation.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:argc];
        for (int i = 0; i < argc; i++) {
            [array addObject:[NSString stringWithUTF8String:argv[i]]];
        }
        
        NSString *execName = [(NSString *)array.firstObject lastPathComponent];
        NSArray *comps = [execName componentsSeparatedByString:@"-"];
        
        NSString *from = comps.count == 2 ? comps.lastObject : @"USD";
        NSString *to = @"CNY";

        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://free.currencyconverterapi.com/api/v5/convert?q=%@_%@&compact=ultra", from, to]];
        
        NSString *cachedResultPath = [NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"BCurrency_%@%@", from, to]];
        
        NSData *data;
        if ([[NSFileManager defaultManager] fileExistsAtPath:cachedResultPath] && -[[NSFileManager defaultManager] attributesOfItemAtPath:cachedResultPath error:nil].fileModificationDate.timeIntervalSinceNow < 12 * 3600) {
            data = [NSData dataWithContentsOfFile:cachedResultPath];
        } else {
            NSURLResponse *response = nil;
            NSError *error = nil;
            data = [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:url] returningResponse:&response error:&error];
            
            if (data.length == 0 || error) {
                NSDictionary *output = @{@"items": @[@{@"title": [NSString stringWithFormat:@"Error: %@", error.localizedDescription]}]};
                
                NSData *outputData = [NSJSONSerialization dataWithJSONObject:output options:0 error:nil];
                
                NSFileHandle *sout = [NSFileHandle fileHandleWithStandardOutput];
                [sout writeData:outputData];
                return 0;
            }
            
            [data writeToFile:cachedResultPath atomically:YES];
        }
        
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        double value = [(NSString *)json.allValues.firstObject doubleValue];
        double source = [array.lastObject doubleValue];
        
//        {"items": [
//                   {
//                       "uid": "desktop",
//                       "type": "file",
//                       "title": "Desktop",
//                       "subtitle": "~/Desktop",
//                       "arg": "~/Desktop",
//                       "autocomplete": "Desktop",
//                       "icon": {
//                           "type": "fileicon",
//                           "path": "~/Desktop"
//                       }
//                   }
//                   ]}
        
        NSString *result = [@(value * source) stringValue];

        NSDictionary *output = @{@"items": @[@{@"subtitle": [NSString stringWithFormat:@"%@/%@ %g", from, to, value],
                                               @"title": result,
                                               @"arg": result
                                               }]};
        
        NSData *outputData = [NSJSONSerialization dataWithJSONObject:output options:0 error:nil];
        
        NSFileHandle *sout = [NSFileHandle fileHandleWithStandardOutput];
        [sout writeData:outputData];
    }
    return 0;
}
