import PlayState.Tool;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxSort;
import structures.Wall;

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

    public var col:Int;
    public var row:Int;

    var parent:PlayState = cast(FlxG.state, PlayState);
    var neighborPoints:Map<PointNeighbors, EditorPoint> = new Map();
    var tiles:Map<TilePositions, EditorTile> = new Map();

    var wall:Wall = null;

    public function new(col:Int, row:Int) {
        var x, y:Float;

        this.col = col;
        this.row = row;
        x = col * EditorTile.EDITOR_TILE_WIDTH / 2
            - (row * EditorTile.EDITOR_TILE_WIDTH / 2)
            + (EditorTile.EDITOR_TILE_WIDTH - EditorPoint.EDITOR_POINT_WIDTH) / 2;
        y = row * EditorTile.EDITOR_TILE_HEIGHT / 2 + (col * EditorTile.EDITOR_TILE_HEIGHT / 2) - (EditorPoint.EDITOR_POINT_HEIGHT) / 2
            + EditorPoint.EDITOR_POINT_Y_OFFSET;
        super(x, y);

        loadGraphic("assets/images/editor_point.png", false, EDITOR_POINT_GRAPHICS_WIDTH, EDITOR_POINT_HEIGHT);
        this.visible = false;
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

    public function getTile(tile:TilePositions) {
        return this.tiles[tile];
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
            if (tile == null) {
                continue;
            }

            if (tile.hasFloor()) {
                floorExists = true;
                break;
            }
        }

        if (!floorExists) {
            return;
        }

        this.wall = new Wall(x, y - 103, this);
        this.parent.addStructure(this.wall);

        updateGraphics();
        updateNeighborsGraphics();
    }

    public function hasWall():Bool {
        return this.wall != null;
    }

    public function populate() {
        this.neighborPoints[POINT_NEIGHBOR_UP] = parent.getEditorPoint(col, row - 1);
        this.neighborPoints[POINT_NEIGHBOR_RIGHT] = parent.getEditorPoint(col + 1, row);
        this.neighborPoints[POINT_NEIGHBOR_DOWN] = parent.getEditorPoint(col, row + 1);
        this.neighborPoints[POINT_NEIGHBOR_LEFT] = parent.getEditorPoint(col - 1, row);

        this.tiles[TILE_CORNER_UP] = parent.getEditorTile(col - 1, row - 1);
        this.tiles[TILE_CORNER_RIGHT] = parent.getEditorTile(col, row - 1);
        this.tiles[TILE_CORNER_DOWN] = parent.getEditorTile(col, row);
        this.tiles[TILE_CORNER_LEFT] = parent.getEditorTile(col - 1, row);
    }

    public function removeWall() {
        if (!hasWall()) {
            return;
        }

        var tmp = this.wall;
        this.wall.kill();
        this.wall = null;
        this.parent.removeStructure(tmp);

        updateNeighborsGraphics();
    }

    public function updateGraphics() {
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

        for (tile in this.tiles) {
            if (tiles != null) {
                tile.updateGraphics();
            }
        }
    }
}
