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

class DialogTrigger extends FlxSprite {
	private var hasTriggered:Bool = false;
	private var id:String;

	public function new(id:String) {
		super();

		Reg.triggers.add(this);

		this.makeGraphic(25, 25, 0);
		this.id = id;
	}

	public function getID():String {
		trace(this.x + " " + this.y + " " + this.width + " " + this.height);
		Reg.triggers.remove(this);
		FlxG.state.remove(this);

		return this.id;
	}
}