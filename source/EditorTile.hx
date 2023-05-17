import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxCollision;

enum Neighbour {
	CORNER_LEFT;
	CORNER_UP;
	CORNER_RIGHT;
	CORNER_DOWN;
	SIDE_LEFT;
	SIDE_UP;
	SIDE_RIGHT;
	SIDE_DOWN;
}

class EditorTile extends FlxSprite {
	public var selected:Bool;

	var parent:PlayState = cast(FlxG.state, PlayState);
	var neighbours:Map<Neighbour, EditorTile> = new Map();
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

		room_tile = new RoomTile(x - 3, y - 104, this);
		room_tile.visible = false;
		parent.room_tiles.add(room_tile);

		loadGraphic("assets/images/editor_tile.png", true, 45, 16);
		animation.add("unselected", [0]);
		animation.add("hover", [1]);
		animation.play("unselected");
	}

	public function isNeighbourSelected(neighbour:Neighbour):Bool {
		return neighbours[neighbour] != null && neighbours[neighbour].selected;
	}

	public function populateNeighbours() {
		if (col > 0)
			neighbours[CORNER_LEFT] = parent.editor_tiles_vec[col - 1][row];
		neighbours[CORNER_UP] = parent.editor_tiles_vec[col][row - 2];
		if (col < PlayState.TILES_COLS - 1)
			neighbours[CORNER_RIGHT] = parent.editor_tiles_vec[col + 1][row];
		neighbours[CORNER_DOWN] = parent.editor_tiles_vec[col][row + 2];

		if (row % 2 == 0) {
			if (col > 0)
				neighbours[SIDE_LEFT] = parent.editor_tiles_vec[col - 1][row - 1];
			neighbours[SIDE_UP] = parent.editor_tiles_vec[col][row - 1];
			neighbours[SIDE_RIGHT] = parent.editor_tiles_vec[col][row + 1];
			if (col > 0)
				neighbours[SIDE_DOWN] = parent.editor_tiles_vec[col - 1][row + 1];
		} else {
			neighbours[SIDE_LEFT] = parent.editor_tiles_vec[col][row - 1];
			if (col < PlayState.TILES_COLS - 1)
				neighbours[SIDE_UP] = parent.editor_tiles_vec[col + 1][row - 1];
			if (col < PlayState.TILES_COLS - 1)
				neighbours[SIDE_RIGHT] = parent.editor_tiles_vec[col + 1][row + 1];
			neighbours[SIDE_DOWN] = parent.editor_tiles_vec[col][row + 1];
		}
	}

	override public function update(elapsed:Float) {
		var mouse_pos = FlxG.mouse.getWorldPosition();
		hovering = FlxCollision.pixelPerfectPointCheck(Std.int(mouse_pos.x), Std.int(mouse_pos.y), this);

		if (hovering && !selected && FlxG.mouse.justPressed) {
			selected = true;
			room_tile.visible = true;
			this.visible = false;

			select();
			selectNeighbours();
		} else if (hovering && selected && FlxG.mouse.justPressed) {
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
		for (neighbour in neighbours.keys())
			if (isNeighbourSelected(neighbour))
				neighbours[neighbour].select();
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
