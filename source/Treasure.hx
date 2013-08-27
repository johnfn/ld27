package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.tile.FlxTilemap;
import flixel.group.FlxSpriteGroup;
import flixel.FlxObject;

class Treasure extends FlxSprite {
	private var activated:Bool;

	public static var treasureGotten:Bool = true;

	public function new() {
		super(0, 0);	

		this.loadGraphic("images/treasurechest.png", true, false, 25, 25);
		this.addAnimation("deactivated", [0]);
		this.addAnimation("activated", [1]);

		this.play("deactivated");

		Reg.treasure.add(this);
	}

	public function open() {
		this.play("activated");
	}
}