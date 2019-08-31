//
//  Goods+CoreDataProperties.h
//  
//
//  Created by mac on 2019/8/23.
//
//

#import "Goods+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Goods (CoreDataProperties)

+ (NSFetchRequest<Goods *> *)fetchRequest;

@property (nonatomic) int64_t goodsId;
@property (nullable, nonatomic, retain) NSData *goodsData;

@end

NS_ASSUME_NONNULL_END
