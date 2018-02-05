//
//  NewsFeed+CoreDataProperties.h
//  ObjCVKReader
//
//  Created by Сергей Веселовский on 05/02/2018.
//  Copyright © 2018 Сергей Веселовский. All rights reserved.
//
//

#import "NewsFeed+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface NewsFeed (CoreDataProperties)

+ (NSFetchRequest<NewsFeed *> *)fetchRequest;

@property (nullable, nonatomic, retain) NSData *feed;

@end

NS_ASSUME_NONNULL_END
