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

	public function showDialog() {
		Reg.dialogbox = new DialogBox(Reg.getDialogAt(0, 0)); //TODO
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

		Reg.playState = this;

		Reg.timebar = new TimeBar();
		add(Reg.timebar);
		Reg.timebar.x = 0;
		Reg.timebar.y = 400;

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

		var ls:LaserSource = new LaserSource(100, 150);
		add(ls);

		FlxG.camera.follow(Reg.player, FlxCamera.STYLE_PLATFORMER);
		FlxG.camera.setBounds(0, 0, 1000, 1000);
	}
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void {
		super.destroy();
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
				this.remove(Reg.dialogbox);
				Reg.dialogbox.destroy();
				mode = NORMAL_MODE;
			}
		}
	}	
}