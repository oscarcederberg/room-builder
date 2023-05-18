package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import haxe.ds.Vector;

class PlayState extends FlxState {
	public static inline var TILES_COLS = 10;
	public static inline var TILES_ROWS = 40;

	public var editor_tiles:FlxTypedGroup<EditorTile>;
	public var editor_tiles_vec:Vector<Vector<EditorTile>>;
	public var room_tiles:FlxTypedGroup<RoomTile>;

	override public function create() {
		super.create();

		FlxG.camera.zoom = 2;

		this.editor_tiles = new FlxTypedGroup<EditorTile>();
		this.editor_tiles_vec = new Vector<Vector<EditorTile>>(TILES_COLS);
		for (col in 0...TILES_COLS) {
			this.editor_tiles_vec[col] = new Vector<EditorTile>(TILES_ROWS);
		}
		this.room_tiles = new FlxTypedGroup<RoomTile>();
		var editor_tile:EditorTile;
		for (row in 0...TILES_ROWS) {
			for (col in 0...TILES_COLS) {
				editor_tile = new EditorTile(col, row);
				this.editor_tiles.add(editor_tile);
				this.editor_tiles_vec[col][row] = editor_tile;
			}
		}
		for (row in 0...TILES_ROWS) {
			for (col in 0...TILES_COLS) {
				this.editor_tiles_vec[col][row].populateNeighbours();
			}
		}
		add(editor_tiles);
		add(room_tiles);
	}

	public function getEditorTile(col:Int, row:Int) {
		if (editor_tiles_vec[col] != null)
			return editor_tiles_vec[col][row];
		return null;
	}

	override public function update(elapsed:Float) {
		if (FlxG.mouse.pressedMiddle && !FlxG.mouse.justPressedMiddle) {
			FlxG.camera.scroll.x -= FlxG.mouse.deltaScreenX;
			FlxG.camera.scroll.y -= FlxG.mouse.deltaScreenY;
		}

		super.update(elapsed);
	}
}
