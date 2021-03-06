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

	public function new(x:Int, y:Int, facing:Int=FlxObject.LEFT) {
		super(x, y);
		makeGraphic(1,1,0);

		this.facing = facing;

		if (facing == FlxObject.RIGHT) {
			speed = 500;
			maxCooldown = 1000;
		}
	}	

	private function fireBullet() {
		var vx:Int;
		if (this.facing == FlxObject.LEFT) {
			vx = speed * -1;
		} else {
			vx = speed;
		}

		var b:Bullet = new Bullet(this.x, this.y + 10, vx, 0, this);
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