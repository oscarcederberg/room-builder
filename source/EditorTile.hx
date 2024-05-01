import PlayState.Tool;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxSort;
import structures.Floor;

enum TileNeighbors {
    TILE_NEIGHBOR_CORNER_UP;
    TILE_NEIGHBOR_CORNER_RIGHT;
    TILE_NEIGHBOR_CORNER_DOWN;
    TILE_NEIGHBOR_CORNER_LEFT;
    TILE_NEIGHBOR_SIDE_UP;
    TILE_NEIGHBOR_SIDE_RIGHT;
    TILE_NEIGHBOR_SIDE_DOWN;
    TILE_NEIGHBOR_SIDE_LEFT;
}

enum PointPositions {
    POINT_CORNER_UP;
    POINT_CORNER_RIGHT;
    POINT_CORNER_DOWN;
    POINT_CORNER_LEFT;
}

class EditorTile extends FlxSprite {
    public static final EDITOR_TILE_WIDTH = 48;
    public static final EDITOR_TILE_GRAPHICS_WIDTH = 45;
    public static final EDITOR_TILE_HEIGHT = 16;

    public var col:Int;
    public var row:Int;

    var parent:PlayState = cast(FlxG.state, PlayState);
    var points:Map<PointPositions, EditorPoint> = new Map();
    var neighborTiles:Map<TileNeighbors, EditorTile> = new Map();
    var hovering:Bool;

    var floor:Floor = null;

    public function new(col:Int, row:Int) {
        var x, y:Float;

        this.col = col;
        this.row = row;
        x = col * EDITOR_TILE_WIDTH / 2 - (row * EDITOR_TILE_WIDTH / 2);
        y = row * EDITOR_TILE_HEIGHT / 2 + (col * EDITOR_TILE_HEIGHT / 2);
        super(x, y);

        this.hovering = false;

        loadGraphic("assets/images/editor_tile.png", true, EDITOR_TILE_GRAPHICS_WIDTH, EDITOR_TILE_HEIGHT);
        this.animation.add("unselected", [0]);
        this.animation.add("hover", [1]);
        this.animation.play("unselected");
    }

    override public function update(elapsed:Float) {
        var point = FlxG.mouse.getWorldPosition();
        this.hovering = this.pixelsOverlapPoint(point);

        animate();

        super.update(elapsed);
    }

    public function clear() {
        removeFloor();
        for (point in this.points) {
            point.removeWall();
        }
    }

    public function getFloor() {
        return this.floor;
    }

    public function getNeighbor(neighbor:TileNeighbors):EditorTile {
        return this.neighborTiles[neighbor];
    }

    public function getPoint(pointPosition:PointPositions):EditorPoint {
        return this.points[pointPosition];
    }

    public function handleInput(tool:Tool):Bool {
        if (hovering) {
            if (FlxG.mouse.pressed) {
                switch (tool) {
                case REMOVE:
                    clear();
                    return true;
                case FLOOR:
                    addFloor();
                    return true;
                default:
                    // do nothing
                }
            } else if (FlxG.mouse.pressedRight) {
                switch (tool) {
                case REMOVE:
                    clear();
                    return true;
                case FLOOR:
                    removeFloor();
                    return true;
                default:
                    // do nothing
                }
            }
        }

        return false;
    }

    public function hasFloor():Bool {
        return this.floor != null;
    }

    public function isNeighborActive(neighbor:TileNeighbors):Bool {
        return this.neighborTiles[neighbor] != null && this.neighborTiles[neighbor].isActive();
    }

    public function isActive():Bool {
        return hasFloor();
    }

    public function populate() {
        this.neighborTiles[TILE_NEIGHBOR_CORNER_UP] = parent.getEditorTile(col - 1, row - 1);
        this.neighborTiles[TILE_NEIGHBOR_CORNER_RIGHT] = parent.getEditorTile(col + 1, row - 1);
        this.neighborTiles[TILE_NEIGHBOR_CORNER_DOWN] = parent.getEditorTile(col + 1, row + 1);
        this.neighborTiles[TILE_NEIGHBOR_CORNER_LEFT] = parent.getEditorTile(col - 1, row + 1);
        this.neighborTiles[TILE_NEIGHBOR_SIDE_UP] = parent.getEditorTile(col, row - 1);
        this.neighborTiles[TILE_NEIGHBOR_SIDE_RIGHT] = parent.getEditorTile(col + 1, row);
        this.neighborTiles[TILE_NEIGHBOR_SIDE_DOWN] = parent.getEditorTile(col, row + 1);
        this.neighborTiles[TILE_NEIGHBOR_SIDE_LEFT] = parent.getEditorTile(col - 1, row);

        this.points[POINT_CORNER_UP] = parent.getEditorPoint(col, row);
        this.points[POINT_CORNER_RIGHT] = parent.getEditorPoint(col + 1, row);
        this.points[POINT_CORNER_DOWN] = parent.getEditorPoint(col + 1, row + 1);
        this.points[POINT_CORNER_LEFT] = parent.getEditorPoint(col, row + 1);
    }

    function getNeighborPoint(tileNeighbor:TileNeighbors, pointPosition:PointPositions):EditorPoint {
        var neighbor = this.neighborTiles[tileNeighbor];

        if (neighbor != null) {
            return neighbor.getPoint(pointPosition);
        }

        return null;
    }

    public function updateGraphics() {
        if (hasFloor()) {
            this.floor.updateGraphics();
        }
    }

    function animate() {
        if (this.hovering) {
            animation.play("hover");
        } else {
            animation.play("unselected");
        }
    }

    function addFloor() {
        if (hasFloor()) {
            return;
        }

        this.floor = new Floor(x, y - 16, this);
        this.parent.floors.add(floor);
        this.parent.floors.sort(FlxSort.byY);

        updateGraphics();
        updateNeighborsGraphics();
    }

    function removeFloor() {
        if (!hasFloor()) {
            return;
        }

        this.parent.floors.remove(this.floor, true);
        this.floor.kill();
        this.floor = null;

        updateNeighborsGraphics();
    }

    function updateNeighborsGraphics() {
        for (neighbor in this.neighborTiles) {
            if (neighbor != null) {
                neighbor.updateGraphics();
            }
        }
    }
}
