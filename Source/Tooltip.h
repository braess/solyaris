//
//  Tooltip.h
//  Solyaris
//
//  Created by CNPP on 4.8.2011.
//  Copyright 2011 Beat Raess. All rights reserved.
//
#pragma once
#include "cinder/gl/gl.h"
#include "cinder/gl/Texture.h"
#include "cinder/Color.h"
#include "cinder/Font.h"
#include "cinder/Text.h"
#include "cinder/CinderMath.h"


// namespace
using namespace std;
using namespace ci;


// constants
const int tooltipTimeout = 12;

/**
 * Graph Tooltip.
 */
class Tooltip {
    
    
    // public
    public:
    
    // Tooltip
    Tooltip();
    Tooltip(Vec2d b);
    
    // Cinder
    void resize(int w, int h);
    
    // Sketch
    void update();
    void draw();
    
    // Business
    void hide();
    void show();
    void activate();
    void position(Vec2d p);
    void renderText(vector<string> txts);
    
    // Public Fields
    string text;
    
    // private
    private:
    
    // States
    bool active;
    int timeout;

    
    // position
    Vec2d pos;
    Vec2d dpos;
    Vec2d border;
    Vec2d bounds;
    
    // color
    ColorA cbg;
    ColorA ctxt;

    
    // Font
    Font font;
    Font sfont;
    Vec2d offset;
    Vec2d inset;
    Vec2d size;
    gl::Texture	textureText;
    
};