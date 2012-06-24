
import lru
import os
import random
from mathparse.parser import parser
import os
import subprocess
import shutil

__dir__ = os.path.dirname(os.path.abspath(__file__))

class ImageCache(lru.LRUCache):
    def compute_value(self, args):
        return make_image(*args)

    def evict(self, args, fname):
        os.unlink(fname)

class CCError(Exception): pass

def make_image(f, w, h, l, b, r, t):
    f = parser.parse(f)

    id = random.randint(1, 100000000)

    outname = "/tmp/complex-%d/output.bmp" % id

    os.mkdir("/tmp/complex-%d" % id)
    cc = open("resources/include/complex.cc").read() % dict(f=f, w=w, h=h, \
            l=l, b=b, r=r, t=t, o=outname)
    open("/tmp/complex-%d/complex.cc" % id, "w").write(cc)
    os.symlink(__dir__ + "/resources/include/EasyBMP",
               "/tmp/complex-%d/EasyBMP" % id)
    os.symlink(__dir__ + "/resources/include/ccfunc.cc",
               "/tmp/complex-%d/ccfunc.cc" % id)

    P = subprocess.Popen(["g++", "-std=c++0x",
        "/tmp/complex-%d/complex.cc" % id,
        "/tmp/complex-%d/EasyBMP/EasyBMP.o" % id, "-o",
        "/tmp/complex-%d/plotter" % id, "-O1"],
        stderr=subprocess.PIPE) # O1 has been experimentally found best
    _, errors = P.communicate()

    if errors: raise CCError(errors)

    subprocess.call("/tmp/complex-%d/plotter" % id)
    img = "img/output-%d.png" % id
    subprocess.call(["convert", outname, os.path.join(__dir__, img)])

    shutil.rmtree("/tmp/complex-%d" % id)

    return img
