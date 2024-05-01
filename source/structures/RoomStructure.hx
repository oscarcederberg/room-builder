package structures;

import flixel.FlxSprite;

abstract class RoomStructure extends FlxSprite {
    abstract public function getDepth():Int;
}
