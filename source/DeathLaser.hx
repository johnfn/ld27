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
import flixel.util.FlxSpriteUtil;

class DeathLaser extends LaserSource {
	public var eventualLaserLength:Float = 8 * 25 - 25;

	public function new(x:Float, y:Float) {
		super(x + 30, y + 18);

		outerLaserColor = 0xff661111;
		innerLaserColor = 0xff220000;
	}

	override public function update() {
		this.maxLaserLength = (1 - Reg.timebar.millisecondsLeft / 10000) * eventualLaserLength + 25;
		trace(this.maxLaserLength);

		super.update();
	}
}