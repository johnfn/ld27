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

/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState {
	public static var NORMAL_MODE:Int = 1;
	public static var DIALOG_MODE:Int = 2;

	public var mode:Int = 1;

	public function showDialog(special:String = "") {
		if (special != "") {
			trace(special);
			if (special == "buttonofdoom") {
				Reg.endOfWorldTriggered = true;
				Reg.dialogbox.display([ "button", "beep!"
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
									   , "you", "Well, we have a few minutes right? Let's just move the crystal or something."
									   , "professor", "You're right, we have a few minutes. Let's think this through."
									   , "narrator", "You shift your feet as you contemplate the problem."
									   , "button", "BEEP BEEP BOOP BEEP"
									   , "professor", "OH GOD NO."
									   , "professor", "YOU JUST PRESSED THE BUTTON AGAIN. NOW WE ONLY HAVE 10 SECONDS!!!"
									   , "you", "..."
									   , "you", "Derp."
									   , "professor", "Here. Put this on. It's highly experimental, and it may explode at any time, but it's our only hope!"
									   , "you", "...What is it?"
									   , "professor", "It's my latest creation - a time distortion vest. It'll make time pass for you 20 times slower than it does for anyone else."
									   , "professor", "The bar on the bottom of your visor will show you the amount of time you have left before the end of the world."
									   , "professor", "You can also press Z to - for a little bit - slow down time even more. But that requires energy."
									   , "you", "Neat!"
									   , "professor", "...Sure. Now, quickly, find a way to deactivate the laser, before the world explodes!"
									   ]);
			}
		} else {
			Reg.dialogbox.display(Reg.getDialogAt(Reg.mapX, Reg.mapY));
		}
		this.add(Reg.dialogbox);
		this.mode = DIALOG_MODE;
	}

	public function showOverlay(content:String) {
		if (Reg.overlay == null) {
			Reg.overlay = new OverlayText(content);
			add(Reg.overlay);
		}

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

		var rc:RechargeStation = new RechargeStation();
		add(rc);

		rc.x = 60;
		rc.y = 350;

		var npc:NPC = new NPC();
		add(npc);
		npc.x = 85;
		npc.y = 350;

		add(new ShooterEnemy(200, 350));

		Reg.player = new Player();
		add(Reg.player);

		Reg.player.x = 50;
		Reg.player.y = 50;

		//var ls:LaserSource = new LaserSource(100, 150);
		//add(ls);

		//ls.followTarget(Reg.player);

		FlxG.camera.follow(Reg.player, FlxCamera.STYLE_PLATFORMER);
		FlxG.camera.setBounds(0, 0, Reg.mapWidth, Reg.mapHeight);

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

		if (key == '1,0') {
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
			super.update();

			Reg.inactives.setAll("active", true);
			Reg.inactives.update();
			Reg.inactives.setAll("active", false);
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