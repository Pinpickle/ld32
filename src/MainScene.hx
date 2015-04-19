import entities.HUD;
import entities.Spawner;
import com.punkiversal.Scene;
import com.punkiversal.PV;

import entities.Player;

class MainScene extends Scene
{
	public var player:Player;

	public override function begin()
	{
		player = new Player(PV.width / 2, PV.height / 2);
		add(player);

		add(new HUD());

		add(new Spawner(100, 100));
		add(new Spawner(100, PV.height - 100));
		add(new Spawner(PV.width - 100, PV.height - 100));
		add(new Spawner(PV.width - 100, 100));
		

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
}