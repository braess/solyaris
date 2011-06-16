//
//  Graph.cpp
//  IMDG
//
//  Created by CNPP on 22.5.2011.
//  Copyright 2011 Beat Raess. All rights reserved.
//

#include "Graph.h"
#include "cinder/Rand.h"


#pragma mark -
#pragma mark Object

/**
 * Creates a graph.
 */
Graph::Graph() {
    Graph(0,0,0);
}
Graph::Graph(int w, int h, int d) {
    
    // fields
    width = w;
    height = h;
    direction = d;
    
    
    // movement
    movement.set(0,0);
}


/**
 * Resize.
 */
void Graph::resize(int w, int h, int d) {
    FLog();
    
    // size
    width = w;
    height = h;
    
    // direction
    direction = d;
    
}



#pragma mark -
#pragma mark Sketch

/**
 * Resets the graph.
 */
void Graph::reset() {
    
    // clear
    edges.clear();
    nodes.clear();
}

/**
 * Updates the graph.
 */
void Graph::update() {
    
    // attract
    this->attract();
    
    // repulse
    this->repulse();
    
    // nodes
    for(vector<Node>::iterator n = nodes.begin(); n != nodes.end(); ++n ){
        n->move(movement.x,movement.y);
		n->update();
	}
    
    // edges
    for(vector<Edge>::iterator e = edges.begin(); e != edges.end(); ++e ){
		e->update();
	}
}

/**
 * Draws the graph.
 */
void Graph::draw() {
    
    // nodes
    for(vector<Node>::iterator n = nodes.begin(); n != nodes.end(); ++n ){
		n->draw();
	}
    
    // edges
    for(vector<Edge>::iterator e = edges.begin(); e != edges.end(); ++e ){
		e->draw();
	}
}



#pragma mark -
#pragma mark Touch

/**
 * Touch.
 */
void Graph::touchBegan(Vec2d tpos, int tid) {
    FLog();
    
    // nodes
    for(int i = 0; i < nodes.size(); i++){
        Node n = nodes.at(i);
        
        // distance
		float d = n.pos.distance(tpos);
        if (d < n.radius) {
            
            // selected
            selected[tid] = i+1; // offset to avoid null comparison
            FLog("tid = %d, node = %d",tid,selected[tid]-1);
            
            // state
            n.selected = true;
        }
	}


    
}
void Graph::touchMoved(Vec2d tpos, Vec2d ppos, int tid){
    GLog();
    
    // node
    if (selected[tid]) {
        GLog("tid = %d, node = %d",tid,selected[tid]-1);
        nodes[selected[tid]-1].moveTo(tpos);
    }
    // graph
    else {
        
        // movement
        movement.set(tpos-ppos);
    }

}
void Graph::touchEnded(Vec2d tpos, int tid){
    FLog();
    
    
    // node
    if (selected[tid]) {
        
        // state
        nodes.at(selected[tid]-1).selected = false;
        FLog("tid = %d, node = %d",tid,selected[tid]-1);
    }
    else {
        movement.set(0,0);
    }
    
    // reset
    selected.erase(tid);
}




#pragma mark -
#pragma mark Business




/**
 * Adds a node.
 */
void Graph::addNode(Node n) {
    DLog();

   // push
   nodes.push_back(n);
}

/**
 * Adds an edge.
 */
void Graph::addEdge(Edge e) {
    DLog();
    
    // push
	edges.push_back(e);
}

/**
* Attraction.
*/
void Graph::attract() {
    
    // nodes
    for(vector<Node>::iterator n1 = nodes.begin(); n1 != nodes.end(); n1++ ){
        
        // attract
		for(vector<Node>::iterator n2 = nodes.begin(); n2 != nodes.end(); n2++ ){
            if (n1 != n2) {
                n1->attract(*n2);
            }
		}
	}
}

/**
 * Repulsion.
 */
void Graph::repulse() {
    
    // edges
    for(vector<Edge>::iterator e = edges.begin(); e != edges.end(); e++ ){
        
        // edge
		e->repulse();
	}
}


/**
 * Test setup.
 */
void Graph::test() {
    DLog();
    
    // nodes
    Rand::randomize();
    for (int i = 0; i < 5; i++) {
        this->addNode(Node( Rand::randFloat(0,788),  Rand::randFloat(0,1024), 30));
    }
    
    // edges
    for (int i1 = 0; i1 < 5; i1++) {
        int i2 =  Rand::randFloat(0, 5);
        if (i1 != i2) {
            
            // node
            Node &n1 = nodes.at(i1);
            Node &n2 = nodes.at(i2);
            
            // edge
            this->addEdge(Edge(n1,n2));
            
        }
	}
    
}
