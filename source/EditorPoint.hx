import EditorTile.PointPositions;
import PlayState.Tool;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.util.FlxSort;

enum PointNeighbors {
    POINT_NEIGHBOR_UP;
    POINT_NEIGHBOR_RIGHT;
    POINT_NEIGHBOR_DOWN;
    POINT_NEIGHBOR_LEFT;
}

enum TilePositions {
    TILE_CORNER_UP;
    TILE_CORNER_RIGHT;
    TILE_CORNER_DOWN;
    TILE_CORNER_LEFT;
}

class EditorPoint extends FlxSprite {
    public static final EDITOR_POINT_WIDTH = 48;
    public static final EDITOR_POINT_GRAPHICS_WIDTH = 45;
    public static final EDITOR_POINT_HEIGHT = 16;
    public static final EDITOR_POINT_Y_OFFSET = 0;

    var parent:PlayState = cast(FlxG.state, PlayState);
    var neighborPoints:Map<PointNeighbors, EditorPoint> = new Map();
    var tiles:Map<TilePositions, EditorTile> = new Map();

    var wall:Wall = null;

    public function new(x:Float, y:Float, tile:EditorTile, tilePosition:TilePositions) {
        super(x, y);

        this.parent.editorPoints.add(this);

        switch tilePosition {
        case TILE_CORNER_UP:
            this.tiles[TILE_CORNER_UP] = tile;
            this.tiles[TILE_CORNER_RIGHT] = tile.getNeighbor(TILE_NEIGHBOR_SIDE_RIGHT);
            this.tiles[TILE_CORNER_DOWN] = tile.getNeighbor(TILE_NEIGHBOR_CORNER_DOWN);
            this.tiles[TILE_CORNER_LEFT] = tile.getNeighbor(TILE_NEIGHBOR_SIDE_LEFT);
        case TILE_CORNER_RIGHT:
            this.tiles[TILE_CORNER_UP] = tile.getNeighbor(TILE_NEIGHBOR_SIDE_LEFT);
            this.tiles[TILE_CORNER_RIGHT] = tile;
            this.tiles[TILE_CORNER_DOWN] = tile.getNeighbor(TILE_NEIGHBOR_SIDE_DOWN);
            this.tiles[TILE_CORNER_LEFT] = tile.getNeighbor(TILE_NEIGHBOR_CORNER_LEFT);
        case TILE_CORNER_DOWN:
            this.tiles[TILE_CORNER_UP] = tile.getNeighbor(TILE_NEIGHBOR_CORNER_UP);
            this.tiles[TILE_CORNER_RIGHT] = tile.getNeighbor(TILE_NEIGHBOR_SIDE_UP);
            this.tiles[TILE_CORNER_DOWN] = tile;
            this.tiles[TILE_CORNER_LEFT] = tile.getNeighbor(TILE_NEIGHBOR_SIDE_LEFT);
        case TILE_CORNER_LEFT:
            this.tiles[TILE_CORNER_UP] = tile.getNeighbor(TILE_NEIGHBOR_SIDE_UP);
            this.tiles[TILE_CORNER_RIGHT] = tile.getNeighbor(TILE_NEIGHBOR_CORNER_RIGHT);
            this.tiles[TILE_CORNER_DOWN] = tile.getNeighbor(TILE_NEIGHBOR_SIDE_RIGHT);
            this.tiles[TILE_CORNER_LEFT] = tile;
        }

        loadGraphic("assets/images/editor_point.png", false, EDITOR_POINT_GRAPHICS_WIDTH, EDITOR_POINT_HEIGHT);
    }

    override public function update(elapsed:Float) {
        if (FlxG.keys.justPressed.SPACE) {
            this.visible = !this.visible;
        }

        super.update(elapsed);
    }

    public function getNeighbor(neighbor:PointNeighbors) {
        return this.neighborPoints[neighbor];
    }

    public function handleInput(tool:Tool):Bool {
        var point = FlxG.mouse.getWorldPosition();
        var hovering = this.pixelsOverlapPoint(point);

        if (hovering) {
            if (FlxG.mouse.pressed) {
                switch (tool) {
                case WALL:
                    addWall();
                    return true;
                default:
                    // do nothing
                }
            } else if (FlxG.mouse.pressedRight) {
                switch (tool) {
                case WALL:
                    removeWall();
                    return true;
                default:
                    // do nothing
                }
            }
        }

        return false;
    }

    function addWall() {
        if (hasWall()) {
            return;
        }

        var floorExists = false;
        for (tile in this.tiles) {
            if (tile.hasFloor()) {
                floorExists = true;
                break;
            }
        }

        if (!floorExists) {
            return;
        }

        this.wall = new Wall(x, y - 104, this);
        this.parent.walls.add(this.wall);
        this.parent.walls.sort(FlxSort.byY);

        updateGraphics();
        updateNeighborsGraphics();
    }

    public function hasWall():Bool {
        return this.wall != null;
    }

    public function removeWall() {
        if (!hasWall()) {
            return;
        }

        this.parent.walls.remove(this.wall, true);
        this.wall.kill();
        this.wall = null;

        updateNeighborsGraphics();
    }

    function updateGraphics() {
        if (hasWall()) {
            this.wall.updateGraphics();
        }
    }

    function updateNeighborsGraphics() {
        for (neighbor in this.neighborPoints) {
            if (neighbor != null) {
                neighbor.updateGraphics();
            }
        }
    }
}
