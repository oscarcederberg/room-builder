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

        updateCornerGraphics(TILE_NEIGHBOR_SIDE_UP, TILE_NEIGHBOR_CORNER_UP, TILE_NEIGHBOR_SIDE_LEFT, FLOOR_UP_1, FLOOR_UP_2, FLOOR_UP_3, FLOOR_UP_4,
            FLOOR_UP_5);
        updateCornerGraphics(TILE_NEIGHBOR_SIDE_RIGHT, TILE_NEIGHBOR_CORNER_RIGHT, TILE_NEIGHBOR_SIDE_UP, FLOOR_RIGHT_1, FLOOR_RIGHT_2, FLOOR_RIGHT_3,
            FLOOR_RIGHT_4, FLOOR_RIGHT_5);
        updateCornerGraphics(TILE_NEIGHBOR_SIDE_DOWN, TILE_NEIGHBOR_CORNER_DOWN, TILE_NEIGHBOR_SIDE_RIGHT, FLOOR_DOWN_1, FLOOR_DOWN_2, FLOOR_DOWN_3,
            FLOOR_DOWN_4, FLOOR_DOWN_5);
        updateCornerGraphics(TILE_NEIGHBOR_SIDE_LEFT, TILE_NEIGHBOR_CORNER_LEFT, TILE_NEIGHBOR_SIDE_DOWN, FLOOR_LEFT_1, FLOOR_LEFT_2, FLOOR_LEFT_3,
            FLOOR_LEFT_4, FLOOR_LEFT_5);
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

    function updateCornerGraphics(side_a:TileNeighbors, corner:TileNeighbors, side_b:TileNeighbors, fragment_1:FloorFragment, fragment_2:FloorFragment,
            fragment_3:FloorFragment, fragment_4:FloorFragment, fragment_5:FloorFragment) {
        if (neighborHasFloor(side_a) && neighborHasFloor(corner) && neighborHasFloor(side_b)) {
            stampFragment(fragment_5);
        } else if (neighborHasFloor(side_a) && neighborHasFloor(side_b)) {
            stampFragment(fragment_4);
        } else if (neighborHasFloor(side_a)) {
            stampFragment(fragment_3);
        } else if (neighborHasFloor(side_b)) {
            stampFragment(fragment_2);
        } else {
            stampFragment(fragment_1);
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
