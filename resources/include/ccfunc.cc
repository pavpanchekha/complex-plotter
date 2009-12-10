#include <complex>
using std::abs; using std::arg; using std::conj; using std::imag;
using std::real; using std::exp; using std::log; using std::pow;
using std::sqrt; using std::sin; using std::cos; using std::tan;
using std::sinh; using std::cosh;
#include <cstdlib>
using std::rand;

typedef std::complex<double> cc;

/* Constants */
const cc i(0, 1);
const double pi   = 3.141592653590;
const double e    = exp(1);
const double masc = .5772156649015;

/* Functions */

// Random
extern inline cc ccrand() {return cc(rand(), rand()) / (double) RAND_MAX;}

// Gamma
// See also: Numerical Recipies
double gamma_coeff[] = {75122.6331530, 80916.6278952, 36308.2951477, \
    8687.24529705, 1168.92649479, 83.8676043424, 2.50662827511};
extern inline cc gamma(cc z) {
    cc ret1(0, 0);
    cc ret2(1, 0);
    for (int i = 0; i < 6; i++) {
        ret1 += gamma_coeff[i] * pow(z, i);
        ret2 *= z + double(i);
    }
    return ret1 / ret2 * pow(z + 5.5, z + 0.5) * exp(-(z + 5.5));
}

extern inline cc beta(cc z, cc w) {
    return gamma(z)*gamma(w)/gamma(z + w);
}

// Dirichlet series

// See also: Borwein's method of calculating the eta function
int eta_coeff[] = {0, 200, 6800, 92180, 640400, 2690440, 7349640, \
    13903240, 19473800, 22095240, 22619520};
extern inline cc eta(cc s) {
    int n = 8;
    cc t(0, 0);
    for (int k = 0; k < n; k++) {
        t += -(pow(-1.0, k) * (eta_coeff[k] - eta_coeff[n]) / \
                pow(k + 1.0, s)) / double(eta_coeff[n]);
    }
    return t;
}
extern inline cc zeta(cc s) {return eta(s) / (1.0 - pow(2.0, 1.0-s));}
extern inline cc xi(cc s) {return (s-1.0)*gamma(s/2.0 + 1.0)*zeta(s)/sqrt(pow(pi, s));}

// Trig
extern inline cc cot(cc z)  {return 1.0 / tan(z);}
extern inline cc sec(cc z)  {return 1.0 / cos(z);}
extern inline cc csc(cc z)  {return 1.0 / sin(z);}

// HyperTrig
extern inline cc tanh(cc z) {return sinh(z) / cosh(z);}
extern inline cc coth(cc z) {return cosh(z) / sinh(z);}
extern inline cc sech(cc z) {return 1.0 / cosh(z);}
extern inline cc csch(cc z) {return 1.0 / sinh(z);}

// Arctrig
extern inline cc asin(cc z) {return .5*i * log(i*z + sqrt(1.0 - z*z));}
extern inline cc acos(cc z) {return .5*pi  + i * log(i*z + sqrt(1.0 - z*z));}
extern inline cc atan(cc z) {return .5*i * (log(1.0 - i*z) - log(1.0 + i*z));}
extern inline cc asec(cc z) {return .5*pi + i*(log(1.0 - 1.0/(z*z)) + i/z);}
extern inline cc acsc(cc z) {return -i * (log(1.0 - 1.0/(z*z)) + i/z);}
extern inline cc acot(cc z) {return .5*i * (log((z-i)/z) - log((z+i)/z));}

// ArcHyperTrig
extern inline cc asinh(cc z) {return log(z + sqrt(z*z + 1.0));}
extern inline cc acosh(cc z) {return log(z + sqrt(z*z - 1.0));}
extern inline cc atanh(cc z) {return .5*(log(1.0 + z) - log(1.0 - z));}
extern inline cc acsch(cc z) {return log(sqrt(1.0/(z*z) + 1.0) + 1.0/z);}
extern inline cc asech(cc z) {return log(sqrt(1.0/(z*z) - 1.0) + 1.0/z);}
extern inline cc acoth(cc z) {return .5*(log(1.0 + 1.0/z) - log(1.0 - 1.0/z));}
