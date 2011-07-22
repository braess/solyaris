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
    GLog();
    
    
    // node
    nid = idn;
    
    
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
    loading = false;
    visible = true;
    
    // radius / mass
    core = 20;
    radius = 30;
    mass = radius * radius * 0.0001f + 0.01f;
    
    // velocity
    velocity.set(0,0);
    
    // color
    cbg = Color(1,1,1);
    ctxt = Color(1,1,1);
    
    // alpha
    acore = 0.85;
    ascore = 1.0;
    aglow = 0.3;
    asglow = 0.45;

    
    // font
    font = Font("Helvetica",15);
    textureLabel = gl::Texture(0,0);
    offsetLabel = 0;

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
    

    
    // selected
    if (selected) {
        
        // randomize
        Rand::randomize();
        float mf = dm.length() * 0.01;
        
        // children
        for (NodeIt child = children.begin(); child != children.end(); ++child) {
            
            // move visible children
            if ((*child)->visible) {
                
                // follow
                (*child)->translate(pos - ppos);
                
                // randomize
                (*child)->move(Rand::randFloat(-1,1)*mf,Rand::randFloat(-1,1)*mf);
                
            }
            
        }
    }

    // grow
    if (grow) {
        
        // radius
        radius += 1;
        if (radius >= growradius) {
            
            // stop & activate
            this->activate();
        }
    }

    
    
}




/**
* Draws the node.
*/
void Node::draw() {
    
    
    // blend
    gl::enableAlphaBlending();
    

    // glow
    glColor4f(cbg.r,cbg.g,cbg.b,(selected ? asglow : aglow));
    gl::drawSolidCircle(pos, radius);
    
    // core
    glColor4f(cbg.r,cbg.g,cbg.b,(selected ? ascore : acore));
    gl::drawSolidCircle(pos, core);

    
    // unblend
    gl::enableAlphaBlending(true);
    
    // label
    gl::color(ctxt);
	gl::draw( textureLabel, Vec2d(pos.x+offsetLabel,pos.y+radius+5));

}




#pragma mark -
#pragma mark Business

/**
* Node attraction.
*/
void Node::attract(NodePtr node) {
    

    // distance
    double d = pos.distance((*node).pos);
    if (d > 0 && d < perimeter) {
        
        // force
        double s = pow(d / perimeter, 1 / ramp);
        double m = selected ? mass*2 : mass;
        double force = s * 9 * strength * (1 / (s + 1) + ((s - 3) / 4)) / d;
        Vec2d df = (pos - (*node).pos) * (force/m);
        
        // velocity
        (*node).velocity += df;
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
void Node::addChild(NodePtr child) {
    FLog();
    
    // push
    children.push_back(child);
}

/**
 * Activates the node.
 */
void Node::activate() {
    FLog();
    
    // state
    grow = false;
    
    // children
    Rand::randomize();
    for (NodeIt child = children.begin(); child != children.end(); ++child) {
        
        // position
        (*child)->moveTo(pos.x+Rand::randFloat(-radius,radius),pos.y+Rand::randFloat(-radius,radius));
        
    }

    
    // mass
    mass = radius * radius * 0.0001f + 0.01f;
    
    // active
    active = true;
      
}

/**
 * Load noad.
 */
void Node::load() {
    FLog();
    
    // state
    loading = true;

    
}
void Node::loaded() {
    FLog();
    
    // state
    loading = false;
    

    // field
    growradius = min((int)children.size()*2,80);
    growradius = 80;
    grow = true;
  
}


/**
 * Shows/Hides the node.
 */
void Node::show() {
    FLog();
    
    // state
    visible = true;
    
}
void Node::hide() {
    GLog();
    
    // state
    visible = false;
    
}


/**
 * Makes the node a child.
 */
void Node::makechild() {
    GLog();
    

    // child
    label = "Child";
    core = 10;
    radius = 10;
    
    // font
    font = Font("Helvetica",12);

}

/**
 * Touched.
 */
void Node::touched() {
    FLog();
    
    // state
    selected = true;
    
}
void Node::untouched() {
    GLog();
    
    // state
    selected = false;
    
}


/**
 * Renders the label.
 */
void Node::renderLabel(string lbl) {
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
    offsetLabel = - textureLabel.getWidth() / 2.0;

    
}
