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

class RechargeStation extends FlxSprite {
	public function new() {
		super(0, 0);	

		this.drag.x = 2000;
		this.drag.y = 2000;

		makeGraphic(25, 25, 0xffff0000);

		Reg.rechargeStations.add(this);
	}
}