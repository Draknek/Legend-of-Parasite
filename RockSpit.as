package
{
	import net.flashpunk.*;
	import net.flashpunk.graphics.*;
	import net.flashpunk.masks.*;
	import net.flashpunk.utils.*;
	
	import flash.display.*;
	
	public class RockSpit extends Entity
	{
		[Embed(source="images/rockspit.png")] public static const RockGfx: Class;
		
		public var vx:Number = 0;
		public var vy:Number = 0;
		
		public var owner:Octorok = null;
		
		public function RockSpit (_x:Number, _y:Number, _vx:Number, _vy:Number, _owner:Octorok)
		{
			super(_x, _y);
			
			vx = _vx;
			vy = _vy;
			
			owner = _owner;
			
			graphic = new Stamp(RockGfx, -8, -8);
			
			setHitbox(6, 6, 3, 3);
			
			type = "octorok_spit";
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
		
		public override function removed ():void
		{
			if (! visible) return;
			
			var e:Emitter = new Emitter(foo, 2, 2);
			e.newType("a");
			e.setMotion("a", 0, 10, 15, 360, 5, 10);
			e.setAlpha("a");
			e.emit("a", x, y);
			e.emit("a", x, y);
			e.emit("a", x, y);
			e.emit("a", x, y);
			e.emit("a", x, y);
			e.emit("a", x, y);
			e.emit("a", x, y);
			e.emit("a", x, y);
			e.emit("a", x, y);
			FP.world.addGraphic(e);
		}
		
		public static const foo:BitmapData = new BitmapData(2, 2, false, 0x4e5159);
	}
}

