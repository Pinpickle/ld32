package entities;
import flash.text.TextFieldAutoSize;
import openfl.Assets;
import flash.text.TextFormatAlign;
import flash.text.TextFormat;
import flash.text.TextField;
import com.punkiversal.PV;
import flash.display.Shape;
import flash.display.Sprite;
import com.punkiversal.Entity;

class HUD extends Entity {

    private var energyMetre:Shape;
    private var scoreText:TextField;

    public function new() {
        super(0, 0);
        layer = 3;

        graphic = new Sprite();

        energyMetre = new Shape();
        energyMetre.graphics.beginFill(0x999999);
        energyMetre.graphics.drawRect(0, 0, PV.width - 20, 10);
        energyMetre.x = 10;
        energyMetre.y = PV.height - 20;

        var fontObj = Assets.getFont(PV.defaultFont);
        var format = new TextFormat(fontObj.fontName, 30, 0x999999);
        format.align = TextFormatAlign.RIGHT;

        scoreText = new TextField();
        scoreText.defaultTextFormat = format;
        scoreText.autoSize = TextFieldAutoSize.RIGHT;
        scoreText.text = "0";

        scoreText.x = PV.width - 10 - scoreText.width;
        scoreText.y = PV.height - 20 - scoreText.height;

        cast (graphic, Sprite).addChild(energyMetre);
        cast (graphic, Sprite).addChild(scoreText);
    }

    override public function render() {
        super.render();
        var tool:GravityTool = cast (scene, MainScene).player.gravityTool;
        energyMetre.scaleX = tool.charge / tool.chargeMax;
    }

    public function setScore(score:Int) {
        scoreText.text = Std.string(score);
        scoreText.x = (PV.width - scoreText.textWidth - 10);
    }
}
