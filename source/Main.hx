package;

import flixel.FlxGame;
import openfl.display.Sprite;
import structures.Floor;
import structures.Wall;

using StringTools;

class Main extends Sprite {
    public function new() {
        super();

        stage.showDefaultContextMenu = false;

        Floor.loadAllFragmentAssets();
        Wall.loadAllFragmentAssets();

        addChild(new FlxGame(0, 0, PlayState, 60, 60, true));
    }
}
