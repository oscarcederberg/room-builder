package hud;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class HUD extends FlxSpriteGroup {
    var parent:PlayState;
    var buttons:FlxTypedSpriteGroup<Button>;
    var smallButtons:FlxTypedSpriteGroup<SmallButton>;
    var buttonIcons:FlxSpriteGroup;

    var debugText:FlxText;

    public function new(parent:PlayState) {
        super();

        this.parent = parent;

        this.scrollFactor.set(0, 0);

        this.camera = new FlxCamera(0, 0, FlxG.width, FlxG.height, 1);
        this.camera.bgColor = FlxColor.TRANSPARENT;
        FlxG.cameras.add(camera, false);

        this.buttons = new FlxTypedSpriteGroup<Button>();
        add(this.buttons);

        this.smallButtons = new FlxTypedSpriteGroup<SmallButton>();
        add(this.smallButtons);

        this.buttonIcons = new FlxSpriteGroup();
        add(this.buttonIcons);

        this.debugText = new FlxText(0, 0, 0, 'zoom: ${FlxG.camera.zoom}\nx: ${FlxG.camera.scroll.x}\ny: ${FlxG.camera.scroll.y}');
        this.debugText.setBorderStyle(FlxTextBorderStyle.OUTLINE_FAST, FlxColor.fromRGB(32, 32, 64), 1);
        add(this.debugText);

        #if !debug
        this.debugText.visible = false;
        #end
    }

    override function update(elapsed:Float) {
        if (this.debugText.visible) {
            this.debugText.text = 'zoom: ${FlxG.camera.zoom}\nx: ${FlxG.camera.scroll.x}\ny: ${FlxG.camera.scroll.y}';
        }

        super.update(elapsed);
    }

    public function addButton(iconAsset:String, ?callback:BaseButton->Void) {
        var x = this.buttons.length * Button.WIDTH;
        var y = FlxG.height - Button.HEIGHT;
        var button = new Button(x, y, (button) -> {
            if (button.isSelected()) {
                updateButtonStates(button);
            }

            if (callback != null) {
                callback(button);
            }
        });

        var icon = new FlxSprite(x, y, iconAsset);
        this.buttons.add(button);
        this.buttonIcons.add(icon);
        if (this.buttons.length == 1) {
            button.setSelected(true);
        }
    }

    public function addSmallButton(iconAsset:String, ?callback:BaseButton->Void) {
        var x = this.smallButtons.length * SmallButton.WIDTH;
        var y = FlxG.height - Button.HEIGHT - SmallButton.HEIGHT;
        var smallButton = new SmallButton(x, y, (button) -> {
            if (callback != null) {
                callback(button);
            }
            button.setSelected(false);
        });

        var icon = new FlxSprite(x, y, iconAsset);
        this.smallButtons.add(smallButton);
        this.buttonIcons.add(icon);
    }

    public function handleInput():Bool {
        for (button in this.buttons) {
            if (button.handleInput()) {
                return true;
            }
        }

        for (button in this.smallButtons) {
            if (button.handleInput()) {
                return true;
            }
        }

        return false;
    }

    private function updateButtonStates(updatedButton:BaseButton) {
        for (button in this.buttons) {
            if (button != updatedButton) {
                button.setSelected(false);
            }
        }
    }
}
