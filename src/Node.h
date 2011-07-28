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
#include <boost/ptr_container/ptr_vector.hpp>
#include <boost/shared_ptr.hpp>


// namespace
using namespace std;
using namespace ci;

// declarations
class Node;

// typedef
typedef boost::shared_ptr<Node> NodePtr;
typedef std::vector<NodePtr> NodeVectorPtr;
typedef NodeVectorPtr::iterator NodeIt;


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
    void draw();
    
    
    // Business
    void attract(NodePtr node);
    void moveTo(double x, double y);
    void moveTo(Vec2d p);
    void move(double dx, double dy);
    void move(Vec2d d);
    void translate(Vec2d d);
    void addChild(NodePtr child);
    void grown();
    void load();
    void loaded();
    void hide();
    void show(bool animate);
    void touched();
    void untouched();
    void tapped();
    void renderLabel(string lbl);
    bool isActive();
    bool isVisible();
    bool isSelected();
    void dealloc();
    
    
    // Public Fields
    string nid;
    string label;
    NodePtr parent;
    NodeVectorPtr children;
    Vec2d pos;
    Vec2d ppos;
    Vec2d mpos;
    float core;
    float radius,growradius;
    float mass;
	Vec2d velocity;

    
    // protected
    protected:
    
    // Color
    Color cbg;
    
    
    // private
    private:
    
    // States
    bool selected;
    bool active;
    bool visible;
    bool grow;
    bool loading;
    
    // Font
    Font font;
    gl::Texture	textureLabel;
    float offsetLabel;
    
    
    // Color
    Color ctxt;
    float acore,ascore;
    float aglow,asglow;

    
    // Parameters
    double perimeter;
    double damping;
    double strength;
    double ramp;
    double mvelocity;
    double speed;
    

};
class NodeMovie: public Node {
    
    // public
    public:
    
    // Node
    NodeMovie();
    NodeMovie(string idn, double x, double y);
};
class NodeActor: public Node {
    
    // public
    public:
    
    // Node
    NodeActor();
    NodeActor(string idn, double x, double y);
};
class NodeDirector: public Node {
    
    // public
    public:
    
    // Node
    NodeDirector();
    NodeDirector(string idn, double x, double y);
};



