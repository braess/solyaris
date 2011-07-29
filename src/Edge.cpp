//
//  Edge.cpp
//  IMDG
//
//  Created by CNPP on 22.5.2011.
//  Copyright 2011 Beat Raess. All rights reserved.
//
#include "Edge.h"
#include "cinder/gl/gl.h"
#include "cinder/Text.h"
#include "cinder/CinderMath.h"


#pragma mark -
#pragma mark Object

/**
 * Creates an Edge.
 */
Edge::Edge() {
}
Edge::Edge(NodePtr n1, NodePtr n2) {
    
    // fields
    length = 400;
    stiffness = 0.6;
    damping = 0.9;
    
    // nodes
    node1 = n1;
    node2 = n2;
    
    // state
    active = false;
    visible = false;
    selected = false;
    
    // position
    pos.set(0,0);
    
    // color
    cstroke = Color(0.3,0.3,0.3);
    cstrokea = Color(0.6,0.6,0.6);
    cstrokes = Color(0.9,0.9,0.9);
    
    ctxt = Color(0.85,0.85,0.85);
    ctxts = Color(1,1,1);
    
    // font
    font = Font("Helvetica",12);
    loff.set(0,-12);
    textureLabel = gl::Texture(0,0);
}



#pragma mark -
#pragma mark Sketch

/**
 * Updates the edge.
 */
void Edge::update() {
    
    // selected
    selected = false;
    if (node1->isSelected() || node2->isSelected()) {
        selected = true;
    }
    
    // position
    pos = node1->pos + ((node2->pos - node1->pos) / 2.0);
}

/**
 * Draws the edge.
 */
void Edge::draw() {
    
    // unblend
    gl::enableAlphaBlending(true);
    
    // color
    active ? gl::color(cstrokea) : gl::color(cstroke);
    if (selected) {gl::color(cstrokes);}
    
    // line
    gl::drawLine(node1->pos, node2->pos);
    
    // label
    if (active || selected) {
        
        // color
        selected ? gl::color(ctxts) : gl::color(ctxt);
        
        // angle 
        float ar = cinder::math<float>::atan2(node2->pos.x - node1->pos.x, node2->pos.y - node1->pos.y);
        float ad = cinder::toDegrees(-ar);
        ad += (ad < 0) ? 90 : 270;
        
        // push, translate & rotate
        gl::pushMatrices();
        gl::translate(pos);
        gl::rotate(Vec3f(0, 0,ad));
        
        // draw
        gl::draw( textureLabel, loff);
        
        // and pop it goes
        gl::popMatrices();
    }
    

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
 * Shows/Hides the edge.
 */
void Edge::show() {
    GLog();
    
    // check if active
    if (node1->isActive() && node2->isActive() 
        || node1->isActive() && node2->isLoading()
        || node2->isActive() && node1->isLoading()) {
        
        // label
        font = Font("Helvetica-Bold",12);
        //loff.y = -15;
        this->renderLabel(label);
        
        // state
        active = true;
    }
    
    // state
    visible = true;
    
}
void Edge::hide() {
    GLog();
    
    // state
    visible = false;
    
}

/**
 * States.
 */
bool Edge::isActive() {
    return active;
}
bool Edge::isVisible() {
    return  active
            || (visible && ( (node1->isVisible() && ! node2->isLoading()) && (node2->isVisible() && ! node1->isLoading())) ) 
            || ( (node1->isLoading() && node2->isActive()) || (node2->isLoading() && node1->isActive()) ) 
            || ( (node1->isActive() || node1->isSelected()) & (node2->isActive() || node2->isSelected()));
}


/**
 * Renders the label.
 */
void Edge::renderLabel(string lbl) {
    GLog();
    
    
    // field
    label = lbl;
    
    // text
    TextLayout tlLabel;
	tlLabel.clear(ColorA(0, 0, 0, 0));
	tlLabel.setFont(font);
	tlLabel.setColor(ctxt);
	tlLabel.addCenteredLine(label);
	Surface8u rendered = tlLabel.render(true, true);
	textureLabel = gl::Texture(rendered);
    
    // offset
    loff.x = - textureLabel.getWidth() / 2.0;
    
}



#pragma mark -
#pragma mark Memory management

/*
 * Deallocates used memory.
 */
void Edge::dealloc() {
    GLog();
    
    // reset
    node1.reset();
    node2.reset();
}