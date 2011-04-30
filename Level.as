package
{
	import net.flashpunk.*;
	import net.flashpunk.graphics.*;
	import net.flashpunk.masks.*;
	import net.flashpunk.utils.*;
	
	public class Level extends World
	{
		[Embed(source="images/tiles.png")] public static const TilesGfx: Class;
		[Embed(source="images/rocks.png")] public static const RocksGfx: Class;
		
		public var player:Creature;
		
		public var tiles:Tilemap;
		public var solidMaskE:Entity;
		
		public const WIDTH:int = 2560;
		public const HEIGHT:int = 1600;
		
		public const GRASS:uint = 0;
		public const SAND:uint = 1;
		public const WATER:uint = 2;
		public const ROCK:uint = 3;
		
		public const WALKABLE:Object = {
			hero: [GRASS, SAND],
			octorok: [GRASS, SAND],
			leever: [SAND],
			zola: [WATER]
		};
		
		public function Level ()
		{
			tiles = new Tilemap(TilesGfx, WIDTH, HEIGHT, 16, 16);
			
			var i:int, j:int;
			
			tiles.setRect(0, 0, tiles.rows, tiles.columns, 0);
			
			tiles.setRect(7, 4, 2, 2, 1);
			
			//tiles.drawGraphic(16, 16, new Stamp(RocksGfx));
			
			var r:int = 0;
			var maxR:int = 2;
			
			tiles.usePositions = true;
			
			for (i = 0; i < WIDTH; i += 1) {
				for (j = 16; j < HEIGHT; j += 16) {
					var j1:int = j;
					var j2:int = j;
					
					r = FP.rand(maxR);
					
					if (r == 0) {
						j1--;
					} else if (r == 1) {
						j2--;
					} else {
						continue;
					}
					
					if (tiles.getTile(i, j1) == tiles.getTile(i, j2)) continue;
					
					tiles.setPixel(i, j1, 0x0);//tiles.getPixel(i, j2));
				}
			}
			
			for (i = 16; i < WIDTH; i += 16) {
				for (j = 0; j < HEIGHT; j += 1) {
					var i1:int = i;
					var i2:int = i;
					
					r = FP.rand(maxR);
					
					if (r == 0) {
						i1--;
					} else if (r == 1) {
						i2--;
					} else {
						continue;
					}
					
					if (tiles.getTile(i1, j) == tiles.getTile(i2, j)) continue;
					
					tiles.setPixel(i1, j, 0x0);//tiles.getPixel(i2, j));
				}
			}
			
			tiles.usePositions = false;
			
			addGraphic(tiles);
			
			calculateMasks();
			
			player = new Octorok(FP.width*0.5, FP.height*0.5);
			
			player.isPlayer = true;
			
			add(player);
			
			//add(new Octorok(FP.rand(FP.width*0.5)+FP.width*0.25, FP.rand(FP.height*0.5)+FP.height*0.25));
			//add(new Leever(FP.rand(FP.width*0.5)+FP.width*0.25, FP.rand(FP.height*0.5)+FP.height*0.25));
			//add(new Tektite(FP.rand(FP.width*0.5)+FP.width*0.25, FP.rand(FP.height*0.5)+FP.height*0.25));
		}
		
		public override function update (): void
		{
			super.update();
			
			if (Input.pressed(Key.R)) FP.world = new Level;
		}
		
		public override function render (): void
		{
			super.render();
		}
		
		public function calculateMasks ():void
		{
			if (solidMaskE) remove(solidMaskE);
			
			for (var type:String in WALKABLE) {
				var grid:Grid = new Grid(WIDTH, HEIGHT, 16, 16);
			
				for (var i:int = 0; i < tiles.columns; i++) {
					for (var j:int = 0; j < tiles.rows; j++) {
						var tile:uint = tiles.getTile(i, j);
						var solid:Boolean = (WALKABLE[type].indexOf(tile) < 0);
						grid.setTile(i, j, solid);
					}
				}
			
				addMask(grid, type+"_solid");
			}
		}
	}
}

