package com.kurst.cfwrk.system.data
{
	import flash.geom.Rectangle;

	public class DeviceResolutionInfo
	{
		
		public var screenSize : Rectangle 	= new Rectangle();
		public var stageSize  : Rectangle	= new Rectangle();
		
		public var assetType  : String		
		public var factor	  : int			= 1;
		
		public function DeviceResolutionInfo( 	screenWidth: int 	, screenHeight: int , 
												stageWidth: int 	, stageHeight : int , 
												assetType : String 	, 
												factor : int )
		{
		

			this.screenSize.width 	= screenWidth;
			this.screenSize.height 	= screenHeight;
			
			this.stageSize.width 	= stageWidth;
			this.stageSize.height 	= stageHeight;
			
			this.assetType 			= assetType;
			this.factor 			= factor;
													 
		}
		
	}
}
