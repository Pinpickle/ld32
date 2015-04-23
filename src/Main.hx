import com.punkiversal.utils.Data;
import com.punkiversal.Sfx;
import flash.display.StageAlign;
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
		PV.defaultFont = 'font/Lato-Light.ttf';

		Data.load('pinpickle-ld32-save');
		highScore = Data.readInt('highScore', 0);
		muted = Data.readBool('muted', false);

		initSounds();
		MainScene.init();
		entities.Player.init();

		PV.screen.color = 0xEEEEEE;

		PV.scene = new MainScene();
	}

	public static var highScore:Int = 0;
	public static var lastScore:Int = 0;
	public static var muted:Bool = false;
#if flash
	public static var musicSuffix:String = '.mp3';
#else
	public static var musicSuffix:String = '.ogg';
#end

	override public function update() {
		super.update();

		if (Input.pressed(Key.M)) {
			if (muted) {
				muted = false;
				PV.volume = 1;
			} else {
				muted = true;
				PV.volume = 0;
			}
			Data.write('muted', muted);
			Data.save('pinpickle-ld32-save');
		}

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

	private static var _niceSounds:List<Sfx>;
	private static var _availableNice:List<Sfx>;

	private static var _badSounds:List<Sfx>;
	private static var _availableBad:List<Sfx>;



	private static function initSounds() {
		var sound:Sfx = new Sfx('audio/bg-audio' + musicSuffix);
		sound.loop(0.2);

		if (muted) {
			PV.volume = 0;
		}

		_niceSounds = new List<Sfx>();
		_availableNice = new List<Sfx>();

		_badSounds = new List<Sfx>();
		_availableBad = new List<Sfx>();

		for (name in ['audio/piano1', 'audio/piano2', 'audio/piano3', 'audio/piano4']) {
			_availableNice.add(new Sfx(name + musicSuffix));
		}

		Sfx.setVolume('bad', 0.7);
		for (name in ['audio/bad1', 'audio/bad2', 'audio/bad3', 'audio/bad4']) {
			var s:Sfx = new Sfx(name + musicSuffix);
			s.type = 'bad';
			_availableBad.add(s);
		}

		updateSounds();

	}

	private static function updateSounds() {
		updateSoundList(_availableNice, _niceSounds);
		updateSoundList(_availableBad, _badSounds);
	}

	private static function updateSoundList(available:List<Sfx>, fill:List<Sfx>) {
		for (sfx in fill) {
			if (!sfx.playing) {
				available.add(sfx);
				fill.remove(sfx);
			}
		}
	}

	private static function playFromList(list:List<Sfx>, fill:List<Sfx>, pan:Float = 0) {
		updateSounds();
		if (list.length > 0) {
			var ind:Int = Math.floor(Math.random() * list.length);
			var i = 0;
			for(sfx in list) {
				if (i == ind) {
					sfx.play();
					list.remove(sfx);
					fill.add(sfx);
				}
				i ++;
			}
		}
	}

	public static function playNice(pan:Float = 0) {
		playFromList(_availableNice, _niceSounds, pan);
	}

	public static function playBad(pan:Float = 0) {
		playFromList(_availableBad, _badSounds, pan);
	}

}
