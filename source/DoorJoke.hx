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

class DoorJoke extends MapAwareSprite {
	public static var playedOut:Bool = false;
	
	public function new() {
		Reg.doorJoke = this;
		super();
	}
}