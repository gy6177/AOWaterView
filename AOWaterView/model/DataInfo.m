//
//  DataInfo.m
//  AOWaterView
//
//  Created by akria.king on 13-4-10.
//  Copyright (c) 2013年 akria.king. All rights reserved.
//

#import "DataInfo.h"

@implementation DataInfo
-(id)initWithDictionary:(NSDictionary*)dictionary
{
    self = [super init];
    if (self) {
        //        self.thumbURL = [dictionary objectForKey:@"thumbURL"];
        //        self.width = [[dictionary objectForKey:@"width"]floatValue];
        //        self.height = [[dictionary objectForKey:@"height"]floatValue];
        self.url = [dictionary objectForKey:@"isrc"];
        self.width = [[dictionary objectForKey:@"iwd"]floatValue];
        self.height = [[dictionary objectForKey:@"iht"]floatValue];
        self.mess = [dictionary objectForKey:@"msg"];
    }
    return self;
}
-(NSString *)description
{
    return [NSString stringWithFormat:@"thumbURL:%@ width:%f height:%f labelMsg:%@",self.url,self.width,self.height,self.mess];
}

@end
