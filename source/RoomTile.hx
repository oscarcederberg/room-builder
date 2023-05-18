import flixel.FlxSprite;
import flixel.system.FlxAssets;
import flixel.util.FlxColor;
import openfl.display.BitmapData;
import openfl.geom.Point;

enum Fragment {
	FLOOR_MID;
	FLOOR_CORNER_LEFT;
	FLOOR_CORNER_UP;
	FLOOR_CORNER_RIGHT;
	FLOOR_CORNER_DOWN;
	FLOOR_SIDE_LEFT;
	FLOOR_SIDE_UP;
	FLOOR_SIDE_RIGHT;
	FLOOR_SIDE_DOWN;
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

class RoomTile extends FlxSprite {
	public static var bitmaps:haxe.ds.Map<Fragment, BitmapData> = new Map();
	public static var floor_point:Point = new Point(3, 104);
	public static var wall_point:Point = new Point(0, 0);

	var parent:EditorTile;

	public function new(x:Float, y:Float, parent:EditorTile) {
		super(x, y);

		this.parent = parent;
	}

	public function stampFragment(fragment:Fragment) {
		this.graphic.bitmap.copyPixels(bitmaps[fragment], bitmaps[fragment].rect,
			fragment.getIndex() < WALL_CORNER_LEFT.getIndex() ? floor_point : wall_point, null, null, true);
	}

	public function updateGraphics() {
		makeGraphic(51, 127, FlxColor.TRANSPARENT, true);

		stampFragment(FLOOR_MID);
		if (parent.isNeighbourSelected(SIDE_DOWN) && parent.isNeighbourSelected(CORNER_LEFT) && parent.isNeighbourSelected(SIDE_LEFT))
			stampFragment(FLOOR_CORNER_LEFT);
		if (parent.isNeighbourSelected(SIDE_LEFT) && parent.isNeighbourSelected(CORNER_UP) && parent.isNeighbourSelected(SIDE_UP))
			stampFragment(FLOOR_CORNER_UP);
		if (parent.isNeighbourSelected(SIDE_UP) && parent.isNeighbourSelected(CORNER_RIGHT) && parent.isNeighbourSelected(SIDE_RIGHT))
			stampFragment(FLOOR_CORNER_RIGHT);
		if (parent.isNeighbourSelected(SIDE_RIGHT) && parent.isNeighbourSelected(CORNER_DOWN) && parent.isNeighbourSelected(SIDE_DOWN))
			stampFragment(FLOOR_CORNER_DOWN);
		if (parent.isNeighbourSelected(SIDE_LEFT))
			stampFragment(FLOOR_SIDE_LEFT);
		if (parent.isNeighbourSelected(SIDE_UP))
			stampFragment(FLOOR_SIDE_UP);
		if (parent.isNeighbourSelected(SIDE_RIGHT))
			stampFragment(FLOOR_SIDE_RIGHT);
		if (parent.isNeighbourSelected(SIDE_DOWN))
			stampFragment(FLOOR_SIDE_DOWN);

		if (!parent.isNeighbourSelected(SIDE_LEFT) && !parent.isNeighbourSelected(SIDE_UP))
			stampFragment(WALL_SIDE_LEFT_UP);
		else if (!parent.isNeighbourSelected(SIDE_LEFT) && !parent.isNeighbourSelected(CORNER_UP))
			stampFragment(WALL_SIDE_LEFT);
		else if (!parent.isNeighbourSelected(SIDE_LEFT))
			stampFragment(WALL_SIDE_LEFT_CUT);
		else if (!parent.isNeighbourSelected(SIDE_UP) && !parent.isNeighbourSelected(CORNER_UP))
			stampFragment(WALL_SIDE_UP);
		else if (!parent.isNeighbourSelected(SIDE_UP))
			stampFragment(WALL_SIDE_UP_CUT);

		if (!parent.isNeighbourSelected(SIDE_RIGHT) && !parent.isNeighbourSelected(SIDE_DOWN))
			stampFragment(WALL_SIDE_RIGHT_DOWN);
		else if (!parent.isNeighbourSelected(SIDE_RIGHT))
			stampFragment(WALL_SIDE_RIGHT);
		else if (!parent.isNeighbourSelected(SIDE_DOWN))
			stampFragment(WALL_SIDE_DOWN);

		if (!parent.isNeighbourSelected(SIDE_DOWN) && !parent.isNeighbourSelected(SIDE_LEFT))
			stampFragment(WALL_CORNER_LEFT);
		if (parent.isNeighbourSelected(SIDE_LEFT) && !parent.isNeighbourSelected(CORNER_UP) && parent.isNeighbourSelected(SIDE_UP))
			stampFragment(WALL_CORNER_UP);
		if (!parent.isNeighbourSelected(SIDE_UP) && !parent.isNeighbourSelected(SIDE_RIGHT))
			stampFragment(WALL_CORNER_RIGHT);
		if (parent.isNeighbourSelected(SIDE_RIGHT) && !parent.isNeighbourSelected(CORNER_DOWN) && parent.isNeighbourSelected(SIDE_DOWN))
			stampFragment(WALL_CORNER_DOWN);
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
