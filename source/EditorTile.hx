import flixel.FlxG;
import flixel.FlxSprite;

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
	public static final EDITOR_WIDTH = 48;
	public static final EDITOR_HEIGHT = 16;

	public var col:Int;
	public var row:Int;
	public var selected:Bool;

	var parent:PlayState = cast(FlxG.state, PlayState);
	var neighbours:Map<Neighbour, EditorTile> = new Map();
	var room_tile:RoomTile;
	var hovering:Bool;

	public function new(col:Int, row:Int) {
		var x, y:Float;
		this.col = col;
		this.row = row;

		x = col * EDITOR_WIDTH / 2 + (row * -EDITOR_WIDTH / 2);
		y = row * EDITOR_HEIGHT / 2 + (col * EDITOR_HEIGHT / 2);

		super(x, y);

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
		return neighbours[neighbour] != null && neighbours[neighbour].selected && neighbours[neighbour].getRoomIndex() == getRoomIndex();
	}

	public function getRoomIndex():Int {
		return room_tile.room_index;
	}

	public function populateNeighbours() {
		neighbours[CORNER_LEFT] = parent.getEditorTile(col - 1, row + 1);
		neighbours[CORNER_UP] = parent.getEditorTile(col - 1, row - 1);
		neighbours[CORNER_RIGHT] = parent.getEditorTile(col + 1, row - 1);
		neighbours[CORNER_DOWN] = parent.getEditorTile(col + 1, row + 1);
		neighbours[SIDE_LEFT] = parent.getEditorTile(col - 1, row);
		neighbours[SIDE_UP] = parent.getEditorTile(col, row - 1);
		neighbours[SIDE_RIGHT] = parent.getEditorTile(col + 1, row);
		neighbours[SIDE_DOWN] = parent.getEditorTile(col, row + 1);
	}

	override public function update(elapsed:Float) {
		var mouse_pos = FlxG.mouse.getWorldPosition();
		hovering = this.pixelsOverlapPoint(mouse_pos);

		if (FlxG.mouse.justPressed && hovering) {
			if (!selected) {
				selected = true;
				room_tile.visible = true;
				this.visible = false;

				room_tile.room_index = parent.room_index;
				select();
			} else {
				selected = false;
				room_tile.visible = false;
				this.visible = true;
			}

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
