package
{
	import net.flashpunk.*;
	import net.flashpunk.graphics.*;
	import net.flashpunk.masks.*;
	import net.flashpunk.utils.*;
	import flash.utils.ByteArray;
	
	public class Room extends World
	{
		public var paused:Boolean = false;
		
		public var player:Creature;
		
		public var tiles:Tilemap;
		public var solidMasks:Array;
		
		public static const WIDTH:int = 256;
		public static const HEIGHT:int = 160;
		
		public static const TILES_WIDE:int = WIDTH / 16;
		public static const TILES_HIGH:int = HEIGHT / 16;
		
		public static const MOD_TILES_WIDE:int = WIDTH / 16 - 1;
		public static const MOD_TILES_HIGH:int = HEIGHT / 16 - 1;
		
		public static const MOD_WIDTH:int = WIDTH - 16;
		public static const MOD_HEIGHT:int = HEIGHT - 16;
		
		public static const GRASS:uint = 0;
		public static const SAND:uint = 1;
		public static const WATER:uint = 2;
		public static const ROCK:uint = 3;
		
		public static const BLACK:uint = 0xFF111111;
		
		public const WALKABLE:Object = {
			hero: [GRASS, SAND],
			octorok: [GRASS, SAND],
			leever: [SAND],
			zola: [WATER],
			projectile: [GRASS, SAND, WATER]
		};
		
		public const CREATURE_CLASSES:Array = [null, Hero, Octorok, Leever, Zola, null, Rock, Spike];
		
		public var ix:int;
		public var iy:int;
		
		public var nextRoom:Room;
		
		public var spawnX:int;
		public var spawnY:int;
		
		public function Room (i:int, j:int, _player:Creature = null)
		{
			ix = i;
			iy = j;
			
			camera.x = ix * MOD_WIDTH;
			camera.y = iy * MOD_HEIGHT;
			
			tiles = Overworld.tiles.getSubMap(ix*MOD_TILES_WIDE, iy*MOD_TILES_HIGH, TILES_WIDE, TILES_HIGH);
			
			addGraphic(tiles, 10, camera.x, camera.y);
			
			reloadData();
			
			player = _player;
			
			for (i = 0; i < tiles.columns; i++) {
				for (j = 0; j < tiles.rows; j++) {
					var cx:int = ix*MOD_TILES_WIDE + i;
					var cy:int = iy*MOD_TILES_HIGH + j;
					
					var c:uint = Overworld.creatures.getTile(cx, cy);
					
					if (c) {
						cx = cx*16 + 8;
						cy = cy*16 + 8;
						
						var classGO:Class = CREATURE_CLASSES[c];
						
						var e:Entity = new classGO(cx, cy);
						
						if (e is Hero) {
							if (! player) {
								add(e);
								player = e as Hero;
							}
						} else {
							add(e);
						}
					}
				}
			}
			
			var thanks:Text = new Text("Thanks for\nplaying!", 0, 72, {color: Room.BLACK, size: 8, align: "center"});
			thanks.centerOO();
			thanks.x = Overworld.WIDTH - 128 + 8;
			
			addGraphic(thanks);
			
			if (player) {
				spawnX = player.x;
				spawnY = player.y;
			}
			
		}
		
		public override function begin (): void
		{
			camera.x = ix * MOD_WIDTH;
			camera.y = iy * MOD_HEIGHT;
			if (player) add(player);
		}
		
		public override function update (): void
		{
			//if (Input.pressed(Key.R)) FP.world = new Level;
			if (Input.pressed(Key.P)) paused = ! paused;
			
			if (Input.pressed(Key.E)) {
				FP.world = new Editor(ix, iy);
				return;
			}
			
			if (paused) return;
			
			if (! paused) super.update();
			
			const HALF_TILE:Number = 8;
			
			if (player.x - camera.x < HALF_TILE) scroll(-1, 0);
			if (player.y - camera.y < HALF_TILE) scroll(0, -1);
			if (player.x - camera.x - WIDTH > -HALF_TILE) scroll(1, 0);
			if (player.y - camera.y - HEIGHT > -HALF_TILE) scroll(0, 1);
		}
		
		public override function render (): void
		{
			if (nextRoom) {
				nextRoom.camera.x = camera.x;
				nextRoom.camera.y = camera.y;
				nextRoom.render();
			}
			
			super.render();
		}
		
		public function scroll (dx:int, dy:int):void
		{
			paused = true;
			
			nextRoom = new Room(ix+dx, iy+dy, player);
			
			nextRoom.updateLists();
			//nextRoom.update();
			
			FP.tween(camera, {
				x: camera.x + dx * (MOD_WIDTH),
				y: camera.y + dy * (MOD_HEIGHT)
			}, 60, function():void {
				FP.world = nextRoom;
				remove(player);
			});
		}
		
		public function handleEditing ():void
		{
			for (var k:int = 0; k <= 3; k++) {
				if (Input.check(k + Key.DIGIT_0)) {
					tiles.usePositions = true;
					
					tiles.setTile(mouseX, mouseY, k);
					
					tiles.usePositions = false;
				}
			}
		}
		
		public function reloadData ():void
		{
			calculateMasks();
		}
		
		public function calculateMasks ():void
		{
			if (solidMasks) removeList(solidMasks);
			
			solidMasks = [];
			
			for (var type:String in WALKABLE) {
				var grid:Grid = new Grid(WIDTH, HEIGHT, 16, 16);
			
				for (var i:int = 0; i < tiles.columns; i++) {
					for (var j:int = 0; j < tiles.rows; j++) {
						var tile:uint = tiles.getTile(i, j);
						var solid:Boolean = (WALKABLE[type].indexOf(tile) < 0);
						grid.setTile(i, j, solid);
					}
				}
			
				solidMasks.push(addMask(grid, type+"_solid", camera.x, camera.y));
			}
		}
	
	}
}

