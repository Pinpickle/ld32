package entities.interactables;

import com.punkiversal.Entity;

class Interactable extends PhysicsEntity {

    private var _spawner:Spawner;

    public function new(x:Float, y:Float) {
        super(x, y);
        layer = 9;
    }

    override public function removed() {
        _spawner.deChild(this);
        _spawner = null;
    }

    public function setParent(s:Spawner) {
        _spawner = s;
    }


}
