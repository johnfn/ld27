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

class Player extends FlxSprite {
	private var touchingStation:Bool = false;

	public function new() {
		super(0, 0);	

		this.drag.x = 2000;
		this.drag.y = 2000;

		makeGraphic(25, 25, 0xffff0000);
	}

	public override function update() {
		super.update();

		touchingStation = FlxG.overlap(this, Reg.rechargeStations);

		acceleration.y = 1000;

		Reg.map.collideWithLevel(this);

		if (FlxG.keys.X && this.isTouching(FlxObject.FLOOR)) {
			velocity.y = -500;
		}

		if (FlxG.keys.LEFT) {
			velocity.x = -300;
			this.facing = FlxObject.LEFT;
		}

		if (FlxG.keys.RIGHT) {
			velocity.x = 300;
			this.facing = FlxObject.RIGHT;
		}

		Reg.timeDilationRate = 10;

		if (FlxG.keys.Z && Reg.energybar.canDrain()) {
			if (touchingStation) {
				Reg.energybar.restore();
			} else {
				Reg.timebar.distortTime();
				Reg.energybar.drain();
			Reg.timeDilationRate = 100;
			}
		} else {
			Reg.timebar.normalTime();
		}

		if (FlxG.keys.justReleased("Y")) {
			cast(FlxG.state, PlayState).showDialog();
		}

		checkOverlays();
	}

	public function checkOverlays() {
		if (touchingStation) {
			cast(FlxG.state, PlayState).showOverlay("Z to recharge!");
		} else {
			cast(FlxG.state, PlayState).hideOverlay();
		}
	}
}