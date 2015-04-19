package entities;
import com.punkiversal.PV;
import flash.display.Shape;
import flash.display.Sprite;
import com.punkiversal.Entity;

class HUD extends Entity {

    private var energyMetre:Shape;

    public function new() {
        super(0, 0);
        layer = 3;

        graphic = new Sprite();

        energyMetre = new Shape();
        energyMetre.graphics.beginFill(0x999999);
        energyMetre.graphics.drawRect(0, 0, PV.width - 20, 10);
        energyMetre.x = 10;
        energyMetre.y = PV.height - 20;

        cast (graphic, Sprite).addChild(energyMetre);
    }

    override public function render() {
        super.render();
        var tool:GravityTool = cast (scene, MainScene).player.gravityTool;
        energyMetre.scaleX = tool.charge / tool.chargeMax;
    }
}
