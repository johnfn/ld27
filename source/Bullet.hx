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

class Bullet extends MapAwareSprite {
	public var owner:FlxSprite;
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
		this.immovable = true;

		Reg.bullets.add(this);
	}	

	override public function update() {
		super.update();

		if (!this.onScreen(FlxG.camera)) {
			this.exists = false;
		}

		this.velocity.x = this.baseVelocityX / Reg.timeDilationRate;
		this.velocity.y = this.baseVelocityY / Reg.timeDilationRate;

		this.immovable = false;
		if (Reg.map.collideWithLevel(this)) {
			this.exists = false;
		}
		this.immovable = true;
	}
}