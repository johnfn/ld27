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

	private var touchingLadder:Bool = false;

	private var outOfEnergyOL:Bool = false;
	private var touchingNoEnergy:Bool = false;

	public static var hasTreasure:Bool = false;

	public function new() {
		super(0, 0);	

		this.drag.x = 2000;
		this.drag.y = 2000;

		this.loadGraphic("images/character.png", true, false, 25, 25);
		this.addAnimation("left", [0]);
		this.addAnimation("right", [1]);
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
		this.y = RechargeStation.lastActivatedRecharge.y  - 25;

		FlxSpriteUtil.flicker(this, 1);
	}

	public function collideWithTrigger(p:Player, trigger:DialogTrigger):Bool {
		cast(FlxG.state, PlayState).showDialog(trigger.getID());

		return false;
	}

	public function touchingStationCB(player:Player, station:RechargeStation) {
		station.activate();
	}

	public override function update() {
		super.update();

		if (this.facing == FlxObject.LEFT) {
			this.play("left");
		} else {
			this.play("right");
		}

		if (Reg.mapX == 1 && Reg.mapY == 0 && Player.hasTreasure) {
			cast(FlxG.state, PlayState).showDialog("youwin");
			return;
		}


		touchingStation = FlxG.overlap(this, Reg.rechargeStations, touchingStationCB);
		touchingNPC = FlxG.overlap(this, Reg.talkables);
		touchingDoor = FlxG.overlap(this, Reg.doorJoke);
		touchingNoEnergy = FlxG.overlap(this, Reg.noenergy);

		if (FlxG.overlap(this, Reg.treasure)) {
			cast(FlxG.state, PlayState).showDialog("treasuredialog");
			Player.hasTreasure = true;
		}

		if (FlxG.overlap(this, Reg.spikes)) {
			this.resetPosition();
		}

		touchingLadder = false;
		FlxG.overlap(this, Reg.ladders, null, function(p:Player, l:Ladder):Bool {
			touchingLadder = true;

			return false; //not obstructed by the ladder
		});

		FlxG.overlap(this, Reg.bullets, collideWithBullet);
		FlxG.overlap(this, Reg.triggers, null, collideWithTrigger);

		if (touchingLadder) {
			acceleration.y = 0;
		} else {
			acceleration.y = 1000;
		}

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

		if (FlxG.keys.UP && touchingLadder) {
			velocity.y = -300;
		}

		if (FlxG.keys.DOWN && touchingLadder) {
			velocity.y = 300;
		}

		Reg.timeDilationRate = Reg.normalTimeDilationRate;

		var isTimeSlow:Bool = false;

		if (Reg.endOfWorldTriggered) {
			Reg.timebar.exists = true;
			Reg.energybar.exists = true;
		}

		Reg.timebar.normalTime();

		var wantToClearOL:Bool = true;
		var ps:PlayState = cast(FlxG.state, PlayState);

		if (FlxG.keys.Z) {
			if (touchingStation) {
				Reg.energybar.restore();
			} else if (touchingDoor && !DoorJoke.playedOut) {
				cast(FlxG.state, PlayState).showDialog("doorjoke");
				DoorJoke.playedOut = true;
			} else if (touchingNPC) {
				FlxG.overlap(this, Reg.talkables, null, function(p:Player, t:Talkable):Bool {
					Reg.talkables.remove(t);
					t.destroy();
					return true;
				});
				if (Reg.mapX == 1 && Reg.mapY == 1) {
					// This is just a hack because i have 2 things on 1,1.
					cast(FlxG.state, PlayState).showDialog("1,1NPC");
				} else {
					cast(FlxG.state, PlayState).showDialog();
				}
			} else if (Reg.endOfWorldTriggered) {
				if (Reg.energybar.canDrain()) {
					Reg.timebar.distortTime();
					Reg.energybar.drain();
					Reg.timeDilationRate = Reg.superTimeDilationRate;
				} else {
					cast(FlxG.state, PlayState).showOverlay("No energy!");
					outOfEnergyOL = true;
					wantToClearOL = false;
				}
			}
		}

		// Funky blur effect
		if (Reg.timeDilationRate > Reg.normalTimeDilationRate) {
			if (PlayState.tilesAdded) {
				PlayState.bgtiles.visible = false;
				PlayState.tilesAdded = false;
			}
		}
		
		if (Reg.timeDilationRate == Reg.normalTimeDilationRate) {
			if (!PlayState.tilesAdded) {
				PlayState.bgtiles.visible = true;
				PlayState.tilesAdded = true;
			}
		}

		if (touchingNoEnergy) {
			Reg.energybar.drainAllEnergy();
			Reg.energybar.draw();
			if (!Reg.explainedNoEnergy) {
				Reg.explainedNoEnergy = true;
				cast(FlxG.state, PlayState).showDialog("noenergy");
			}
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
		} else if (!touchingStation && Reg.endOfWorldTriggered && FlxG.keys.Z && !Reg.energybar.canDrain()) {
			cast(FlxG.state, PlayState).showOverlay("No more energy!");
		} else {
			cast(FlxG.state, PlayState).hideOverlay();
		}
	}
}