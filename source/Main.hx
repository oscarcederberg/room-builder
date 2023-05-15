package;

import flixel.system.FlxAssets;
import flixel.FlxGame;
import openfl.display.Sprite;

class Main extends Sprite {
	public function new() {
		super();

		RoomTile.FLOOR_MID = FlxAssets.getBitmapData("assets/images/floor/mid.png");
		addChild(new FlxGame(0, 0, PlayState, 60, 60, true));
	}
}