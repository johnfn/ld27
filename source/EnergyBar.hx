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
	public var barWidth:Int = 200;
	public var barHeight:Int = 15;

	public var whitebar:FlxSprite;
	public var bar:FlxSprite;
	public var outline:FlxSprite;
	public var description:FlxText;

	private var restoring:Bool = false;

	public function new() {
		super();

		outline = new FlxSprite();

		outline.x = 4;
		outline.y = 4;
		outline.makeGraphic(barWidth + 2, barHeight + 2, 0xff000000);
		outline.scrollFactor.x = 0;
		outline.scrollFactor.y = 0;

		add(outline);

		whitebar = new FlxSprite();
		whitebar.x = 5;
		whitebar.y = 5;
		whitebar.makeGraphic(barWidth, barHeight, 0xffffffff);
		whitebar.scrollFactor.x = 0;
		whitebar.scrollFactor.y = 0;
		
		add(whitebar);

		bar = new FlxSprite();
		add(bar);

		bar.x = 5;
		bar.y = 5;


		description = new FlxText(5, 5, 50, "Energy");
		description.color = 0;
		add(description);

		bar.scrollFactor.x = 0;
		bar.scrollFactor.y = 0;

		description.scrollFactor.x = 0;
		description.scrollFactor.y = 0;
	}	

	public function drainAllEnergy() {
		this.amount = 0;
	}

	public function full() {
		return amount == totalAmount;
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
		var width:Int = Std.int(this.barWidth * (amount / totalAmount));

		if (width < 2) width = 2;
		bar.makeGraphic(width, this.barHeight, 0xff00ff00);
	}

	public override function update() {
		if (restoring) {
			amount += Reg.timeDilationRate;
			if (amount >= totalAmount) {
				amount = totalAmount;
				restoring = false;
			}
		}

		drawBar();
	}
}