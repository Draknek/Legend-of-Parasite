package
{
	import net.flashpunk.*;
	import net.flashpunk.graphics.*;
	import net.flashpunk.masks.*;
	import net.flashpunk.utils.*;
	
	public class Level extends LoadableWorld
	{
		[Embed(source="images/tiles.png")] public static const TilesGfx: Class;
		[Embed(source="images/rocks.png")] public static const RocksGfx: Class;
		
		public var editMode:Boolean = false;
		
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
			
			tiles.setRect(0, 0, tiles.columns, tiles.rows, ROCK);
			
			tiles.setRect(1, 1, tiles.columns - 2, tiles.rows - 2, GRASS);
			
			tiles.setRect(7, 4, 2, 2, SAND);
			
			addGraphic(tiles);
			
			reloadData();
			
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
			
			if (Input.pressed(Key.E)) {
				editMode = ! editMode;
				
				FP.screen.scale = editMode ? 1 : 2;
				
				if (! editMode) {
					reloadData();
				}
			}
			
			if (editMode) {
				handleEditing();
			}
		}
		
		public override function render (): void
		{
			super.render();
			
			if (editMode) {
				Draw.line(FP.width - 8, 0, FP.width - 8, FP.height*2, 0x0)
				Draw.line(0, FP.height - 8, FP.width*2, FP.height - 8, 0x0)
			}
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
			drawEdges();
			calculateMasks();
		}
		
		public function drawEdges ():void
		{
			tiles.updateAll();
			
			var i:int, j:int;
			
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

