package hud;

import flixel.FlxG;

class SmallButton extends BaseButton {
    public static final WIDTH = 24;
    public static final HEIGHT = 24;

    public function new(x:Float, y:Float, ?callback:BaseButton->Void) {
        super(x, y, callback);

        loadGraphic("assets/images/hud/small_button.png", true, WIDTH, HEIGHT);
        animation.add("unselected", [0]);
        animation.add("selected", [1]);
        animation.play("unselected");
    }
}
