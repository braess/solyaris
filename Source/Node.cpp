//
//  Node.cpp
//  Solyaris
//
//  Created by CNPP on 22.5.2011.
//  Copyright 2011 Beat Raess. All rights reserved.
//
//  This file is part of Solyaris.
//  
//  Solyaris is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//  
//  Solyaris is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//  
//  You should have received a copy of the GNU General Public License
//  along with Solyaris.  If not, see www.gnu.org/licenses/.

#include "Node.h"


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
    parent = NodeWeakPtr();
    label = "";
    meta = "";
    type = "Node";
    
    
    // fields
    perimeter = 390;
    dist = 420;
    damping = 0.5;
    strength = -1;
    ramp = 1.0;
    mvelocity = 10;
    speed = 45;
    nbchildren = 12;
    fcount = 0;
    
    // position
    pos.set(x,y);
    ppos.set(x,y);
    mpos.set(x,y);
    
    // state
    selected = false;
    active = false;
    closed = false;
    grow = false;
    shrink = false;
    loading = false;
    visible = false;
    
    // radius / mass
    core = 9;
    radius = 9;
    maxr = 90;
    minr = 60;
    mass = calcmass();
    
    // velocity
    velocity.set(0,0);
    
    // color
    ctxt = Color(0.85,0.85,0.85);
    ctxts = Color(1,1,1);
    
    // alpha
    anode = 0.54;
    asnode = 0.9;
    acore = 0.6;
    ascore = 0.9;
    aglow = 0.18;
    asglow = 0.45;
    
    // textures
    textureNode = gl::Texture(1,1);
    textureCore = gl::Texture(1,1);
    textureGlow = gl::Texture(1,1);
    
    // font
    font = Font("Helvetica",12);
    textureLabel = gl::Texture(1,1);
    loff.set(0,5);

}

/**
 * Node movie.
 */
NodeMovie::NodeMovie(): Node::Node()  {    
}
NodeMovie::NodeMovie(string idn, double x, double y): Node::Node(idn, x, y) {
    
    // type
    this->updateType(nodeMovie);

}

/**
 * Node person.
 */
NodePerson::NodePerson(): Node::Node()  {    
}
NodePerson::NodePerson(string idn, double x, double y): Node::Node(idn, x, y) {
    
    // type
    this->updateType(nodePerson);
}



#pragma mark -
#pragma mark Cinder

/**
 * Applies the settings.
 */
void Node::setting(GraphSettings s) {
    
    
    // children
    nbchildren = 12;
    Default graphNodeChildren = s.getDefault("graph_node_children");
    if (graphNodeChildren.isSet()) {
        nbchildren = (int) graphNodeChildren.doubleVal();
    }
    
    
    // distance
    dist = 420;
    perimeter = 390;
    double length = 400;
    Default graphEdgeLength = s.getDefault("graph_edge_length");
    if (graphEdgeLength.isSet()) {
        length = graphEdgeLength.doubleVal();
        dist = length * 1.05;
        perimeter = 0.9 * dist;
    }

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
    if (abs(velocity.x) < thresh && abs(velocity.y) < thresh) {
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
        if (radius >= growr) {
            this->grown();
        }
        
    }
    
    // shrink
    if (shrink) {
        
        // radius
        radius -= 1.39;
        
        // mass
        mass = calcmass();
        
        // shrunk
        if (radius <= shrinkr) {
            this->shrinked();
        }
        
        
    }

    
}




/**
* Draws the node.
*/
void Node::draw() {
    
    
    // blend
    gl::enableAlphaBlending();
    
    // node expanded
    if (active || loading) {
        
        // core
        float ca = selected ? ascore : acore;
        gl::color( ColorA(1.0f, 1.0f, 1.0f, ca) ); // alpha channel
        gl::draw(textureCore, Rectf(pos.x-core,pos.y-core,pos.x+core,pos.y+core));
        
        // glow
        float ga = selected ? asglow : aglow;
        if (loading && ! grow) {
            ga *= (1.15+sin((fcount*1.15*M_PI)/180));
            ga = fmin(0.79,ga);
        }
        gl::color( ColorA(1.0f, 1.0f, 1.0f, ga) ); // alpha channel
        gl::draw(textureGlow, Rectf(pos.x-radius,pos.y-radius,pos.x+radius,pos.y+radius));
        
    }
    else {
        
        // node
        float na = selected ? asnode : anode;
        gl::color( ColorA(1.0f, 1.0f, 1.0f, na) ); // alpha channel
        gl::draw(textureNode, Rectf(pos.x-core,pos.y-core,pos.x+core,pos.y+core));
        
    }
    
    
    // label
    if (active || ! closed) {
        
        // unblend
        gl::enableAlphaBlending(true);
        
        // drawy thingy
        selected ? gl::color(ctxts) : gl::color(ctxt);
        gl::draw(textureLabel, Vec2d(pos.x+loff.x, pos.y+radius+loff.y));
    }

    
    // reset
    gl::disableAlphaBlending();

}




