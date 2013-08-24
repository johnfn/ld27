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

class Bullet extends FlxSprite {
	var owner:FlxSprite;
	var baseVelocityX:Float;
	var baseVelocityY:Float;

	public function new(x:Float, y:Float, vx:Float, vy:Float, owner:FlxSprite) {
		super(x, y);

		this.baseVelocityX = vx * 10;
		this.baseVelocityY = vy * 10; // to accomodate for 10x slowdown, which is on by default.

		this.velocity.x = vx;
		this.velocity.y = vy;
		this.owner = owner;

		this.makeGraphic(5, 5, 0xffffff00);
	}	

	override public function update() {
		super.update();
		
		if (Reg.map.collideWithLevel(this)) {
			cast(FlxG.state, PlayState).remove(this);
			this.destroy();
		}

		this.velocity.x = this.baseVelocityX / Reg.timeDilationRate;
		this.velocity.y = this.baseVelocityY / Reg.timeDilationRate;
	}
}