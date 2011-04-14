//
//  GraphTests.h
//  GraphTests
//
//  Created by aaron qian on 4/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "Graph.h"

@interface GraphTests : SenTestCase {
@private
    Graph* graph;
    GraphNode *ns, *nt, *n1, *n2, *n3;
    GraphEdge *nsn1, *nsn2, *nsn3, *n1nt, *n2nt, *n3nt;    
}

@end
