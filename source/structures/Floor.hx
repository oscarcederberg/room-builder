package structures;

import EditorTile.PointPositions;
import EditorTile.TileNeighbors;
import flixel.FlxG;
import flixel.system.FlxAssets;
import flixel.util.FlxColor;
import openfl.display.BitmapData;
import openfl.geom.Point;

enum FloorFragment {
    FLOOR_MID;
    FLOOR_UP_A;
    FLOOR_UP_B;
    FLOOR_UP_C;
    FLOOR_UP_D;
    FLOOR_UP_E;
    FLOOR_RIGHT_A;
    FLOOR_RIGHT_B;
    FLOOR_RIGHT_C;
    FLOOR_RIGHT_D;
    FLOOR_RIGHT_E;
    FLOOR_DOWN_A;
    FLOOR_DOWN_B;
    FLOOR_DOWN_C;
    FLOOR_DOWN_D;
    FLOOR_DOWN_E;
    FLOOR_LEFT_A;
    FLOOR_LEFT_B;
    FLOOR_LEFT_C;
    FLOOR_LEFT_D;
    FLOOR_LEFT_E;
}

class Floor extends RoomStructure {
    public static final FLOOR_WIDTH = 48;
    public static final FLOOR_GRAPHICS_WIDTH = 45;
    public static final FLOOR_HEIGHT = 32;

    public static var bitmaps:Map<FloorFragment, BitmapData> = new Map();

    var parent:PlayState = cast(FlxG.state, PlayState);
    var tile:EditorTile;

    public function new(x:Float, y:Float, tile:EditorTile) {
        super(x, y);

        this.tile = tile;
    }

    override function kill() {
        super.kill();
    }

    public function getDepth():Int {
        return 100 * (this.tile.col + this.tile.row);
    }

    public function updateGraphics() {
        makeGraphic(FLOOR_WIDTH, FLOOR_HEIGHT, FlxColor.TRANSPARENT, true);

        stampFragment(FLOOR_MID);

        updateCornerGraphics(TILE_NEIGHBOR_SIDE_UP, TILE_NEIGHBOR_CORNER_UP, TILE_NEIGHBOR_SIDE_LEFT, FLOOR_UP_A, FLOOR_UP_B, FLOOR_UP_C, FLOOR_UP_D,
            FLOOR_UP_E);
        updateCornerGraphics(TILE_NEIGHBOR_SIDE_RIGHT, TILE_NEIGHBOR_CORNER_RIGHT, TILE_NEIGHBOR_SIDE_UP, FLOOR_RIGHT_A, FLOOR_RIGHT_B, FLOOR_RIGHT_C,
            FLOOR_RIGHT_D, FLOOR_RIGHT_E);
        updateCornerGraphics(TILE_NEIGHBOR_SIDE_DOWN, TILE_NEIGHBOR_CORNER_DOWN, TILE_NEIGHBOR_SIDE_RIGHT, FLOOR_DOWN_A, FLOOR_DOWN_B, FLOOR_DOWN_C,
            FLOOR_DOWN_D, FLOOR_DOWN_E);
        updateCornerGraphics(TILE_NEIGHBOR_SIDE_LEFT, TILE_NEIGHBOR_CORNER_LEFT, TILE_NEIGHBOR_SIDE_DOWN, FLOOR_LEFT_A, FLOOR_LEFT_B, FLOOR_LEFT_C,
            FLOOR_LEFT_D, FLOOR_LEFT_E);
    }

    function getNeighbor(neighbor:TileNeighbors):Floor {
        var neighbor = tile.getNeighbor(neighbor);

        if (neighbor != null) {
            return neighbor.getFloor();
        }

        return null;
    }

    function neighborHasFloor(neighbor:TileNeighbors):Bool {
        var neighbor = tile.getNeighbor(neighbor);

        if (neighbor != null) {
            return neighbor.hasFloor();
        }

        return false;
    }

    function pointHasWall(point:PointPositions):Bool {
        var point = tile.getPoint(point);

        if (point != null) {
            return point.hasWall();
        }

        return false;
    }

    function stampFragment(fragment:FloorFragment) {
        this.graphic.bitmap.copyPixels(bitmaps[fragment], bitmaps[fragment].rect, new Point(0, 0), null, null, true);
    }

    function updateCornerGraphics(side_a:TileNeighbors, corner:TileNeighbors, side_b:TileNeighbors, fragment_A:FloorFragment, fragment_B:FloorFragment,
            fragment_C:FloorFragment, fragment_D:FloorFragment, fragment_E:FloorFragment) {
        if (neighborHasFloor(side_a) && neighborHasFloor(corner) && neighborHasFloor(side_b)) {
            stampFragment(fragment_E);
        } else if (neighborHasFloor(side_a) && neighborHasFloor(side_b)) {
            stampFragment(fragment_D);
        } else if (neighborHasFloor(side_a)) {
            stampFragment(fragment_C);
        } else if (neighborHasFloor(side_b)) {
            stampFragment(fragment_B);
        } else {
            stampFragment(fragment_A);
        }
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
