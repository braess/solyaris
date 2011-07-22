//
//  Node.cpp
//  IMDG
//
//  Created by CNPP on 22.5.2011.
//  Copyright 2011 Beat Raess. All rights reserved.
//
#include "Node.h"
#include "cinder/Text.h"
#include "cinder/Rand.h"




#pragma mark -
#pragma mark Object

/**
 * Creates a Node.
 */
Node::Node() {
    Node("nid",0,0);
}
Node::Node(string idn, double x, double y) {
    
    // node
    nid = idn;
    label = "Node";
    
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
    
    // state
    selected = false;
    active = false;
    grow = false;
    load = false;
    visible = true;
    
    // radius / mass
    core = 10;
    radius = 30;
    mass = radius * radius * 0.0001f + 0.01f;
    
    // velocity
    velocity.set(0,0);
    
    // color
    cbg = Color(1,1,1);
    ctxt = Color(1,1,1);
    
    // alpha
    acore = 0.9;
    ascore = 1.0;
    aglow = 0.3;
    asglow = 0.6;

    
    // font
    font = Font("Helvetica",12);
    
    
    TextLayout lbl;
	lbl.clear(ColorA(0, 0, 0, 0));
	lbl.setFont(font);
	lbl.setColor(ctxt);
	lbl.addCenteredLine("Text Texture");
	Surface8u rendered = lbl.render(true, true);
	mTexture = gl::Texture(rendered);

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
    Vec2d ppos = pos;
    pos += dm/speed;
    
    // travelling without moving
    bool moving = false;
    float mf = 0;
    if (dm.length() > 5) {
        moving = true;
        
        // randomize
        Rand::randomize();
        mf = dm.length() * 0.01;
    }
    
    // children
    for(vector<Node>::iterator child = children.begin(); child != children.end(); child++ ){
        // draw
        if (child->visible) {
            
            // follow
            child->translate(pos - ppos);
            
            // randomize
            if (moving) {
                child->move(Rand::randFloat(-1,1)*mf,Rand::randFloat(-1,1)*mf);
            }
            
            
            // update
            child->update();
        }
	}

    
    // grow
    if (grow) {
        
        // radius
        radius += 1;
        if (radius >= growradius) {
            
            // stop & activate
            grow = false;
            this->activate();
        }
    }
    
}

/**
* Draws the node.
*/
void Node::drawNode() {
    
    // glow
    glColor4f(cbg.r,cbg.g,cbg.b,(selected ? asglow : aglow));
    gl::drawSolidCircle(pos, radius);
    
    // core
    glColor4f(cbg.r,cbg.g,cbg.b,(selected ? ascore : acore));
    gl::drawSolidCircle(pos, core);
    

   
}
void Node::drawLabel() {
    

    // active
    if (active) {
        
        // children
        for(vector<Node>::iterator child = children.begin(); child != children.end(); child++ ){
            // draw
            if (child->visible) {
                child->drawNode();
                child->drawLabel();
            }
        }
        
    }
    
    // label
    glColor4f(ctxt.r,ctxt.g,ctxt.b,(selected ? ascore : acore));
	gl::draw( mTexture, Vec2d(pos.x,pos.y+radius));

}



#pragma mark -
#pragma mark Touch


#pragma mark -
#pragma mark Touch

/**
 * Touch.
 */
void Node::touchBegan(Vec2d tpos, int tid) {
    GLog();
    
    // selected
    selected = true;
    
    
    // children
    for(int i = 0; i < children.size(); i++){
        
        // reference
        Node &c = children.at(i);
        
        // visible
        if (c.visible) {
            
            // distance
            float dc = c.pos.distance(tpos);
            if (dc < c.radius) {
                
                // touched
                FLog("tid = %d, child = %d",tid,i);
                touched[tid] = i+1; // offset to avoid null comparison
                
            }
        }
        
    }
    
}
void Node::touchMoved(Vec2d tpos, Vec2d ppos, int tid){
    GLog();
    
    // child
    if (touched[tid]) {
        FLog("tid = %d, child = %d",tid,touched[tid]-1);
        children[touched[tid]-1].moveTo(tpos);
    }
    // node
    else {
        this->moveTo(tpos);
    }
    
}
void Node::touchEnded(Vec2d tpos, int tid){
    GLog();
    
    // child
    if (touched[tid]) {
        
        // state
        FLog("tid = %d, child = %d",tid,touched[tid]-1);
    }
    else {
        selected = false;
    }
    
    // reset
    touched.erase(tid);

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

/**
 * Translate.
 */
void Node::translate(Vec2d d) {
    pos += d;
    mpos += d;
}


/**
* Adds a child.
*/
void Node::addChild(Node n) {
    GLog();
    
    // push
    children.push_back(n);
}

/**
 * Activates the node.
 */
void Node::activate() {
    
    // children
    Rand::randomize();
    for(vector<Node>::iterator child = children.begin(); child != children.end(); child++ ){
        // position
        child->moveTo(pos.x+Rand::randFloat(-radius,radius),pos.y+Rand::randFloat(-radius,radius));
        
    }
    
    // maxx
    mass = radius * radius * 0.0001f + 0.01f;
    
    // active
    active = true;
}
