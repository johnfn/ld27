package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.tile.FlxTilemap;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxSpriteUtil;
import flixel.FlxObject;

class Player extends FlxSprite {
	private var touchingStation:Bool = false;
	private var touchingNPC:Bool = false;
	private var touchingDoor:Bool = false;

	public function new() {
		super(0, 0);	

		this.drag.x = 2000;
		this.drag.y = 2000;

		makeGraphic(25, 25, 0xffff0000);
	}

	public function collideWithBullet(player:Player, bullet:Bullet) {
		if (bullet.owner == player) {
			return;
		}

		if (Reg.timeDilationRate == Reg.normalTimeDilationRate) {
			player.resetPosition();
		} else {
			FlxObject.separate(player, bullet);
		}
	}

	public function resetPosition() {
		this.x = RechargeStation.lastActivatedRecharge.x;
		this.y = RechargeStation.lastActivatedRecharge.y;

		FlxSpriteUtil.flicker(this, 5);
	}

	public function collideWithTrigger(p:Player, trigger:DialogTrigger) {
		cast(FlxG.state, PlayState).showDialog(trigger.getID());
	}

	public function touchingStationCB(player:Player, station:RechargeStation) {
		station.activate();
	}

	public override function update() {
		super.update();

		touchingStation = FlxG.overlap(this, Reg.rechargeStations, touchingStationCB);
		touchingNPC = FlxG.overlap(this, Reg.talkables);
		touchingDoor = FlxG.overlap(this, Reg.doorJoke);

		FlxG.overlap(this, Reg.bullets, collideWithBullet);
		FlxG.overlap(this, Reg.triggers, collideWithTrigger);

		acceleration.y = 1000;

		Reg.map.collideWithLevel(this);

		if (FlxG.keys.X && this.isTouching(FlxObject.FLOOR)) {
			velocity.y = -500;
		}

		if (!FlxG.keys.X && velocity.y < 0) {
			velocity.y = 0;
		}

		if (FlxG.keys.LEFT) {
			velocity.x = -300;
			this.facing = FlxObject.LEFT;
		}

		if (FlxG.keys.RIGHT) {
			velocity.x = 300;
			this.facing = FlxObject.RIGHT;
		}

		Reg.timeDilationRate = Reg.normalTimeDilationRate;

		if (Reg.endOfWorldTriggered) {
			Reg.timebar.exists = true;
			Reg.energybar.exists = true;
			if (FlxG.keys.Z && Reg.energybar.canDrain()) {
				if (touchingStation) {
					Reg.energybar.restore();
				} else if (touchingNPC) {
					if (Reg.mapX == 1 && Reg.mapY == 1) {
						// This is just a hack because i have 2 things on 1,1.
						cast(FlxG.state, PlayState).showDialog("1,1NPC");
					} else {
						cast(FlxG.state, PlayState).showDialog();
					}
				} else {
					Reg.timebar.distortTime();
					Reg.energybar.drain();
					Reg.timeDilationRate = Reg.superTimeDilationRate;
				}
			} else {
				Reg.timebar.normalTime();
			}
		} else {
			if (FlxG.keys.Z) {
				if (touchingNPC) {
					if (Reg.mapX == 1 && Reg.mapY == 1) {
						// This is just a hack because i have 2 things on 1,1.
						cast(FlxG.state, PlayState).showDialog("1,1NPC");
					} else {
						cast(FlxG.state, PlayState).showDialog();
					}
				}

				if (touchingDoor) {
					cast(FlxG.state, PlayState).showDialog("doorjoke");
					DoorJoke.playedOut = true;
				}
			}
		}

		if (FlxG.keys.justReleased("Y")) {
			cast(FlxG.state, PlayState).showDialog();
		}

		checkOverlays();
	}

	public function checkOverlays() {
		if (touchingStation && !Reg.energybar.full()) {
			cast(FlxG.state, PlayState).showOverlay("Z to recharge!");
		} else if (touchingNPC) {
			cast(FlxG.state, PlayState).showOverlay("Z to talk!");
		} else if (touchingDoor && !DoorJoke.playedOut) {
			cast(FlxG.state, PlayState).showOverlay("Z to enter!");
		} else {
			cast(FlxG.state, PlayState).hideOverlay();
		}
	}
}