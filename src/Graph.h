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
        
    // public
    public:
    
    // Graph
    Graph();
    Graph(int w, int h, int d);
    void resize(int w, int h, int d);
    
    // Sketch
    void reset();
    void update();
    void draw();
    
    // Touch
	void touchBegan(Vec2d tpos, int tid);
    void touchMoved(Vec2d tpos, Vec2d ppos, int tid);
    void touchEnded(Vec2d tpos, int tid);
    
    // Business
    void test();
    void attract();
    void repulse();
    void addNode(Node n);
    void addEdge(Edge e);
    Node* getNode(string nid);
    void activateNode(Node *n);
    
    
    // private
    private:
    
    // size
    int width;
    int height;
    int direction;
    
    // data
    vector<Node> nodes;
    vector<Edge> edges;
    
    // movement
    Vec2d movement;
    
    // touched nodes
    map<int, int> touched;
    
    
};

