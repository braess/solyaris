//
//  Action.h
//  Solyaris
//
//  Created by Beat Raess on 28.10.2011.
//  Copyright (c) 2011 Beat Raess. All rights reserved.
//

#pragma once
#include "cinder/gl/gl.h"
#include "cinder/gl/Texture.h"
#include "cinder/Color.h"
#include "cinder/CinderMath.h"
#include "Node.h"


// namespace
using namespace std;
using namespace ci;


// constants
const int actionTimeout = 90;
const int actionReminder = 90;

/**
 * Graph Action.
 */
class Action {
    
    
    // public
    public:
    
    // Action
    Action();

    
    // Sketch
    void update();
    void draw();
    
    // Business
    void hide();
    void show();
    void activate();
    void deactivate();
    bool isActive();
    bool action(Vec2d tpos);
    void assignNode(NodePtr n);
    
    // private
    private:
    
    // node
    NodeWeakPtr node;
    
    // states
    bool active;
    int timeout;
    int counter;
    int reminder;
    
    // position
    Vec2d offset;
    Vec2d size;
    Vec2d pos;
    Vec2d asize;
    
    // textures
    gl::Texture textureActionClose;
    
    
};
