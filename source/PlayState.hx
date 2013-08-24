package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.tile.FlxTilemap;

/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState {
	public static var NORMAL_MODE:Int = 1;
	public static var DIALOG_MODE:Int = 2;

	public var mode:Int = 1;

	public function showDialog() {
		Reg.dialogbox = new DialogBox(["HerpDerp!", "Yayay!"]);
		this.add(Reg.dialogbox);
		this.mode = DIALOG_MODE;
	}

	override public function create():Void {
		// Set a background color
		FlxG.cameras.bgColor = 0xff131c1b;
		// Show the mouse (in case it hasn't been disabled)
		#if !FLX_NO_MOUSE
		FlxG.mouse.show();
		#end
		
		super.create();
		var level:TiledLevel;

		level = new TiledLevel("maps/map.tmx", "images/tiles.png", 25);
		Reg.map = level;
		add(level.foregroundTiles);

		Reg.map.loadObjects(this);

		Reg.player = new Player();
		add(Reg.player);

		Reg.player.x = 50;
		Reg.player.y = 50;
		Reg.playState = this;

		Reg.timebar = new TimeBar();
		add(Reg.timebar);
		Reg.timebar.x = 0;
		Reg.timebar.y = 400;

		Reg.energybar = new EnergyBar();
		add(Reg.energybar);
	}
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void {
		super.destroy();
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update():Void {
		if (mode == NORMAL_MODE) {
			super.update();
		} else if (mode == DIALOG_MODE) {
			Reg.dialogbox.update();

			if (FlxG.keys.justReleased("X")) {
				Reg.dialogbox.next();
			}

			if (Reg.dialogbox.done()) {
				this.remove(Reg.dialogbox);
				Reg.dialogbox.destroy();
				mode = NORMAL_MODE;

				trace('setting mode back to $mode');
			}
		}
	}	
}