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
    moved = false;
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
    
    // randomize
    Rand::randomize();
    
    // attract
    this->attract();
    
    // repulse
    this->repulse();

    
    // nodes
    for (NodeIt node = nodes.begin(); node != nodes.end(); ++node) {
        
        // global movement
        if (moved) {
            (*node)->move(movement.x,movement.y);
        }
		
        // update
        (*node)->update();
    }
    
    /* nothing to update?
    // edges
    for (EdgeIt edge = edges.begin(); edge != edges.end(); ++edge) {
		
        // update
        (*edge)->update();
    }
     */
    

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
    
    // edges
    for (EdgeIt edge = edges.begin(); edge != edges.end(); ++edge) {
        
        // draw if visible
        if ((*edge)->visible) {
            (*edge)->draw();
        }
    }

}


/**
 * Resets the graph.
 */
void Graph::reset() {
    
    // reset maps
    nmap.clear();
    emap.clear();
    
    // clear
    for (EdgeIt edge = edges.begin(); edge != edges.end(); ++edge) {
        
        // null
        (*edge)->hide();
    }
    nodes.clear();
    //edges.clear(); // pointer being freed was not allocated
    
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
            
            // have a break
            break;
            
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
        moved = true;
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
    // graph
    else {
        moved = false;
        movement.set(0,0);
    }
    
    // reset
    touched.erase(tid);

}





#pragma mark -
#pragma mark Business


/**
 * Creates a node.
 */
NodePtr Graph::createNode(string nid, string type, double x, double y) {
    FLog();
    
    // node map
    nmap.insert(make_pair(nid, nodes.size()));
    
    // node
    if (type == "movie") {
        boost::shared_ptr<NodeMovie> node(new NodeMovie(nid,x,y));
        nodes.push_back(node);
        return node;
    }
    else if (type == "actor") {
        boost::shared_ptr<NodeActor> node(new NodeActor(nid,x,y));
        nodes.push_back(node);
        return node;
    }
    else if (type == "director") {
        boost::shared_ptr<NodeDirector> node(new NodeDirector(nid,x,y));
        nodes.push_back(node);
        return node;
    }
    else {
        boost::shared_ptr<Node> node(new Node(nid,x,y));
        nodes.push_back(node);
        return node;
    }

}

/**
 * Gets a node.
 */
NodePtr Graph::getNode(string nid) {
    FLog();
    
    // find the key
    map<string,int>::iterator it = nmap.find(nid);
    if(it != nmap.end()) {
        return NodePtr(nodes.at(it->second));
    }
    
    // nop
    return NodePtr();
}


/**
 * Creates an edge.
 */
EdgePtr Graph::createEdge(string eid, NodePtr n1, NodePtr n2) {
    FLog();
    
    // node
    boost::shared_ptr<Edge> edge(new Edge(n1,n2));
    edges.push_back(edge);
    
    // edge map
    emap.insert(make_pair(eid, edges.size()-1));
    
    // return
    return edge;
}

/**
 * Gets an edge.
 */
EdgePtr Graph::getEdge(string eid) {
    FLog();
    
    // find the key
    map<string,int>::iterator it = emap.find(eid);
    if(it != emap.end()) {
        return EdgePtr(edges.at(it->second));
    }
    
    // nop
    return EdgePtr();
}


/**
* Attraction.
*/
void Graph::attract() {
    
    // nodes
    for (NodeIt n1 = nodes.begin(); n1 != nodes.end(); ++n1) {
        
        // attract others
        for (NodeIt n2 = nodes.begin(); n2 != nodes.end(); ++n2) {
            if ((*n1)->active && (*n2)->active && (*n1) != (*n2)) {
                (*n1)->attract(*n2);
            }
        }
        
        // children
        if ((*n1)->active) {
            
            // brothers & sisters
            for (NodeIt c1 = (*n1)->children.begin(); c1 != (*n1)->children.end(); ++c1) {
                for (NodeIt c2 = (*n1)->children.begin(); c2 != (*n1)->children.end(); ++c2) {
                    if ((*c1)->visible && (*c2)->visible && (*c1) != (*c2)) {
                        (*c1)->attract(*c2);
                    }
                }
            }
            
        }
    }

}

/**
 * Repulsion.
 */
void Graph::repulse() {
    
    // edges
    for (EdgeIt edge = edges.begin(); edge != edges.end(); ++edge) {
        
        // active
        if ((*edge)->active) {
            (*edge)->repulse();
        }
    }

}



