//
//  Graph.h
//  IMDG
//
//  Created by CNPP on 22.5.2011.
//  Copyright 2011 Beat Raess. All rights reserved.
//
#include "cinder/app/TouchEvent.h"
#include "Node.h"
#include "Edge.h"
#include <vector>
#include <map>


// namespace
using namespace std;
using namespace ci;


/**
 * Graph.
 */
class Graph {
    
    // Fields
    int width;
    int height;
    int direction;
    
    // data
    vector<Node> nodes;
    vector<Edge> edges;
    
    // selected nodes
    map<int, int> selected;
    
    // movement
    Vec2d movement;
    
        
    // Methods
    public:
    Graph();
    Graph(int w, int h, int d);
    void resize(int w, int h, int d);
    
    // sketch
    void reset();
    void update();
    void draw();
    
    // touch
	void touchBegan(Vec2d tpos, int tid);
    void touchMoved(Vec2d tpos, Vec2d ppos, int tid);
    void touchEnded(Vec2d tpos, int tid);
    
    // business
    void test();
    void attract();
    void repulse();
    void addNode(Node n);
    void addEdge(Edge e);
    
    
};