#pragma mark -
#pragma mark Business

/**
* Node repulsion.
*/
void Node::attract(NodePtr node) {
    

    // distance
    double d = pos.distance((*node).pos);
    double p = active ? perimeter : radius*1.25;
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

    // mass
    mass = calcmass();
    
    // state
    if (! active) {
        
        // born
        this->born();
    }
    else {
        
        // unfold
        this->unfold();
    }

      
}

/**
 * Node is shrinked.
 */
void Node::shrinked() {
    FLog();
    
    // state
    shrink = false;
    
    // mass
    mass = calcmass();
    
    // fold
    this->fold();
    
}


/**
 * Born.
 */
void Node::born() {
    
    // state
    active = true;
    closed = false;
    
    // children
    int nb = nbchildren;
    Rand::randomize();
    for (NodeIt child = children.begin(); child != children.end(); ++child) {
        
        // parent
        if ((*child)->parent.lock()) {
            
            // unhide
            (*child)->show(false);
            
        }
        
        // adopt child
        else {
            
            // adopt child
            (*child)->parent = sref;
            
            // director
            if ((*child)->type == nodePersonDirector) {
                (*child)->show(true);
            }
            
            // actor / movie
            if (((*child)->type == nodePersonActor || (*child)->type == nodeMovie)) {
                
                // show
                if (nb > 0) {
                    (*child)->show(true);
                    nb--;
                }
                else if (! (*child)->isActive()) {
                    (*child)->hide(); 
                }
            }
            
            
        }
        
    }
    
    // offset
    this->offset();
    
}

/**
 * Unfold.
 */
void Node::unfold() {
    
    // children
    Rand::randomize();
    for (NodeIt child = children.begin(); child != children.end(); ++child) {
        
        // open child
        if (this->isNodeChild(*child)) {
            
            // radius & position
            float dmin = 0.3;
            float dmax = 1.2;
            float rx = Rand::randFloat(radius * dmin,radius * dmax) + 0.1;
            rx *= (Rand::randFloat(1) > 0.5) ? 1.0 : -1.0;
            float ry = Rand::randFloat(radius * dmin,radius * dmax) + 0.1;
            ry *= (Rand::randFloat(1) > 0.5) ? 1.0 : -1.0;
            Vec2d p = Vec2d(pos.x+rx,pos.y+ry);
            
            // move & open
            (*child)->moveTo(p);
            (*child)->open();
        }
        
    }
    
    // offset
    this->offset();
}

/**
 * Fold.
 */
void Node::fold() {
    
    // children
    Rand::randomize();
    for (NodeIt child = children.begin(); child != children.end(); ++child) {
        
        // move it
        if (this->isNodeChild(*child)) {
            
            // radius & position
            float dmin = 0.2;
            float dmax = 0.9;
            float rx = Rand::randFloat(radius * dmin,radius * dmax) + 0.1;
            rx *= (Rand::randFloat(1) > 0.5) ? 1.0 : -1.0;
            float ry = Rand::randFloat(radius * dmin,radius * dmax) + 0.1;
            ry *= (Rand::randFloat(1) > 0.5) ? 1.0 : -1.0;
            Vec2d p = Vec2d(pos.x+rx,pos.y+ry);
            
            // you gotta
            (*child)->moveTo(p);
            
        }

        
    }

}


/**
 * Offset.
 */
void Node::offset() {
    
    // positions
    vector<float> cpos;
    vector<float>::iterator cposi;
    
    // offset children to minimize vertical collision
    for (int pass = 0; pass < 2 ; pass++) {
        
        // clear
        cpos.clear();
        
        // iterate
        for (NodeIt child = children.begin(); child != children.end(); ++child) {
            if (this->isNodeChild(*child)) {
                for (cposi = cpos.begin(); cposi != cpos.end(); ++cposi) {
                    
                    // vertical diff
                    if ( abs((*child)->mpos.y - (*cposi)) < 15 ) {
                        
                        // up it goes
                        (*child)->move(0,-15);
                    }
                }
                cpos.push_back((*child)->mpos.y);
            }
            
        }
    }

    
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
    core = 15;
    radius = 36;
    
    // color
    ctxt = Color(0.9,0.9,0.9);
    
    // font
    font = Font("Helvetica-Bold",15);
    loff.y = 6;
    this->renderLabel(label);
    this->renderNode();
    
}
void Node::unload() {
    FLog();
    
    // state
    visible = true;
    loading = false;
    
    // radius
    core = 9;
    radius = 9;
    
    // color
    ctxt = Color(0.85,0.85,0.85);
    
    // font
    font = Font("Helvetica",12);
    loff.y = 5;
    this->renderLabel(label);
    
    // parent
    NodePtr pp = this->parent.lock();
    if (pp) {
        
        // radius & position
        Vec2d back = pp->pos + ((this->pos - pp->pos) / 2.0);
        this->moveTo(back);
    }
    
    
}
void Node::loaded() {
    FLog();

    // state
    growr = ((int)children.size()) > 1 ? min(minr+(int)children.size(),maxr) : minr * 0.75;
    grow = true;
  
}

