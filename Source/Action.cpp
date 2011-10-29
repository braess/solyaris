//
//  Action.cpp
//  Solyaris
//
//  Created by Beat Raess on 28.10.2011.
//  Copyright (c) 2011 Beat Raess. All rights reserved.
//

#include "Action.h"


#pragma mark -
#pragma mark Object

/**
 * Creates an action object.
 */
Action::Action() {
    
    // state
    active = false;
    
    // position
    pos.set(0,0);
    offset.set(60,0);
    size.set(45,120);
    asize.set(44,44);
    
    // time
    timeout = -1;
    reminder = -1;
    
    // textures
    textureActionClose = gl::Texture(loadImage(loadResource("node_close.png")));
    
    // hide
    this->hide();
}



#pragma mark -
#pragma mark Sketch

/**
 * Updates the Action.
 */
void Action::update() {
    
    // timeout (avoids flickering)
    if (timeout > 0) {
        timeout--;
    }
    else if (timeout == 0) {
        this->activate();
    }
    
    // reminder
    if (reminder > 0) {
        reminder--;
    }
    else if (reminder == 0) {
        this->deactivate();
    }
    
    // position
    if (active) {
        
        // lock & loll
        NodePtr n = this->node.lock();
        if (n) {
    
            // position
            pos = (n->pos-size/2.0)+offset;
        }
        
    }
    
    
}

/**
 * Draws the Action.
 */
void Action::draw() {
    
    // test
    //gl::enableAlphaBlending();
    //Rectf rect = Rectf(pos.x,pos.y,pos.x+size.x,pos.y+size.y);
    //glColor4f(1,0,0,0.9);
    //gl::drawSolidRect(rect, false);
    
    // active
    if (active) {
        
        // unblend
        gl::enableAlphaBlending(true);
        
        // draw textures
        gl::color( ColorA(1.0f, 1.0f, 1.0f, 1.0f) ); // alpha channel
        gl::draw(textureActionClose, pos);
        
        // reset
        gl::disableAlphaBlending();
    }
    
}


#pragma mark -
#pragma mark Business

/**
 * It's hammer time.
 */
bool Action::action(Vec2d tpos) {
    FLog();
    
    // action
    if (tpos.x > pos.x && tpos.x < pos.x+size.x) {
        
        // close
        if (tpos.y > pos.y && tpos.y < pos.y+asize.y) {
            
            // node
            NodePtr n = this->node.lock();
            if (n) {
                
                // close node
                n->close();
                
                // deactivate actions
                this->deactivate();
            }
            
        }
    }
    
    // miss
    return false;
}


/**
 * States.
 */
bool Action::isActive() {
    return active;
}


/**
 * Show / Hide.
 */
void Action::show() {
    GLog();
    
    // state
    active = false;
    
    // props
    timeout = actionTimeout;
    reminder = -1;
    
}
void Action::hide() {
    GLog();
    
    // reminder
    timeout = -1;
    reminder = actionReminder;

}
void Action::activate() {
    GLog();
    
    // state
    active = true;
    
    
    // reset
    timeout = -1;
    reminder = -1;
    

}
void Action::deactivate() {
    GLog();
    
    // state
    active = false;
    
    // fluff
    pos.set(-10000,-10000);
    
    // reset
    timeout = -1;
    reminder = -1;
    
    // no no node
    node = NodePtr();
}


/**
 * Assign node.
 */
void Action::assignNode(NodePtr n) {
    
    
    // ref
    node = n;
    
    // offset
    if (n) {
        offset.set(n->radius*0.66,0);
        size.y = n->radius * 2;
    }
}


