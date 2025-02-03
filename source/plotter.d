module plotter;

import adv_math;

import std.stdio;
import std.math;
import adv_math;
import std.functional;
import ggplotd.aes;
import ggplotd.axes;
import ggplotd.ggplotd;
import ggplotd.geom;
import std.algorithm;
import std.array;

private struct Vector2Color
{
    double x;
    double y;
    uint color;
}

public void plot(double xmin, double xmax, double ymin, double ymax, UniMathFunction[] funcs, double dx, string file_name)
{
    auto gg = GGPlotD();

    foreach (i, UniMathFunction func; funcs)
    {
        Vector2Color[] vectors = [];
        vectors ~= func.probe(xmin, xmax, dx)
            .map!((vector) => Vector2Color(vector.x, vector.y, cast(uint) i + 2)).array;

        if (func.cont)
        {
            gg = vectors.map!((vector) =>
                     // Map data to aesthetics (x, y and colour)
                    aes!("x", "y", "colour", "size")(clamp(vector.x, xmin, xmax), clamp(vector.y, ymin, ymax), vector
                        .color, 2))
                .array // Draw points
                .geomLine.putIn(gg);
        }
        else
        {
            gg = vectors.map!((vector) =>
                     // Map data to aesthetics (x, y and colour)
                    aes!("x", "y", "colour", "size")(clamp(vector.x, xmin, xmax), clamp(vector.y, ymin, ymax), vector
                        .color, 2))
                .array // Draw points
                .geomPoint.putIn(gg);
        }

    }

    // Axis labels
    gg = "x".xaxisLabel.putIn(gg);
    gg = "y".yaxisLabel.putIn(gg);
    gg.margins(-2,2);
    gg = "Wizualizacja".title.putIn(gg);

    gg.save(file_name, 1000, 1000);
}
