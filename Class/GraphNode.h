//
//  GraphNode.h
//  danmaku
//
//  Created by aaron qian on 4/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GraphEdge;

@interface GraphNode : NSObject<NSCopying> {
    id value_;
    NSMutableSet *edgesIn_;
    NSMutableSet *edgesOut_;
}

@property (nonatomic, readonly, retain) NSSet *edgesIn;
@property (nonatomic, readonly, retain) NSSet *edgesOut;
@property (nonatomic, readonly, retain) id    value;
@property (nonatomic, readwrite, retain) NSDictionary *options;

- (id)init;
- (id)initWithValue:(id)value;
- (id)initWithOptions:(NSDictionary*)options;
- (id)initWithOptions:(NSDictionary*)options andValue:(id)value;
- (BOOL)isEqualToGraphNode:(GraphNode*)otherNode;

- (NSUInteger)inDegree;
- (NSUInteger)outDegree;
- (BOOL)isSource;
- (BOOL)isSink;
- (NSMutableSet*)outNodes;
- (NSMutableSet*)inNodes;
- (GraphEdge*)edgeConnectedTo:(GraphNode*)toNode;
- (GraphEdge*)edgeConnectedFrom:(GraphNode*)fromNode;

+ (id)node;
+ (id)nodeWithValue:(id)value;
+ (id)nodeWithOptions:(NSDictionary*)options;
+ (id)nodeWithOptions:(NSDictionary*)options andValue:(id)value;

@end
