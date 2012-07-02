#!/usr/bin/env python2
# -*- coding: utf-8 -*-

# Configuration Section
import bottle
import os
import pickle
import traceback
import genimg

__dir__ = os.path.dirname(os.path.abspath(__file__))
import config

# A 100-image image cache
image_cache = genimg.ImageCache(100)

# For reading

def getform():
    form = bottle.request.query

    f = form.get("f", "exp(-pi * sec(pi * z/2))")
    t = form.get("t", "2")
    b = form.get("b", "-2")
    l = form.get("l", "-2")
    r = form.get("r", "2")
    w = str(max(min(int(form.get("w", "750")), 1000), 2))
    h = str(max(min(int(form.get("h", "750")), 1000), 2))

    params = (t, b, l, r, w, h)
    paramdict = dict(zip(["t", "b", "l", "r", "w", "h"], params))

    return f, params, paramdict

## The main page

@bottle.route("/")
@bottle.view("plotter")
def index():
    from ply.lex import LexError
    from mathparse.parser import YaccError
    from genimg import CCError

    f, params, paramdict = getform()

    # Errors will sink into here

    try:
        img = image_cache.get(f, *params)
    except (LexError, YaccError, CCError) as err:
        # In this case, we display the message, which we know is reasonable
        msg = err.args[0]
        body = bottle.template("error/parse", func=f, err=msg, **paramdict)
        bottle.abort(400, body)
    except Exception as err:
        # In this case, we're not so fortunate, so we just dump the traceback
        tb =  traceback.format_exc()
        body = bottle.template("error/server", func=f, err=tb, **paramdict)
        bottle.abort(500, body)
    else:
        return dict(func=f, img=img, **paramdict)

## The gallery pages

@bottle.route("/gallery")
@bottle.view("gallery")
def gallery():
    # Gallery format: [ID, DESCRIPTION, f, w, h, l, b, r, t]
    gallery = pickle.load(open("img/database.pickle", "rb"))
    
    for (i, desc, f, w, h, l, b, r, t) in gallery:
        if not os.path.exists("img/gallery-%d.png" % i):
            img = image_cache.get(f, w, h, l, b, r, t)
            shutil.copy(img, "img/gallery-%d.png" % i)

    return dict(gallery=gallery)

@bottle.route("/gallery/<viewid:int>")
@bottle.view("gallery-view")
def gallery_view(viewid):
    gal = pickle.load(open("img/database.pickle", "rb"))
    i, desc, f, w, h, l, b, r, t = filter(lambda x: x[0] == viewid, gal)[0]
    return dict(f=f, desc=desc, l=l, b=b, r=r, t=t, i=i)

@bottle.route("/gallery_add")
def gallery_add(req):
    f = req.form.get("f", "exp(-pi * sec(pi * z/2))")
    t = req.form.get("t", "2")
    b = req.form.get("b", "-2")
    l = req.form.get("l", "-2")
    r = req.form.get("r", "2")
    w = str(max(min(int(req.form.get("w", "750")), 1000), 2))
    h = str(max(min(int(req.form.get("h", "750")), 1000), 2))
    desc = req.form.get("desc", "")
    
    gal = pickle.load(open("img/database.pickle", "rb"))
    gal.append((max(map(lambda x: x[0], gal)) + 1, desc, f, w, h, l, b, r, t))
    pickle.dump(gal, open("img/database.pickle", "wb"))

## The API page

@bottle.route("/api")
def api():
    bottle.response.content_type = "image/png"

    f, params, paramdict = getform()

    # Errors will sink into here

    try:
        assert 0 < int(paramdict["w"]) < 1000
        assert 0 < int(paramdict["h"]) < 1000
    except (AssertionError, ValueError):
        bottle.abort(400, "Width and height out of bounds")

    try:
        img = image_cache.get(f, *params)
    except:
        bottle.abort(400, "Failed to make image")

    return open(img, "rb").read()

## "Static" pages

@bottle.route("/about")
@bottle.view("about")
def about():
    return {}

@bottle.route("/source")
@bottle.view("source")
def source():
    import codecs
    complexcc = open("resources/include/complex.cc").read()
    ccfunccc = open("resources/include/ccfunc.cc").read()
    mathparse = codecs.open("mathparse/parser.py", encoding="utf8").read()
    return dict(complex=complexcc, ccfunc=ccfunccc, mathparse=mathparse)

## Page Resources

@bottle.route('/resources/<filename:path>')
def send_resource(filename):
    root = __dir__  + "/resources"
    return bottle.static_file(filename, root=root)

@bottle.route('/img/<filename:path>.png')
def send_img(filename):
    root = __dir__ + "/img"
    return bottle.static_file(filename + ".png", root=root, mimetype="image/png")

if __name__ == "__main__":
    bottle.run(**config.run_params)
