package structures;

import EditorPoint.PointNeighbors;
import EditorPoint.TilePositions;
import flixel.system.FlxAssets;
import flixel.util.FlxColor;
import openfl.display.BitmapData;
import openfl.geom.Point;

enum Type {
    WALL_NONE;
    WALL_SINGLE_A;
    WALL_SINGLE_B;
    WALL_SINGLE_C;
    WALL_SINGLE_D;
    WALL_DOUBLE_A;
    WALL_DOUBLE_B;
    WALL_DOUBLE_C;
    WALL_DOUBLE_D;
    WALL_DOUBLE_E;
    WALL_DOUBLE_F;
    WALL_TRIPLE_A;
    WALL_TRIPLE_B;
    WALL_TRIPLE_C;
    WALL_TRIPLE_D;
    WALL_QUAD;
}

enum Fragment {
    WALL_TOP_NONE;
    WALL_TOP_SINGLE_A;
    WALL_TOP_SINGLE_B;
    WALL_TOP_SINGLE_C;
    WALL_TOP_SINGLE_D;
    WALL_TOP_DOUBLE_A;
    WALL_TOP_DOUBLE_B;
    WALL_TOP_DOUBLE_C;
    WALL_TOP_DOUBLE_D;
    WALL_TOP_DOUBLE_E;
    WALL_TOP_DOUBLE_F;
    WALL_TOP_TRIPLE_A;
    WALL_TOP_TRIPLE_B;
    WALL_TOP_TRIPLE_C;
    WALL_TOP_TRIPLE_D;
    WALL_TOP_QUAD;
    WALL_BOTTOM_LEFT_A;
    WALL_BOTTOM_LEFT_B;
    WALL_BOTTOM_LEFT_C;
    WALL_BOTTOM_LEFT_D;
    WALL_BOTTOM_LEFT_E;
    WALL_BOTTOM_LEFT_F;
    WALL_BOTTOM_LEFT_G;
    WALL_BOTTOM_LEFT_H;
    WALL_BOTTOM_LEFT_I;
    WALL_BOTTOM_LEFT_J;
    WALL_BOTTOM_MIDDLE_A;
    WALL_BOTTOM_MIDDLE_B;
    WALL_BOTTOM_MIDDLE_C;
    WALL_BOTTOM_MIDDLE_D;
    WALL_BOTTOM_RIGHT_A;
    WALL_BOTTOM_RIGHT_B;
    WALL_BOTTOM_RIGHT_C;
    WALL_BOTTOM_RIGHT_D;
    WALL_BOTTOM_RIGHT_E;
    WALL_BOTTOM_RIGHT_F;
    WALL_BOTTOM_RIGHT_G;
    WALL_BOTTOM_RIGHT_H;
    WALL_BOTTOM_RIGHT_I;
    WALL_BOTTOM_RIGHT_J;
}

class Wall extends RoomStructure {
    public static var bitmaps:haxe.ds.Map<Fragment, BitmapData> = new Map();

    var type:Type;
    var point:EditorPoint;

    public function new(x:Float, y:Float, point:EditorPoint) {
        super(x, y);

        this.point = point;
    }

    public function getDepth():Int {
        return 100 * (this.point.col + this.point.row + 1);
    }

    public function stampFragment(fragment:Fragment) {
        if (bitmaps[fragment] == null) {
            trace(fragment);
        }
        this.graphic.bitmap.copyPixels(bitmaps[fragment], bitmaps[fragment].rect, new Point(0, 0), null, null, true);
    }

