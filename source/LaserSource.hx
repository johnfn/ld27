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
	private var laserSourceX:Float;
	private var laserSourceY:Float;

	private var target:FlxObject = null;

	private var collisionDummy:MapAwareSprite;
	public var maxLaserLength:Float = 0;
	public var outerLaserColor:Int = 0xffaa0000;
	public var innerLaserColor:Int = 0xffff4444;

	public static var surface:FlxSprite = null;

	public function new(x:Float, y:Float) {
		this.facing = FlxObject.LEFT;
		collisionDummy = new MapAwareSprite(0, 0); // Flixel has no way to check point-object collisions, only object-object collisions.
		collisionDummy.width = 1;
		collisionDummy.height = 1;

		this.laserSourceX = x;
		this.laserSourceY = y;
		this.maxLaserLength = Reg.mapWidth + Reg.mapHeight;

		super(0, 0);

		if (LaserSource.surface == null) {
			LaserSource.surface = new FlxSprite(0, 0).makeGraphic(Reg.mapWidth, Reg.mapHeight, 0x00000000);
			FlxG.state.add(LaserSource.surface);
		}
	}	

	public function followTarget(target:FlxObject) {
		this.target = target;
	}

    // bad style johnfn, bad style, updating private variables instead of using return values! TSK TSK
	private function raycastToWall() {
		var dx:Float = 0;
		var dy:Float = 0;

		if (this.target != null) {
			dx = this.target.x - this.laserSourceX;
			dy = this.target.y - this.laserSourceY;

			var magnitude:Float = Math.sqrt(dx * dx + dy * dy);

			dx /= magnitude;
			dy /= magnitude;
		} else {
			if (this.facing == FlxObject.LEFT) {
				dx = -1;
			} else if (this.facing == FlxObject.RIGHT){
				dx = 1;
			}
		}

		collisionDummy.x = laserSourceX;
		collisionDummy.y = laserSourceY;

		var laserLengthLeft = maxLaserLength;

		while (collisionDummy.onCurrentMap() && !Reg.map.collideWithLevel(collisionDummy) && laserLengthLeft > 0) {
			collisionDummy.x += dx * 1;
			collisionDummy.y += dy * 1;

			laserLengthLeft -= 1;
		}

		laserDestX = collisionDummy.x;
		laserDestY = collisionDummy.y;
	}

	override public function update() {
		super.update();

		surface.x = Reg.mapX * Reg.mapWidth;
		surface.y = Reg.mapY * Reg.mapHeight;

		if (laserSourceX >= surface.x && laserSourceX <= surface.x + Reg.mapWidth && 
			laserSourceY >= surface.y && laserSourceY <= surface.y + Reg.mapHeight) {
			++ticker;

			raycastToWall();

			// Outer
			FlxSpriteUtil.drawLine(LaserSource.surface, laserSourceX % Reg.mapWidth, laserSourceY % Reg.mapWidth, laserDestX % Reg.mapWidth, laserDestY % Reg.mapWidth, outerLaserColor, 6 + Std.int(Math.sin(ticker / Reg.timeDilationRate) * 4)); //pulsing brought to you with thanks to Math.sin
			// Inner
			FlxSpriteUtil.drawLine(LaserSource.surface, (laserSourceX) % Reg.mapWidth, laserSourceY % Reg.mapWidth, (laserDestX) % Reg.mapWidth, laserDestY % Reg.mapWidth, innerLaserColor, 1);
		}
	}
}