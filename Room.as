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
		
		public var ix:int;
		public var iy:int;
		
		public var nextRoom:Room;
		
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
			
			if (! player) {
				player = new Hero(camera.x + WIDTH*0.5, camera.y + HEIGHT*0.5);
				player.isPlayer = true;
			}
			
			add(new Octorok(FP.rand(FP.width*0.5)+FP.width*0.35, FP.rand(FP.height*0.5)+FP.height*0.35));
			add(new Leever(WIDTH+16, HEIGHT *0.5));
			add(new Leever(WIDTH+16, HEIGHT *0.5));
			add(new Leever(WIDTH+16, HEIGHT *0.5));
			//add(new Tektite(FP.rand(FP.width*0.5)+FP.width*0.25, FP.rand(FP.height*0.5)+FP.height*0.25));
		}
		
		public override function begin (): void
		{
			camera.x = ix * MOD_WIDTH;
			camera.y = iy * MOD_HEIGHT;
			add(player);
		}
		
		public override function update (): void
		{
			//if (Input.pressed(Key.R)) FP.world = new Level;
			if (Input.pressed(Key.P)) paused = ! paused;
			
			/*if (Input.pressed(Key.E)) {
				editMode = ! editMode;
				
				FP.screen.scale = editMode ? 1 : 2;
				
				if (editMode) {
					camera.x -= FP.width*0.5;
					camera.y -= FP.height*0.5;
				} else {
					camera.x = int((player.x - 8) / MOD_WIDTH) * MOD_WIDTH;
					camera.y = int((player.y - 8) / MOD_HEIGHT) * MOD_HEIGHT;
					reloadData();
				}
			}*/
			
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

