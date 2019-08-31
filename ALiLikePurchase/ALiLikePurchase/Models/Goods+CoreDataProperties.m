//
//  Goods+CoreDataProperties.m
//  
//
//  Created by mac on 2019/8/23.
//
//

#import "Goods+CoreDataProperties.h"

@implementation Goods (CoreDataProperties)

+ (NSFetchRequest<Goods *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Goods"];
}

@dynamic goodsId;
@dynamic goodsData;

@end
