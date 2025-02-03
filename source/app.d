import std.stdio;
import std.math;
import adv_math;
import std.array;
import fourier;
import taylor;
import std.functional;
import plotter;

void main()
{
	UniMathFunction unifunc = new UniMathFunction((&func).toDelegate);
	unifunc.cont = true;
	
	for(int n = 1;n<5;n++){
		import std.format;
		writeln(n);
		plot(-10,10,-10,10,[unifunc.indefinite_integral(1/n + 0.01,-1)/*taylor_5*/],0.001,format("./renders/integral_%s.png",n));
	}
	
	
}
double func(double x){
	return sin(x);
	
}