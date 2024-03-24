package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import haxe.ds.Vector;

class PlayState extends FlxState {
	public static inline var TILES_COLS = 15;
	public static inline var TILES_ROWS = 15;

	public var editor_tiles:FlxTypedGroup<EditorTile>;
	public var editor_tiles_vec:Vector<Vector<EditorTile>>;
	public var room_tiles:FlxTypedGroup<RoomTile>;

	public var ui:UI;
	public var room_index:Int;

	override public function create() {
		super.create();

		FlxG.camera.zoom = 2;

		this.editor_tiles = new FlxTypedGroup<EditorTile>();
		this.editor_tiles_vec = new Vector<Vector<EditorTile>>(TILES_COLS);
		this.room_tiles = new FlxTypedGroup<RoomTile>();

		for (col in 0...TILES_COLS) {
			this.editor_tiles_vec[col] = new Vector<EditorTile>(TILES_ROWS);
		}

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

		this.ui = new UI(this);
		this.room_index = 0;

		add(ui);
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

		if (FlxG.mouse.wheel > 0) {
			room_index += 1;
		} else if (FlxG.mouse.wheel < 0) {
			room_index -= 1;
		}

		if (room_index > 8) {
			room_index = 0;
		} else if (room_index < 0) {
			room_index = 8;
		}

		super.update(elapsed);
	}
}
