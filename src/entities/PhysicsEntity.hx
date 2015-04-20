//More of a game entity than a physics entity

package entities;

import com.punkiversal.PV;
import com.punkiversal.Entity;

class PhysicsEntity extends Entity
{

	public var xSpeed:Float = 0;
	public var ySpeed:Float = 0;
	public var aSpeed:Float = 0;

	public var stopAtSolid:Bool = false;
	public var forceEffected:Bool = true;

	public var restitution:Float = 0;
	public var friction:Float = 0.1;

	private var snapAngles:Array<Float> = [0];

	private var _forceMap:Map<String, Float>;
	private var forceField:Bool = false;

	function new(x:Float = 0, y:Float = 0) {
		super(x, y);
		_forceMap = new Map<String, Float>();
		_class = Type.getClassName(Type.getClass(this));
	}

	override public function update() 
	{
		xSpeed += Utils.friction(xSpeed, friction);
		ySpeed += Utils.friction(ySpeed, friction);
		aSpeed += Utils.friction(aSpeed, friction);

		angle += aSpeed * PV.elapsed;

		var xAdd:Float = xSpeed * PV.elapsed;
		var yAdd:Float = ySpeed * PV.elapsed;

		if (forceField) {
			var list:List<Entity> = cast (scene, MainScene).getEntities();
			var e:Entity;
			var p:PhysicsEntity;
			var m:Float;
			var d:Float;
			var f:Float;
			var rad = (width * width + height * height);

			for (e in list) {
				if ((Std.is(e, PhysicsEntity)) && (e != this)) {
					p = cast e;
					if (_forceMap.exists(p._class)) {
						d = Math.pow(Math.abs(p.x - x), 2) + Math.pow(Math.abs(p.y - y), 2);
						f = _forceMap.get(p._class);
						if (d * 4 < p.width * p.width + p.height * p.height + rad + 100) {
							m = -Math.abs(f) * PV.elapsed / 10;
						} else {
							m = f * PV.elapsed / Math.max(d, 100);
						}

						p.force(PV.angle(p.x, p.y, x, y), m);
					}
				}
			}
		}

		if ((stopAtSolid) && (collide("solid", x + xAdd, y + yAdd) != null))
		{
			//It's crude, I'm sorry
			var xSgn:Int = Utils.sgn(xAdd);
			var ySgn:Int = Utils.sgn(yAdd);

			xAdd = Math.abs(xAdd);
			yAdd = Math.abs(yAdd);

			var xFrac:Float = xAdd - Math.floor(xAdd);
			var yFrac:Float = yAdd - Math.floor(yAdd);

			var nextStep:Float;

			while(xAdd > 0) 
			{
				nextStep = xAdd < 1 ? xFrac * xSgn : xSgn;
				if (collide("solid", x + nextStep, y) == null)
				{
					x += nextStep;
					xAdd -= 1;
				}
				else
				{
					/*if (xSgn > 0)
					{
						x = Math.fceil(x);
					}
					if (xSgn < 0)
					{
						x = Math.ffloor(x);
					}*/
					xSpeed = -xSpeed * restitution;
					break;
				}
			}

			while(yAdd > 0) 
			{
				nextStep = yAdd < 1 ? yFrac * ySgn : ySgn;
				if (collide("solid", x, y + nextStep) == null)
				{
					y += nextStep;
					yAdd -= 1;
				}
				else
				{
					/*if (ySgn > 0)
					{
						y = Math.fceil(y);
					}
					if (ySgn < 0)
					{
						y = Math.ffloor(y);
					}*/
					ySpeed = -ySpeed * restitution;
					break;
				}
			}
		}
		else
		{
			x += xAdd;
			y += yAdd;
		}

		super.update();
	}

	public function force(ang:Float, mag:Float) {
		// While ang is still in degrees, find nearest snap angle
		var snapTest:Float, snap:Float = 0, lastDist = 360;
		for (snapTest in snapAngles) {
			var dForward = Utils.normaliseAngle(ang - angle);
			var dBackward = Utils.normaliseAngle(angle - ang);

			var test = dForward < dBackward ? dForward : dBackward;

			if (test < lastDist) {
				snap = snapTest;
				lastDist = test;
			}
		}

		ang *= PV.RAD;
		xSpeed += Math.cos(ang) * mag;
		ySpeed += Math.sin(ang) * mag;

		// Angular velocity



		aSpeed += mag * Math.abs(Math.sin(ang - (angle + snap) * PV.RAD));
	}

	private var _angle:Float = 0;
	private var angle(get, set):Float;
	private function get_angle():Float {
		return _angle;
	}
	private function set_angle(v:Float) {
		_angle = v;
		return _angle;
	}
}