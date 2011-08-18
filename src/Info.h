//
//  Info.h
//  IMDG
//
//  Created by CNPP on 4.8.2011.
//  Copyright 2011 Beat Raess. All rights reserved.
//
#pragma once
#include "cinder/gl/gl.h"
#include "cinder/gl/Texture.h"
#include "cinder/Color.h"
#include "cinder/Font.h"


// namespace
using namespace std;
using namespace ci;


/**
 * Graph Info.
 */
class Info {
    
    
    // public
    public:
    
    // Info
    Info();
    Info(Vec2d b);
    
    // Sketch
    void update();
    void draw();
    
    // Business
    void hide();
    void show(int o);
    bool isVisible();
    void position(Vec2d p);
    void renderText(vector<string> txts);
    
    // Public Fields
    string text;
    
    // private
    private:
    
    // States
    bool visible;
    float alpha;
    int timeout;

    
    // position
    Vec2d pos;
    Vec2d border;
    Vec2d bounds;
    double dx,dy;
    
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