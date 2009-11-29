#define OUTNAME "%(o)s"
#define WIDTH   %(w)s
#define HEIGHT  %(h)s
#define RANGE   {{%(l)s, %(b)s}, {%(r)s, %(t)s}}
#define F1      %(f)s

#include "EasyBMP/EasyBMP.h"
#include <complex>
#include "ccfunc.cc"

unsigned int col[3];
inline void hsi2rgb(double H, double S, double I) {
    double r, g, b;
    if(S==0) {
        r = g = b = I;
    } else {
        if(H==1) H = 0;
        double z = floor(H*6); int i = int(z);
        double f = double(H*6 - z);
        double p = I*(1-S);
        double q = I*(1-S*f);
        double t = I*(1-S*(1-f));
 
        switch(i){
        case 0: r=I; g=t; b=p; break;
        case 1: r=q; g=I; b=p; break;
        case 2: r=p; g=I; b=t; break;
        case 3: r=p; g=q; b=I; break;
        case 4: r=t; g=p; b=I; break;
        case 5: r=I; g=p; b=q; break;
        }
    }
    int c;
    c = int(256*r); if(c>255) c = 255; col[0] = c;
    c = int(256*g); if(c>255) c = 255; col[1] = c;
    c = int(256*b); if(c>255) c = 255; col[2] = c;
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

void run(int c, int r, cc (*func)(cc)) {
	cc z = cc(win[0][0] + xstep * c, win[1][1] - ystep * r);
	cc w = -func(z);
	double in = atan(log(abs(w))) / pi + .5;
	double hue = (arg(w) / (2 * pi) + .5);
	double sat = in;
	hsi2rgb(hue, sat, in);
}
	
int main() {
	image.SetSize(WIDTH, HEIGHT);
	for(int c=0; c < WIDTH; c++) {
		for(int r=0; r < HEIGHT; r++) {
			run(c, r, f1);
            RGBApixel* p = image(c, r);
			p->Red = col[0];
			p->Green = col[1];
			p->Blue = col[2];
		}
	}
	
	image.WriteToFile(OUTNAME);
	return 0;
}
