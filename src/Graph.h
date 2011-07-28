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
    
    // Tap
    NodePtr doubleTap(Vec2d tpos, int tid);
    
    // Business
    void attract();
    void repulse();
    NodePtr createNode(string nid, string type, double x, double y);
    NodePtr getNode(string nid);
    EdgePtr createEdge(string eid, NodePtr n1, NodePtr n2);
    EdgePtr getEdge(string eid);
    
    
    // private
    private:
    
    // state
    bool clear;
    
    // size
    int width;
    int height;
    int direction;
    
    // data
    NodeVectorPtr nodes;
    EdgeVectorPtr edges;
    
    // maps
    map<string,int>nmap;
    map<string,int>emap;
    
    // movement
    Vec2d movement;
    
    // touched nodes
    map<int, NodePtr> touched;
    
    
};

