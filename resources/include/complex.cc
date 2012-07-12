#define OUTNAME "%(o)s"
#define WIDTH   %(w)s
#define HEIGHT  %(h)s
#define RANGE   {{%(l)s, %(b)s}, {%(r)s, %(t)s}}
#define F1      %(f)s

#include "EasyBMP/EasyBMP.h"
#include <complex>
#include "ccfunc.cc"

#define OUTPACK(r, g, b) (int(256*r) << 16) + (int(256*g) << 8) + (int(256*b));

inline int hsi2rgb(double H, double I) {
     double r, g, b;

     if(H==1) H = 0;
     double z = floor(H*6); int i = int(z);
     double f = H*6 - z;
     double p = I*(1-I);
     double q = I*(1-I*f);

     if (I > .999) I = .999;
     if (! (i & 1)) {
          q = I + p - q;
     }
 
     switch(i){
     case 0: r=I, g=q, b=p; break;
     case 1: r=q, g=I, b=p; break;
     case 2: r=p, g=I, b=q; break;
     case 3: r=p, g=q, b=I; break;
     case 4: r=q, g=p, b=I; break;
     case 5: r=I, g=p, b=q; break;
     }

     return OUTPACK(r, g, b);
}

inline double decc(cc a) {
     if (imag(a) == 0) {
          return real(a);
     } else {
          return abs(a);
     }
}

inline cc f1(cc z) {
     return F1;
}

BMP image;
double win[2][2] = RANGE;
double xstep = (win[1][0] - win[0][0]) / WIDTH;
double ystep = (win[1][1] - win[0][1]) / HEIGHT;

int run(int c, int r) {
     cc z = cc(win[0][0] + xstep * c, win[1][1] - ystep * r);
     cc out = -f1(z);
     //cc w = log(-f1(z));

     double in = atan(2*sqrt(sqrt(real(out)*real(out) + imag(out)*imag(out)))) / (.5 * pi);
     double hue = atan2(imag(out), real(out)) / (2 * pi) + .5;
     return hsi2rgb(hue, in);
}
	
int main() {
     image.SetSize(WIDTH, HEIGHT);
     cc z = cc(win[0][0], win[1][1]);
     for(int c=0; c < WIDTH; c++) {
          for(int r=0; r < HEIGHT; r++) {
            
               int color = run(c, r);
               RGBApixel* p = image(c, r);
               p->Red = (color >> 16) & 0xff;
               p->Green = (color >> 8) & 0xff;
               p->Blue = color & 0xff;
          }
     }
	
     image.WriteToFile(OUTNAME);
     return 0;
}
