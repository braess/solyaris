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
#include "cinder/CinderMath.h"


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
    label = "";
    type = "Node";
    
    
    // fields
    perimeter = 420;
    damping = 0.5;
    strength = -1;
    ramp = 1.0;
    mvelocity = 10;
    speed = 45;
    nbchildren = 8;
    fcount = 0;
    
    // position
    pos.set(x,y);
    ppos.set(x,y);
    mpos.set(x,y);
    
    // state
    selected = false;
    active = false;
    grow = false;
    loading = false;
    visible = false;
    
    // radius / mass
    core = 12;
    radius = 12;
    mass = calcmass();
    
    // velocity
    velocity.set(0,0);
    
    // color
    cbg = Color(1,1,1);
    ctxt = Color(0.85,0.85,0.85);
    ctxts = Color(1,1,1);
    
    // alpha
    acore = 0.6;
    ascore = 1.0;
    aglow = 0.3;
    asglow = 0.45;

    
    // font
    font = Font("Helvetica",12);
    textureLabel = gl::Texture(0,0);
    loff.set(0,5);

}

/**
 * Node movie.
 */
NodeMovie::NodeMovie(): Node::Node()  {    
}
NodeMovie::NodeMovie(string idn, double x, double y): Node::Node(idn, x, y) {
    
    // type
    type = nodeMovie;
    
    // color (187,176,130)
    cbg = Color(187.0/255.0,176.0/255.0,130.0/255.0);
}

/**
 * Node actor.
 */
NodeActor::NodeActor(): Node::Node()  {    
}
NodeActor::NodeActor(string idn, double x, double y): Node::Node(idn, x, y) {
    
    // type
    type = nodeActor;
    
    // color (130,153,147)
    cbg = Color(130.0/255.0,153.0/255.0,147.0/255.0);
}

/**
 * Node director.
 */
NodeDirector::NodeDirector(): Node::Node()  {    
}
NodeDirector::NodeDirector(string idn, double x, double y): Node::Node(idn, x, y) {
    
    // type
    type = nodeDirector;
    
    // color (94,118,117)
    cbg = Color(94.0/255.0,118.0/255.0,117.0/255.0);
}




#pragma mark -
#pragma mark Sketch

/**
* Updates the node.
*/
void Node::update() {
    
    // count
    fcount++;
    
    
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
    ppos = pos;
    pos += dm/speed;

    // grow
    if (grow) {
        
        // radius
        radius += 1;
        
        // mass
        mass = calcmass();
        
        // grown
        if (radius >= growradius) {
            this->grown();
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
    float ga = selected ? asglow : aglow;
    if (loading && ! grow) {
        ga *= (1.5+sin((fcount*1.5*M_PI)/180)); 
    }
    glColor4f(cbg.r,cbg.g,cbg.b,ga);
    gl::drawSolidCircle(pos, radius);
    
    // core
    glColor4f(cbg.r,cbg.g,cbg.b,(selected ? ascore : acore));
    gl::drawSolidCircle(pos, core);

    
    // unblend
    gl::enableAlphaBlending(true);
    
    // label
    selected ? gl::color(ctxts) : gl::color(ctxt);
	gl::draw(textureLabel, Vec2d(pos.x+loff.x, pos.y+radius+loff.y));

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
    GLog();
    
    // push
    children.push_back(child);
}

/**
 * Node is grown.
 */
void Node::grown() {
    FLog();
    
    // state
    loading = false;
    grow = false;
    
    // children
    int nb = nbchildren;
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
    mass = calcmass();
    
    // state
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
    radius = 39;
    core = 18;
    
    // color
    ctxt = Color(0.9,0.9,0.9);
    
    // font
    font = Font("Helvetica-Bold",15);
    loff.y = 6;
    this->renderLabel(label);

    
}
void Node::loaded() {
    FLog();

    // field
    growradius = min((int)children.size()*3,90);
    grow = true;
  
}


/**
 * Shows/Hides the node.
 */
void Node::show(bool animate) {
    GLog();
    
    // show it
    if (! visible) {
        
        // radius & position
        float r = (*parent).radius * 0.3;
        Vec2d p = Vec2d((*parent).pos.x+Rand::randFloat(-r,r),(*parent).pos.y+Rand::randFloat(-r,r));
        
        // animate
        if (animate) {
            this->pos.set((*parent).pos);
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
    GLog();
    
    // state
    selected = true;
    
}
void Node::untouched() {
    GLog();
    
    // state
    selected = false;
    
}


/**
 * Tapped.
 */
void Node::tapped() {
    FLog();
    
    // state
    selected = false;
    
    // reposition
    if (! active && ! loading) {
        
        // distance to parent
        Vec2d pdist =  pos - parent->pos;
        if (pdist.length() < perimeter) {
            
            // unity vector
            pdist.safeNormalize();
            
            // move
            this->moveTo(parent->pos+pdist*perimeter);
        }
    
    }
    
}


/**
 * States.
 */
bool Node::isActive() {
    return active;
}
bool Node::isVisible() {
    return visible;
}
bool Node::isSelected() {
    return selected;
}
bool Node::isLoading() {
    return loading;
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
    loff.x = - textureLabel.getWidth() / 2.0;

}


/*
 * Calculates the mass.
 */
float Node::calcmass() {
    return radius * radius * 0.0001f + 0.01f;
}




#pragma mark -
#pragma mark Memory management

/*
 * Deallocates used memory.
 */
void Node::dealloc() {
    GLog();
    
    // reset
    if (parent != NULL) {
        parent.reset();
    }
    for (NodeIt child = children.begin(); child != children.end(); ++child) {
        child->reset();
    }
}
