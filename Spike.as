package
{
	import net.flashpunk.*;
	import net.flashpunk.graphics.*;
	import net.flashpunk.masks.*;
	import net.flashpunk.utils.*;
	
	public class Spike extends Creature
	{
		[Embed(source="images/spike.png")] public static const SpikeGfx: Class;
		
		public var spawnX:int;
		public var spawnY:int;
		
		public var primed:Boolean = true;
		
		public function Spike (_x:Number = 0, _y:Number = 0)
		{
			super(_x, _y);
			
			spawnX = _x;
			spawnY = _y;
			
			graphic = new Stamp(SpikeGfx, -8, -8);
			
			setHitbox(16, 16, 8, 8);
			
			type = "spike";
			
			isAlive = false;
		}
		
		public override function nativeBehaviour (): void
		{
			if (primed) {
				var p:Creature = Room(world).player;
				
				var diffX:int = p.centerX - x;
				var diffY:int = p.centerY - y;
				
				const closeX:int = 6+p.width*0.5;
				const closeY:int = 6+p.height*0.5;
				
				if (diffX >= -closeX && diffX <= closeX) {
					inputDY = (diffY > 0) ? 1 : -1;
					primed = false;
				}
				else if (diffY >= -closeY && diffY <= closeY) {
					inputDX = (diffX > 0) ? 1 : -1;
					primed = false;
				}
			}
		}
		
		public override function doMovement (): void
		{
			if (dx || dy) {
				moveBy(dx*3, dy*3);
			
				if (collideTypes(["hero_solid", "solid", "spike"], x, y)) {
					inputDX = 0;
					inputDY = 0;
				}
			} else if (! primed) {
				var diffX:int = spawnX - x;
				var diffY:int = spawnY - y;
				
				if (diffX) x += (diffX > 0) ? 1 : -1;
				if (diffY) y += (diffY > 0) ? 1 : -1;
				
				if (!diffX && !diffY) primed = true;
			}
		}
		
	}
}

