# -*- coding: utf-8 -*-

config = {
    "dir": "/srv/www/complex",
    "base": "/complex",
}

class CCError(Exception): pass

def setup():
    import os
    os.chdir(config["dir"])

def loadtmpl(templ, **vars):
    master = open("resources/templates/master.html").read()
    templ = open("resources/templates/%s.html" % templ).read() % vars
    master %= templ
    return master

def makeimage(f, w, h, l, b, r, t):
    from mathparse.parser import parser
    f = parser.parse(f)

    import random
    id = random.randint(1, 100000000)

    outname = "/tmp/complex-%d/output.bmp" % id

    import os
    os.mkdir("/tmp/complex-%d" % id)
    cc = open("resources/include/complex.cc").read() % dict(f=f, w=w, h=h, \
            l=l, b=b, r=r, t=t, o=outname)
    open("/tmp/complex-%d/complex.cc" % id, "w").write(cc)
    os.symlink(config["dir"] + "/resources/include/EasyBMP", \
            "/tmp/complex-%d/EasyBMP" % id)
    os.symlink(config["dir"] + "/resources/include/ccfunc.cc", \
            "/tmp/complex-%d/ccfunc.cc" % id)

    import subprocess
    P = subprocess.Popen(["g++", "-std=c++0x",
        "/tmp/complex-%d/complex.cc" % id,
        "/tmp/complex-%d/EasyBMP/EasyBMP.o" % id, "-o",
        "/tmp/complex-%d/plotter" % id, "-O1"],
        stderr=subprocess.PIPE) # O1 has been experimentally found
    errors = P.communicate()[1]
    if errors:
        raise CCError(errors)

    subprocess.call("/tmp/complex-%d/plotter" % id)
    subprocess.call(["convert", outname, "img/output-%d.png" % id])

    import shutil
    shutil.rmtree("/tmp/complex-%d" % id)

    return id

def html_clean(s):
    s = s.replace("<", "&lt;").replace(">", "&gt;")
    s = s.replace("--", "&mdash;")
    return s

def index(req):
    setup()

    req.content_type = "text/html"
    f = req.form.get("f", "exp(-pi * sec(pi * z/2))")
    t = req.form.get("t", "2")
    b = req.form.get("b", "-2")
    l = req.form.get("l", "-2")
    r = req.form.get("r", "2")
    w = str(max(min(int(req.form.get("w", "750")), 1000), 2))
    h = str(max(min(int(req.form.get("h", "750")), 1000), 2))

    err = None
    if "f" in req.form:
        try:
            outsuffix = "-%d" % makeimage(f, w, h, l, b, r, t)
            err = None
        except Exception as e:
            err = e
    else:
        outsuffix = ""
    
    if not err:
        req.write(loadtmpl("plotter", outsuffix=outsuffix, func=f, w=w, \
            h=h, t=t, r=r, b=b, l=l))
    else:
        from ply.lex import LexError
        from mathparse.parser import YaccError
        if type(e) in (LexError, YaccError, CCError):
            req.status = 400
            req.write(loadtmpl("error/parse", func=f, w=w, h=h, t=t, r=r, \
                    b=b, l=l, err=e.args[0]))
        else:
            req.status = 500
            import traceback
            req.write(loadtmpl("error/server", func=f, w=w, h=h, t=t, r=r, \
                    b=b, l=l, err=traceback.format_exc()))
    return

def gallery(req, viewid=None):
    setup()
    import os
    req.content_type = "text/html"

    if viewid:
        viewid = int(viewid)
        return _gallery(req, viewid)
    
    import cPickle as pickle
    gal = pickle.load(open("img/database.pickle"))

    # Gallery format:
    # [ID, DESCRIPTION, f, w, h, l, b, r, t]
    
    to_make = [] # Images that someone deleted and that we thus have to make
    gallery_code = [] # HTML code that we'll be injecting. Ugly, I know.

    template = """<li><a href="gallery/%(i)d"><img src="img/gallery-%(i)d.png" alt="%(f)s" />"""\
            """<code>%(f)s</code></a></li>"""
    for (i, desc, f, w, h, l, b, r, t) in gal:
        if not os.path.exists("img/gallery-%d.png" % i):
            to_make.append((i, desc, f, w, h, l, b, r, t))
        gallery_code.append(template % dict(f=html_clean(f), i=i))

    for (i, desc, f, w, h, l, b, r, t) in to_make:
        id = makeimage(f, w, h, l, b, r, t)
        os.rename("img/output-%d.png" % id, "img/gallery-%d.png" % i)

    req.write(loadtmpl("gallery", itemlist="\n".join(gallery_code)))

def _gallery(req, viewid):
    import cPickle as pickle
    gal = pickle.load(open("img/database.pickle"))
    i, desc, f, w, h, l, b, r, t = filter(lambda x: x[0] == viewid, gal)[0]
    req.write(loadtmpl("gallery-view", f=html_clean(f), desc=html_clean(desc), l=l, b=b, r=r, t=t, i=i))

def gallery_add(req):
    setup()
    
    f = req.form.get("f", "exp(-pi * sec(pi * z/2))")
    t = req.form.get("t", "2")
    b = req.form.get("b", "-2")
    l = req.form.get("l", "-2")
    r = req.form.get("r", "2")
    w = str(max(min(int(req.form.get("w", "750")), 1000), 2))
    h = str(max(min(int(req.form.get("h", "750")), 1000), 2))
    desc = req.form.get("desc", "")
    
    import cPickle as pickle
    gal = pickle.load(open("img/database.pickle"))
    gal.append((max(map(lambda x: x[0], gal)) + 1, desc, f, w, h, l, b, r, t))
    pickle.dump(gal, open("img/database.pickle", "w"))

def api(req):
    setup()

    req.content_type = "image/png"
    t = req.form.get("t", "2") or "2"
    b = req.form.get("b", "-2") or "-2"
    l = req.form.get("l", "-2") or "-2"
    r = req.form.get("r", "2") or "2"
    w = req.form.get("w", "300") or "300"
    h = req.form.get("h", "300") or "300"

    try:
        assert 0 < int(w) < 300
        assert 0 < int(h) < 300
    except AssertionError, ValueError:
        req.status = 400
        return

    if "f" not in req.form or not req.form["f"]:
        req.status = 400
        return

    f = req.form.get("f", "exp(-pi * sec(pi * z/2))")
    try:
        outsuffix = "-%d" % makeimage(f, w, h, l, b, r, t)
    except:
        req.status = 400
        return

    req.write(open("img/output%s.png" % outsuffix, "rb").read())

def about(req):
    setup()
    req.content_type = "text/html"
    
    req.write(loadtmpl("about"))

def feedback(req):
    setup()
    req.content_type = "text/html"
    
    req.write(loadtmpl("feedback"))

def source(req):
    setup()
    req.content_type = "text/html"

    from pygments import highlight
    from pygments.lexers import PythonLexer, CppLexer
    from pygments.formatters import HtmlFormatter

    formatter = HtmlFormatter(linenos="table", noclasses=True)
    
    complexcc = open("resources/include/complex.cc").read()
    complexcc = highlight(complexcc, CppLexer(), formatter)

    ccfunccc = open("resources/include/ccfunc.cc").read()
    ccfunccc = highlight(ccfunccc, CppLexer(), formatter)
    
    indexpy = open("index.py").read()
    indexpy = highlight(indexpy, PythonLexer(), formatter)

    req.write(loadtmpl("source", complex=complexcc, index=indexpy, \
            ccfunc=ccfunccc))
