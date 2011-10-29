//
//  Graph.cpp
//  Solyaris
//
//  Created by CNPP on 22.5.2011.
//  Copyright 2011 Beat Raess. All rights reserved.
//

#include "Graph.h"


#pragma mark -
#pragma mark Object

/**
 * Creates a graph.
 */
Graph::Graph() {
}
Graph::Graph(int w, int h, int o) {
    
    // fields
    width = w;
    height = h;
    orientation = o;
    
    // virtual position
    vpos.set(0,0);
    vppos.set(0,0);
    vmpos.set(0,0);
    vdrag.set(0,0);
    mbound = 90.0;
    
    // movement
    speed = 45;
    friction = 0.9;
    
    // hitarea
    harea = 6;
    
    // tooltip / action
    nbtouch = 10;
    for (int t = 1; t <= nbtouch; t++) {
        tooltips[t] = Tooltip(Vec2d(w,h));
        actions[t] = Action();
    }
    tooltip_disabled = false;
    
    // layout
    layout_none = false;
    layout_force = true;
    
    // background
    background = gl::Texture(loadImage(loadResource("bg_graph.png")));
    
    // sample
    audioSampleClick = audio::load(loadResource(SAMPLE_CLICK));
    sound_disabled = false;

}


#pragma mark -
#pragma mark Cinder

/**
 * Resize.
 */
void Graph::resize(int w, int h, int o) {
    
    // fields
    width = w;
    height = h;
    orientation = o;
    
    // tooltip
    for (int t = 1; t <= nbtouch; t++) {
        tooltips[t].resize(w,h);
    }
}


/**
 * Applies the settings.
 */
void Graph::setting(GraphSettings s) {
    
    // reference
    gsettings = s;
    
    
    // layout 
    layout_none = false;
    layout_force = true;
    Default graphLayout = s.getDefault("graph_layout");
    if (graphLayout.isSet()) {
        
        // none
        if (graphLayout.stringVal() == graphLayoutNone) {
            layout_none = true;
            layout_force = false;
        }
        
        // force
        if (graphLayout.stringVal() == graphLayoutForce) {
            layout_none = false;
            layout_force = true;
        }
    }
    
    // tooltip 
    tooltip_disabled = false;
    Default graphTooltipDisabled = s.getDefault("graph_tooltip_disabled");
    if (graphTooltipDisabled.isSet()) {
        tooltip_disabled = graphTooltipDisabled.boolVal();
    }
    
    // sound 
    sound_disabled = false;
    Default graphSoundDisabled = s.getDefault("graph_sound_disabled");
    if (graphSoundDisabled.isSet()) {
        sound_disabled = graphSoundDisabled.boolVal();
    }
    
    // apply to nodes
    for (NodeIt node = nodes.begin(); node != nodes.end(); ++node) {
        (*node)->setting(gsettings);
    }
    
    // apply to edges
    for (EdgeIt edge = edges.begin(); edge != edges.end(); ++edge) {
        (*edge)->setting(gsettings);
    }
    
}


#pragma mark -
#pragma mark Sketch


/**
 * Updates the graph.
 */
void Graph::update() {

    // randomize
    Rand::randomize();
    
    // layout force
    if (layout_force) {
        
        // attract
        this->attract();
        
        // repulse
        this->repulse();
        
    }
    
    // virtual movement
    Vec2d dm = vmpos - vpos;
    vppos = vpos;
    vpos += dm/speed;
    Vec2d vmove = (vpos - vppos) + vdrag;
    
    
    // nodes
    for (NodeIt node = nodes.begin(); node != nodes.end(); ++node) {
        
        // active
        if ((*node)->isActive() || (*node)->isLoading()) {
            
            // global movement
            (*node)->move(vmove);
            
            // update
            (*node)->update();
            
            // node movement
            Vec2d ndist = (*node)->mpos - (*node)->pos;
            float nmov = (ndist.length() > 1) ? ndist.length() * 0.0045 : 0;
            
            // children
            for (NodeIt child = (*node)->children.begin(); child != (*node)->children.end(); ++child) {
                
                // parent
                NodePtr pp = (*child)->parent.lock();

                // move visible children
                if (! (*child)->isActive() && ! (*child)->isLoading() && (*child)->isVisible() && pp == (*node)) {
                    
                    // follow
                    (*child)->translate((*node)->pos - (*node)->ppos);
                    
                    // randomize
                    (*child)->move(Rand::randFloat(-1,1)*nmov,Rand::randFloat(-1,1)*nmov);
                    
                    // update
                    (*child)->update();
                    
                }
                
            }

        }
        
    }
    
    // edges
    for (EdgeIt edge = edges.begin(); edge != edges.end(); ++edge) {
        
        // active
        if ((*edge)->isVisible()) {
            (*edge)->update();
        }
    }
    
    // tooltip / actions
    for (int t = 1; t <= nbtouch; t++) {
        tooltips[t].update();
        actions[t].update();
    }

}

