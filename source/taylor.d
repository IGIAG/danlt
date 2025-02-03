module taylor;

import adv_math;
import std.math;
import std.mathspecial;
import std.stdio;

UniMathFunction to_taylor_series(UniMathFunction source,double a,uint n){

    UniMathFunction f = new UniMathFunction(source.expression);

    double[] f_prime_a = [];
    uint k = 0;
    while(k <= n){
        f_prime_a ~= f.expression(a);
        f = f.derivative(0.001);
        k++;
    }

    

    UniMathFunction taylor_approx = new UniMathFunction(x => taylor_sum(x,a,f_prime_a));

    return taylor_approx;
}

private double taylor_sum(double x,double a,double[] f_prime_a){
    double sum = f_prime_a[0];
    for(uint k = 1;k < f_prime_a.length;k++){
        sum += f_prime_a[k] * pow((x - a),k)/gamma(k);
    }
    return sum;
}