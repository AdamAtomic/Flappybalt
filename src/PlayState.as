package
{
	import org.flixel.FlxG;
	import org.flixel.FlxObject;
	import org.flixel.FlxSave;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;
	import org.flixel.FlxText;

	public class PlayState extends FlxState
	{
		[Embed(source="data/background.png")] protected var ImgBG:Class;
		[Embed(source="data/bounce.png")] protected var ImgBounce:Class;
		
		static public const SAVE_DATA:String = "FLAPPYBALT";
		
		public var player:Player;
		
		public var bounceLeft:FlxSprite;
		public var bounceRight:FlxSprite;
		
		public var paddleLeft:Paddle;
		public var paddleRight:Paddle;
		
		public var scoreDisplay:FlxText;
		
		override public function create():void
		{
			FlxG.score = 0;
			
			add(new FlxSprite(0,0,ImgBG));
			
			//current score
			scoreDisplay = new FlxText(75,141,90);
			scoreDisplay.color = 0xff4d4d59;
			scoreDisplay.size = 24;
			add(scoreDisplay);
			
			//all-time high score
			var oldHighScore:int = loadScore();
			if(oldHighScore > 0)
				(add(new FlxText(FlxG.width*0.5 - 20,16,40,oldHighScore.toString())) as FlxText).alignment = "center";

			bounceLeft = new FlxSprite(1,17).loadGraphic(ImgBounce,true,false,4,206);
			bounceLeft.addAnimation("flash",[1,0],8,false);
			add(bounceLeft);
			bounceRight = new FlxSprite(FlxG.width-5,17).loadGraphic(ImgBounce,true,false,4,206);
			bounceRight.addAnimation("flash",[1,0],8,false);
			add(bounceRight);
			
			paddleLeft = new Paddle(6,FlxObject.RIGHT);
			add(paddleLeft);
			paddleRight = new Paddle(FlxG.width-15,FlxObject.LEFT);
			add(paddleRight);
			
			player = new Player();
			add(player);
		}
		
		override public function update():void
		{
			super.update();
			
			var edges:int = 14;
			if((player.y < edges) || (player.y + player.height > FlxG.height-edges) || player.overlaps(paddleLeft) || player.overlaps(paddleRight))
				player.kill();
			else if(player.x < 5)
			{
				player.x = 5;
				player.velocity.x = -player.velocity.x;
				player.facing = FlxObject.RIGHT;
				FlxG.score++;
				scoreDisplay.text = FlxG.score.toString();
				bounceLeft.play("flash");
				paddleRight.randomize();
			}
			else if(player.x + player.width > FlxG.width - 5)
			{
				player.x = FlxG.width - player.width - 5;
				player.velocity.x = -player.velocity.x;
				player.facing = FlxObject.LEFT;
				FlxG.score++;
				scoreDisplay.text = FlxG.score.toString();
				bounceRight.play("flash");
				paddleLeft.randomize();
			}
			
			if(FlxG.keys.justPressed("E") && (FlxG.keys.CONTROL || FlxG.keys.SHIFT || FlxG.keys.ALT))
			{
				clearSave();
				FlxG.resetState();
			}
		}
		
		//safely store a new high score into the saved session if possible
		static public function saveScore():void
		{
			var save:FlxSave = new FlxSave();
			if(save.bind(SAVE_DATA))
			{
				if((save.data.score == null) || (save.data.score < FlxG.score))
					save.data.score = FlxG.score;
			}
		}
		
		//load data from the saved session (mostly used elsewhere)
		//returns the total points
		static public function loadScore():int
		{
			var save:FlxSave = new FlxSave();
			if(save.bind(SAVE_DATA))
			{
				if((save.data != null) && (save.data.score != null))
					return save.data.score;
			}
			return 0;
		}
		
		//wipe save data
		static public function clearSave():void
		{
			var save:FlxSave = new FlxSave();
			if(save.bind(SAVE_DATA))
				save.erase();
		}
	}
}
