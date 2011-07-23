//
//  Edge.cpp
//  IMDG
//
//  Created by CNPP on 22.5.2011.
//  Copyright 2011 Beat Raess. All rights reserved.
//
#include "Edge.h"
#include "cinder/gl/gl.h"


#pragma mark -
#pragma mark Object

/**
 * Creates an Edge.
 */
Edge::Edge() {
}
Edge::Edge(NodePtr n1, NodePtr n2) {
    
    // fields
    length = 200;
    stiffness = 0.6;
    damping = 0.9;
    
    // nodes
    node1 = n1;
    node2 = n2;
    
    // state
    selected = false;
    active = false;
    visible = false;
    
    // color
    cstroke = ColorA(1,1,1);
}



#pragma mark -
#pragma mark Sketch

/**
 * Updates the edge.
 */
void Edge::update() {

}

/**
 * Draws the edge.
 */
void Edge::draw() {
    
    // node
    gl::color(cstroke);
    gl::drawLine(node1->pos, node2->pos);


}


#pragma mark -
#pragma mark Business

/**
 * Edge repulsion.
 */
void Edge::repulse() {
    
    // distance vector
    Vec2d diff = node2->pos - node1->pos;
    
    // normalize / length
    diff.safeNormalize();
    diff *= length;
    
    // target
    Vec2d target = node1->pos + diff;

    // force
    Vec2d force = target - node2->pos;
    force *= 0.5;
    force *= stiffness;
    force *= (1 - damping);
    
    // update velocity
    node1->velocity += force*-1;
    node2->velocity += force;

}

/**
 * Activates the edge.
 */
void Edge::activate() {
    FLog();
    
    // state
    active = true;
    
}


/**
 * Shows/Hides the edge.
 */
void Edge::show() {
    FLog();
    
    // show it
    if (! visible) {
        
        // check if active
        if (node1->active && node2->active) {
            this->activate();
        }
    }
    
    // state
    visible = true;
    
}
void Edge::hide() {
    GLog();
    
    // state
    visible = false;
    
}