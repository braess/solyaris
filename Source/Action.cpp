//
//  Action.cpp
//  Solyaris
//
//  Created by Beat Raess on 28.10.2011.
//  Copyright (c) 2011 Beat Raess. All rights reserved.
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
    offset.set(60,-4);
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
#pragma mark Cinder

/*
 * Configuration.
 */
void Action::config(Configuration c) {
    
    // display retina
    retina = false;
    Config confDisplayRetina = c.getConfiguration(cDisplayRetina);
    if (confDisplayRetina.isSet()) {
        retina = confDisplayRetina.boolVal();
    }
    
    // retina stuff
    if (retina) {
        
        // position
        offset *= 2;
        size *= 2;
        asize *= 2;
        
        // textures
        textureActionClose = gl::Texture(loadImage(loadResource("node_close@2x.png")));
        
    }
    
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
        offset.x = n->radius*0.66;
        size.y = n->radius * 2;
    }
}


