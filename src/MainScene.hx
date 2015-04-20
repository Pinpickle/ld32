import entities.InteractableAnimator;
import entities.interactables.Interactable;
import com.punkiversal.Entity;
import entities.Dropper;
import entities.HUD;
import entities.Spawner;
import com.punkiversal.Scene;
import com.punkiversal.PV;

import entities.Player;

class MainScene extends Scene
{
	public var player:Player;
	public var hud:HUD;
	public var animator:InteractableAnimator;
	public var score:Int = 0;

	private var timer:Float = 0;
	private var spawnerIndex = 0;

	public static var spawnerLocations:Array<Array<Float>>;
	public var spawners:List<Spawner>;

	public static function init() {
		spawnerLocations = [
			[PV.halfWidth - 200, PV.halfHeight],
			[PV.halfWidth + 200, PV.halfHeight],
			[PV.halfWidth - 300, PV.halfHeight - 80],
			[PV.halfWidth + 300, PV.halfHeight + 80],
			[PV.halfWidth - 300, PV.halfHeight + 80],
			[PV.halfWidth + 300, PV.halfHeight - 80]
		];
	}

	public override function begin()
	{
		animator = new InteractableAnimator();
		add(animator);

		player = new Player(PV.width / 2, PV.height / 2);
		add(player);

		hud = new HUD();
		add(hud);

		add(new Spawner(PV.halfWidth - 100, PV.halfHeight - 100));
		add(new Spawner(PV.halfWidth + 100, PV.halfHeight - 100));
		add(new Spawner(PV.halfWidth + 100, PV.halfHeight + 100));
		add(new Spawner(PV.halfWidth - 100, PV.halfHeight + 100));

		var l:Array<Float>;
		spawners = new List<Spawner>();
		for (l in spawnerLocations) {
			spawners.add(new Spawner(l[0], l[1]));
		}

		add(new Dropper(PV.halfWidth, 50));
		add(new Dropper(PV.halfWidth, PV.height - 50));

		score = 0;
		timer = 0;


/*add(new Collectable(PV.width / 2 - 100, PV.height / 2 - 100));
		add(new Collectable(PV.width / 2 + 100, PV.height / 2 - 100));
		add(new Collectable(PV.width / 2 + 100, PV.height / 2 + 100));
		add(new Collectable(PV.width / 2 - 100, PV.height / 2 + 100));

		add(new Smashable(PV.width / 2 - 100, PV.height / 2));
		add(new Smashable(PV.width / 2 + 100, PV.height / 2));
		add(new Smashable(PV.width / 2, PV.height / 2 + 100));
		add(new Smashable(PV.width / 2, PV.height / 2 - 100));

		add(new Droppable(PV.width / 2 - 200, PV.height / 2));
		add(new Droppable(PV.width / 2 + 200, PV.height / 2));
		add(new Droppable(PV.width / 2, PV.height / 2 + 200));
		add(new Droppable(PV.width / 2, PV.height / 2 - 200));*/
	}

	public function getEntities():List<Entity> {
		return _update;
	}

	override public function update() {
		if (spawners.length > 0) {
			timer += PV.elapsed;

			if (timer >= 30) {
				timer = 0;
				add(spawners.pop());
			}
		}



		super.update();
	}

	public function addScore(add:Int):Int {
		score += add;
		hud.setScore(score);
		return score;
	}
}