/**
 * Close / open node.
 */
void Node::close() {
    GLog();
    
    // state
    closed = true;
    
    // active
    if (active) {
        
        // shrink
        shrinkr = minr * 0.5;
        shrink = true;
        
        // children
        for (NodeIt child = children.begin(); child != children.end(); ++child) {
            
            // close child
            if (this->isNodeChild(*child)) {
                (*child)->close();
            }
            
        }
    }
    
}


/**
 * Reactivate node.
 */
void Node::open() {
    GLog();
    
    // state
    closed = false;
    
    // active
    if (active) {
        
        // state
        growr = ((int)children.size()) > 1 ? min(minr+(int)children.size(),maxr) : minr * 0.75;
        grow = true;
        
    }
    
}


/**
 * Shows/Hides the node.
 */
void Node::show(bool animate) {
    GLog();
    
    // show it
    if (! visible) {
        
        // parent
        NodePtr pp = this->parent.lock();
        if (pp) {
            
            // radius & position
            float dmin = 0.3;
            float dmax = 1.2;
            float rx = Rand::randFloat(pp->radius * dmin,pp->radius * dmax) + 0.1;
            rx *= (Rand::randFloat(1) > 0.5) ? 1.0 : -1.0;
            float ry = Rand::randFloat(pp->radius * dmin,pp->radius * dmax) + 0.1;
            ry *= (Rand::randFloat(1) > 0.5) ? 1.0 : -1.0;
            Vec2d p = Vec2d(pp->pos.x+rx,pp->pos.y+ry);
   
 
            // animate
            if (animate) {
                this->pos.set(pp->pos);
                this->moveTo(p);
            }
            // set position
            else {
                this->pos.set(p);
                this->mpos.set(p);
            }
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
 * Child.
 */
bool Node::isNodeChild(NodePtr n) {
    
    // parent
    NodePtr cp = n->parent.lock();
    
    // active
    bool available = ! (n->isActive() || n->isLoading()) && n->isVisible();
    return available && cp->nid == this->nid;
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
    
    // show
    if (! visible) {
        this->show(false);
    }
    
    // reposition
    if (! active && ! loading) {
        
        // parent
        NodePtr pp = this->parent.lock();
        if (pp) {
            
            // distance to parent
            Vec2d pdist =  pos - pp->pos;
            if (pdist.length() < dist) {
                
                // unity vector
                pdist.safeNormalize();
                
                // move
                this->moveTo(pp->pos+pdist*dist);
            }
        }
    
    }
    
}


/**
 * States.
 */
bool Node::isActive() {
    return active;
}
bool Node::isClosed() {
    return closed;
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
    label = (lbl == "") ? " " : lbl;
    
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
 * Renders the node.
 */
void Node::renderNode() {
    
    // movie
    if (type == nodeMovie) {
        
        // texture
        textureNode = gl::Texture(loadImage(loadResource("node_movie.png")));
        if (active || loading) {
            textureCore = gl::Texture(loadImage(loadResource("node_movie_core.png")));
            textureGlow = gl::Texture(loadImage(loadResource("node_movie_glow.png")));
        }
        
    }
    // director / crew
    else if (type == nodePersonDirector || type == nodePersonCrew) {
        
        // texture
        textureNode = gl::Texture(loadImage(loadResource("node_crew.png")));
        if  (active || loading) {
            textureCore = gl::Texture(loadImage(loadResource("node_crew_core.png")));
            textureGlow = gl::Texture(loadImage(loadResource("node_crew_glow.png")));
        }
        
    }
    // person
    else {
        
        // texture
        textureNode = gl::Texture(loadImage(loadResource("node_person.png")));
        if (active || loading) {
            textureCore = gl::Texture(loadImage(loadResource("node_person_core.png")));
            textureGlow = gl::Texture(loadImage(loadResource("node_person_glow.png")));
        }
    }
}

/**
 * Updates the type.
 */
void Node::updateType(string t) {
    
    // type
    type = t;
    
    // render
    this->renderNode();
}


/**
 * Updates the meta.
 */
void Node::updateMeta(string m) {
    meta = m;
}

/*
 * Calculates the mass.
 */
float Node::calcmass() {
    return radius * radius * 0.0001f + 0.01f;
}




