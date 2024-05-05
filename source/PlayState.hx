package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.util.FlxSort;
import haxe.ds.Vector;
import hud.HUD;
import structures.Floor;
import structures.RoomStructure;
import structures.Wall;

enum Tool {
    REMOVE;
    FLOOR;
    WALL;
}

class PlayState extends FlxState {
    public static inline var TILES_COLS = 16;
    public static inline var TILES_ROWS = 16;

    public var currentTool:Tool = REMOVE;
    public var hud:HUD;

    var editorTiles:FlxTypedGroup<EditorTile>;
    var editorTilesVec:Vector<Vector<EditorTile>>;
    var editorPoints:FlxTypedGroup<EditorPoint>;
    var editorPointsVec:Vector<Vector<EditorPoint>>;
    var structures:FlxTypedGroup<RoomStructure>;

    override public function create() {
        super.create();

        FlxG.camera.zoom = 2;

        this.editorTiles = new FlxTypedGroup<EditorTile>();
        this.editorTilesVec = new Vector<Vector<EditorTile>>(TILES_COLS);
        this.editorPoints = new FlxTypedGroup<EditorPoint>();
        this.editorPointsVec = new Vector<Vector<EditorPoint>>(TILES_COLS + 1);
        this.structures = new FlxTypedGroup<RoomStructure>();

        for (col in 0...TILES_COLS) {
            this.editorTilesVec[col] = new Vector<EditorTile>(TILES_ROWS);
        }

        for (col in 0...(TILES_COLS + 1)) {
            this.editorPointsVec[col] = new Vector<EditorPoint>(TILES_ROWS + 1);
        }

        var editorTile:EditorTile;
        for (row in 0...TILES_ROWS) {
            for (col in 0...TILES_COLS) {
                editorTile = new EditorTile(col, row);
                this.editorTiles.add(editorTile);
                this.editorTilesVec[col][row] = editorTile;
            }
        }

        var editorPoint:EditorPoint;
        for (row in 0...(TILES_ROWS + 1)) {
            for (col in 0...(TILES_COLS + 1)) {
                editorPoint = new EditorPoint(col, row);
                this.editorPoints.add(editorPoint);
                this.editorPointsVec[col][row] = editorPoint;
            }
        }

        for (row in 0...TILES_ROWS) {
            for (col in 0...TILES_COLS) {
                this.editorTilesVec[col][row].populate();
            }
        }

        for (row in 0...(TILES_ROWS + 1)) {
            for (col in 0...(TILES_COLS + 1)) {
                this.editorPointsVec[col][row].populate();
            }
        }

        add(editorTiles);
        add(editorPoints);
        add(structures);

        this.hud = new HUD(this);
        this.hud.addButton("assets/images/hud/remove.png", (button) -> {
            if (button.isSelected()) {
                this.currentTool = REMOVE;
            }
        });
        this.hud.addButton("assets/images/hud/floor.png", (button) -> {
            if (button.isSelected()) {
                this.currentTool = FLOOR;
            }
        });
        this.hud.addButton("assets/images/hud/wall.png", (button) -> {
            if (button.isSelected()) {
                this.currentTool = WALL;
            }
        });

        add(hud);
    }

    override public function update(elapsed:Float) {
        handleInput();

        super.update(elapsed);
    }

    public function addStructure(structure:RoomStructure) {
        this.structures.add(structure);
        this.structures.sort((order, a, b) -> FlxSort.byValues(order, a.getDepth(), b.getDepth()));
    }

    public function getEditorTile(col:Int, row:Int) {
        if (editorTilesVec[col] != null)
            return editorTilesVec[col][row];

        return null;
    }

    public function getEditorPoint(col:Int, row:Int) {
        if (editorPointsVec[col] != null)
            return editorPointsVec[col][row];

        return null;
    }

    public function handleInput() {
        var mouseWorldPos = FlxG.mouse.getWorldPosition();

        if (this.hud.handleInput()) {
            return;
        }

        for (point in this.editorPoints) {
            if (point.handleInput(currentTool)) {
                return;
            }
        }

        for (tile in this.editorTiles) {
            if (tile.handleInput(currentTool)) {
                return;
            }
        }

        if (FlxG.mouse.pressedMiddle && !FlxG.mouse.justPressedMiddle) {
            FlxG.camera.scroll.x -= FlxG.mouse.deltaScreenX;
            FlxG.camera.scroll.y -= FlxG.mouse.deltaScreenY;
            FlxG.camera.scroll.set(Math.round(FlxG.camera.scroll.x), Math.round(FlxG.camera.scroll.y));
        }

        if (FlxG.keys.pressed.CONTROL) {
            var oldZoom = FlxG.camera.zoom;
            var newZoom = Math.min(4, Math.max(1, oldZoom + FlxG.mouse.wheel));

            if (oldZoom != newZoom) {
                FlxG.camera.zoom = newZoom;
                var newMouseWorldPos = FlxG.mouse.getWorldPosition();
                var diffPos = newMouseWorldPos.subtractPoint(mouseWorldPos);
                FlxG.camera.scroll.subtractPoint(diffPos);
                FlxG.camera.scroll.set(Math.round(FlxG.camera.scroll.x), Math.round(FlxG.camera.scroll.y));
            }
        }
    }

    public function removeStructure(structure:RoomStructure) {
        this.structures.remove(structure, true);
        this.structures.sort((order, a, b) -> FlxSort.byValues(order, a.getDepth(), b.getDepth()));
    }
}
