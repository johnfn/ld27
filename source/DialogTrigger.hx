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

class DialogTrigger extends Talkable {
	private var hasTriggered:Bool = false;
	private var id:String;

	public function new(id:String) {
		super();

		Reg.triggers.add(this);

		this.makeGraphic(25, 25, 0x00000000);
		this.id = id;
	}

	public function getID():String {
		Reg.triggers.remove(this);
		this.destroy();

		return this.id;
	}
}