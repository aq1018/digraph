//
//  GraphEdge.m
//  danmaku
//
//  Created by aaron qian on 4/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GraphEdge.h"
#import "GraphNode.h"

#define NSUINT_BIT (CHAR_BIT * sizeof(NSUInteger))
#define NSUINTROTATE(val, howmuch) ((((NSUInteger)val) << howmuch) | (((NSUInteger)val) >> (NSUINT_BIT - howmuch)))

@interface GraphEdge()
@property (nonatomic, readwrite, retain)  GraphNode *fromNode;
@property (nonatomic, readwrite, retain)  GraphNode *toNode;
@end

@implementation GraphEdge

@synthesize fromNode = fromNode_;
@synthesize toNode = toNode_;
@synthesize weight = weight_;


- (id)init {
    if( (self = [super init]) ) {
        self.fromNode = nil;
        self.toNode = nil;
        self.weight = 0;
    }
    
    return self;
}

- (id)initWithFromNode:(GraphNode*)fromNode toNode:(GraphNode*)toNode {
    if( (self = [super init]) ) {
        self.fromNode = fromNode;
        self.toNode = toNode;
        self.weight = 0;
    }
    
    return self;
}

- (id)initWithFromNode:(GraphNode*)fromNode toNode:(GraphNode*)toNode weight:(float)weight {
    if( (self = [super init]) ) {
        self.fromNode = fromNode;
        self.toNode = toNode;
        self.weight = weight;
    }
    
    return self;
}

-(void) dealloc
{
	[fromNode_ release];
    [toNode_ release];
	[super dealloc];
}

- (BOOL)isEqual:(id)other {
    if (other == self)
        return YES;
    if (!other || ![other isKindOfClass:[self class]])
        return NO;
    return [self isEqualToGraphEdge:other];
}

- (BOOL)isEqualToGraphEdge:(GraphEdge*)other {
    if (self == other)
        return YES;
    if (![[self fromNode] isEqualToGraphNode: [other fromNode]])
        return NO;
    if (![[self toNode] isEqualToGraphNode: [other toNode]])
        return NO;

    return YES;
}

- (NSUInteger)hash
{
    return NSUINTROTATE([fromNode_ hash], NSUINT_BIT / 2) ^ [toNode_ hash];
}

+ (id)edge {
    return [[[self alloc] init] autorelease];
}

+ (id)edgeWithFromNode:(GraphNode*)fromNode toNode:(GraphNode*)toNode {
    return [[[self alloc] initWithFromNode:fromNode toNode:toNode] autorelease];  
}

+ (id)edgeWithFromNode:(GraphNode*)fromNode toNode:(GraphNode*)toNode weight:(float)weight {
    return [[[self alloc] initWithFromNode:fromNode toNode:toNode weight:weight] autorelease];  
}

@end
