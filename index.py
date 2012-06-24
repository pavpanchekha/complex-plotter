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

class CCError(Exception): pass

# A 100-image image cache
image_cache = genimg.ImageCache(100)

## The main page

@bottle.route("/")
def index():
    form = bottle.request.query

    f = form.get("f", "exp(-pi * sec(pi * z/2))")
    t = form.get("t", "2")
    b = form.get("b", "-2")
    l = form.get("l", "-2")
    r = form.get("r", "2")
    w = str(max(min(int(form.get("w", "750")), 1000), 2))
    h = str(max(min(int(form.get("h", "750")), 1000), 2))

    # Errors will sink into here
    err = None

    try:
        img = image_cache.get((f, w, h, l, b, r, t))
    except Exception as e:
        err = e
    
    if not err:
        return bottle.template("plotter", img=img, func=f, w=w, \
                                   h=h, t=t, r=r, b=b, l=l)
    else:
        from ply.lex import LexError
        from mathparse.parser import YaccError
        if type(err) in (LexError, YaccError, CCError):
            body = bottle.template("error/parse", func=f, img=img, w=w, h=h, t=t, r=r, \
                                       b=b, l=l, err=err.args[0])
            bottle.abort(400, body)
        else:
            body = bottle.template("error/server", func=f, w=w, h=h, t=t, r=r, \
                                       b=b, l=l, err=traceback.format_exc())
            bottle.abort(500, body)
    return

## The gallery pages

@bottle.route("/gallery")
@bottle.view("gallery")
def gallery():
    # Gallery format: [ID, DESCRIPTION, f, w, h, l, b, r, t]
    gallery = pickle.load(open("img/database.pickle", "rb"))
    
    for (i, desc, f, w, h, l, b, r, t) in gallery:
        if not os.path.exists("img/gallery-%d.png" % i):
            img = image_cache.get((f, w, h, l, b, r, t))
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
def api(req):
    bottle.response.content_type = "image/png"
    t = req.form.get("t", "2") or "2"
    b = req.form.get("b", "-2") or "-2"
    l = req.form.get("l", "-2") or "-2"
    r = req.form.get("r", "2") or "2"
    w = req.form.get("w", "300") or "300"
    h = req.form.get("h", "300") or "300"

    try:
        assert 0 < int(w) < 300
        assert 0 < int(h) < 300
    except (AssertionError, ValueError):
        bottle.abort(400, "Width and height out of bounds")

    if "f" not in req.form or not req.form["f"]:
        bottle.abort(400, "No equation specified")

    f = req.form.get("f", "exp(-pi * sec(pi * z/2))")
    try:
        img = image_cache.get((f, w, h, l, b, r, t))
    except:
        bottle.abort(400, "Failed to make image")

    return open(img, "rb").read()

## "Static" pages

@bottle.route("/about")
@bottle.view("about")
def about():
    return {}

@bottle.route("/feedback")
@bottle.view("feedback")
def feedback():
    return {}

@bottle.route("/source")
@bottle.view("source")
def source():
    import codecs
    complexcc = open("resources/include/complex.cc").read()
    ccfunccc = open("resources/include/ccfunc.cc").read()
    indexpy = codecs.open("index.py", encoding="utf8").read()
    mathparse = codecs.open("mathparse/parser.py", encoding="utf8").read()
    return dict(complex=complexcc, index=indexpy,
                ccfunc=ccfunccc, mathparse=mathparse)

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
