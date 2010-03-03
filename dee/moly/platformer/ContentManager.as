package dee.moly.platformer{
	
	import flash.display.BitmapData;
	import flash.media.Sound;

	public class ContentManager{
	
		[Embed(source="/Content/Backgrounds/Layer0_0.png")] private static const $Backgrounds$Layer0_0Data:Class;
		private static const $Backgrounds$Layer0_0:BitmapData = new $Backgrounds$Layer0_0Data().bitmapData;
		
		[Embed(source="/Content/Backgrounds/Layer0_1.png")] private static const $Backgrounds$Layer0_1Data:Class;
		private static const $Backgrounds$Layer0_1:BitmapData = new $Backgrounds$Layer0_1Data().bitmapData;
		
		[Embed(source="/Content/Backgrounds/Layer0_2.png")] private static const $Backgrounds$Layer0_2Data:Class;
		private static const $Backgrounds$Layer0_2:BitmapData = new $Backgrounds$Layer0_2Data().bitmapData;
		
		[Embed(source="/Content/Backgrounds/Layer1_0.png")] private static const $Backgrounds$Layer1_0Data:Class;
		private static const $Backgrounds$Layer1_0:BitmapData = new $Backgrounds$Layer1_0Data().bitmapData;
		
		[Embed(source="/Content/Backgrounds/Layer1_1.png")] private static const $Backgrounds$Layer1_1Data:Class;
		private static const $Backgrounds$Layer1_1:BitmapData = new $Backgrounds$Layer1_1Data().bitmapData;
		
		[Embed(source="/Content/Backgrounds/Layer1_2.png")] private static const $Backgrounds$Layer1_2Data:Class;
		private static const $Backgrounds$Layer1_2:BitmapData = new $Backgrounds$Layer1_2Data().bitmapData;
	
		[Embed(source="/Content/Backgrounds/Layer2_0.png")] private static const $Backgrounds$Layer2_0Data:Class;
		private static const $Backgrounds$Layer2_0:BitmapData = new $Backgrounds$Layer2_0Data().bitmapData;
		
		[Embed(source="/Content/Backgrounds/Layer2_1.png")] private static const $Backgrounds$Layer2_1Data:Class;
		private static const $Backgrounds$Layer2_1:BitmapData = new $Backgrounds$Layer2_1Data().bitmapData;
		
		[Embed(source="/Content/Backgrounds/Layer2_2.png")] private static const $Backgrounds$Layer2_2Data:Class;
		private static const $Backgrounds$Layer2_2:BitmapData = new $Backgrounds$Layer2_2Data().bitmapData;
		
		[Embed(source="/Content/Overlays/you_died.png")] private static const $Overlays$you_diedData:Class;
		private static const $Overlays$you_died:BitmapData = new $Overlays$you_diedData().bitmapData;
		
		[Embed(source="/Content/Overlays/you_lose.png")] private static const $Overlays$you_loseData:Class;
		private static const $Overlays$you_lose:BitmapData = new $Overlays$you_loseData().bitmapData;
		
		[Embed(source="/Content/Overlays/you_win.png")] private static const $Overlays$you_winData:Class;
		private static const $Overlays$you_win:BitmapData = new $Overlays$you_winData().bitmapData;
		
		[Embed(source="/Content/Sprites/MonsterA/Idle.png")] private static const $Sprites$MonsterA$IdleData:Class;
		private static const $Sprites$MonsterA$Idle:BitmapData = new $Sprites$MonsterA$IdleData().bitmapData;
		
		[Embed(source="/Content/Sprites/MonsterA/Run.png")] private static const $Sprites$MonsterA$RunData:Class;
		private static const $Sprites$MonsterA$Run:BitmapData = new $Sprites$MonsterA$RunData().bitmapData;
		
		[Embed(source="/Content/Sprites/MonsterA/Die.png")] private static const $Sprites$MonsterA$DieData:Class;
		private static const $Sprites$MonsterA$Die:BitmapData = new $Sprites$MonsterA$DieData().bitmapData;
		
		[Embed(source="/Content/Sprites/MonsterB/Idle.png")] private static const $Sprites$MonsterB$IdleData:Class;
		private static const $Sprites$MonsterB$Idle:BitmapData = new $Sprites$MonsterB$IdleData().bitmapData;
		
		[Embed(source="/Content/Sprites/MonsterB/Run.png")] private static const $Sprites$MonsterB$RunData:Class;
		private static const $Sprites$MonsterB$Run:BitmapData = new $Sprites$MonsterB$RunData().bitmapData;
		
		[Embed(source="/Content/Sprites/MonsterB/Die.png")] private static const $Sprites$MonsterB$DieData:Class;
		private static const $Sprites$MonsterB$Die:BitmapData = new $Sprites$MonsterB$DieData().bitmapData;
		
		[Embed(source="/Content/Sprites/MonsterC/Idle.png")] private static const $Sprites$MonsterC$IdleData:Class;
		private static const $Sprites$MonsterC$Idle:BitmapData = new $Sprites$MonsterC$IdleData().bitmapData;
		
		[Embed(source="/Content/Sprites/MonsterC/Run.png")] private static const $Sprites$MonsterC$RunData:Class;
		private static const $Sprites$MonsterC$Run:BitmapData = new $Sprites$MonsterC$RunData().bitmapData;
		
		[Embed(source="/Content/Sprites/MonsterC/Die.png")] private static const $Sprites$MonsterC$DieData:Class;
		private static const $Sprites$MonsterC$Die:BitmapData = new $Sprites$MonsterC$DieData().bitmapData;
		
		[Embed(source="/Content/Sprites/MonsterD/Idle.png")] private static const $Sprites$MonsterD$IdleData:Class;
		private static const $Sprites$MonsterD$Idle:BitmapData = new $Sprites$MonsterD$IdleData().bitmapData;
		
		[Embed(source="/Content/Sprites/MonsterD/Run.png")] private static const $Sprites$MonsterD$RunData:Class;
		private static const $Sprites$MonsterD$Run:BitmapData = new $Sprites$MonsterD$RunData().bitmapData;
		
		[Embed(source="/Content/Sprites/MonsterD/Die.png")] private static const $Sprites$MonsterD$DieData:Class;
		private static const $Sprites$MonsterD$Die:BitmapData = new $Sprites$MonsterD$DieData().bitmapData;
		
		[Embed(source="/Content/Sprites/Player/Idle.png")] private static const $Sprites$Player$IdleData:Class;
		private static const $Sprites$Player$Idle:BitmapData = new $Sprites$Player$IdleData().bitmapData;
		
		[Embed(source="/Content/Sprites/Player/Run.png")] private static const $Sprites$Player$RunData:Class;
		private static const $Sprites$Player$Run:BitmapData = new $Sprites$Player$RunData().bitmapData;
		
		[Embed(source="/Content/Sprites/Player/Celebrate.png")] private static const $Sprites$Player$CelebrateData:Class;
		private static const $Sprites$Player$Celebrate:BitmapData = new $Sprites$Player$CelebrateData().bitmapData;
		
		[Embed(source="/Content/Sprites/Player/Die.png")] private static const $Sprites$Player$DieData:Class;
		private static const $Sprites$Player$Die:BitmapData = new $Sprites$Player$DieData().bitmapData;
		
		[Embed(source="/Content/Sprites/Player/Jump.png")] private static const $Sprites$Player$JumpData:Class;
		private static const $Sprites$Player$Jump:BitmapData = new $Sprites$Player$JumpData().bitmapData;
		
		[Embed(source="/Content/Sprites/Gem.png")] private static const $Sprites$GemData:Class;
		private static const $Sprites$Gem:BitmapData = new $Sprites$GemData().bitmapData;
		
		[Embed(source="/Content/Tiles/BlockA0.png")] private static const $Tiles$BlockA0Data:Class;
		private static const $Tiles$BlockA0:BitmapData = new $Tiles$BlockA0Data().bitmapData;
		
		[Embed(source="/Content/Tiles/BlockA1.png")] private static const $Tiles$BlockA1Data:Class;
		private static const $Tiles$BlockA1:BitmapData = new $Tiles$BlockA1Data().bitmapData;
		
		[Embed(source="/Content/Tiles/BlockA2.png")] private static const $Tiles$BlockA2Data:Class;
		private static const $Tiles$BlockA2:BitmapData = new $Tiles$BlockA2Data().bitmapData;
		
		[Embed(source="/Content/Tiles/BlockA3.png")] private static const $Tiles$BlockA3Data:Class;
		private static const $Tiles$BlockA3:BitmapData = new $Tiles$BlockA3Data().bitmapData;
		
		[Embed(source="/Content/Tiles/BlockA4.png")] private static const $Tiles$BlockA4Data:Class;
		private static const $Tiles$BlockA4:BitmapData = new $Tiles$BlockA4Data().bitmapData;
		
		[Embed(source="/Content/Tiles/BlockA5.png")] private static const $Tiles$BlockA5Data:Class;
		private static const $Tiles$BlockA5:BitmapData = new $Tiles$BlockA5Data().bitmapData;
		
		[Embed(source="/Content/Tiles/BlockA6.png")] private static const $Tiles$BlockA6Data:Class;
		private static const $Tiles$BlockA6:BitmapData = new $Tiles$BlockA6Data().bitmapData;
		
		[Embed(source="/Content/Tiles/BlockB0.png")] private static const $Tiles$BlockB0Data:Class;
		private static const $Tiles$BlockB0:BitmapData = new $Tiles$BlockB0Data().bitmapData;
		
		[Embed(source="/Content/Tiles/BlockB1.png")] private static const $Tiles$BlockB1Data:Class;
		private static const $Tiles$BlockB1:BitmapData = new $Tiles$BlockB1Data().bitmapData;
		
		[Embed(source="/Content/Tiles/Exit.png")] private static const $Tiles$ExitData:Class;
		private static const $Tiles$Exit:BitmapData = new $Tiles$ExitData().bitmapData;
		
		[Embed(source="/Content/Tiles/Platform.png")] private static const $Tiles$PlatformData:Class;
		private static const $Tiles$Platform:BitmapData = new $Tiles$PlatformData().bitmapData;
		
		[Embed(source="/Content/Sounds/ExitReached.mp3")] private static const $Sounds$ExitReachedData:Class;
		private static const $Sounds$ExitReached:Sound = new $Sounds$ExitReachedData();
		
		[Embed(source="/Content/Sounds/GemCollected.mp3")] private static const $Sounds$GemCollectedData:Class;
		private static const $Sounds$GemCollected:Sound = new $Sounds$GemCollectedData();
		
		[Embed(source="/Content/Sounds/PlayerKilled.mp3")] private static const $Sounds$PlayerKilledData:Class;
		private static const $Sounds$PlayerKilled:Sound = new $Sounds$PlayerKilledData();
		
		[Embed(source="/Content/Sounds/PlayerJump.mp3")] private static const $Sounds$PlayerJumpData:Class;
		private static const $Sounds$PlayerJump:Sound = new $Sounds$PlayerJumpData();
		
		[Embed(source="/Content/Sounds/MonsterKilled.mp3")] private static const $Sounds$MonsterKilledData:Class;
		private static const $Sounds$MonsterKilled:Sound = new $Sounds$MonsterKilledData();
		
		[Embed(source="/Content/Sounds/PlayerFall.mp3")] private static const $Sounds$PlayerFallData:Class;
		private static const $Sounds$PlayerFall:Sound = new $Sounds$PlayerFallData();
		
		[Embed(source="/Content/Sounds/PowerUp.mp3")] private static const $Sounds$PowerUpData:Class;
		private static const $Sounds$PowerUp:Sound = new $Sounds$PowerUpData();
		
		[Embed(source="/Content/Sounds/Music.mp3")] private static const $Sounds$MusicData:Class;
		private static const $Sounds$Music:Sound = new $Sounds$MusicData();
		
		public static const BITMAP:int = 0;
		public static const SOUND:int = 1;
		
		public function ContentManager():void{
		
		}
		
		public function load(type:int, path:String):*{
			
			path = path.split("/").join("$");
			
			switch(type){
				
				case BITMAP:
					
					return ContentManager[path];
					
				case SOUND:
				
					return ContentManager[path];
					
				default:
				
					throw new Error("Unknown content type");
									
			}
			
		}
		
	}
	
}