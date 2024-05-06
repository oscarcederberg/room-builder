package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxPoint;
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
    public static inline var TILES_COLS = 32;
    public static inline var TILES_ROWS = 32;

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
            this.currentTool = REMOVE;
        });
        this.hud.addButton("assets/images/hud/floor.png", (button) -> {
            this.currentTool = FLOOR;
        });
        this.hud.addButton("assets/images/hud/wall.png", (button) -> {
            this.currentTool = WALL;
        });
        this.hud.addSmallButton("assets/images/hud/zoom_in.png", (_) -> {
            zoom(1);
        });
        this.hud.addSmallButton("assets/images/hud/zoom_out.png", (_) -> {
            zoom(-1);
        });

        add(hud);

        centerCamera();
        refreshCameraScrollBounds();
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
        #if web
        if (FlxG.keys.pressed.CONTROL) {
            if (FlxG.mouse.pressed && !FlxG.mouse.justPressed) {
                FlxG.camera.scroll.x -= FlxG.mouse.deltaScreenX;
                FlxG.camera.scroll.y -= FlxG.mouse.deltaScreenY;
                FlxG.camera.scroll.set(Math.round(FlxG.camera.scroll.x), Math.round(FlxG.camera.scroll.y));
            }
            return;
        }
        #else
        if (FlxG.mouse.pressedMiddle && !FlxG.mouse.justPressedMiddle) {
            FlxG.camera.scroll.x -= FlxG.mouse.deltaScreenX;
            FlxG.camera.scroll.y -= FlxG.mouse.deltaScreenY;
            FlxG.camera.scroll.set(Math.round(FlxG.camera.scroll.x), Math.round(FlxG.camera.scroll.y));
            return;
        }
        #end

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

        #if web
        if (FlxG.keys.pressed.CONTROL && (FlxG.keys.justPressed.UP || FlxG.keys.justPressed.DOWN)) {
            var by = if (FlxG.keys.justPressed.UP) 1 else -1;
            var into = FlxG.mouse.getWorldPosition();
            zoomInto(by, into);
        }
        #else
        if (FlxG.keys.pressed.CONTROL) {
            var into = FlxG.mouse.getWorldPosition();
            zoomInto(FlxG.mouse.wheel, into);
        }
        #end
    }

    public function removeStructure(structure:RoomStructure) {
        this.structures.remove(structure, true);
        this.structures.sort((order, a, b) -> FlxSort.byValues(order, a.getDepth(), b.getDepth()));
    }

    public function zoom(by:Int) {
        var oldZoom = FlxG.camera.zoom;
        var newZoom = Math.min(4, Math.max(1, oldZoom + by));

        if (oldZoom != newZoom) {
            FlxG.camera.zoom = newZoom;
            FlxG.camera.scroll.set(Math.round(FlxG.camera.scroll.x), Math.round(FlxG.camera.scroll.y));
            refreshCameraScrollBounds();
        }
    }

    public function zoomInto(by:Int, into:FlxPoint) {
        var oldZoom = FlxG.camera.zoom;
        var newZoom = Math.min(4, Math.max(1, oldZoom + by));

        if (oldZoom != newZoom) {
            FlxG.camera.zoom = newZoom;
            var newMouseWorldPos = FlxG.mouse.getWorldPosition();
            var diffPos = newMouseWorldPos.subtractPoint(into);
            FlxG.camera.scroll.subtractPoint(diffPos);
            FlxG.camera.scroll.set(Math.round(FlxG.camera.scroll.x), Math.round(FlxG.camera.scroll.y));
            refreshCameraScrollBounds();
        }
    }

    private function centerCamera() {
        var midCol = Math.round(TILES_COLS / 2);
        var midRow = Math.round(TILES_ROWS / 2);
        var midTile = this.editorTilesVec[midCol][midRow];

        this.camera.scroll.x = Math.round(midTile.x - FlxG.width / 2 + EditorTile.EDITOR_TILE_WIDTH / 2);
        this.camera.scroll.y = Math.round(midTile.y - FlxG.height / 2);
    }

    private function refreshCameraScrollBounds() {
        var gameHalfWidth = FlxG.width / (2 * FlxG.camera.zoom);
        var gameHalfHeight = FlxG.height / (2 * FlxG.camera.zoom);
        var minX = this.editorTilesVec[0][TILES_ROWS - 1].x - gameHalfWidth + EditorTile.EDITOR_TILE_GRAPHICS_WIDTH / 2;
        var maxX = this.editorTilesVec[TILES_COLS - 1][0].x + gameHalfWidth + EditorTile.EDITOR_TILE_GRAPHICS_WIDTH / 2;
        var minY = this.editorTilesVec[0][0].y - gameHalfHeight + EditorTile.EDITOR_TILE_HEIGHT / 2;
        var maxY = this.editorTilesVec[TILES_COLS - 1][TILES_ROWS - 1].y + gameHalfHeight + EditorTile.EDITOR_TILE_HEIGHT / 2;
        this.camera.setScrollBounds(minX, maxX, minY, maxY);
    }
}