/**
 * Draws the graph.
 */
void Graph::draw() {
    
    
    // background
    gl::color( ColorA(1.0f, 1.0f, 1.0f, 1.0f) ); // alpha channel
    gl::draw(background);
    

    // edges
    for (EdgeIt edge = edges.begin(); edge != edges.end(); ++edge) {
        
        // draw if visible
        if ((*edge)->isVisible()) {
            (*edge)->draw();
        }
    }
    
    // nodes
    for (NodeIt node = nodes.begin(); node != nodes.end(); ++node) {
        
        // draw if visible and on stage
        if ((*node)->isVisible() && (*node)->pos.x > -300 && (*node)->pos.x < 1500 && (*node)->pos.y > -300 && (*node)->pos.y < 1500) {
            (*node)->draw();
        }
    }
    
    // tooltip / actions
    for (int t = 1; t <= nbtouch; t++) {
        actions[t].draw();
        tooltips[t].draw();
    }


}


/**
 * Resets the graph.
 */
void Graph::reset() {
    DLog();
    
    // clear
    edges.clear(); 
    nodes.clear(); 
    
    // reset maps
    nmap.clear();
    emap.clear();
    
}



#pragma mark -
#pragma mark Touch

/**
 * Touch.
 */
void Graph::touchBegan(Vec2d tpos, int tid) {
    GLog();
    
    // actions
    bool action = false;
    for (int t = 1; t <= nbtouch; t++) {
        if (actions[t].isActive()) {
            action = actions[t].action(tpos);
        }
    }
    
    // nodes
    for (NodeIt node = nodes.begin(); ! action && node != nodes.end(); ++node) {
        
        // visible
        if ((*node)->isVisible()) {
            
            // distance
            float d = (*node)->pos.distance(tpos);
            if (d < (*node)->core+harea) {
                
                // touched
                GLog("tid = %d, node = ",tid);
                touched[tid] = NodePtr(*node); 
                
                // state
                touched[tid]->touched();
                
                // set the tooltip
                this->tooltip(tid);
                tooltips[tid].position(tpos);
                
                // set the action
                this->action(tid);
                
                // sample
                this->sample(sampleClick);
                
                // have a break
                break;
                
            }
        }
    }

    
}
void Graph::touchMoved(Vec2d tpos, Vec2d ppos, int tid){
    GLog();

    // node
    if (touched[tid]) {
        GLog("tid = %d, node = ",tid);
        
        // move
        touched[tid]->moveTo(tpos);
        
        // tooltip
        tooltips[tid].position(tpos);


    }
    // graph
    else {
        
        // drag
        this->drag(tpos-ppos);
    }
    
}
void Graph::touchEnded(Vec2d tpos, int tid){
    GLog();
    
    // node
    if (touched[tid]) {
        
        // state
        GLog("tid = %d, node = ",tid);
        touched[tid]->untouched();
        
        // hide tooltip
        tooltips[tid].hide();
        
        // hide action
        actions[tid].hide();
    }
    // graph
    else {
        
        // undrag
        this->drag(Vec2d(0,0));
    }
    
    // reset
    touched.erase(tid);

}


#pragma mark -
#pragma mark Taps

/**
 * Tapped.
 */
NodePtr Graph::doubleTap(Vec2d tpos, int tid) {
    GLog();
    
    // nodes
    for (NodeIt node = nodes.begin(); node != nodes.end(); ++node) {
        // distance
        float d = (*node)->pos.distance(tpos);
        if (d < (*node)->core+harea) {
            
            // tapped
            (*node)->tapped();
            
            // sample
            this->sample(sampleClick);
          
            // return
            return (*node);
                            
        }
    }
    
    // nop
    return NodePtr();
    
}



#pragma mark -
#pragma mark Business


/**
 * Attraction.
 */
void Graph::attract() {
    
    // nodes
    for (NodeIt n1 = nodes.begin(); n1 != nodes.end(); ++n1) {
        
        // attract others
        for (NodeIt n2 = nodes.begin(); n2 != nodes.end(); ++n2) {
            if ((*n1)->isActive() && (*n2)->isActive() && ! (*n1)->isClosed() && ! (*n2)->isClosed() && (*n1) != (*n2)) {
                (*n1)->attract(*n2);
            }
        }
    }
    
}

/**
 * Repulsion.
 */
void Graph::repulse() {
    
    // edges
    for (EdgeIt edge = edges.begin(); edge != edges.end(); ++edge) {
        
        // active
        if ((*edge)->isActive()) {
            (*edge)->repulse();
        }
    }
    
}


/**
 * Move.
 */
void Graph::move(Vec2d d) {
    vmpos += d;
}

/**
 * Drag.
 */
