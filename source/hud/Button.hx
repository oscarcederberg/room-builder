package hud;

import flixel.FlxG;

class Button extends BaseButton {
    public static final WIDTH = 48;
    public static final HEIGHT = 48;

    public function new(x:Float, y:Float, ?callback:BaseButton->Void) {
        super(x, y, callback);

        loadGraphic("assets/images/hud/button.png", true, WIDTH, HEIGHT);
        animation.add("unselected", [0]);
        animation.add("selected", [1]);
        animation.play("unselected");
    }
}
