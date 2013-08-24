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
class TimeBar extends FlxSpriteGroup {
	public var millisecondsLeft:Float = 10000;
	public var timePassRate:Float = 10; // 10x slower than normal.
	public var bar:FlxSprite;
	public var timeLeftText:FlxText;
	public var rateText:FlxText;

	public function new() {
		super();

		bar = new FlxSprite();
		bar.makeGraphic(FlxG.width, 15, 0xff0000ff);
		add(bar);

		timeLeftText = new FlxText(bar.x, bar.y, 200, "Time Left: 10 seconds");
		add(timeLeftText);

		rateText = new FlxText(FlxG.width - 100, bar.y, 100, "Dilation rate: 10x");
		add(rateText);
	}

	public override function update() {
		super.update();

		millisecondsLeft = millisecondsLeft - (1000 / (FlxG.framerate * timePassRate));

		var newWidth:Float = (millisecondsLeft / 10000.0) * FlxG.width; 

		if (newWidth > 0) {

			if (timePassRate == 10) {
				bar.makeGraphic(Std.int(newWidth), 15, 0xff0000ff);
			} else if (timePassRate == 100) {
				bar.makeGraphic(Std.int(newWidth), 15, 0xff00ffff);
			}
		}

		timeLeftText.text = "Milliseconds left: " + Std.int(millisecondsLeft);
		rateText.text = "Dilation rate: " + timePassRate + "x";
	}

	public function distortTime() {
		timePassRate = 100;
	}

	public function normalTime() {
		timePassRate = 10;
	}
}