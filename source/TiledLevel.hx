
package;

import openfl.Assets;
import haxe.io.Path;
import haxe.xml.Parser;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.tile.FlxTilemap;
import flixel.addons.editors.tiled.TiledMap;
import flixel.addons.editors.tiled.TiledObject;
import flixel.addons.editors.tiled.TiledObjectGroup;
import flixel.addons.editors.tiled.TiledTileSet;

/**
 * ...
 * @author Samuel Batista
 */
class TiledLevel extends TiledMap
{
	// For each "Tile Layer" in the map, you must define a "tileset" property which contains the name of a tile sheet image 
	// used to draw tiles in that layer (without file extension). The image file must be located in the directory specified bellow.
	private inline static var c_PATH_LEVEL_TILESHEETS = "images/";

	// Array of tilemaps used for collision
	public var foregroundTiles:FlxGroup;
	public var backgroundTiles:FlxGroup;
	public var tileSheet:String;
	public var tileSize:Int;
	private var collidableTileLayers:Array<FlxTilemap>;

	public function new(tiledLevel:Dynamic, tileSheet:String, tileSize:Int) {
		super(tiledLevel);
		this.collidableTileLayers = [];
		this.tileSheet = tileSheet;
		this.tileSize = tileSize;

		foregroundTiles = new FlxGroup();
		backgroundTiles = new FlxGroup();

		FlxG.camera.setBounds(0, 0, fullWidth, fullHeight, true);

		var layer:FlxTilemap = loadLayer("Map");
		collidableTileLayers.push(layer);
		foregroundTiles.add(layer);

		var bglayer:FlxTilemap = loadLayer("nocollide");
		backgroundTiles.add(bglayer);
	}

	public function loadLayer(layer:String):FlxTilemap {
		var result:FlxTilemap;

		for ( tileLayer in layers ) {
			if (tileLayer.name != layer) continue;

			var imagePath 		= new Path(tileSheet);
			var processedPath 	= c_PATH_LEVEL_TILESHEETS + imagePath.file + "." + imagePath.ext;

			var tilemap:FlxTilemap = new FlxTilemap();
			tilemap.widthInTiles = width;
			tilemap.heightInTiles = height;
			tilemap.loadMap(tileLayer.tileArray, processedPath, tileSize, tileSize, 0, 1, 1, 1);

			return tilemap;
		}

		throw 'Couldn\'t find layer named $layer';
		return null;
	}

	public function loadObjects(state:PlayState) {
		for (group in objectGroups) {
			for (o in group.objects) {
				loadObject(o, group, state);
			}
		}
	}

	private function loadObject(o:TiledObject, g:TiledObjectGroup, state:PlayState) {
		var x:Int = o.x;
		var y:Int = o.y;

		// objects in tiled are aligned bottom-left (top-left in flixel)
		if (o.gid != -1)
			y -= g.map.getGidOwner(o.gid).tileHeight;

		switch (o.type.toLowerCase()) {
			case "buttonofdoom":
				var dt:DialogTrigger = new DialogTrigger(o.type.toLowerCase());
				dt.x = x;
				dt.y = y;
				FlxG.state.add(dt);
			case "npc":
				var npc:NPC = new NPC();
				npc.x = x;
				npc.y = y;
			case "doorjoke":
				var dj:DoorJoke = new DoorJoke();
				dj.x = x;
				dj.y = y;
			case "recharger":
				var rc:RechargeStation = new RechargeStation();
				rc.x = x;
				rc.y = y;
				FlxG.state.add(rc);
			case "deathlaser":
				var dl:DeathLaser = new DeathLaser(x, y);
				dl.x = 0;
				dl.y = 0;
				FlxG.state.add(dl);
			case "ladder":
				var l:Ladder = new Ladder();
				l.x = x;
				l.y = y;
				FlxG.state.add(l);
			case "shooterleft":
				var s:ShooterEnemy = new ShooterEnemy(x, y);
				FlxG.state.add(s);
			case "shooterright":
				var s:ShooterEnemy = new ShooterEnemy(x, y, FlxObject.RIGHT);
				FlxG.state.add(s);
			case "spikes":
				var ss:Spike = new Spike();
				ss.x = x;
				ss.y = y;
				FlxG.state.add(ss);
			case "noenergy":
				var ne:NoEnergy = new NoEnergy();
				ne.x = x;
				ne.y = y;
				FlxG.state.add(ne);
			case "treasure":
				var t:Treasure = new Treasure();
				t.x = x;
				t.y = y;
				FlxG.state.add(t);
		}
	}

	public function collideWithLevel(obj:FlxObject, ?notifyCallback:FlxObject->FlxObject->Void, ?processCallback:FlxObject->FlxObject->Bool):Bool
	{
		if (collidableTileLayers != null)
		{
			for ( map in collidableTileLayers)
			{
				// IMPORTANT: Always collide the map with objects, not the other way around. 
				//			  This prevents odd collision errors (collision separation code off by 1 px).
				return FlxG.overlap(map, obj, notifyCallback, processCallback != null ? processCallback : FlxObject.separate);
			}
		}
		return false;
	}
}