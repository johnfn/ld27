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

class MapAwareSprite extends FlxSprite {
	// Only update if we're actually within camera bounds.
	public override function update() {
		if (!this.active) {
			this.active = this.onScreen(FlxG.camera);

			if (this.active) {
				Reg.inactives.remove(this);
			}
		} else {
			this.active = this.onScreen(FlxG.camera);

			trace("I just became inactive!");

			if (!this.active) {
				Reg.inactives.add(this);
			}
		}
		super.update();
	}
}