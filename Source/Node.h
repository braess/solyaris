//
//  Node.h
//  Solyaris
//
//  Created by CNPP on 22.5.2011.
//  Copyright 2011 Beat Raess. All rights reserved.
//
#pragma once
#include "cinder/app/AppCocoaTouch.h"
#include "cinder/gl/gl.h"
#include "cinder/gl/Texture.h"
#include "cinder/ImageIo.h"
#include "cinder/Vector.h"
#include "cinder/Color.h"
#include "cinder/Font.h"
#include "cinder/Text.h"
#include "cinder/Rand.h"
#include "cinder/CinderMath.h"
#include <boost/ptr_container/ptr_vector.hpp>
#include <boost/shared_ptr.hpp>
#include <boost/weak_ptr.hpp>
#include "GraphSettings.h"




// namespace
using namespace std;
using namespace ci;
using namespace ci::app;

// declarations
class Node;

// typedef
typedef boost::shared_ptr<Node> NodePtr;
typedef boost::weak_ptr<Node> NodeWeakPtr;
typedef std::vector<NodePtr> NodeVectorPtr;
typedef NodeVectorPtr::iterator NodeIt;


// constants
const string nodeMovie = "movie";
const string nodePerson = "person";
const string nodePersonActor = "person_actor";
const string nodePersonDirector = "person_director";
const string nodePersonCrew = "person_crew";


/**
 * Graph Node.
 */
class Node {
    
    
    // public
    public:
    
    // Node
    Node();
    Node(string idn, double x, double y); 
    
    // Cinder
    void setting(GraphSettings s);
    
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
    void unfold();
    void show(bool animate);
    void touched();
    void untouched();
    void tapped();
    void renderLabel(string lbl);
    void updateType(string t);
    void updateMeta(string m);
    bool isActive();
    bool isVisible();
    bool isSelected();
    bool isLoading();
    
    
    // Public Fields
    string nid;
    string label;
    string meta;
    string type;
    NodeWeakPtr sref;
    NodeWeakPtr parent;
    NodeVectorPtr children;
    Vec2d pos;
    Vec2d ppos;
    Vec2d mpos;
    float core;
    float radius,growr;
    float mass;
	Vec2d velocity;

    
    // private
    private:
    
    // States
    bool selected;
    bool active;
    bool visible;
    bool grow;
    bool loading;
    
    // Helpers
    float calcmass();

    
    // Parameters
    double perimeter;
    double dist;
    double damping;
    double strength;
    double ramp;
    double mvelocity;
    double speed;
    int nbchildren;
    int fcount;
    int minr,maxr;
    
    // Textures
    gl::Texture textureNode;
    gl::Texture textureCore;
    gl::Texture textureGlow;
    
    
    // Color
    Color ctxt;
    Color ctxts;
    float acore,ascore;
    float aglow,asglow;
    
    // Font
    Font font;
    Vec2d loff;
    gl::Texture	textureLabel;

};
class NodeMovie: public Node {
    
    // public
    public:
    
    // Node
    NodeMovie();
    NodeMovie(string idn, double x, double y);
};
class NodePerson: public Node {
    
    // public
    public:
    
    // Node
    NodePerson();
    NodePerson(string idn, double x, double y);
};




