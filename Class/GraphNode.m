//
//  GraphNode.m
//  danmaku
//
//  Created by aaron qian on 4/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GraphNode.h"
#import "GraphEdge.h"

@interface GraphNode()
@property (nonatomic, readwrite, retain) NSSet *edgesIn;
@property (nonatomic, readwrite, retain) NSSet *edgesOut;
@property (nonatomic, readwrite, retain) id    value;
- (GraphEdge*)linkToNode:(GraphNode*)node;
- (GraphEdge*)linkToNode:(GraphNode*)node weight:(float)weight;
- (GraphEdge*)linkFromNode:(GraphNode*)node;
- (GraphEdge*)linkFromNode:(GraphNode*)node weight:(float)weight;
- (void)unlinkToNode:(GraphNode*)node;
- (void)unlinkFromNode:(GraphNode*)node;
@end

@implementation GraphNode

@synthesize edgesIn = edgesIn_;
@synthesize edgesOut = edgesOut_;
@synthesize value = value_;

- (id)init {
    if( (self=[super init]) ) {
		self.value = nil;
		self.edgesIn  = [NSMutableSet set];
        self.edgesOut = [NSMutableSet set];
	}
    return self; 
}

- (id)initWithValue:(id)value {
    if( (self=[super init]) ) {
		self.value = value;
        self.edgesIn  = [NSMutableSet set];
        self.edgesOut = [NSMutableSet set];
	}
    return self; 
}

- (void)dealloc
{
    // need to remove all relavent edges in neighboring nodes
    for (GraphNode* toNode in [[self outNodes] objectEnumerator]) {
        [toNode->edgesIn_ minusSet:edgesOut_];
    }
    
    for (GraphNode* fromNode in [[self inNodes] objectEnumerator]) {
        [fromNode->edgesOut_ minusSet:edgesIn_];
    }
    
	[value_ release];
    [edgesIn_ release];
    [edgesOut_ release];
	[super dealloc];
}

- (BOOL)isEqual:(id)other {
    if (other == self)
        return YES;
    if (!other || ![other isKindOfClass:[self class]])
        return NO;
    return [self isEqualToGraphNode:other];
}

- (BOOL)isEqualToGraphNode:(GraphNode*)other {
    if (self == other)
        return YES;
    return [[self value] isEqual: [other value]];
}

- (NSUInteger)hash
{
    return [ value_ hash];
}

-(GraphNode*) copyWithZone: (NSZone*) zone {
    return [[GraphNode allocWithZone: zone] initWithValue:value_];
}

- (GraphEdge*)linkToNode:(GraphNode*)node {
    GraphEdge* edge = [GraphEdge edgeWithFromNode:self toNode:node];
    [edgesOut_          addObject:edge];
    [node->edgesIn_     addObject:edge];
    return edge;
}

- (GraphEdge*)linkToNode:(GraphNode*)node weight:(float)weight {
    GraphEdge* edge = [GraphEdge edgeWithFromNode:self toNode:node weight:weight];
    [edgesOut_          addObject:edge];
    [node->edgesIn_     addObject:edge];
    return edge;
}

- (GraphEdge*)linkFromNode:(GraphNode*)node {
    GraphEdge* edge = [GraphEdge edgeWithFromNode:node toNode:self];
    [edgesIn_           addObject:edge];
    [node->edgesOut_    addObject:edge];
    return edge;
}

- (GraphEdge*)linkFromNode:(GraphNode*)node weight:(float)weight {
    GraphEdge* edge = [GraphEdge edgeWithFromNode:node toNode:self weight:weight];
    [edgesIn_           addObject:edge];
    [node->edgesOut_    addObject:edge];
    return edge;
}

- (void)unlinkToNode:(GraphNode*)node {
    GraphEdge* edge = [self edgeConnectedTo: node];
    GraphNode* from = [edge   fromNode];
    GraphNode* to   = [edge   toNode];
    [from->edgesOut_ removeObject:edge];
    [to->edgesIn_    removeObject:edge];
}

- (void)unlinkFromNode:(GraphNode*)node {
    GraphEdge* edge = [self edgeConnectedFrom: node];
    GraphNode* from = [edge   fromNode];
    GraphNode* to   = [edge   toNode];
    [from->edgesOut_ removeObject:edge];
    [to->edgesIn_    removeObject:edge];    
}

- (NSUInteger)inDegree {
    return [[self edgesIn] count];
}

- (NSUInteger)outDegree {
    return [[self edgesOut] count];    
}

- (BOOL)isSource {
    return [self inDegree] == 0;
}

- (BOOL)isSink {
    return [self outDegree] == 0;
}

- (NSMutableSet*)outNodes {
    NSMutableSet* set = [NSMutableSet setWithCapacity:[edgesOut_ count]];
    for( GraphEdge* edge in [edgesOut_ objectEnumerator] ) {
        [set addObject: [edge toNode]];
    }
    return set;
}

- (NSMutableSet*)inNodes {
    NSMutableSet* set = [NSMutableSet setWithCapacity:[edgesIn_ count]];
    for( GraphEdge* edge in [edgesIn_ objectEnumerator] ) {
        [set addObject: [edge fromNode]];
    }
    return set;    
}

- (GraphEdge*)edgeConnectedTo:(GraphNode*)toNode {
    for(GraphEdge* edge in [ edgesOut_ objectEnumerator]) {
        if( [edge toNode] == toNode )
            return edge;
    }
    return nil;
}

- (GraphEdge*)edgeConnectedFrom:(GraphNode*)fromNode {
    for(GraphEdge* edge in [ edgesIn_ objectEnumerator]) {
        if( [edge fromNode] == fromNode )
            return edge;
    }
    return nil;    
}

+ (id)node {
    return [[[GraphNode alloc] init] autorelease];
}

+ (id)nodeWithValue:(id)value {
    return [[[GraphNode alloc] initWithValue:value] autorelease];
}

@end
