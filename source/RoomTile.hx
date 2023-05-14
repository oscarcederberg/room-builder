import flixel.FlxSprite;
import flixel.util.FlxColor;

class RoomTile extends FlxSprite {
	var parent:EditorTile;

	public function new(x:Float, y:Float, parent:EditorTile) {
		super(x, y);

		this.parent = parent;
	}

	public function updateGraphics() {
		makeGraphic(45, 16, FlxColor.TRANSPARENT, true);

		var mid = new FlxSprite();
		var corner_left = new FlxSprite();
		var corner_up = new FlxSprite();
		var corner_right = new FlxSprite();
		var corner_down = new FlxSprite();
		var side_left = new FlxSprite();
		var side_up = new FlxSprite();
		var side_right = new FlxSprite();
		var side_down = new FlxSprite();

		mid.loadGraphic("assets/images/room_tile/mid.png");
		corner_left.loadGraphic("assets/images/room_tile/corner_left.png");
		corner_up.loadGraphic("assets/images/room_tile/corner_up.png");
		corner_right.loadGraphic("assets/images/room_tile/corner_right.png");
		corner_down.loadGraphic("assets/images/room_tile/corner_down.png");
		side_left.loadGraphic("assets/images/room_tile/side_left.png");
		side_up.loadGraphic("assets/images/room_tile/side_up.png");
		side_right.loadGraphic("assets/images/room_tile/side_right.png");
		side_down.loadGraphic("assets/images/room_tile/side_down.png");

		stamp(mid);
		if (EditorTile.isSelected(parent.side_down)
			&& EditorTile.isSelected(parent.corner_left)
			&& EditorTile.isSelected(parent.side_left))
			stamp(corner_left);
		if (EditorTile.isSelected(parent.side_left) && EditorTile.isSelected(parent.corner_up) && EditorTile.isSelected(parent.side_up))
			stamp(corner_up);
		if (EditorTile.isSelected(parent.side_up)
			&& EditorTile.isSelected(parent.corner_right)
			&& EditorTile.isSelected(parent.side_right))
			stamp(corner_right);
		if (EditorTile.isSelected(parent.side_right)
			&& EditorTile.isSelected(parent.corner_down)
			&& EditorTile.isSelected(parent.side_down))
			stamp(corner_down);
		if (parent.side_left != null && parent.side_left.selected)
			stamp(side_left);
		if (parent.side_up != null && parent.side_up.selected)
			stamp(side_up);
		if (parent.side_right != null && parent.side_right.selected)
			stamp(side_right);
		if (parent.side_down != null && parent.side_down.selected)
			stamp(side_down);

		mid.destroy();
		corner_left.destroy();
		corner_up.destroy();
		corner_right.destroy();
		corner_down.destroy();
		side_left.destroy();
		side_up.destroy();
		side_right.destroy();
		side_down.destroy();
	}
}
