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
    for (NodeIt node = nodes.begin(); node != nodes.end(); ++node) {
        
        // global movement
        (*node)->move(movement.x,movement.y);
		
        // update
        (*node)->update();
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
    for (NodeIt node = nodes.begin(); node != nodes.end(); ++node) {
        
        // draw if visible
        if ((*node)->visible) {
            (*node)->draw();
        }
    }
    
    /*
    
    // edges
    for(vector<Edge>::iterator e = edges.begin(); e != edges.end(); ++e ){
		e->draw();
	}
     */
    
    

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
#pragma mark Touch

/**
 * Touch.
 */
void Graph::touchBegan(Vec2d tpos, int tid) {
    GLog();
    
    // nodes
    for (NodeIt node = nodes.begin(); node != nodes.end(); ++node) {
        
        // distance
		float d = (*node)->pos.distance(tpos);
        if (d < (*node)->core) {
            
            // touched
            FLog("tid = %d, node = ",tid);
            touched[tid] = NodePtr(*node); 
            
            // state
            touched[tid]->touched();
            
        }
    }

    
}
void Graph::touchMoved(Vec2d tpos, Vec2d ppos, int tid){
    GLog();
    

    // node
    if (touched[tid]) {
        GLog("tid = %d, node = ",tid);
        touched[tid]->moveTo(tpos);
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
    if (touched[tid]) {
        
        // state
        FLog("tid = %d, node = ",tid);
        touched[tid]->untouched();
    }
    else {
        movement.set(0,0);
    }
    
    // reset
    touched.erase(tid);

}





#pragma mark -
#pragma mark Business


/**
 * Adds a node.
 */
NodePtr Graph::createNode(string nid, double x, double y) {
    FLog();
    

    
    // node
    boost::shared_ptr<Node> node(new Node(nid,x,y));
    nodes.push_back(node);
    
    // node map
    nmap.insert(make_pair(nid, nodes.size()-1));
    
    // return
    return node;

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
NodePtr Graph::getNode(string nid) {
    FLog();
    
    // map
    map<string,int>::iterator it = nmap.find(nid);
    if(it != nmap.end()) {
        return NodePtr(nodes.at(it->second));
    }

    
    // nop
    return NodePtr();

}



/**
* Attraction.
*/
void Graph::attract() {
    

    // nodes
    for (NodeIt n1 = nodes.begin(); n1 != nodes.end(); ++n1) {
        
        // others
        for (NodeIt n2 = nodes.begin(); n2 != nodes.end(); ++n2) {
            
            // attract
            if ((*n1)->active && (*n2)->active && (*n1) != (*n2)) {
                (*n1)->attract(*n2);
            }
        }
    }


}

/**
 * Repulsion.
 */
void Graph::repulse() {
    /*
    // edges
    for(vector<Edge>::iterator e = edges.begin(); e != edges.end(); e++ ){
        
        // edge
		e->repulse();
	}
     */
}



