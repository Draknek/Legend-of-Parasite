package
{
	import net.flashpunk.*;
	import net.flashpunk.graphics.*;
	import net.flashpunk.masks.*;
	import net.flashpunk.utils.*;
	
	import flash.display.*;
	
	public class RockSpit extends Projectile
	{
		[Embed(source="images/rockspit.png")] public static const RockGfx: Class;
		
		public function RockSpit (_x:Number, _y:Number, _vx:Number, _vy:Number, _owner:Octorok)
		{
			super(_x, _y, _vx, _vy, _owner);
			
			graphic = new Stamp(RockGfx, -8, -8);
			
			setHitbox(6, 6, 3, 3);
			
			type = "octorok_spit";
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

