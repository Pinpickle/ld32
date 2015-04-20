package ;
import openfl.Assets;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;
import flash.text.TextFieldAutoSize;
import com.punkiversal.utils.Key;
import com.punkiversal.utils.Input;
import com.punkiversal.PV;
import flash.text.TextField;
import flash.display.Sprite;
import com.punkiversal.Scene;
class DeathScene extends Scene {
    public function new(score:Int) {
        super();

        var endText:Sprite = new Sprite();


        var fontObj = Assets.getFont('font/Lato-Regular.ttf');
        var lightFont = Assets.getFont('font/Lato-Thin.ttf');
        var format = new TextFormat(fontObj.fontName, 20, 0xAAAAAA);
        format.align = TextFormatAlign.CENTER;
        var bigFormat = new TextFormat(lightFont.fontName, 180, 0xAAAAAA);
        bigFormat.align = TextFormatAlign.CENTER;

        var scoreText = new TextField();
        scoreText.defaultTextFormat = bigFormat;
        scoreText.autoSize = TextFieldAutoSize.CENTER;
        scoreText.text = Std.string(score);
        scoreText.x = (PV.width - scoreText.width) / 2;
        scoreText.y = PV.height / 2 - 130;

        var points = new TextField();
        points.defaultTextFormat = format;
        points.autoSize = TextFieldAutoSize.CENTER;
        points.text = 'Your high score is ' + Std.string(Main.highScore) + '\nWant to try again? Just press space';
        points.x = (PV.width - points.width) / 2;
        points.y = 300;

#if flash
        scoreText.embedFonts = true;
        points.embedFonts = true;
#end

        endText.addChild(scoreText);
        endText.addChild(points);

        addGraphic(endText, 10);
    }

    override public function update() {
        super.update();
        if (Input.pressed(Key.SPACE)) {
            PV.scene = new MainScene();
        }
    }
}
