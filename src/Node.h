//
//  Node.h
//  IMDG
//
//  Created by CNPP on 22.5.2011.
//  Copyright 2011 Beat Raess. All rights reserved.
//
#pragma once
#include "cinder/gl/gl.h"
#include "cinder/gl/Texture.h"
#include "cinder/Vector.h"
#include "cinder/Color.h"
#include "cinder/Font.h"



// namespace
using namespace std;
using namespace ci;


/**
 * Graph Node.
 */
class Node {
    
    
    // public
    public:
    
    // Node
    Node();
    Node(string idn, double x, double y); 
    
    // Sketch
    void update();
    void drawNode();
    void drawLabel();
    
    
    // Business
    void attract(Node &n);
    void moveTo(double x, double y);
    void moveTo(Vec2d p);
    void move(double dx, double dy);
    void move(Vec2d d);
    void translate(Vec2d d);
    void addChild(Node n);
    void activate();
    
    
    // Public Fields
    string nid;
    string label;
    vector<Node> children;
    Vec2d pos;
    Vec2d mpos;
    float core;
    float radius,growradius;
    float mass;
	Vec2d velocity;
    
    
    // States
    bool selected;
    bool active;
    bool grow;
    bool load;
    bool visible;
    
    
    // private 
    private:
    
    // Parameters
    double perimeter;
    double damping;
    double strength;
    double ramp;
    double mvelocity;
    double speed;
    
    // Color
    Color cbg;
    Color ctxt;
    float acore,ascore;
    float aglow,asglow;
    
    // Font
    Font font;
    gl::Texture	mTexture;

};
