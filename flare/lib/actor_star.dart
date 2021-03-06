import 'dart:math';
import "actor.dart";
import "actor_node.dart";
import "math/vec2d.dart";
import "stream_reader.dart";
import "actor_path.dart";
import "path_point.dart";

class ActorStar extends ActorProceduralPath
{
    int _numPoints = 5;
    double _innerRadius = 0.0;

    ActorStar makeInstance(Actor resetActor)
    {
        ActorStar instance = new ActorStar();
        instance.copyPath(this, resetActor);
        instance._numPoints = this._numPoints;
        instance._innerRadius = this._innerRadius;
        return instance;
    }

    static ActorStar read(Actor actor, StreamReader reader, ActorStar component)
    {
        if(component == null)
        {
            component = new ActorStar();
        }

        ActorNode.read(actor, reader, component);

        component.width = reader.readFloat32("width");
        component.height = reader.readFloat32("height");
        component._numPoints = reader.readUint32("points");
        component._innerRadius = reader.readFloat32("innerRadius");
        return component;
    }

    @override
    List<PathPoint> get points
    {
        List<PathPoint> _starPoints = <PathPoint>[
            new StraightPathPoint.fromTranslation(Vec2D.fromValues(0.0, -radiusY))
        ];

        double angle = pi/2.0;
        double inc = (pi*2.0)/sides;
        Vec2D sx = Vec2D.fromValues(radiusX, radiusX*_innerRadius);
        Vec2D sy = Vec2D.fromValues(radiusY, radiusY*_innerRadius);

        for(int i = 0; i < sides; i++)
        {
            _starPoints.add(
                new StraightPathPoint.fromTranslation(
                    Vec2D.fromValues(
                        cos(angle)*sx[i%2], 
                        sin(angle)*sy[i%2]
                    )
                )
            );
            angle += inc;
        }
        return _starPoints;
    }
    

    set innerRadius(double val)
    {
        if(val != _innerRadius)
        {
            _innerRadius = val;
            markPathDirty();
        }
    }

    get innerRadius => _innerRadius;

    bool get isClosed => true;
    bool get doesDraw => !this.renderCollapsed;
    double get radiusX => this.width/2;
    double get radiusY => this.height/2;
    int get numPoints => _numPoints;
    int get sides => _numPoints*2;
}