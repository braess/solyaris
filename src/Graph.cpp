//
//  Graph.cpp
//  IMDG
//
//  Created by CNPP on 22.5.2011.
//  Copyright 2011 Beat Raess. All rights reserved.
//

#include "Graph.h"
#include "cinder/gl/gl.h"
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
    
    // blend
    gl::enableAlphaBlending();
    
    // nodes
    for(vector<Node>::iterator n = nodes.begin(); n != nodes.end(); ++n ){
		n->drawNode();
	}
    
    // unblend
    gl::enableAlphaBlending(true);

    
    // edges
    for(vector<Edge>::iterator e = edges.begin(); e != edges.end(); ++e ){
		e->draw();
	}
    
    // label
    for(vector<Node>::iterator n = nodes.begin(); n != nodes.end(); ++n ){
		n->drawLabel();
	}
}


/**
 * Resets the graph.
 */
void Graph::reset() {
    
    // clear
    edges.clear();
    nodes.clear();
}







#pragma mark -
#pragma mark Business


/**
 * Adds a node.
 */
void Graph::addNode(Node n) {
    FLog();

   // push
   nodes.push_back(n);
}

/**
 * Adds an edge.
 */
void Graph::addEdge(Edge e) {
    FLog();
    
    // push
	edges.push_back(e);
}

/**
 * Gets a node.
 */
Node* Graph::getNode(string nid) {
    FLog();
    
    // search
    for(vector<Node>::iterator n = nodes.begin(); n != nodes.end(); n++ ){
        if (nid.compare(n->nid) == 0) {
            return &(*n);
        }
    }
    return NULL;
}

/**
 * Activates a node.
 */
void Graph::activateNode(Node *n) {
    FLog();
    
    // grow
    n->grow = true;
    
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
        this->addNode(Node("nid", Rand::randFloat(0,788),  Rand::randFloat(0,1024)));
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




#pragma mark -
#pragma mark Touch

/**
 * Touch.
 */
void Graph::touchBegan(Vec2d tpos, int tid) {
    GLog();
    
    // nodes
    for(int i = 0; i < nodes.size(); i++){
        
        // reference
        Node &n = nodes.at(i);
        
        // distance
		float d = n.pos.distance(tpos);
        if (d < n.radius) {
            
            // selected
            selected[tid] = i+1; // offset to avoid null comparison
            FLog("tid = %d, node = %d",tid,selected[tid]-1);
            
            // state
            n.selected = true;
            
            // core
            if (d > n.core) {
                for(int j = 0; j < n.children.size(); j++){
                    
                    // reference
                    Node &c = n.children.at(j);
                    
                    // distance
                    float dc = c.pos.distance(tpos);
                    if (dc < c.radius) {
                        FLog("child = %d",j);
                    }
                }
            }
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
    GLog();
    
    
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
