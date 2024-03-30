import PlayState.Tool;
import flixel.FlxG;
import flixel.FlxSprite;
import haxe.display.Display.Package;

enum NeighbourPosition {
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

	var parent:PlayState = cast(FlxG.state, PlayState);
	var neighbours:Map<NeighbourPosition, EditorTile> = new Map();
	var hovering:Bool;

	var floorActive:Bool;
	var floor:Floor;

	var wallActive:Bool;
	var wall:Wall;

	public function new(col:Int, row:Int) {
		var x, y:Float;
		this.col = col;
		this.row = row;

		x = col * EDITOR_WIDTH / 2 - (row * EDITOR_WIDTH / 2);
		y = row * EDITOR_HEIGHT / 2 + (col * EDITOR_HEIGHT / 2);

		super(x, y);

		this.hovering = false;

		this.floor = new Floor(x, y - 16, this);
		this.floorActive = false;
		this.floor.visible = false;
		this.parent.floors.add(floor);

		this.wall = new Wall(x, y - 112, this);
		this.wallActive = false;
		this.wall.visible = false;
		this.parent.walls.add(wall);

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

	public function getNeighbour(neighbour:NeighbourPosition):EditorTile {
		return this.neighbours[neighbour];
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

	public function isNeighbourActive(neighbour:NeighbourPosition):Bool {
		return this.neighbours[neighbour] != null && this.neighbours[neighbour].isActive();
	}

	public function isActive():Bool {
		return this.floorActive || this.wallActive;
	}

	public function populateNeighbours() {
		this.neighbours[CORNER_LEFT] = parent.getEditorTile(col - 1, row + 1);
		this.neighbours[CORNER_UP] = parent.getEditorTile(col - 1, row - 1);
		this.neighbours[CORNER_RIGHT] = parent.getEditorTile(col + 1, row - 1);
		this.neighbours[CORNER_DOWN] = parent.getEditorTile(col + 1, row + 1);
		this.neighbours[SIDE_LEFT] = parent.getEditorTile(col - 1, row);
		this.neighbours[SIDE_UP] = parent.getEditorTile(col, row - 1);
		this.neighbours[SIDE_RIGHT] = parent.getEditorTile(col + 1, row);
		this.neighbours[SIDE_DOWN] = parent.getEditorTile(col, row + 1);
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
		for (neighbour in this.neighbours.keys())
			if (isNeighbourActive(neighbour))
				this.neighbours[neighbour].updateGraphics();
	}

	function animate() {
		if (this.hovering) {
			animation.play("hover");
		} else {
			animation.play("unselected");
		}
	}
}
