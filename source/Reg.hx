package;

import flixel.util.FlxSave;
import flixel.FlxState;
import flixel.tile.FlxTilemap;
import flixel.group.FlxGroup;
import flixel.FlxSprite;

/**
* Handy, pre-built Registry class that can be used to store 
* references to objects and other things for quick-access. Feel
* free to simply ignore it or change it in any way you like.
*/
class Reg {

	static public var player:Player;
	static public var map:TiledLevel;
	static public var playState:FlxState;
	static public var dialogbox:DialogBox;
	static public var timebar:TimeBar;
	static public var energybar:EnergyBar;
	static public var overlay:OverlayText = null;

	static public var timeDilationRate:Int = 10;
	static public var normalTimeDilationRate:Int = 10;
	static public var superTimeDilationRate:Int = 100;

	static public var mapX:Int = 0;
	static public var mapY:Int = 0;
	static public var mapWidth:Int = 750;
	static public var mapHeight:Int = 750;

	static public var endOfWorldTriggered:Bool = false;

	static public var rechargeStations:FlxGroup = new FlxGroup();
	static public var bullets:FlxGroup = new FlxGroup();
	static public var talkables:FlxGroup = new FlxGroup();
	static public var triggers:FlxGroup = new FlxGroup();
	static public var ladders:FlxGroup = new FlxGroup();
	static public var spikes:FlxGroup = new FlxGroup();
	static public var treasure:FlxGroup = new FlxGroup();

	static public var explainedNoEnergy:Bool = false;
	static public var noenergy:FlxGroup = new FlxGroup();

	static public var inactives:FlxGroup = new FlxGroup();
	static public var doorJoke:FlxSprite;

	static public var allDialog:Array<Array<String>>;

	static public var debug:Bool = true;

	static public function initializeDialog() {
		// This whole thing is a hack because I want a literal way of writing out dialog, rather than populating a map
		// with a for loop or something. I guess I could read from a file, but that seems like more trouble than it's worth.

		// yay ludum dare!!!!!
		Reg.allDialog = [ ["1,0"], [ "narrator", "You hear the sounds of machinery."
								   , "narrator", "Sounds like someone up ahead is hard at work!"
						           ]
						, ["1,1"], [ "you", "See that weird machine with a red dot on it?"
								   , "you", "I bet that's a recharger. If I stand on it and press Z, I can recharge my time distortion energy."
								   , "you", "It'll also act as a respawn point in case I die."
						           ]
						, ["0,2"], ["you", "Uh oh. Is that a shooter machine?",
						            "youD", "Crap... there's no way I can get past that without dying.",
						            "youD", "I guess I should just give up and let the world explode."
						            ]
						, ["1,2"], ["you", "Ha! This screen looks exactly the same as the last one.",
						            "youhuh", "...Except that weird glimmering section of the air.",
						            "you", "Eh, I'm sure it'll do absolutely nothing."
						            ]
						, ["2,2"], ["you", "Phew...",
						            "you", "That was REALLY HARD.",
						            "you", "Well, I bet was probably the hardest part of my adventure.",
						            "youD", "I'm sure this next room won't be... HOLY CRAP."
						            ]
						 , ["3,1"], ["you", "HOLY CRAP! I can't jump that far.",
						             "youD", "D:",
						             "you", "I give up!"
						            ]
			            ];
	}

	static public function hasDialogKey(s:String):Bool {
		for (x in 0...Reg.allDialog.length) {
			if (Reg.allDialog[x][0] == s) {
				return true;
			}
		}

		return false;
	}

	static public function getDialogAt(mapX:Int, mapY:Int):Array<String> {
		var key:String = '$mapX,$mapY';

		for (x in 0...Reg.allDialog.length) { // Should really count by 2s...
			if (Reg.allDialog[x][0] == key) {
				return Reg.allDialog[x+1];
			}
		}

		throw 'Dialog for $mapX,$mapY not found!';
		return [];
	}

	/**
	 * Generic levels Array that can be used for cross-state stuff.
	 * Example usage: Storing the levels of a platformer.
	 */
	static public var levels:Array<Dynamic> = [];
	/**
	 * Generic level variable that can be used for cross-state stuff.
	 * Example usage: Storing the current level number.
	 */
	static public var level:Int = 0;
	/**
	 * Generic scores Array that can be used for cross-state stuff.
	 * Example usage: Storing the scores for level.
	 */
	static public var scores:Array<Dynamic> = [];
	/**
	 * Generic score variable that can be used for cross-state stuff.
	 * Example usage: Storing the current score.
	 */
	static public var score:Int = 0;
	/**
	 * Generic bucket for storing different <code>FlxSaves</code>.
	 * Especially useful for setting up multiple save slots.
	 */
	static public var saves:Array<FlxSave> = [];
	/**
	 * Generic container for a <code>FlxSave</code>. You might want to 
	 * consider assigning <code>FlxG._game._prefsSave</code> to this in
	 * your state if you want to use the same save flixel uses internally
	 */
	static public var save:FlxSave;
}