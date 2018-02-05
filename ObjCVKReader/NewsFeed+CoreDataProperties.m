//
//  NewsFeed+CoreDataProperties.m
//  ObjCVKReader
//
//  Created by Сергей Веселовский on 05/02/2018.
//  Copyright © 2018 Сергей Веселовский. All rights reserved.
//
//

#import "NewsFeed+CoreDataProperties.h"

@implementation NewsFeed (CoreDataProperties)

+ (NSFetchRequest<NewsFeed *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"NewsFeed"];
}

@dynamic feed;

@end
