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


        var fontObj = Assets.getFont(PV.defaultFont);
        var lightFont = Assets.getFont('font/Lato-Thin.ttf');
        var format = new TextFormat(fontObj.fontName, 20, 0xAAAAAA);
        format.align = TextFormatAlign.CENTER;
        var bigFormat = new TextFormat(lightFont.fontName, 180, 0xAAAAAA);
        bigFormat.align = TextFormatAlign.CENTER;

        var youGot = new TextField();
        youGot.defaultTextFormat = format;
        youGot.autoSize = TextFieldAutoSize.CENTER;
        youGot.text = "You Got";
        youGot.x = (PV.width - youGot.width) / 2;
        youGot.y = 50 - youGot.height / 2;

        var scoreText = new TextField();
        scoreText.defaultTextFormat = bigFormat;
        scoreText.autoSize = TextFieldAutoSize.CENTER;
        scoreText.text = Std.string(score);
        scoreText.x = (PV.width - scoreText.width) / 2;
        scoreText.y = PV.height / 2 - scoreText.height / 2;

        var points = new TextField();
        points.defaultTextFormat = format;
        points.autoSize = TextFieldAutoSize.CENTER;
        points.text = 'Your high score is ' + Std.string(Main.highScore) + '\nWant to try again? Just press space';
        points.x = (PV.width - points.width) / 2;
        points.y = 340 - points.height / 2;

        var tryagain = new TextField();
        tryagain.defaultTextFormat = format;
        tryagain.autoSize = TextFieldAutoSize.CENTER;
        tryagain.text = '';
        tryagain.x = (PV.width - tryagain.width) / 2;
        tryagain.y = 380 - tryagain.height / 2;

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
