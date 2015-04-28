package entities.interactables;

import com.punkiversal.math.Vector;
import com.punkiversal.masks.Polygon;
import flash.display.Shape;

class Droppable extends Interactable
{
	public static var mainColour:Int = 0x6d9243;

    public function new(x:Float = 0, y:Float = 0) {
        super(x, y);

        _forceMap.set(Type.getClassName(Droppable), -1000);
        _forceMap.set(Type.getClassName(Collectable), -1000);
        _forceMap.set(Type.getClassName(Smashable), -1000);
        _forceMap.set(Type.getClassName(Player), -100);

        var squarePoints:Array<Vector> = [
            new Vector(-9, 0),
            new Vector(0, -9),
            new Vector(9, 0),
            new Vector(0, 9)
        ];

        snapAngles = [0, 90, 180, 270];

        cast (graphic, Shape).graphics.beginFill(mainColour);
        cast (graphic, Shape).graphics.moveTo(squarePoints[0].x, squarePoints[0].y);
        cast (graphic, Shape).graphics.lineTo(squarePoints[1].x, squarePoints[1].y);
        cast (graphic, Shape).graphics.lineTo(squarePoints[2].x, squarePoints[2].y);
        cast (graphic, Shape).graphics.lineTo(squarePoints[3].x, squarePoints[3].y);

        mask = new Polygon(squarePoints);

        type = "collectable";

    }

    override public function update() {

        if (!dead) {
            var c:Interactable = cast collide("collectable", x, y);

            if ((c != null) && (Std.is(c, Droppable))) {
                cast (scene, MainScene).player.health -= 1;
                Main.playBad();
                cast (scene, MainScene).animator.consume(this, 'badbubble', cast c);
            }
        }

        super.update();
    }

    override public function render() {
        graphic.rotation = -angle;
        super.render();
    }

    override private function set_angle(v:Float):Float {
        cast (mask, Polygon).angle = v;
        _angle = v;
        return _angle;
    }

}