    public function updateGraphics() {
        var upHasWall = neighborHasWall(POINT_NEIGHBOR_UP);
        var rightHasWall = neighborHasWall(POINT_NEIGHBOR_RIGHT);
        var downHasWall = neighborHasWall(POINT_NEIGHBOR_DOWN);
        var leftHasWall = neighborHasWall(POINT_NEIGHBOR_LEFT);

        makeGraphic(48, 128, FlxColor.TRANSPARENT, true);

        if (upHasWall && rightHasWall && downHasWall && leftHasWall) {
            this.type = WALL_QUAD;
            stampFragment(WALL_TOP_QUAD);
        } else if (upHasWall && rightHasWall && downHasWall) {
            this.type = WALL_TRIPLE_A;
            stampFragment(WALL_TOP_TRIPLE_A);
        } else if (upHasWall && rightHasWall && leftHasWall) {
            this.type = WALL_TRIPLE_B;
            stampFragment(WALL_TOP_TRIPLE_B);
        } else if (upHasWall && downHasWall && leftHasWall) {
            this.type = WALL_TRIPLE_C;
            stampFragment(WALL_TOP_TRIPLE_C);
        } else if (rightHasWall && downHasWall && leftHasWall) {
            this.type = WALL_TRIPLE_D;
            stampFragment(WALL_TOP_TRIPLE_D);
        } else if (upHasWall && rightHasWall) {
            this.type = WALL_DOUBLE_A;
            stampFragment(WALL_TOP_DOUBLE_A);
        } else if (upHasWall && downHasWall) {
            this.type = WALL_DOUBLE_B;
            stampFragment(WALL_TOP_DOUBLE_B);
        } else if (upHasWall && leftHasWall) {
            this.type = WALL_DOUBLE_C;
            stampFragment(WALL_TOP_DOUBLE_C);
        } else if (rightHasWall && downHasWall) {
            this.type = WALL_DOUBLE_D;
            stampFragment(WALL_TOP_DOUBLE_D);
        } else if (rightHasWall && leftHasWall) {
            this.type = WALL_DOUBLE_E;
            stampFragment(WALL_TOP_DOUBLE_E);
        } else if (downHasWall && leftHasWall) {
            this.type = WALL_DOUBLE_F;
            stampFragment(WALL_TOP_DOUBLE_F);
        } else if (upHasWall) {
            this.type = WALL_SINGLE_A;
            stampFragment(WALL_TOP_SINGLE_A);
        } else if (rightHasWall) {
            this.type = WALL_SINGLE_B;
            stampFragment(WALL_TOP_SINGLE_B);
        } else if (downHasWall) {
            this.type = WALL_SINGLE_C;
            stampFragment(WALL_TOP_SINGLE_C);
        } else if (leftHasWall) {
            this.type = WALL_SINGLE_D;
            stampFragment(WALL_TOP_SINGLE_D);
        } else {
            this.type = WALL_NONE;
            stampFragment(WALL_TOP_NONE);
        }

        stampBottomLeftFragment();
        stampBottomMiddleFragment();
        stampBottomRightFragment();
    }

    function stampBottomLeftFragment() {
        var downHasFloor = tileHasFloor(TILE_CORNER_DOWN);
        var leftHasFloor = tileHasFloor(TILE_CORNER_LEFT);

        var fragment:Fragment = switch (this.type) {
        case WALL_NONE | WALL_SINGLE_A | WALL_SINGLE_B | WALL_DOUBLE_A:
            if (leftHasFloor && downHasFloor) {
                WALL_BOTTOM_LEFT_B;
            } else if (leftHasFloor) {
                WALL_BOTTOM_LEFT_C;
            } else if (downHasFloor) {
                WALL_BOTTOM_LEFT_D;
            } else {
                WALL_BOTTOM_LEFT_A;
            }

        case WALL_SINGLE_C | WALL_DOUBLE_B | WALL_DOUBLE_D | WALL_DOUBLE_F | WALL_TRIPLE_A | WALL_TRIPLE_C | WALL_TRIPLE_D | WALL_QUAD:
            if (leftHasFloor && downHasFloor) {
                WALL_BOTTOM_LEFT_J;
            } else if (leftHasFloor) {
                WALL_BOTTOM_LEFT_I;
            } else if (downHasFloor) {
                WALL_BOTTOM_LEFT_J;
            } else {
                WALL_BOTTOM_LEFT_I;
            }

        case WALL_SINGLE_D | WALL_DOUBLE_C | WALL_DOUBLE_E | WALL_TRIPLE_B:
            if (leftHasFloor && downHasFloor) {
                WALL_BOTTOM_LEFT_F;
            } else if (leftHasFloor) {
                WALL_BOTTOM_LEFT_G;
            } else if (downHasFloor) {
                WALL_BOTTOM_LEFT_H;
            } else {
                WALL_BOTTOM_LEFT_E;
            }
        }

        stampFragment(fragment);
    }

