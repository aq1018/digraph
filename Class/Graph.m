//
//  Graph.m
//  danmaku
//
//  Created by aaron qian on 4/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Graph.h"


@interface GraphNode()
@property (nonatomic, readwrite, retain) id    value;
- (GraphEdge*)linkToNode:(GraphNode*)node;
- (GraphEdge*)linkToNode:(GraphNode*)node weight:(float)weight;
- (GraphEdge*)linkToNode:(GraphNode*)node withOptions:(NSDictionary*)options;
- (GraphEdge*)linkFromNode:(GraphNode*)node;
- (GraphEdge*)linkFromNode:(GraphNode*)node weight:(float)weight;
- (GraphEdge*)linkFromNode:(GraphNode*)node withOptions:(NSDictionary*)options;
- (void)unlinkToNode:(GraphNode*)node;
- (void)unlinkFromNode:(GraphNode*)node;
@end

// private methods for Graph
@interface Graph()
@property (nonatomic, readwrite, retain) NSSet *nodes;
- (GraphNode*)smallest_distance:(NSMutableDictionary*)dist nodes:(NSMutableSet*)nodes;
@end


@implementation Graph

@synthesize nodes = nodes_;

- (id)init
{
    if ( (self = [super init]) ) {
        self.nodes = [NSMutableSet set];
    }
    
    return self;
}

- (void)dealloc
{

}

// Using Dijkstra's algorithm to find shortest path
// See http://en.wikipedia.org/wiki/Dijkstra%27s_algorithm
- (NSArray*)shortestPath:(GraphNode*)source to:(GraphNode*)target {
    if (![nodes_ containsObject:source] || ![nodes_ containsObject:target]) {
        return [NSArray array];
    }
    
    NSUInteger size = [nodes_ count];
    NSMutableDictionary* dist = [NSMutableDictionary dictionaryWithCapacity:size];
    NSMutableDictionary* prev = [NSMutableDictionary dictionaryWithCapacity:size];
    NSMutableSet* remaining = [nodes_ mutableCopy];
    
    for(GraphNode* node in [nodes_ objectEnumerator])
        [dist setObject:[NSNumber numberWithFloat:INFINITY] forKey:node];
    
    [dist setObject:[NSNumber numberWithFloat:0.0f] forKey:source];
    
    while ([remaining count] != 0) {
        // find the node in remaining with the smallest distance
        GraphNode* minNode = [self smallest_distance:dist nodes:remaining];
        float min = [[dist objectForKey: minNode] floatValue];

        if (min == INFINITY)
            break;
        
        // we found it!
        if( [minNode isEqual: target] ) {
            NSMutableArray* path = [NSMutableArray array];
            GraphNode* temp = target;
            while ([prev objectForKey:temp]) {
                [path addObject:temp];
                temp = [prev objectForKey:temp];
            }
            return [ NSMutableArray arrayWithArray:
                    [ [path reverseObjectEnumerator ] allObjects]];
        }
        
        // didn't find it yet, keep going
        
        [remaining removeObject:minNode];

        // find neighbors that have not been removed yet
        NSMutableSet* neighbors = [minNode outNodes];
        [neighbors intersectSet:remaining];
        
        // loop through each neighbor to find min dist
        for (GraphNode* neighbor in [neighbors objectEnumerator]) {
            NSLog(@"Looping neighbor %@", (NSString*)[neighbor value]);
            float alt = [[dist objectForKey: minNode] floatValue];
            alt += [[minNode edgeConnectedTo: neighbor] weight];
            
            if( alt < [[dist objectForKey: neighbor] floatValue] ) {
                [dist setObject:[NSNumber numberWithFloat:alt] forKey:neighbor];
                [prev setObject:minNode forKey:neighbor];
            }
        }
    }
    
    return [NSArray array];
}

- (GraphNode*)smallest_distance:(NSMutableDictionary*)dist nodes:(NSMutableSet*)nodes {
    NSEnumerator *e = [nodes objectEnumerator];
    GraphNode* node;
    GraphNode* minNode = [e nextObject];
    NSNumber *min = [dist objectForKey: minNode];
    
    while ( (node = [e nextObject]) ) {
        NSNumber *temp = [dist objectForKey:node];
        
        if ( [temp floatValue] < [min floatValue] ) {
            min = temp;
            minNode = node;
        }
    }
    
    return minNode;
}

- (BOOL)hasNode:(GraphNode*)node {
    return !![nodes_ member:node];
}

// addNode first checks to see if we already have a node
// that is equal to the passed in node.
// If an equal node already exists, the existing node is returned
// Otherwise, the new node is added to the set and then returned.
- (GraphNode*)addNode:(GraphNode*)node {
    GraphNode* existing = [nodes_ member:node];
    if (!existing) {
       [nodes_ addObject:node]; 
        existing = node;
    }
    return existing;
}

- (GraphEdge*)addEdgeFromNode:(GraphNode*)fromNode toNode:(GraphNode*)toNode {
    fromNode = [self addNode:fromNode];
    toNode   = [self addNode:toNode];
    return [fromNode linkToNode:toNode];
}

- (GraphEdge*)addEdgeFromNode:(GraphNode*)fromNode toNode:(GraphNode*)toNode withWeight:(float)weight {
    fromNode = [self addNode:fromNode];
    toNode   = [self addNode:toNode];
    return [fromNode linkToNode:toNode weight:weight];    
}

- (GraphEdge*)addEdgeFromNode:(GraphNode*)fromNode toNode:(GraphNode*)toNode withOptions:(NSDictionary*)options {
    fromNode = [self addNode:fromNode];
    toNode   = [self addNode:toNode];
    return [fromNode linkToNode:toNode withOptions: options];
}

- (void)removeNode:(GraphNode*)node {
    [nodes_ removeObject:node];
}

- (void)removeEdge:(GraphEdge*)edge {
    [[edge fromNode] unlinkToNode:[edge toNode]];
}

+ (Graph*)graph {
    return [[self alloc] init];
}

@end
