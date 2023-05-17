package;

import RoomTile;
import flixel.FlxGame;
import openfl.display.Sprite;

using StringTools;

class Main extends Sprite {
	public function new() {
		super();

		RoomTile.loadAllFragmentAssets();

		addChild(new FlxGame(0, 0, PlayState, 60, 60, true));
	}
}