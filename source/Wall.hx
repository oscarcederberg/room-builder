import EditorTile.NeighbourPosition;
import flixel.FlxSprite;
import flixel.system.FlxAssets;
import flixel.util.FlxColor;
import openfl.display.BitmapData;
import openfl.geom.Point;

enum Fragment {
	WALL_NO;
	WALL_SINGLE_1;
	WALL_SINGLE_2;
	WALL_SINGLE_3;
	WALL_SINGLE_4;
	WALL_DOUBLE_1;
	WALL_DOUBLE_2;
	WALL_DOUBLE_3;
	WALL_DOUBLE_4;
	WALL_DOUBLE_5;
	WALL_DOUBLE_6;
	WALL_TRIPLE_1;
	WALL_TRIPLE_2;
	WALL_TRIPLE_3;
	WALL_TRIPLE_4;
	WALL_QUAD;
	WALL_SIDE_1;
	WALL_SIDE_2;
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
		makeGraphic(48, 128, FlxColor.TRANSPARENT, true);
		var up = neighbourHasWall(SIDE_UP);
		var right = neighbourHasWall(SIDE_RIGHT);
		var down = neighbourHasWall(SIDE_DOWN);
		var left = neighbourHasWall(SIDE_LEFT);

		if (up && right && down && left) {
			stampFragment(WALL_QUAD);
		} else if (up && right && down) {
			stampFragment(WALL_TRIPLE_1);
		} else if (up && right && left) {
			stampFragment(WALL_TRIPLE_2);
		} else if (up && down && left) {
			stampFragment(WALL_TRIPLE_3);
		} else if (right && down && left) {
			stampFragment(WALL_TRIPLE_4);
		} else if (up && right) {
			stampFragment(WALL_DOUBLE_1);
		} else if (up && down) {
			stampFragment(WALL_DOUBLE_2);
		} else if (up && left) {
			stampFragment(WALL_DOUBLE_3);
		} else if (right && down) {
			stampFragment(WALL_DOUBLE_4);
		} else if (right && left) {
			stampFragment(WALL_DOUBLE_5);
		} else if (down && left) {
			stampFragment(WALL_DOUBLE_6);
		} else if (up) {
			stampFragment(WALL_SINGLE_1);
		} else if (right) {
			stampFragment(WALL_SINGLE_2);
		} else if (down) {
			stampFragment(WALL_SINGLE_3);
		} else if (left) {
			stampFragment(WALL_SINGLE_4);
		} else {
			stampFragment(WALL_NO);
		}

		if (neighbourHasFloor(SIDE_RIGHT) && !neighbourHasFloor(SIDE_DOWN) && !neighbourHasFloor(SIDE_LEFT)) {
			stampFragment(WALL_SIDE_1);
		} else if (!neighbourHasFloor(SIDE_UP) && !neighbourHasFloor(SIDE_RIGHT) && neighbourHasFloor(SIDE_DOWN)) {
			stampFragment(WALL_SIDE_2);
		}
	}

	function neighbourHasFloor(neighbour:NeighbourPosition):Bool {
		var neighbour = parent.getNeighbour(neighbour);

		if (neighbour != null) {
			return neighbour.hasFloor();
		}

		return false;
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
