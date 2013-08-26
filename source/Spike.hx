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

class Spike extends MapAwareSprite {
	public function new() {
		super();

		Reg.spikes.add(this);
		this.makeGraphic(25, 25, 0);
	}
}