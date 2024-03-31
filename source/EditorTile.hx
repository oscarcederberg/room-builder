import PlayState.Tool;
import flixel.FlxG;
import flixel.FlxSprite;

enum TileNeighbors {
	TILE_CORNER_UP;
	TILE_CORNER_RIGHT;
	TILE_CORNER_DOWN;
	TILE_CORNER_LEFT;
	TILE_SIDE_UP;
	TILE_SIDE_RIGHT;
	TILE_SIDE_DOWN;
	TILE_SIDE_LEFT;
}

enum PointPositions {
	POINT_CORNER_UP;
	POINT_CORNER_RIGHT;
	POINT_CORNER_DOWN;
	POINT_CORNER_LEFT;
}

class EditorTile extends FlxSprite {
	public static final EDITOR_TILE_WIDTH = 48;
	public static final EDITOR_TILE_HEIGHT = 16;

	public var col:Int;
	public var row:Int;

	var parent:PlayState = cast(FlxG.state, PlayState);
	var neighbors:Map<TileNeighbors, EditorTile> = new Map();
	var points:Map<PointPositions, EditorPoint> = new Map();
	var hovering:Bool;

	var floorActive:Bool;
	var floor:Floor;

	public function new(col:Int, row:Int) {
		var x, y:Float;
		this.col = col;
		this.row = row;

		x = col * EDITOR_TILE_WIDTH / 2 - (row * EDITOR_TILE_WIDTH / 2);
		y = row * EDITOR_TILE_HEIGHT / 2 + (col * EDITOR_TILE_HEIGHT / 2);

		super(x, y);

		this.hovering = false;

		this.floor = new Floor(x, y - 16, this);
		this.floorActive = false;
		this.floor.visible = false;
		this.parent.floors.add(floor);

		loadGraphic("assets/images/editor_tile.png", true, 45, 16);
		this.animation.add("unselected", [0]);
		this.animation.add("hover", [1]);
		this.animation.play("unselected");
	}

	override public function update(elapsed:Float) {
		var point = FlxG.mouse.getWorldPosition();
		this.hovering = this.pixelsOverlapPoint(point);

		animate();

		super.update(elapsed);
	}

	public function clear() {
		setWall(false);
		setFloor(false);
	}

	public function getNeighbour(neighbor:TileNeighbors):EditorTile {
		return this.neighbors[neighbor];
	}

	public function handleInput(tool:Tool):Bool {
		if (hovering) {
			if (FlxG.mouse.pressed) {
				switch (tool) {
					case REMOVE:
						clear();
					case FLOOR:
						setFloor(true);
					case WALL:
						setWall(true);
				}

				return true;
			} else if (FlxG.mouse.pressedRight) {
				switch (tool) {
					case REMOVE:
						clear();
					case FLOOR:
						setFloor(false);
					case WALL:
						setWall(false);
				}

				return true;
			}
		}

		return false;
	}

	public function hasFloor():Bool {
		return this.floorActive;
	}

	public function hasWall():Bool {
		return this.wallActive;
	}

	public function setFloor(selected:Bool) {
		if (this.floorActive != selected) {
			if (!selected) {
				setWall(false);
			}

			this.floorActive = selected;
			this.floor.visible = selected;

			this.floor.updateGraphics();
			updateNeighborsGraphics();
		}
	}

	public function setWall(selected:Bool) {
		if (this.floorActive) {
			if (this.wallActive != selected) {
				this.wallActive = selected;
				this.wall.visible = selected;
				this.wall.updateGraphics();
				updateNeighborsGraphics();
			}
		}
	}

	public function isNeighbourActive(neighbor:TileNeighbors):Bool {
		return this.neighbors[neighbor] != null && this.neighbors[neighbor].isActive();
	}

	public function isActive():Bool {
		return this.floorActive || this.wallActive;
	}

	public function populateNeighbours() {
		this.neighbors[TILE_CORNER_UP] = parent.getEditorTile(col - 1, row - 1);
		this.neighbors[TILE_CORNER_RIGHT] = parent.getEditorTile(col + 1, row - 1);
		this.neighbors[TILE_CORNER_DOWN] = parent.getEditorTile(col + 1, row + 1);
		this.neighbors[TILE_CORNER_LEFT] = parent.getEditorTile(col - 1, row + 1);
		this.neighbors[TILE_SIDE_UP] = parent.getEditorTile(col, row - 1);
		this.neighbors[TILE_SIDE_RIGHT] = parent.getEditorTile(col + 1, row);
		this.neighbors[TILE_SIDE_DOWN] = parent.getEditorTile(col, row + 1);
		this.neighbors[TILE_SIDE_LEFT] = parent.getEditorTile(col - 1, row);
	}

	public function updateGraphics() {
		if (this.floorActive) {
			this.floor.updateGraphics();
		}

		if (this.wallActive) {
			this.wall.updateGraphics();
		}
	}

	function updateNeighborsGraphics() {
		for (neighbor in this.neighbors.keys())
			if (isNeighbourActive(neighbor))
				this.neighbors[neighbor].updateGraphics();
	}

	function animate() {
		if (this.hovering) {
			animation.play("hover");
		} else {
			animation.play("unselected");
		}
	}
}
