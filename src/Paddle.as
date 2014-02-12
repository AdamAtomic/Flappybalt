package
{
	import org.flixel.*;
	
	public class Paddle extends FlxSprite
	{
		[Embed(source="data/paddle.png")] protected var ImgPaddle:Class;
		
		static public var SPEED:int = 480;
		
		public var targetY:int = 0;
		
		public function Paddle(X:Number=0,Facing:uint=0)
		{
			super(X, FlxG.height);
			loadGraphic(ImgPaddle,false,true);
			facing = Facing;
		}
		
		public function randomize():void
		{
			targetY = 16 + FlxG.random()*(208-height);
			if(targetY < y)
				velocity.y = -SPEED;
			else
				velocity.y = SPEED;
		}
		
		override public function update():void
		{
			if( ((velocity.y < 0) && (y <= targetY + SPEED*FlxG.elapsed)) ||
				((velocity.y > 0) && (y >= targetY - SPEED*FlxG.elapsed)) )
			{
				velocity.y = 0;
				y = targetY;
			}
		}
	}
}