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

class ShooterEnemy extends Enemy {
	private var cooldown:Float = 300;
	private var maxCooldown:Float = 300;
	private var speed:Int = 500;

	public function new(x:Int, y:Int) {
		this.facing = FlxObject.LEFT;

		super(x, y);
	}	

	private function fireBullet() {
		var vx:Int;
		if (this.facing == FlxObject.LEFT) {
			vx = speed * -1;
		} else {
			vx = speed;
		}

		var b:Bullet = new Bullet(this.x, this.y, vx, 0, this);
		FlxG.state.add(b);
	}

	override public function update() {
		cooldown -= 200 / Reg.timeDilationRate;

		if (cooldown < 0) {
			cooldown = maxCooldown;

			fireBullet();
		}
		super.update();
	}
}