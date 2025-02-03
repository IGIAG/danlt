module fourier;

import adv_math;
import std.math;
import std.stdio;

UniMathFunction to_fourier_series(UniMathFunction f,double lb,double hb,uint k){
    double T = abs(hb - lb);
    double a_zero = (2/T) * f.definite_integral(lb,hb,0.001);
    double[] cos_coefficients = [a_zero];
    double[] sin_coefficients = [0];

    for(int n = 1;n <= k;n++){
        UniMathFunction cosfunc = new UniMathFunction(x => f.expression(x) * cos(2 * n * PI * x * (1/T)));
        UniMathFunction sinfunc = new UniMathFunction(x => f.expression(x) * sin(2 * n * PI * x * (1/T)));
        cos_coefficients ~= (2/T) * cosfunc.definite_integral(lb,hb,0.001);
        sin_coefficients ~= (2/T) * sinfunc.definite_integral(lb,hb,0.001);
        writeln(cos_coefficients);
        writeln(sin_coefficients);
    }

    UniMathFunction fourier_approx = new UniMathFunction(x => fourier_sum(x,T,cos_coefficients,sin_coefficients));

    return fourier_approx;
}

private double fourier_sum(double x,double T,double[] cos_coefficients,double[] sin_coefficients){
    double sum = cos_coefficients[0]/2;
    for(uint n = 1;n < cos_coefficients.length;n++){
        sum += cos_coefficients[n] * cos(2 * n * PI * x * (1/T));
        sum += sin_coefficients[n] * sin(2 * n * PI * x * (1/T));
    }
    return sum;
}