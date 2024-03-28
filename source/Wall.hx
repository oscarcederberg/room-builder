import EditorTile.NeighbourPosition;
import flixel.FlxSprite;
import flixel.system.FlxAssets;
import flixel.util.FlxColor;
import openfl.display.BitmapData;
import openfl.geom.Point;

enum Fragment {
	WALL_CORNER_LEFT;
	WALL_CORNER_UP;
	WALL_CORNER_RIGHT;
	WALL_CORNER_DOWN;
	WALL_SIDE_LEFT;
	WALL_SIDE_LEFT_CUT;
	WALL_SIDE_LEFT_UP;
	WALL_SIDE_UP;
	WALL_SIDE_UP_CUT;
	WALL_SIDE_RIGHT;
	WALL_SIDE_RIGHT_DOWN;
	WALL_SIDE_DOWN;
}

class Wall extends FlxSprite {
	public static var bitmaps:haxe.ds.Map<Fragment, BitmapData> = new Map();

	var parent:EditorTile;

	public function new(x:Float, y:Float, parent:EditorTile) {
		super(x, y);

		this.parent = parent;
	}

	public function stampFragment(fragment:Fragment) {
		this.graphic.bitmap.copyPixels(bitmaps[fragment], bitmaps[fragment].rect, new Point(0, 0), null, null, true);
	}

	public function updateGraphics() {
		makeGraphic(51, 127, FlxColor.TRANSPARENT, true);

		if (!neighbourHasWall(SIDE_LEFT) && !neighbourHasWall(SIDE_UP))
			stampFragment(WALL_SIDE_LEFT_UP);
		else if (!neighbourHasWall(SIDE_LEFT) && !neighbourHasWall(CORNER_UP))
			stampFragment(WALL_SIDE_LEFT);
		else if (!neighbourHasWall(SIDE_LEFT))
			stampFragment(WALL_SIDE_LEFT_CUT);
		else if (!neighbourHasWall(SIDE_UP) && !neighbourHasWall(CORNER_UP))
			stampFragment(WALL_SIDE_UP);
		else if (!neighbourHasWall(SIDE_UP))
			stampFragment(WALL_SIDE_UP_CUT);

		if (!neighbourHasWall(SIDE_RIGHT) && !neighbourHasWall(SIDE_DOWN))
			stampFragment(WALL_SIDE_RIGHT_DOWN);
		else if (!neighbourHasWall(SIDE_RIGHT))
			stampFragment(WALL_SIDE_RIGHT);
		else if (!neighbourHasWall(SIDE_DOWN))
			stampFragment(WALL_SIDE_DOWN);

		if (!neighbourHasWall(SIDE_DOWN) && !neighbourHasWall(SIDE_LEFT))
			stampFragment(WALL_CORNER_LEFT);
		if (neighbourHasWall(SIDE_LEFT) && !neighbourHasWall(CORNER_UP) && neighbourHasWall(SIDE_UP))
			stampFragment(WALL_CORNER_UP);
		if (!neighbourHasWall(SIDE_UP) && !neighbourHasWall(SIDE_RIGHT))
			stampFragment(WALL_CORNER_RIGHT);
		if (neighbourHasWall(SIDE_RIGHT) && !neighbourHasWall(CORNER_DOWN) && neighbourHasWall(SIDE_DOWN))
			stampFragment(WALL_CORNER_DOWN);
	}

	function neighbourHasWall(neighbour:NeighbourPosition):Bool {
		var neighbour = parent.getNeighbour(neighbour);

		if (neighbour != null) {
			return neighbour.hasWall();
		}

		return false;
	}

	public static function loadFragmentAsset(fragment:Fragment, asset:String) {
		bitmaps[fragment] = FlxAssets.getBitmapData(asset);
	}

	public static function loadAllFragmentAssets() {
		for (frag in Fragment.createAll()) {
			var name = frag.getName().toLowerCase();
			var split = name.indexOf("_");
			var asset = 'assets/images/${name.substring(0, split)}/${name.substring(split + 1)}.png';

			loadFragmentAsset(frag, asset);
		}
	}
}
