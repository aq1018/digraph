//
//  GraphTests.m
//  GraphTests
//
//  Created by aaron qian on 4/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GraphTests.h"


@implementation GraphTests

- (void)setUp
{
    [super setUp];
    graph = [Graph graph];
    
    ns = [GraphNode nodeWithValue:@"ns"];
    nt = [GraphNode nodeWithValue:@"nt"];
    n1 = [GraphNode nodeWithValue:@"n1"];
    n2 = [GraphNode nodeWithValue:@"n2"];
    n3 = [GraphNode nodeWithValue:@"n3"];
    
    nsn1 = [graph addEdgeFromNode:ns toNode:n1 withWeight:7.0f];
    nsn2 = [graph addEdgeFromNode:ns toNode:n2 withWeight:9.0f];
    nsn3 = [graph addEdgeFromNode:ns toNode:n3 withWeight:14.0f];
    n1nt = [graph addEdgeFromNode:n1 toNode:nt withWeight:10.0f];
    n2nt = [graph addEdgeFromNode:n2 toNode:nt withWeight:9.0f];
    n3nt = [graph addEdgeFromNode:n3 toNode:nt withWeight:1.0f];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testAddGraphNode
{
    [graph addNode:[GraphNode nodeWithValue:@"testNode"]];
}

- (void)testAddGraphEdge
{
    STAssertNotNil([graph addEdgeFromNode:ns toNode:nt withWeight:7.0f],
                   @"Failure");
}

- (void)testGraphNodeEquality
{
    GraphNode* node1 = [GraphNode nodeWithValue:@"ns"];
    GraphNode* node2 = [GraphNode nodeWithValue:@"ns"];
    
    STAssertEqualObjects(node1, node2, @"Failure");
}

- (void)testGraphEdgeEquality
{
    NSString* val = @"ns";
    GraphNode* node1 = [GraphNode nodeWithValue:val];
    GraphNode* node2 = [GraphNode nodeWithValue:val];
    GraphEdge* e1 = [GraphEdge edgeWithFromNode:node1 toNode:node2];
    GraphEdge* e2 = [GraphEdge edgeWithFromNode:node1 toNode:node2];
    
    STAssertEqualObjects(e1, e2, @"Failure");
}

- (void)testGraphNodeInDegree
{
    STAssertEquals([nt inDegree], (NSUInteger)3, @"Failure");
}

- (void)testGraphNodeOutDegree
{
    STAssertEquals([ns outDegree], (NSUInteger)3, @"Failure");
}

- (void)testGraphNodeOutNodes
{
    NSMutableSet* expected = [NSMutableSet set];
    [expected addObject:n1];
    [expected addObject:n2];
    [expected addObject:n3];
    
    STAssertEqualObjects([ns outNodes], expected, @"FAILURE");
}

- (void)testGraphNodeInNodes
{
    NSMutableSet* expected = [NSMutableSet set];
    [expected addObject:n1];
    [expected addObject:n2];
    [expected addObject:n3];
    
    STAssertEqualObjects([nt inNodes], expected, @"FAILURE");
}

- (void)testGraphNodeEdgeConnectedTo
{
    STAssertEquals([n1 edgeConnectedTo:nt], n1nt, @"FAILURE");
    STAssertNil([n1 edgeConnectedTo:n2], @"FAILURE");
}

- (void)testGraphNodeEdgeConnectedFrom
{
    STAssertEquals([n1 edgeConnectedFrom:ns], nsn1, @"FAILURE");
    STAssertNil([n1 edgeConnectedFrom:n2], @"FAILURE");
}

- (void)testGraphNodeIsSource
{
    
    STAssertTrue([ns isSource], @"FAILURE");
    STAssertFalse([n1 isSource], @"FAILURE");
    STAssertFalse([nt isSource], @"FAILURE");
}

- (void)testGraphNodeIsSink
{
    
    STAssertTrue([nt isSink], @"FAILURE");
    STAssertFalse([n1 isSink], @"FAILURE");
    STAssertFalse([ns isSink], @"FAILURE");
}

- (void)testSortestPath
{
    NSArray* path = [graph shortestPath:ns to:nt];
    NSMutableArray* expected = [NSMutableArray array];
    [expected addObject:n3];
    [expected addObject:nt];
    
    STAssertEqualObjects(path, expected, @"FAILURE");
}

- (void)testSortestPathNoResult
{
    NSArray* path = [graph shortestPath:n1 to:n2];
    NSMutableArray* expected = [NSMutableArray array];
    
    STAssertEqualObjects(path, expected, @"FAILURE");
}

@end
