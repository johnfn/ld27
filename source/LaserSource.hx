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

class LaserSource extends Enemy {
	private var cooldown:Float = 300;
	private var maxCooldown:Float = 300;
	private var speed:Int = 500;
	private var ticker:Int = 0;

	private var laserDestX:Float;
	private var laserDestY:Float;

	private var target:FlxObject = null;

	private var collisionDummy:MapAwareSprite;

	public function new(x:Int, y:Int) {
		this.facing = FlxObject.LEFT;
		collisionDummy = new MapAwareSprite(0, 0); // Flixel has no way to check point-object collisions, only object-object collisions.
		collisionDummy.width = 1;
		collisionDummy.height = 1;

		super(x, y);

		this.makeGraphic(1000, 1000, 0x00000000);
		this.width = 1000;
		this.height = 1000;
	}	

	public function followTarget(target:FlxObject) {
		this.target = target;
	}

    // bad style johnfn, bad style, updating private variables instead of using return values! TSK TSK
	private function raycastToWall() {
		var dx:Int = 0;
		var dy:Int = 0;

		if (this.target != null) {
			//TODO
			throw "haven't implemented laser targets yet.";
		} else {
			if (this.facing == FlxObject.LEFT) {
				dx = -1;
			} else if (this.facing == FlxObject.RIGHT){
				dx = 1;
			}
		}

		collisionDummy.x = this.x;
		collisionDummy.y = this.y;

		while (collisionDummy.onCurrentMap() && !Reg.map.collideWithLevel(collisionDummy)) {
			collisionDummy.x += dx * 10;
			collisionDummy.y += dy * 10;
		}

		laserDestX = collisionDummy.x;
		laserDestY = collisionDummy.y;
	}

	override public function update() {
		super.update();

		++ticker;

		FlxSpriteUtil.fill(this, 0x00000000);

		raycastToWall();

		// Outer
		FlxSpriteUtil.drawLine(this, this.x, this.y, laserDestX, laserDestY, 0xffaa0000, 6 + Std.int(Math.sin(ticker / Reg.timeDilationRate) * 4)); //pulsing brought to you with thanks to Math.sin
		// Inner
		FlxSpriteUtil.drawLine(this, this.x, this.y, laserDestX, laserDestY, 0xffff4444, 1);
	}
}