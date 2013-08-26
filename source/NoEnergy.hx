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

class NoEnergy extends MapAwareSprite {
	public function new() {
		super();

		Reg.noenergy.add(this);
		this.makeGraphic(25, 25, 0);
	}
}