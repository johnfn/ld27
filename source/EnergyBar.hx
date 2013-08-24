package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.tile.FlxTilemap;
import flixel.group.FlxSpriteGroup;

/**
 * A FlxState which can be used for the actual gameplay.
 */
class EnergyBar extends FlxSpriteGroup {
	public var amount:Int = 180;
	public var totalAmount:Int = 180;

	public var bar:FlxSprite;
	public var description:FlxText;

	private var restoring:Bool = false;

	public function new() {
		super();
		
		bar = new FlxSprite();
		add(bar);

		bar.x = 0;
		bar.y = 5;

		description = new FlxText(0, 5, 50, "Energy");
		add(description);
	}	

	public function canDrain() {
		return amount > 0 && !restoring;
	}

	public function drain() {
		if (!restoring) {
			amount -= 1;
		}
	}

	public function restore() {
		restoring = true;
	}

	private function drawBar() {
		bar.makeGraphic(Std.int(200 * (amount / totalAmount)), 10, 0xff00ff00);
	}

	public override function update() {
		if (restoring) {
			amount += 1;
			if (amount >= totalAmount) {
				amount = totalAmount;
				restoring = false;
			}
		}

		drawBar();
	}
}