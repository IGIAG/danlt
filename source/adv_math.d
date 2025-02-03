module adv_math;

import std.stdio;
import std.math;
import adv_math;
import std.functional;
import ggplotd.aes : aes;
import ggplotd.axes : xaxisLabel, yaxisLabel;
import ggplotd.ggplotd : GGPlotD, putIn;
import ggplotd.geom : geomPoint;
import std.algorithm;
import std.array;
import std.functional;


struct Vector2
{
    double x;
    double y;
}

class UniMathFunction
{
    public double delegate(double) expression;

    public bool cont = true;

    public double point_derivative(double x, double epsilon)
    {
        double eminus = x - epsilon;
        double eplus = x + epsilon;

        return (expression(eplus) - expression(eminus)) / (eplus - eminus);
    }

    public UniMathFunction derivative(double epsilon)
    {
        auto derivative_expression = (double x) => point_derivative(x, epsilon);
        return new UniMathFunction(derivative_expression);
    }
    public double definite_integral(double lb,double hb,double dx)
    {
        bool neg = false;
        if(lb > hb){
            double temp = lb;
            lb = hb;
            hb = temp;
            neg = true;
        }
        double riemann_sum = 0;
        while (lb < hb)
        {
            riemann_sum += (expression(lb) + expression(lb + dx)) * dx * 0.5;
            lb += dx;
        }
        return neg ? -riemann_sum : riemann_sum;
    }

    public UniMathFunction indefinite_integral(double dx,double c)
    {
        auto integral_expression = (double x) => definite_integral(0,x, dx) + c;
        return new UniMathFunction(integral_expression);
    }

    public Vector2[] probe(double from, double to, double delta)
    {
        Vector2[] plot = [];
        while (from < to + delta)
        {
            plot ~= Vector2(from, expression(from));
            from += delta;
        }
        return plot;
    }

    public void plot(double from, double to, double delta, string file_name)
    {
        auto gg = probe(from, to, delta).map!((vector) =>
                aes!("x", "y")(vector.x, vector.y))
            .array 
            .geomPoint.putIn(GGPlotD());
        gg = "x".xaxisLabel.putIn(gg);
        gg = "Y".yaxisLabel.putIn(gg);
        gg.save(file_name);
    }

    public this(double delegate(double) expression)
    {
        this.expression = expression;
    }
}
