import com.punkiversal.Scene;
import com.punkiversal.PV;

import entities.Player;

class MainScene extends Scene
{
	public override function begin()
	{
		add(new Player(PV.width / 2, PV.height / 2));
	}
}