package hud;

import flixel.FlxG;
import flixel.FlxSprite;

abstract class BaseButton extends FlxSprite {
    private var callback:BaseButton->Void;
    private var selected:Bool = false;
    private var held:Bool = false;

    public function new(x:Float, y:Float, ?callback:BaseButton->Void) {
        super(x, y);

        this.callback = callback;
    }

    override function update(elapsed:Float) {
        var point = FlxG.mouse.getScreenPosition(this.camera);

        if (overlapsPoint(point) && FlxG.mouse.pressed) {
            this.held = true;
        } else {
            this.held = false;
        }

        if (this.held || this.selected) {
            animation.play("selected");
        } else {
            animation.play("unselected");
        }

        super.update(elapsed);
    }

    public function handleInput():Bool {
        var point = FlxG.mouse.getScreenPosition(this.camera);

        if (overlapsPoint(point)) {
            if (FlxG.mouse.justReleased && !this.selected) {
                setSelected(true);
            }

            return true;
        }

        return false;
    }

    public function isSelected():Bool {
        return this.selected;
    }

    public function setSelected(selected:Bool) {
        this.selected = selected;

        if (this.selected && this.callback != null) {
            callback(this);
        }
    }
}
