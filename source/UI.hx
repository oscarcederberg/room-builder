import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;

class UI extends FlxTypedGroup<FlxSprite> {
	public var room_index_counter:FlxText;

	var parent:PlayState;

	public function new(parent:PlayState) {
		super();

		this.parent = parent;

		room_index_counter = new FlxText(FlxG.width / 4, FlxG.height / 4, 0, 'R: ${parent.room_index}', 8);
		room_index_counter.scrollFactor.set();
		add(room_index_counter);
	}

	public override function update(elapsed:Float) {
		room_index_counter.text = 'R: ${parent.room_index}';

		super.update(elapsed);
	}
}