    function stampBottomMiddleFragment() {
        var downHasFloor = tileHasFloor(TILE_CORNER_DOWN);

        var fragment:Fragment = switch (this.type) {
        case WALL_NONE | WALL_SINGLE_A | WALL_SINGLE_D | WALL_DOUBLE_D | WALL_DOUBLE_C | WALL_TRIPLE_A | WALL_TRIPLE_D | WALL_QUAD:
            if (downHasFloor) {
                WALL_BOTTOM_MIDDLE_B;
            } else {
                WALL_BOTTOM_MIDDLE_A;
            }
        case WALL_SINGLE_B | WALL_SINGLE_C | WALL_DOUBLE_A | WALL_DOUBLE_B | WALL_DOUBLE_E | WALL_DOUBLE_F | WALL_TRIPLE_B | WALL_TRIPLE_C:
            if (downHasFloor) {
                WALL_BOTTOM_MIDDLE_D;
            } else {
                WALL_BOTTOM_MIDDLE_C;
            }
        }

        stampFragment(fragment);
    }

    function stampBottomRightFragment() {
        var rightHasFloor = tileHasFloor(TILE_CORNER_RIGHT);
        var downHasFloor = tileHasFloor(TILE_CORNER_DOWN);

        var fragment:Fragment = switch (this.type) {
        case WALL_NONE | WALL_SINGLE_C | WALL_SINGLE_D | WALL_DOUBLE_F:
            if (downHasFloor && rightHasFloor) {
                WALL_BOTTOM_RIGHT_B;
            } else if (rightHasFloor) {
                WALL_BOTTOM_RIGHT_C;
            } else if (downHasFloor) {
                WALL_BOTTOM_RIGHT_D;
            } else {
                WALL_BOTTOM_RIGHT_A;
            }

        case WALL_SINGLE_A | WALL_DOUBLE_B | WALL_DOUBLE_C | WALL_TRIPLE_C:
            if (downHasFloor && rightHasFloor) {
                WALL_BOTTOM_RIGHT_F;
            } else if (rightHasFloor) {
                WALL_BOTTOM_RIGHT_G;
            } else if (downHasFloor) {
                WALL_BOTTOM_RIGHT_H;
            } else {
                WALL_BOTTOM_RIGHT_E;
            }

        case WALL_SINGLE_B | WALL_DOUBLE_A | WALL_DOUBLE_D | WALL_DOUBLE_E | WALL_TRIPLE_A | WALL_TRIPLE_B | WALL_TRIPLE_D | WALL_QUAD:
            if (downHasFloor && rightHasFloor) {
                WALL_BOTTOM_RIGHT_J;
            } else if (rightHasFloor) {
                WALL_BOTTOM_RIGHT_I;
            } else if (downHasFloor) {
                WALL_BOTTOM_RIGHT_J;
            } else {
                WALL_BOTTOM_RIGHT_I;
            }
        }

        stampFragment(fragment);
    }

    function tileHasFloor(tile:TilePositions):Bool {
        var tile = point.getTile(tile);

        if (tile != null) {
            return tile.hasFloor();
        }

        return false;
    }

    function neighborHasWall(neighbor:PointNeighbors):Bool {
        var neighbor = point.getNeighbor(neighbor);

        if (neighbor != null) {
            return neighbor.hasWall();
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
