package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import haxe.ds.Vector;
import hud.HUD;

enum Tool {
	REMOVE;
	FLOOR;
	WALL;
}

class PlayState extends FlxState {
	public static inline var TILES_COLS = 15;
	public static inline var TILES_ROWS = 15;

	public var currentTool:Tool = REMOVE;
	public var editorTiles:FlxTypedGroup<EditorTile>;
	public var editorTilesVec:Vector<Vector<EditorTile>>;
	public var floors:FlxTypedGroup<Floor>;
	public var walls:FlxTypedGroup<Wall>;

	public var hud:HUD;

	override public function create() {
		super.create();

		FlxG.camera.zoom = 2;

		this.editorTiles = new FlxTypedGroup<EditorTile>();
		this.editorTilesVec = new Vector<Vector<EditorTile>>(TILES_COLS);
		this.floors = new FlxTypedGroup<Floor>();
		this.walls = new FlxTypedGroup<Wall>();

		for (col in 0...TILES_COLS) {
			this.editorTilesVec[col] = new Vector<EditorTile>(TILES_ROWS);
		}

		var editor_tile:EditorTile;
		for (row in 0...TILES_ROWS) {
			for (col in 0...TILES_COLS) {
				editor_tile = new EditorTile(col, row);
				this.editorTiles.add(editor_tile);
				this.editorTilesVec[col][row] = editor_tile;
			}
		}

		for (row in 0...TILES_ROWS) {
			for (col in 0...TILES_COLS) {
				this.editorTilesVec[col][row].populateNeighbours();
			}
		}

		add(editorTiles);
		add(floors);
		add(walls);

		this.hud = new HUD(this);
		this.hud.addButton("assets/images/hud/remove.png", (button) -> {
			if (button.isSelected()) {
				this.currentTool = REMOVE;
			}
		});
		this.hud.addButton("assets/images/hud/floor.png", (button) -> {
			if (button.isSelected()) {
				this.currentTool = FLOOR;
			}
		});
		this.hud.addButton("assets/images/hud/wall.png", (button) -> {
			if (button.isSelected()) {
				this.currentTool = WALL;
			}
		});

		add(hud);
	}

	override public function update(elapsed:Float) {
		handleInput();

		super.update(elapsed);
	}

	public function getEditorTile(col:Int, row:Int) {
		if (editorTilesVec[col] != null)
			return editorTilesVec[col][row];

		return null;
	}

	public function handleInput() {
		var mouseWorldPos = FlxG.mouse.getWorldPosition();

		if (this.hud.handleInput()) {
			return;
		}

		for (tile in this.editorTiles) {
			if (tile.handleInput(currentTool)) {
				return;
			}
		}

		if (FlxG.mouse.pressedMiddle && !FlxG.mouse.justPressedMiddle) {
			FlxG.camera.scroll.x -= FlxG.mouse.deltaScreenX;
			FlxG.camera.scroll.y -= FlxG.mouse.deltaScreenY;
		}

		if (FlxG.keys.pressed.CONTROL) {
			var oldZoom = FlxG.camera.zoom;
			var newZoom = Math.min(4, Math.max(1, oldZoom + FlxG.mouse.wheel));

			if (oldZoom != newZoom) {
				FlxG.camera.zoom = newZoom;
				var newMouseWorldPos = FlxG.mouse.getWorldPosition();
				var diffPos = newMouseWorldPos.subtractPoint(mouseWorldPos);
				FlxG.camera.scroll.subtractPoint(diffPos);
			}
		}
	}
}
