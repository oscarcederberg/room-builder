package hud;

import flixel.FlxG;
import flixel.FlxSprite;
import haxe.display.Display.Package;
import haxe.macro.Compiler.PackageRule;

class Button extends FlxSprite {
	public static final WIDTH = 48;
	public static final HEIGHT = 48;

	private var callback:Button->Void;
	private var selected:Bool = false;
	private var held:Bool = false;

	public function new(x:Float, y:Float, ?callback:Button->Void) {
		super(x, y);

		this.callback = callback;

		loadGraphic("assets/images/hud/button.png", true, WIDTH, HEIGHT);
		animation.add("unselected", [0]);
		animation.add("selected", [1]);
		animation.play("unselected");
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

		if (this.callback != null) {
			callback(this);
		}
	}
}
