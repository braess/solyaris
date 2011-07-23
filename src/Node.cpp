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
    parent = NodePtr();
    self = NodePtr(this);
    
    
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
    visible = false;
    
    // radius / mass
    core = 15;
    radius = 15;
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
    font = Font("Helvetica",12);
    textureLabel = gl::Texture(0,0);
    offsetLabel = 0;

}

/**
 * Node movie.
 */
NodeMovie::NodeMovie(): Node::Node()  {    
}
NodeMovie::NodeMovie(string idn, double x, double y): Node::Node(idn, x, y) {
    
    // color (187,176,130)
    cbg = Color(187.0/255.0,176.0/255.0,130.0/255.0);
}

/**
 * Node actor.
 */
NodeActor::NodeActor(): Node::Node()  {    
}
NodeActor::NodeActor(string idn, double x, double y): Node::Node(idn, x, y) {
    
    // color (130,153,147)
    cbg = Color(130.0/255.0,153.0/255.0,147.0/255.0);
}

/**
 * Node director.
 */
NodeDirector::NodeDirector(): Node::Node()  {    
}
NodeDirector::NodeDirector(string idn, double x, double y): Node::Node(idn, x, y) {
    
    // color (94,118,117)
    cbg = Color(94.0/255.0,118.0/255.0,117.0/255.0);
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

    // grow
    if (grow) {
        
        // radius
        radius += 1;
        if (radius >= growradius) {
            
            // stop & activate
            this->activate();
        }
    }
    
    // active
    if (active && ! moved) {
        
        // factor
        float mf = (dm.length() > 5) ? dm.length() * 0.01 : 0;
        
        // children
        for (NodeIt child = children.begin(); child != children.end(); ++child) {
            
            // move visible children
            if ((*child)->visible && (*child)->parent == self) {
                
                // follow
                (*child)->translate(pos - ppos);
                
                // randomize
                (*child)->move(Rand::randFloat(-1,1)*mf,Rand::randFloat(-1,1)*mf);
                
            }
            
        }
    }
    
    // reset
    moved = false;

    
    
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
* Node repulsion.
*/
void Node::attract(NodePtr node) {
    

    // distance
    double d = pos.distance((*node).pos);
    double p = active ? perimeter : (2*radius);
    if (d > 0 && d < p) {
        
        // force
        double s = pow(d / p, 1 / ramp);
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
    moved = true;
    mpos.x += dx;
    mpos.y += dy;
}
void Node::move(Vec2d d) {
    moved = true;
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
    int nb = 10;
    Rand::randomize();
    for (NodeIt child = children.begin(); child != children.end(); ++child) {
        
        // parent
        if ((*child)->parent) {
            
            // unhide
            (*child)->show(false);
            
        }
        // adopt child
        else {
            
            // adopt child
            (*child)->parent = NodePtr(this);
            
            // show
            if (nb > 0) {
                (*child)->show(true);
                nb--;
            }
        }
        
        
        
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
    visible = true;
    loading = true;
    
    // radius
    radius = 40;
    core = 20;
    
    // font
    font = Font("Helvetica",15);
    this->renderLabel(label);

    
}
void Node::loaded() {
    FLog();
    
    // state
    loading = false;
    

    // field
    growradius = min((int)children.size()*3,150);
    grow = true;
  
}


/**
 * Shows/Hides the node.
 */
void Node::show(bool animate) {
    FLog();
    
    // show it
    if (! visible) {
        
        // radius & position
        float r = (*parent).radius * 0.75;
        Vec2d p = Vec2d((*parent).pos.x+Rand::randFloat(-r,r),(*parent).pos.y+Rand::randFloat(-r,r));
        
        // animate
        if (animate) {
            this->moveTo(p);
        }
        // set position
        else {
            this->pos.set(p);
            this->mpos.set(p);
        }
    }
    
    // state
    visible = true;
    
}
void Node::hide() {
    GLog();
    
    // state
    visible = false;
    
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
