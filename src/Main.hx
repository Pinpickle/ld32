import com.punkiversal.debug.Console.TraceCapture;
import openfl.gl.GL;
import com.punkiversal.Engine;
import com.punkiversal.PV;
import com.punkiversal.utils.Input;
import com.punkiversal.utils.Key;

import flash.display.StageScaleMode;
import flash.display.StageQuality;
import flash.ui.Mouse;

class Main extends Engine
{
#if debug
	private var consoleOn:Bool = true;
#end

	override public function init()
	{
#if debug
		PV.console.enable(TraceCapture.Yes);
#end

		PV.stage.scaleMode = StageScaleMode.SHOW_ALL;
		PV.stage.quality = StageQuality.BEST;

#if !debug
		Mouse.hide();
#end
		entities.Player.init();

		PV.screen.color = 0xEEEEEE;

		PV.scene = new MainScene();
	}

	override public function update() {
		super.update();
#if debug
		if (Input.pressed(Key.P)) {
			if (consoleOn) {
				consoleOn = false;
				PV.console.hide();
			} else {
				consoleOn = true;
				PV.console.show();
			}
		}
#end
	}

	public static function main() {

		new Main(800, 450);
	}

}