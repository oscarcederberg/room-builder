import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxPoint;

enum PointNeighbors {
	POINT_SIDE_UP;
	POINT_SIDE_RIGHT;
	POINT_SIDE_DOWN;
	POINT_SIDE_LEFT;
}

class EditorPoint extends FlxSprite {
	public static final EDITOR_POINT_WIDTH = 28;
	public static final EDITOR_POINT_HEIGHT = 8;

	public var col:Int;
	public var row:Int;

	var parent:PlayState = cast(FlxG.state, PlayState);
	var tiles:EditorTile;
	var wallActive:Bool;
	var wall:Wall;

	public function new(col:Int, row:Int) {
		var x, y;
		this.col = col;
		this.row = row;

		x = col * EditorTile.EDITOR_TILE_WIDTH / 2 - (row * EditorTile.EDITOR_TILE_WIDTH / 2);
		y = row * EditorTile.EDITOR_TILE_HEIGHT / 2 + (col * EditorTile.EDITOR_TILE_HEIGHT / 2);

		super(x, y);

		this.wall = new Wall(x, y - 112, this);
		this.wallActive = false;
		this.wall.visible = false;
		this.parent.walls.add(wall);

		makeGraphic()
	}
}
