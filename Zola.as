package
{
	import net.flashpunk.*;
	import net.flashpunk.graphics.*;
	import net.flashpunk.masks.*;
	import net.flashpunk.utils.*;
	
	public class Zola extends Creature
	{
		[Embed(source="images/zola.png")] public static const ZolaGfx: Class;
		
		public var sprite:Spritemap;
		
		public function Zola (_x:Number = 0, _y:Number = 0)
		{
			super(_x, _y);
			
			graphic = sprite = new Spritemap(ZolaGfx, 16, 16);
			
			sprite.centerOO();
			
			setHitbox(16, 16, 8, 8);
			
			sprite.add("bob", [0, 1], 0.05);
			
			sprite.play("bob");
			
			type = "zola";
			
			hurtBy = ["octorok_spit"];
		}
		
		public override function doMovement (): void
		{
			moveBy(dx, dy, "zola_solid");
			
			if (! isPlayer && doAction1) {
				var p:Creature = Room(world).player;
				
				var vx:Number = p.x - x;
				var vy:Number = p.y - y;
				var vz:Number = Math.sqrt(vx*vx + vy*vy);
				vx *= 2 / vz;
				vy *= 2 / vz;
				
				world.add(new RockSpit(x, y, vx, vy, this));
			}
		}
		
	}
}

