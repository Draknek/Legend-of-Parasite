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
		
		public var inputDX:Number = 0;
		public var inputDY:Number = 0;
		
		public var isPlayer:Boolean = false;
		
		public var doAction1:Boolean = false;
		public var doAction2:Boolean = false;
		
		public var wasMoving:Boolean = false;
		public var isMoving:Boolean = false;
		
		public var preferAxis:String = "x";
		
		public var canDiagonal:Boolean = false;
		public const DIAGONAL_SCALE:Number = 1.0/Math.sqrt(2.0);
		
		private var moveTimer:int = 0;
		
		public var hurtBy:Array;
		
		public function Creature (_x:Number = 0, _y:Number = 0)
		{
			x = _x;
			y = _y;
		}
		
		public function nativeBehaviour (): void
		{
			if (moveTimer == 0) {
				doAction1 = (FP.rand(10) == 0);
				
				var r:int = FP.rand(6);
				
				if (r != 0) { // r == 0: keep going in same direction
					inputDX = 0;
					inputDY = 0;
					
					if (r == 1) inputDX = 1;
					else if (r == 2) inputDX = -1;
					else if (r == 3) inputDY = 1;
					else if (r == 4) inputDY = -1;
				
					inputDX *= 0.5;
					inputDY *= 0.5;
				}
				
				moveTimer = 16*2;
			}
			
			moveTimer--;
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
			
			inputDX = Number(Input.check(Key.RIGHT)) - Number(Input.check(Key.LEFT));
			inputDY = Number(Input.check(Key.DOWN)) - Number(Input.check(Key.UP));
			
			if (Input.pressed(Key.LEFT) || Input.pressed(Key.RIGHT)) preferAxis = "y";
			else if (Input.pressed(Key.UP) || Input.pressed(Key.DOWN)) preferAxis = "x";
			
			doAction1 = Input.pressed("ACTION1");
			doAction2 = Input.pressed("ACTION2");
		}
		
		public function checkDeath ():void
		{
			for each (var t:String in hurtBy) {
				var e:Entity = collide(t, x, y);
				
				if (e) {
					if (e is RockSpit) {
						world.remove(e);
						e = RockSpit(e).owner;
					}
					
					var c:Creature = this;
					
					collidable = false;
					
					var nextHost:Creature = e as Creature;
					
					FP.tween(c, {color: 0xFF0000}, 30, { tweener: FP.tweener });
					
					FP.tween(c, {alpha: 0.0}, 30, {
						tweener: FP.tweener,
						delay: 15,
						complete: function ():void
						{
							if (c.isPlayer) {
								Level(world).player = nextHost;
								nextHost.isPlayer = true;
								nextHost.active = true;
							}
							
							world.remove(c);
						}
					});
					
					if (c.isPlayer) {
						nextHost.active = false;
						
						var effect:Image = Image.createRect(32, 32, 0xFFFFFF, 0.5);
						
						effect.centerOO();
						
						effect.x = nextHost.x;
						effect.y = nextHost.y;
						
						FP.tween(effect, {angle: 45, alpha: 0.0}, 45, {delay: 30});
						
						world.addGraphic(effect);
					}
					
					active = false;
					graphic.active = false;
					return;
				}
			}
		}
		
		public function get color ():uint { return 0xFFFFFF; }
		
		public function set color (c:uint):void
		{
			if (graphic is Image) {
				Image(graphic).color = c;
			} else if (graphic is Graphiclist) {
				for each (var g:Graphic in Graphiclist(graphic).children) {
					if (g is Image) {
						Image(g).color = c;
					}
				}
			}
		}
		
		public function get alpha ():Number { return 1.0; }
		
		public function set alpha (n:Number):void
		{
			if (graphic is Image) {
				Image(graphic).alpha = n;
			} else if (graphic is Graphiclist) {
				for each (var g:Graphic in Graphiclist(graphic).children) {
					if (g is Image) {
						Image(g).alpha = n;
					}
				}
			}
		}
		
		public override function update (): void
		{
			wasMoving = isMoving;
			doInput();
			
			dx = inputDX;
			dy = inputDY;
			
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
			
			checkDeath();
		}
		
		public function get angle (): Number
		{
			var theta:Number = (Math.atan2(dy, dx) * FP.DEG);
			
			theta = Math.round(theta / 90.0) * 90.0;
			
			return theta - 90;
			
			// old code
			if (dx > 0.6) return -90;
			if (dx < -0.6) return 90;
			if (dy > 0.6) return 180;
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
			
			this["d"+axis] = delta * 0.25;
		}
	}
}

