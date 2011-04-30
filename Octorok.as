package
{
	import net.flashpunk.*;
	import net.flashpunk.graphics.*;
	import net.flashpunk.masks.*;
	import net.flashpunk.utils.*;
	
	public class Octorok extends Creature
	{
		[Embed(source="images/octorok.png")] public static const OctorokGfx: Class;
		
		public var sprite:Spritemap;
		
		public function Octorok (_x:Number = 0, _y:Number = 0)
		{
			super(_x, _y);
			
			graphic = sprite = new Spritemap(OctorokGfx, 16, 16);
			
			sprite.centerOO();
			
			//sprite.add("down", [0, 1], 0.1);
			
			//sprite.play("down");
		}
		
		public override function doMovement (): void
		{
			x += dx;
			y += dy;
			
			if (isMoving) sprite.angle = angle;
			
			sprite.rate = isMoving ? 1 : 0;
			
			if (isMoving && ! wasMoving) { sprite.index++; }
			
			if (doAction1) {
				// TODO: shoot rock
			}
		}
		
	}
}

