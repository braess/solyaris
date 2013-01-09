//
//  ImageToDataTransformer.m
//  Solyaris
//
//  Created by Beat Raess on 13.09.12.
//  Copyright (c) 2012 Beat Raess. All rights reserved.
//

#import "ImageToDataTransformer.h"


/**
 * Image Transformer.
 */
@implementation ImageToDataTransformer

+ (BOOL)allowsReverseTransformation {
	return YES;
}

+ (Class)transformedValueClass {
	return [NSData class];
}

- (id)transformedValue:(id)value {
	return UIImagePNGRepresentation(value);
}

- (id)reverseTransformedValue:(id)value {
	return [[[UIImage alloc] initWithData:value] autorelease];
}

@end
