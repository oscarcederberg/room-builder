import flixel.system.FlxAssets;
import openfl.geom.Point;
import openfl.display.BitmapData;
import flixel.FlxSprite;
import flixel.util.FlxColor;

class RoomTile extends FlxSprite {
	public static var FLOOR_MID:BitmapData;
	static var floor_point:Point = new Point(3, 104);

	var parent:EditorTile;

	public function new(x:Float, y:Float, parent:EditorTile) {
		super(x, y);

		this.parent = parent;
	}

	public function updateGraphics() {
		makeGraphic(51, 127, FlxColor.TRANSPARENT, true);

		var floor_corner_left = new FlxSprite();
		var floor_corner_up = new FlxSprite();
		var floor_corner_right = new FlxSprite();
		var floor_corner_down = new FlxSprite();
		var floor_side_left = new FlxSprite();
		var floor_side_up = new FlxSprite();
		var floor_side_right = new FlxSprite();
		var floor_side_down = new FlxSprite();

		var wall_corner_left = new FlxSprite();
		var wall_corner_up = new FlxSprite();
		var wall_corner_right = new FlxSprite();
		var wall_corner_down = new FlxSprite();
		var wall_side_left = new FlxSprite();
		var wall_side_left_cut = new FlxSprite();
		var wall_side_left_up = new FlxSprite();
		var wall_side_up = new FlxSprite();
		var wall_side_up_cut = new FlxSprite();
		var wall_side_right = new FlxSprite();
		var wall_side_right_down = new FlxSprite();
		var wall_side_down = new FlxSprite();

		floor_corner_left.loadGraphic("assets/images/floor/corner_left.png");
		floor_corner_up.loadGraphic("assets/images/floor/corner_up.png");
		floor_corner_right.loadGraphic("assets/images/floor/corner_right.png");
		floor_corner_down.loadGraphic("assets/images/floor/corner_down.png");
		floor_side_left.loadGraphic("assets/images/floor/side_left.png");
		floor_side_up.loadGraphic("assets/images/floor/side_up.png");
		floor_side_right.loadGraphic("assets/images/floor/side_right.png");
		floor_side_down.loadGraphic("assets/images/floor/side_down.png");

		wall_corner_left.loadGraphic("assets/images/wall/corner_left.png");
		wall_corner_up.loadGraphic("assets/images/wall/corner_up.png");
		wall_corner_right.loadGraphic("assets/images/wall/corner_right.png");
		wall_corner_down.loadGraphic("assets/images/wall/corner_down.png");
		wall_side_left.loadGraphic("assets/images/wall/side_left.png");
		wall_side_left_cut.loadGraphic("assets/images/wall/side_left_cut.png");
		wall_side_left_up.loadGraphic("assets/images/wall/side_left_up.png");
		wall_side_up.loadGraphic("assets/images/wall/side_up.png");
		wall_side_up_cut.loadGraphic("assets/images/wall/side_up_cut.png");
		wall_side_right.loadGraphic("assets/images/wall/side_right.png");
		wall_side_right_down.loadGraphic("assets/images/wall/side_right_down.png");
		wall_side_down.loadGraphic("assets/images/wall/side_down.png");

		trace(FLOOR_MID);
		this.graphic.bitmap.copyPixels(FLOOR_MID, FLOOR_MID.rect, floor_point);
		if (EditorTile.isSelected(parent.side_down)
			&& EditorTile.isSelected(parent.corner_left)
			&& EditorTile.isSelected(parent.side_left))
			stamp(floor_corner_left, 3, 104);
		if (EditorTile.isSelected(parent.side_left) && EditorTile.isSelected(parent.corner_up) && EditorTile.isSelected(parent.side_up))
			stamp(floor_corner_up, 3, 104);
		if (EditorTile.isSelected(parent.side_up)
			&& EditorTile.isSelected(parent.corner_right)
			&& EditorTile.isSelected(parent.side_right))
			stamp(floor_corner_right, 3, 104);
		if (EditorTile.isSelected(parent.side_right)
			&& EditorTile.isSelected(parent.corner_down)
			&& EditorTile.isSelected(parent.side_down))
			stamp(floor_corner_down, 3, 104);
		if (EditorTile.isSelected(parent.side_left))
			stamp(floor_side_left, 3, 104);
		if (EditorTile.isSelected(parent.side_up))
			stamp(floor_side_up, 3, 104);
		if (EditorTile.isSelected(parent.side_right))
			stamp(floor_side_right, 3, 104);
		if (EditorTile.isSelected(parent.side_down))
			stamp(floor_side_down, 3, 104);

		if (!EditorTile.isSelected(parent.side_left) && !EditorTile.isSelected(parent.side_up))
			stamp(wall_side_left_up);
		else if (!EditorTile.isSelected(parent.side_left) && !EditorTile.isSelected(parent.corner_up))
			stamp(wall_side_left);
		else if (!EditorTile.isSelected(parent.side_left))
			stamp(wall_side_left_cut);
		else if (!EditorTile.isSelected(parent.side_up) && !EditorTile.isSelected(parent.corner_up))
			stamp(wall_side_up);
		else if (!EditorTile.isSelected(parent.side_up))
			stamp(wall_side_up_cut);

		if (!EditorTile.isSelected(parent.side_right) && !EditorTile.isSelected(parent.side_down))
			stamp(wall_side_right_down);
		else if (!EditorTile.isSelected(parent.side_right))
			stamp(wall_side_right);
		else if (!EditorTile.isSelected(parent.side_down))
			stamp(wall_side_down);

		if (!EditorTile.isSelected(parent.side_down) && !EditorTile.isSelected(parent.side_left))
			stamp(wall_corner_left);
		if (EditorTile.isSelected(parent.side_left) && !EditorTile.isSelected(parent.corner_up) && EditorTile.isSelected(parent.side_up))
			stamp(wall_corner_up);
		if (!EditorTile.isSelected(parent.side_up) && !EditorTile.isSelected(parent.side_right))
			stamp(wall_corner_right);
		if (EditorTile.isSelected(parent.side_right)
			&& !EditorTile.isSelected(parent.corner_down)
			&& EditorTile.isSelected(parent.side_down))
			stamp(wall_corner_down);

		floor_corner_left.destroy();
		floor_corner_up.destroy();
		floor_corner_right.destroy();
		floor_corner_down.destroy();
		floor_side_left.destroy();
		floor_side_up.destroy();
		floor_side_right.destroy();
		floor_side_down.destroy();

		wall_corner_left.destroy();
		wall_corner_up.destroy();
		wall_corner_right.destroy();
		wall_corner_down.destroy();
		wall_side_left.destroy();
		wall_side_left_up.destroy();
		wall_side_up.destroy();
		wall_side_right.destroy();
		wall_side_right_down.destroy();
		wall_side_down.destroy();
	}
}
