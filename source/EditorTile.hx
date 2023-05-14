import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxCollision;

class EditorTile extends FlxSprite {
	public var selected:Bool;
	public var corner_left:EditorTile;
	public var corner_up:EditorTile;
	public var corner_right:EditorTile;
	public var corner_down:EditorTile;
	public var side_left:EditorTile;
	public var side_up:EditorTile;
	public var side_right:EditorTile;
	public var side_down:EditorTile;

	var parent:PlayState = cast(FlxG.state, PlayState);
	var room_tile:RoomTile;

	public var row:Int;
	public var col:Int;

	var hovering:Bool;

	public function new(col:Int, row:Int) {
		var x, y:Float;

		if (row % 2 == 0) {
			x = 48 * col;
		} else {
			x = 48 * col + 24;
		}
		y = 8 * row;

		super(x, y);

		this.col = col;
		this.row = row;
		hovering = false;
		selected = false;

		room_tile = new RoomTile(x, y, this);
		room_tile.visible = false;
		parent.room_tiles.add(room_tile);

		loadGraphic("assets/images/editor_tile.png", true, 45, 16);
		animation.add("unselected", [0]);
		animation.add("hover", [1]);
		animation.play("unselected");
	}

	public static function isSelected(tile:EditorTile):Bool {
		return tile != null && tile.selected;
	}

	public function populateNeighbours() {
		if (col > 0)
			corner_left = parent.editor_tiles_vec[col - 1][row];
		corner_up = parent.editor_tiles_vec[col][row - 2];
		if (col < PlayState.TILES_COLS - 1)
			corner_right = parent.editor_tiles_vec[col + 1][row];
		corner_down = parent.editor_tiles_vec[col][row + 2];

		if (row % 2 == 0) {
			if (col > 0)
				side_left = parent.editor_tiles_vec[col - 1][row - 1];
			side_up = parent.editor_tiles_vec[col][row - 1];
			side_right = parent.editor_tiles_vec[col][row + 1];
			if (col > 0)
				side_down = parent.editor_tiles_vec[col - 1][row + 1];
		} else {
			side_left = parent.editor_tiles_vec[col][row - 1];
			if (col < PlayState.TILES_COLS - 1)
				side_up = parent.editor_tiles_vec[col + 1][row - 1];
			if (col < PlayState.TILES_COLS - 1)
				side_right = parent.editor_tiles_vec[col + 1][row + 1];
			side_down = parent.editor_tiles_vec[col][row + 1];
		}
	}

	override public function update(elapsed:Float) {
		var mouse_pos = FlxG.mouse.getWorldPosition();
		hovering = FlxCollision.pixelPerfectPointCheck(Std.int(mouse_pos.x), Std.int(mouse_pos.y), this);

		if (hovering && !selected && FlxG.mouse.justPressed) {
			trace("(" + col + ", " + row + ")");
			if (corner_right == null) {
				trace('CR NULL: (${col + 1},$row)');
			}
			if (corner_down == null) {
				trace('CD NULL: ($col,${row + 2})');
			}
			selected = true;
			room_tile.visible = true;
			this.visible = false;

			select();
			selectNeighbours();
		} else if (hovering && selected && FlxG.mouse.justPressed) {
			trace("unselected");
			selected = false;
			room_tile.visible = false;
			this.visible = true;

			selectNeighbours();
		}

		animate();

		super.update(elapsed);
	}

	public function select() {
		room_tile.updateGraphics();
	}

	function selectNeighbours() {
		if (isSelected(corner_left))
			corner_left.select();
		if (isSelected(corner_up))
			corner_up.select();
		if (isSelected(corner_right))
			corner_right.select();
		if (isSelected(corner_down))
			corner_down.select();
		if (isSelected(side_left))
			side_left.select();
		if (isSelected(side_up))
			side_up.select();
		if (isSelected(side_right))
			side_right.select();
		if (isSelected(side_down))
			side_down.select();
	}

	function animate() {
		if (!selected) {
			if (hovering) {
				animation.play("hover");
			} else {
				animation.play("unselected");
			}
		}
	}
}
