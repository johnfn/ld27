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

class RechargeStation extends FlxSprite {
	public static var lastActivatedRecharge:RechargeStation = null;
	private var activated:Bool;

	public function new() {
		super(0, 0);	

		this.drag.x = 2000;
		this.drag.y = 2000;
		this.deactivate();

		Reg.rechargeStations.add(this);

		if (RechargeStation.lastActivatedRecharge == null) {
			RechargeStation.lastActivatedRecharge = this;
		}
	}

	public function activate() {
		if (RechargeStation.lastActivatedRecharge != null) {
			RechargeStation.lastActivatedRecharge.deactivate();
		}

		RechargeStation.lastActivatedRecharge = this;
		activated = true;
		makeGraphic(25, 25, 0xffffffff);
	}

	public function deactivate() {
		makeGraphic(25, 25, 0xffff0000);
		activated = false;
	}
}