import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxCollision;

class Tile extends FlxSprite
{
	var hovering:Bool;
	var selected:Bool;
	var row:Int;
	var col:Int;

	public function new(x:Int, y:Int)
	{
		var real_x, real_y:Float;

		if (y % 2 == 0)
		{
			real_x = 48 * x;
		}
		else
		{
			real_x = 48 * x + 24;
		}
		real_y = 8 * y;

		super(real_x, real_y);

		c
		hovering = false;
		selected = false;

		loadGraphic(AssetPaths.tile__png, true, 45, 16);
		animation.add("unselected", [0]);
		animation.add("hover", [1]);
		animation.add("left_up_right_down", [2]);
		animation.add("up_right_down", [3]);
		animation.add("left_right_down", [4]);
		animation.add("left_up_down", [5]);
		animation.add("left_up_right", [6]);
		animation.add("right_down", [7]);
		animation.add("up_down", [8]);
		animation.add("up_right", [9]);
		animation.add("left_down", [10]);
		animation.add("left_right", [11]);
		animation.add("left_up", [12]);
		animation.add("left", [13]);
		animation.add("up", [14]);
		animation.add("right", [15]);
		animation.add("down", [16]);
		animation.add("mid", [17]);
		animation.play("unselected");
	}

	override public function update(elapsed:Float)
	{
		var mouse_pos = FlxG.mouse.getWorldPosition();
		hovering = FlxCollision.pixelPerfectPointCheck(Std.int(mouse_pos.x), Std.int(mouse_pos.y), this);

		if (hovering && FlxG.mouse.justPressedRight)
		{
			selected = !selected;
			if (selected)
			{
				var parent:PlayState = cast(FlxG.state, PlayState);
			}
		}

		animate();
	}

	function animate()
	{
		if (!selected)
		{
			if (hovering)
			{
				animation.play("hover");
			}
			else
			{
				animation.play("default");
			}
		}
	}
}
