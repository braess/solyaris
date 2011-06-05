//
//  Node.cpp
//  IMDG
//
//  Created by CNPP on 22.5.2011.
//  Copyright 2011 Beat Raess. All rights reserved.
//
#include "Node.h"
#include "cinder/gl/gl.h"



#pragma mark -
#pragma mark Object

/**
 * Creates a Node.
 */
Node::Node() {
    Node(0,0,10);
}
Node::Node(double x, double y, double r) {
    
    // fields
    perimeter = 300;
    damping = 0.5;
    strength = -1;
    ramp = 1.0;
    mvelocity = 10;
    speed = 45;
    
    // position
    mpos.set(x,y);
    pos.set(x,y);
    
    // radius / mass
    radius = r;
    mass = radius * radius * 0.0001f + 0.01f;
    
    // velocity
    velocity.set(0,0);
    
    // color
    bg = ColorA(1,1,1,0.9);

}



#pragma mark -
#pragma mark Sketch

/**
* Updates the node.
*/
void Node::update() {
    
    // limit
    velocity.limit(mvelocity);
    
    // threshold
    float thresh = 0.1;
    if (velocity.x < thresh && velocity.y < thresh) {
        velocity.x = 0;
        velocity.y = 0;
    }

    // damping
    velocity *= (1 - damping);
    
    // add vel to moving position
    mpos += velocity;
    
    // update position
    Vec2d dm = mpos - pos;
    pos += dm/speed;
    
}

/**
* Draws the node.
*/
void Node::draw() {
    
    // node
    glColor4f(bg.r,bg.g,bg.b,bg.a);
    gl::drawSolidCircle(pos, radius);

}



#pragma mark -
#pragma mark Business

/**
* Node attraction.
*/
void Node::attract(Node &n) {
    
    // distance
    double d = pos.distance(n.pos);
    if (d > 0 && d < perimeter) {
        
        // force
        double s = pow(d / perimeter, 1 / ramp);
        double m = selected ? mass*2 : mass;
        double force = s * 9 * strength * (1 / (s + 1) + ((s - 3) / 4)) / d;
        Vec2d df = (pos - n.pos) * (force/m);
        
        // velocity
        n.velocity += df;
    }
}


/**
 * Move.
 */
void Node::move(double dx, double dy) {
    mpos.x += dx;
    mpos.y += dy;
}
void Node::move(Vec2d d) {
    mpos += d;
}
void Node::moveTo(double x, double y) {
    mpos.x = x;
    mpos.y = y;
}
void Node::moveTo(Vec2d p) {
    mpos.set(p);
}