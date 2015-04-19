import com.punkiversal.Engine;
import com.punkiversal.PV;
import com.punkiversal.utils.Input;
import com.punkiversal.utils.Key;

import flash.display.StageScaleMode;
import flash.ui.Mouse;

class Main extends Engine
{

	override public function init()
	{
#if debug
		PV.console.enable();
#end

		PV.stage.scaleMode = StageScaleMode.SHOW_ALL;
		Mouse.hide();

		entities.GravityTool.init();

		PV.scene = new MainScene();
	}

	public static function main() { new Main(800, 450); }

}