void Graph::drag(Vec2d d) {
    
    // set
    vdrag = d*friction;
    
    // threshold
    float thresh = 1.0;
    if (abs(vdrag.x) < thresh && abs(vdrag.y) < thresh) {
        vdrag.set(0,0);
    }
}


/**
 * Creates a node.
 */
NodePtr Graph::createNode(string nid, string type, double x, double y) {
    GLog();
    
    // node map
    nmap.insert(make_pair(nid, nodes.size()));
    
    // node
    if (type == nodeMovie) {
        boost::shared_ptr<NodeMovie> node(new NodeMovie(nid,x,y));
        node->sref = node;
        node->setting(gsettings);
        nodes.push_back(node);
        return node;
    }
    else if (type == nodePerson) {
        boost::shared_ptr<NodePerson> node(new NodePerson(nid,x,y));
        node->sref = node;
        node->setting(gsettings);
        nodes.push_back(node);
        return node;
    }
    else {
        boost::shared_ptr<Node> node(new Node(nid,x,y));
        node->sref = node;
        node->setting(gsettings);
        nodes.push_back(node);
        return node;
    }

}

/**
 * Gets a node.
 */
NodePtr Graph::getNode(string nid) {
    GLog();
    
    // find the key
    map<string,int>::iterator it = nmap.find(nid);
    if(it != nmap.end()) {
        return NodePtr(nodes.at(it->second));
    }
    
    // nop
    return NodePtr();
}


/**
 * Creates an edge.
 */
EdgePtr Graph::createEdge(string eid, string type, NodePtr n1, NodePtr n2) {
    GLog();
    
    // edge map
    emap.insert(make_pair(eid, edges.size()));
    
    // node
    if (type == edgeMovie) {
        boost::shared_ptr<Edge> edge(new EdgeMovie(eid,n1,n2));
        edge->setting(gsettings);
        edges.push_back(edge);
        return edge;
    }
    else if (type == edgePerson) {
        boost::shared_ptr<Edge> edge(new EdgePerson(eid,n1,n2));
        edge->setting(gsettings);
        edges.push_back(edge);
        return edge;
    }
    else {
        boost::shared_ptr<Edge> edge(new Edge(eid,n1,n2));
        edge->setting(gsettings);
        edges.push_back(edge);
        return edge;
    }

}

/**
 * Gets an edge.
 */
EdgePtr Graph::getEdge(string nid1, string nid2) {
    GLog();
    
    // find the key
    map<string,int>::iterator it1 = emap.find(nid1 + "_edge_" + nid2);
    if(it1 != emap.end()) {
        return EdgePtr(edges.at(it1->second));
    }
    map<string,int>::iterator it2 = emap.find(nid2 + "_edge_" + nid1);
    if(it2 != emap.end()) {
        return EdgePtr(edges.at(it2->second));
    }
    
    // nop
    return EdgePtr();
}

/**
 * Prepares the graph for loading.
 */
void Graph::load(NodePtr n) {
    FLog();
    
    // bounds
    Vec2d d = Vec2d(0,0);
    if (n->mpos.x < mbound) {
        d.x = mbound - n->mpos.x;
    }
    else if (n->mpos.x > width - mbound) {
        d.x = - (n->mpos.x - (width-mbound));
    }
    if (n->mpos.y < mbound) {
        d.y = mbound - n->mpos.y;
    }
    else if (n->mpos.y > height - mbound) {
        d.y = - (n->mpos.y - (height-mbound));
    }
    
    // move it
    this->move(d);
}


/**
 * Sets the tooltip.
 */
void Graph::tooltip(int tid) {
    GLog();
    
    // enabled
    if (! tooltip_disabled) {
        
        // selected edges
        bool etouch;
        vector<string> txts = vector<string>();
        for (EdgeIt edge = edges.begin(); edge != edges.end(); ++edge) {
            
            // touched
            if ((*edge)->isTouched(touched[tid])) {
                etouch = true;
                txts.push_back((*edge)->info());
            }
        }
        
        // touched
        if (etouch && txts.size() > 0) {
            tooltips[tid].renderText(txts);
            tooltips[tid].offset(touched[tid]->radius+12.0);
            tooltips[tid].show();
        }
        
    }
    
}

/**
 * Sets the action.
 */
void Graph::action(int tid) {
    GLog();
    
    // showtime
    if (touched[tid]->isActive() && ! touched[tid]->isClosed()) {
        actions[tid].assignNode(touched[tid]);
        actions[tid].show();
    }
    
}


/**
 * Sample player.
 */
void Graph::sample(int s) {
    
    // play it again sam
    if (! sound_disabled) {
        switch(s) {
            // click
            case sampleClick:
                try {
                    audio::Output::play(audioSampleClick);
                }
                catch (...) {
                    // ignore
                }
                break;
            default:
                break;
        }
    }

}


