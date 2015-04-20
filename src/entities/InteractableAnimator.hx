package entities;


import flash.display.Shape;
import com.punkiversal.PV;
import flash.display.Sprite;
import entities.interactables.Interactable;
import flash.display.DisplayObject;
import com.punkiversal.Entity;
class InteractableAnimator extends Entity {

    private var animators:List<InteractableAnimation>;
    private var _remove:List<InteractableAnimation>;

    public function new() {
        super(0, 0);
        layer = 10;
        graphic = new Sprite();
        animators = new List<InteractableAnimation>();
        _remove = new List<InteractableAnimation>();
    }

    public function finish(animator:InteractableAnimation) {
        _remove.add(animator);
    }

    override public function render() {
        for (anim in animators) {
            anim.update();
        }

        for (anim in _remove) {
            animators.remove(anim);
            for (e in anim.entities) {
                scene.recycle(e);
            }
            cast (graphic, Sprite).removeChild(anim.graphic);
        }

        _remove.clear();
    }

    public function consume(e1:Interactable, type:String = 'fall', e2:Interactable = null) {
        var animator = new InteractableAnimation(this);

        cast (graphic, Sprite).addChild(animator.graphic);
        animator.entities.add(e1);
        e1.dead = true;
        scene.remove(e1);
        if (e2 != null) {
            animator.entities.add(e2);
            e2.dead = true;
            scene.remove(e2);
        }

        animators.add(animator);

        animator.setType(type);
    }
}

class InteractableAnimation {
    public var entities:List<Entity>;
    public var graphic:Sprite;
    public var through:Float = 0;
    public var finished:Bool = false;

    private var step:Float = 1;
    private var type:String = '';
    private var updateFunc:Void -> Void;
    private var _parent:InteractableAnimator;

    private var bubble:Shape;

    public function new(parent) {
        _parent = parent;
        graphic = new Sprite();
        entities = new List<Entity>();
    }

    public function setType(t:String) {
        type = t;
        switch (type) {
            case 'fall':
                setupFall();
                updateFunc = updateFall;
            case 'goodbubble':
                setupBubble(0x00FF00);
                updateFunc = updateBubble;
            case 'badbubble':
                setupBubble(0xFF0000);
                updateFunc = updateBubble;
            case 'collect':
                setupCollect();
                updateFunc = updateCollect;
        }
    }

    public function update() {
        through += step * PV.elapsed;
        if (through < 1) {
            updateFunc();
        } else {
            _parent.finish(this);
        }
    }


    private function setupCollect() {
        step = 2;
        for (e in entities) {
            graphic.addChild(e.graphic);
        }
    }

    private function updateCollect() {
        var p:Player = cast (_parent.scene, MainScene).player;
        for (e in entities) {
            e.graphic.x = PV.lerp(e.x, p.x, through);
            e.graphic.y = PV.lerp(e.y, p.y, through);
        }
    }


    private function setupBubble(col:Int = 0xFF0000) {
        var x:Float = 0, y:Float = 0;
        step = 4;
        for (e in entities) {
            x += e.x;
            y += e.y;
        }
        x /= entities.length;
        y /= entities.length;

        for (e in entities) {
            e.graphic.x -= x;
            e.graphic.y -= y;
            graphic.addChild(e.graphic);
        }

        graphic.x = x;
        graphic.y = y;

        bubble = new Shape();
        bubble.graphics.beginFill(col, 0.8);
        bubble.graphics.lineStyle(4, col);
        bubble.graphics.drawCircle(0, 0, 30);
        bubble.alpha = 0;

        graphic.addChild(bubble);
    }

    private function updateBubble() {
        graphic.scaleX = graphic.scaleY = 1 - through;
        bubble.alpha = through;
    }


    private function setupFall() {
        step = 2;
        for (e in entities) {
            graphic.addChild(e.graphic);
        }
    }

    private function updateFall() {
        for (e in entities) {
            e.graphic.scaleX = e.graphic.scaleY = 1 - through;
            e.graphic.alpha = 1 - through;
        }
    }


    private function complete() {

    }
}
