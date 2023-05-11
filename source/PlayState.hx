package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxPoint;
import haxe.ds.Vector;
import lime.math.Vector2;

class PlayState extends FlxState
{
	public static inline var TILES_COLS = 10;
	public static inline var TILES_ROWS = 40;

	public var tiles:FlxTypedGroup<Tile>;
	public var tiles_vec:Vector<Tile>;

	override public function create()
	{
		super.create();

		FlxG.camera.zoom = 2;

		this.tiles = new FlxTypedGroup<Tile>();
		this.tiles_vec = new Vector<Tile>(TILES_ROWS * TILES_COLS);
		var tile:Tile;
		for (y in 0...(TILES_ROWS + 1))
		{
			for (x in 0...(TILES_COLS + 1))
			{
				if (x == TILES_COLS && y % 2 == 1)
					continue;
				tile = new Tile(x, y);
				this.tiles.add(tile);
				this.tiles_vec[y * TILES_COLS + x] = tile;
			}
		}
		add(tiles);
	}

	override public function update(elapsed:Float)
	{
		if (FlxG.mouse.pressedMiddle && !FlxG.mouse.justPressedMiddle)
		{
			FlxG.camera.scroll.x -= FlxG.mouse.deltaScreenX;
			FlxG.camera.scroll.y -= FlxG.mouse.deltaScreenY;
		}

		this.tiles.update(elapsed);

		super.update(elapsed);
	}
}
