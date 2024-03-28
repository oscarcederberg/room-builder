import EditorTile.NeighbourPosition;
import flixel.FlxSprite;
import flixel.system.FlxAssets;
import flixel.util.FlxColor;
import openfl.display.BitmapData;
import openfl.geom.Point;

enum FloorFragment {
	FLOOR_MID;
	FLOOR_UP_1;
	FLOOR_UP_2;
	FLOOR_UP_3;
	FLOOR_UP_4;
	FLOOR_UP_5;
	FLOOR_RIGHT_1;
	FLOOR_RIGHT_2;
	FLOOR_RIGHT_3;
	FLOOR_RIGHT_4;
	FLOOR_RIGHT_5;
	FLOOR_DOWN_1;
	FLOOR_DOWN_2;
	FLOOR_DOWN_3;
	FLOOR_DOWN_4;
	FLOOR_DOWN_5;
	FLOOR_LEFT_1;
	FLOOR_LEFT_2;
	FLOOR_LEFT_3;
	FLOOR_LEFT_4;
	FLOOR_LEFT_5;
}

class Floor extends FlxSprite {
	public static var bitmaps:haxe.ds.Map<FloorFragment, BitmapData> = new Map();

	var parent:EditorTile;

	public function new(x:Float, y:Float, parent:EditorTile) {
		super(x, y);

		this.parent = parent;
	}

	public function stampFragment(fragment:FloorFragment) {
		this.graphic.bitmap.copyPixels(bitmaps[fragment], bitmaps[fragment].rect, new Point(0, 0), null, null, true);
	}

	public function updateGraphics() {
		makeGraphic(48, 32, FlxColor.TRANSPARENT, true);

		stampFragment(FLOOR_MID);
		updateCornerGraphics(SIDE_UP, CORNER_UP, SIDE_LEFT, FLOOR_UP_1, FLOOR_UP_2, FLOOR_UP_3, FLOOR_UP_4, FLOOR_UP_5);
		updateCornerGraphics(SIDE_RIGHT, CORNER_RIGHT, SIDE_UP, FLOOR_RIGHT_1, FLOOR_RIGHT_2, FLOOR_RIGHT_3, FLOOR_RIGHT_4, FLOOR_RIGHT_5);
		updateCornerGraphics(SIDE_DOWN, CORNER_DOWN, SIDE_RIGHT, FLOOR_DOWN_1, FLOOR_DOWN_2, FLOOR_DOWN_3, FLOOR_DOWN_4, FLOOR_DOWN_5);
		updateCornerGraphics(SIDE_LEFT, CORNER_LEFT, SIDE_DOWN, FLOOR_LEFT_1, FLOOR_LEFT_2, FLOOR_LEFT_3, FLOOR_LEFT_4, FLOOR_LEFT_5);
	}

	function updateCornerGraphics(side_a:NeighbourPosition, corner:NeighbourPosition, side_b:NeighbourPosition, fragment_1:FloorFragment,
			fragment_2:FloorFragment, fragment_3:FloorFragment, fragment_4:FloorFragment, fragment_5:FloorFragment) {
		if (neighbourHasFloor(side_a) && neighbourHasFloor(corner) && neighbourHasFloor(side_b)) {
			stampFragment(fragment_5);
		} else if (neighbourHasFloor(side_a) && neighbourHasFloor(side_b)) {
			stampFragment(fragment_4);
		} else if (neighbourHasFloor(side_a)) {
			stampFragment(fragment_3);
		} else if (neighbourHasFloor(side_b)) {
			stampFragment(fragment_2);
		} else {
			stampFragment(fragment_1);
		}
	}

	function neighbourHasFloor(neighbour:NeighbourPosition):Bool {
		var neighbour = parent.getNeighbour(neighbour);

		if (neighbour != null) {
			return neighbour.hasFloor();
		}

		return false;
	}

	public static function loadFragmentAsset(fragment:FloorFragment, asset:String) {
		bitmaps[fragment] = FlxAssets.getBitmapData(asset);
	}

	public static function loadAllFragmentAssets() {
		for (frag in FloorFragment.createAll()) {
			var name = frag.getName().toLowerCase();
			var split = name.indexOf("_");
			var asset = 'assets/images/${name.substring(0, split)}/${name.substring(split + 1)}.png';
			loadFragmentAsset(frag, asset);
		}
	}
}
