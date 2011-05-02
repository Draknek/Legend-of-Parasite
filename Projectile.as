package
{
	import net.flashpunk.*;
	import net.flashpunk.graphics.*;
	import net.flashpunk.masks.*;
	import net.flashpunk.utils.*;
	
	import flash.display.*;
	
	public class Projectile extends Entity
	{
		public var vx:Number = 0;
		public var vy:Number = 0;
		
		public var owner:Creature = null;
		
		public function Projectile (_x:Number, _y:Number, _vx:Number, _vy:Number, _owner:Creature)
		{
			super(_x, _y);
			
			vx = _vx;
			vy = _vy;
			
			owner = _owner;
		}
		
		public override function update ():void
		{
			x += vx;
			y += vy;
			
			layer = -500;
			
			if (collideTypes(["projectile_solid", "solid"], x, y)) {
				world.remove(this);
			}
			
			/*if (! onCamera) {
				visible = false;
				world.remove(this);
			}*/
		}
	}
}

