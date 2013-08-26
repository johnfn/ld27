package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.tile.FlxTilemap;
import flixel.FlxCamera;
import flixel.util.FlxRect;
import flixel.util.FlxSpriteUtil;

/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState {
	public static var NORMAL_MODE:Int = 1;
	public static var DIALOG_MODE:Int = 2;

	public static var paused:Bool = false;

	public var mode:Int = 1;

	public var hasTalked:Map<String, Bool> ;

	public function showDialog(special:String = "") {
		if (hasTalked == null) hasTalked = new Map();

		if (special != "") {
			if (hasTalked.exists(special)) return;
			hasTalked.set(special, true);

			if (special == "buttonofdoom") {
				Reg.endOfWorldTriggered = true;
				Reg.dialogbox.display([ "button", "beep!"
					#if DEBUG
									   , "professor", "OH MY GOD YOU IDIOT!"
									   , "you", "...Huh?"
									   , "professor", "YOU STEPPED ON THE BUTTON!"
									   , "you", "What button?"
									   , "professor", "THE ONE YOU STEPPED ON."
									   , "you", "..."
									   , "you", "Oh yeah!"
									   , "professor", "THE END OF THE WORLD BUTTON!!!"
									   , "you", "What?"
									   , "professor", "By pressing that button, you've triggered the end of the world!!!"
									   , "you", "Er..."
									   , "professor", "That button causes a laser to be emitted from this laser cannon here, which will crash into the red crystal here in a few minutes..."
									   , "professor", "...causing a chain reaction that will BLOW UP THE WORLD."
									   , "you", "Why do you have a button that causes the end of the world, anyways?"
									   , "professor", "That's not important right now."
									   , "you", "Well, let's just move the crystal or something."
									   , "professor", "Nah, that's impossible. But see that green switch up there? If you hit that, the laser will turn off."
									   , "you", "Um... I can't jump that high."
									   , "professor", "Drat! Well, we have a few minutes. Let's think this through."
									   , "narrator", "You shift your feet as you contemplate the problem."
									   , "button", "BEEP BEEP BOOP BEEP"
									   , "professor", "OH GOD NO."
									   , "professor", "YOU JUST PRESSED THE BUTTON AGAIN. THAT MAKES THE LASER SPEED UP! NOW WE ONLY HAVE 10 SECONDS!!!"
									   , "you", "..."
									   , "you", "Derp."
									   , "professor", "Here. Put this on. It's highly experimental, and it may explode at any time, but it's our only hope!"
									   , "you", "...What is it?"
									   , "professor", "It's my latest creation - a time distortion vest. It'll make time pass for you 20 times slower than it does for anyone else."
									   , "professor", "The bar on the bottom of your visor will show you the amount of time you have left before the end of the world."
									   , "professor", "You can also press Z to - for a little bit - slow down time even more. But that requires energy."
									   , "you", "Neat!"
									   , "professor", "...Sure. Now, quickly, find a way to deactivate the laser, before the world explodes!"
									   #end
									   ]);
			}

			if (special == "noenergy") {
				Reg.dialogbox.display(["you", "GAH! All my energy is gone!!!",
									   "you", "So THAT's what the sparkles do?",
									   "you", "Why is there even a recharge station here if the energy is COMPLETELY USELESS?"
					                   ]);
			}

			if (special == "doorjoke") {
				Reg.dialogbox.display([ "you", "...Huh?"
									   , "you", "Enter that house?"
									   , "you", "Do you have no respect for personal privacy?"
									   , "you", "I REFUSE."
									   ]);
			}

			if (special == "1,1NPC") {
				Reg.dialogbox.display([ "randomnpc", "H..."
								       , "you", "..."
								       , "randomnpc", "E..."
								       , "you", "..."
								       , "randomnpc", "L..."
								       , "you", "...zzz..."
								       , "randomnpc", "L..."
								       , "you", "Watch your tongue, old lady!"
								       , "randomnpc", "...O."
								       , "you", "..."
								       , "you", "...Oh."
								       , "narrator", "You realize that talking to other people when you're moving so fast may not be the best use of your time."
								       ]);
			}
		} else {
			Reg.dialogbox.display(Reg.getDialogAt(Reg.mapX, Reg.mapY));
		}

		this.mode = DIALOG_MODE;
	}

	public function showOverlay(content:String) {
		Reg.overlay.exists = true;
		Reg.overlay.text = content;
	}

	public function hideOverlay() {
		if (Reg.overlay != null) {
			Reg.overlay.exists = false;
		}
	}

	override public function create():Void {
		Reg.initializeDialog();

		Reg.dialogbox = new DialogBox();

		// Set a background color
		FlxG.cameras.bgColor = 0xff131c1b;
		// Show the mouse (in case it hasn't been disabled)
		#if !FLX_NO_MOUSE
		FlxG.mouse.show();
		#end

		super.create();
		var level:TiledLevel;

		level = new TiledLevel("maps/map.tmx", "images/ld27.png", 25);
		Reg.map = level;
		add(level.backgroundTiles);
		add(level.foregroundTiles);

		Reg.map.loadObjects(this);

		Reg.playState = this;

		Reg.timebar = new TimeBar();
		add(Reg.timebar);
		Reg.timebar.x = 0;
		Reg.timebar.y = FlxG.height - 15;
		Reg.timebar.exists = false;

		Reg.energybar = new EnergyBar();
		add(Reg.energybar);
		Reg.energybar.exists = false;

		add(new ShooterEnemy(200, 350));

		Reg.mapX = 1;
		Reg.mapY = 2;

		Reg.player = new Player();
		add(Reg.player);

		Reg.player.x = 50 + Reg.mapX * Reg.mapWidth;
		Reg.player.y = 50 + Reg.mapY * Reg.mapHeight;

		FlxG.camera.follow(Reg.player, FlxCamera.STYLE_PLATFORMER);
		FlxG.camera.setBounds(Reg.mapX * Reg.mapWidth, Reg.mapY * Reg.mapHeight, Reg.mapWidth, Reg.mapHeight);

		Reg.overlay = new OverlayText("");
		add(Reg.overlay);
		Reg.overlay.exists = false;

		this.add(Reg.dialogbox);

		if (Reg.debug) {
			Reg.endOfWorldTriggered = true;
		}
	}
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void {
		super.destroy();
	}

	public var hasEntered:Map<String, Bool> = null;

	public function checkEnterDialog(mx:Int, my:Int) {
		if (hasEntered == null) {
			hasEntered = new Map();
		}

		var key:String = '$mx,$my';

		if (hasEntered.exists(key)) {
			return;
		}

		hasEntered.set(key, true);

		if (Reg.hasDialogKey(key)) {
			showDialog();
		}
	}

	public function checkUpdateScreen() {
		var change:Bool = false;

		if (Reg.player.x > (Reg.mapX + 1) * Reg.mapWidth) {
			Reg.mapX++;
			change = true;
		}

		if (Reg.player.x < Reg.mapX * Reg.mapWidth) {
			Reg.mapX--;
			change = true;
		}

		if (Reg.player.y > (Reg.mapY + 1) * Reg.mapHeight) {
			Reg.mapY++;
			change = true;
		}

		if (Reg.player.y < Reg.mapY * Reg.mapHeight) {
			Reg.mapY--;
			change = true;
		}

		if (change) {
			FlxG.camera.setBounds(Reg.mapX * Reg.mapWidth, Reg.mapY * Reg.mapHeight, Reg.mapWidth, Reg.mapHeight, true);

			checkEnterDialog(Reg.mapX, Reg.mapY);
		}
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update():Void {
		checkUpdateScreen();

		if (mode == NORMAL_MODE) {
			if (LaserSource.surface != null) {
				FlxSpriteUtil.fill(LaserSource.surface, 0x00000000);
			}

			if (FlxG.keys.justPressed("P")) {
				paused = !paused;
				if (paused) {
					showOverlay("PAUSED - PRESS P");
				}
			}

			if (!paused) {
				super.update();

				Reg.inactives.setAll("active", true);
				Reg.inactives.update();
				Reg.inactives.setAll("active", false);
			}
		} else if (mode == DIALOG_MODE) {
			Reg.dialogbox.update();

			if (FlxG.keys.justPressed("Z")) {
				Reg.dialogbox.next();
			}

			if (Reg.dialogbox.done()) {
				Reg.dialogbox.backToNormal(); // bad coding... oh well
				mode = NORMAL_MODE;
			}
		}
	}	
}