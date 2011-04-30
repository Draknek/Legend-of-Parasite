package
{
	import net.flashpunk.*;
	import net.flashpunk.graphics.*;
	import net.flashpunk.masks.*;
	import net.flashpunk.utils.*;
	
	public class Creature extends Entity
	{
		public var dx: Number = 0;
		public var dy: Number = 0;
		
		public var isPlayer:Boolean = false;
		
		public var doAction1:Boolean = false;
		public var doAction2:Boolean = false;
		
		public var wasMoving:Boolean = false;
		public var isMoving:Boolean = false;
		
		public var preferAxis:String = "x";
		
		public var canDiagonal:Boolean = false;
		public const DIAGONAL_SCALE:Number = 1.0/Math.sqrt(2.0);
		
		public function Creature (_x:Number = 0, _y:Number = 0)
		{
			x = _x;
			y = _y;
		}
		
		public function nativeBehaviour (): void
		{
			if (FP.rand(8) == 0) {
				dx = FP.rand(3) - 1;
				dy = FP.rand(3) - 1;
			}
		}
		
		public function doMovement (): void
		{
			moveBy(dx, dy, type+"_solid");
		}
		
		public function doInput (): void
		{
			doAction1 = false;
			doAction2 = false;
			
			if (! isPlayer) {
				nativeBehaviour();
				return;
			}
			
			dx = Number(Input.check(Key.RIGHT)) - Number(Input.check(Key.LEFT));
			dy = Number(Input.check(Key.DOWN)) - Number(Input.check(Key.UP));
			
			if (Input.pressed(Key.LEFT) || Input.pressed(Key.RIGHT)) preferAxis = "y";
			else if (Input.pressed(Key.UP) || Input.pressed(Key.DOWN)) preferAxis = "x";
			
			doAction1 = Input.pressed(Key.X);
			doAction2 = Input.pressed(Key.C);
		}
		
		public override function update (): void
		{
			wasMoving = isMoving;
			doInput();
			
			if (canDiagonal && dx && dy) {
				dx *= DIAGONAL_SCALE;
				dy *= DIAGONAL_SCALE;
			}
			
			if (! canDiagonal) {
				if (dx && dy) {
					this["d"+preferAxis] = 0;
				}
				
				if (dx) straighten("y");
				else if (dy) straighten("x");
			}
			
			isMoving = (dx || dy);
			doMovement();
		}
		
		public function get angle (): Number
		{
			if (dx > 0.4) return -90;
			if (dx < -0.4) return 90;
			if (dy > 0.4) return 180;
			return 0;
		}
		
		public function straighten (axis:String):void
		{
			var N:int = 2;
			
			var p:int = this[axis] % (N*2);
			
			var delta:int = 0;
			
			if (p == 0) return
			else if (p < N) delta = -1;
			else if (p > N) delta = 1;
			else if (p == N) {
				p = this[axis] % (N*4);
				
				if (p < N*2) delta = -1;
				else delta = 1;
			}
			
			this["d"+axis] = delta //* 0.25;
		}
	}
}

