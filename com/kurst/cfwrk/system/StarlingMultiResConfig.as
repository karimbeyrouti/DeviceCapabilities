/********************************************************************************************************************************************************************************
 * 
 * Class Name	: StarlingMultiResConfig
 * Version		: 1
 * Description 	: Configure the viewport and stage for starling games and applications base on device type, resolution, and orientation
 * 
 ********************************************************************************************************************************************************************************
 * 
 * Author 		: based on: http://wiki.starling-framework.org/manual/multi-resolution_development
 * 				  Karim Beyrouti ( karim@kurst.co.uk )
 * 
 ********************************************************************************************************************************************************************************
 * 
 * METHODS
 * 
 * 		StarlingMultiResConfig.set( flStage : Stage , starling : Starling , viewPort : Rectangle = null , desktopStage : Rectangle = null , simulateDevice 	: String = null ) : void
 * 	
 *********************************************************************************************************************************************************************************
 * NOTES	 
 * 
 *	_starling = new Starling(StarlingRootClass, stage );
 *	
 *	Simulate an IOS device:		StarlingMultiResConfig.set( stage, _starling , null , null , OSList.IOS );
 * 	Simulate an Android device: StarlingMultiResConfig.set( stage, _starling , null , null , OSList.ANDROID );
 * 	Production / no simulation: StarlingMultiResConfig.set( stage, _starling ) ;
 * 		
 **********************************************************************************************************************************************************************************/
package com.kurst.cfwrk.system
{

	import starling.core.Starling;

	import com.kurst.cfwrk.system.constants.DeviceAssetType;
	import com.kurst.cfwrk.system.constants.OSList;
	import com.kurst.cfwrk.system.data.DeviceInfo;
	import com.kurst.cfwrk.system.data.DeviceResolutionInfo;

	import flash.display.Stage;
	import flash.geom.Rectangle;

	public class StarlingMultiResConfig
	{
		//------------------------------------------------------------------------
		
		public static var viewPort : Rectangle = new Rectangle();
		
		//------------------------------------------------------------------------
		
		private static var androidResolutionSettings 	: Vector.<DeviceResolutionInfo> = new Vector.<DeviceResolutionInfo>();
		private static var resolutionSettingInitFlag 	: Boolean = false;
		private static var iPhoneResolutionSetting 		: DeviceResolutionInfo;
		private static var iPadResolutionSetting 		: DeviceResolutionInfo;

		//------------------------------------------------------------------------------------
		
		/**
		 * 
		 * Configure starling stage depending on device resolution. 
		 * 
		 * flStage 			: Stage 			- Stage
		 * starling 		: Starling 			- Starling instance
		 * viewPort 		: Rectangle = null 	- Custom view port size - will use fullScreenWidth / fullScreenHeight if not set
		 * desktopStage 	: Rectangle = null	- Size of starling stage for desktop apps
		 * simulateDevice 	: String 	= null	- Simulate device ( OSList.IOS /  OSList.ANDROID )
		 *  
		 */
		public static function set(flStage : Stage, starling : Starling, viewPort : Rectangle = null, desktopStage : Rectangle = null, simulateDevice : String = null) : void
		{
		
			DeviceCapabilities.init(flStage);
			initResolutionInfo();

			if ( !viewPort )
			{
				StarlingMultiResConfig.viewPort.width = flStage.fullScreenWidth;
				StarlingMultiResConfig.viewPort.height = flStage.fullScreenHeight;
			}
			else
			{
				StarlingMultiResConfig.viewPort = viewPort;
			}

			starling.viewPort 			= StarlingMultiResConfig.viewPort;
			var landscape : Boolean 	= DeviceCapabilities.isLandscape();
			var deviceInfo : DeviceInfo = DeviceCapabilities.deviceInformation(simulateDevice);

			if ( deviceInfo.os == OSList.IOS )
			{
				if ( DeviceCapabilities.isTablet() )
				{
					updateAndMaintainAspectRatio( 	landscape ? iPadResolutionSetting.stageSize.width : iPadResolutionSetting.stageSize.height , 
													landscape ? iPadResolutionSetting.stageSize.height : iPadResolutionSetting.stageSize.width , 
													flStage , starling );
				}
				else
				{
					updateAndMaintainAspectRatio( 	landscape ? iPhoneResolutionSetting.stageSize.width : iPhoneResolutionSetting.stageSize.height , 
													landscape ? iPhoneResolutionSetting.stageSize.height : iPhoneResolutionSetting.stageSize.width , 
													flStage , starling );
				}
				
			}
			else if ( deviceInfo.os == OSList.ANDROID )
			{
				matchClosestResolution(flStage, starling, androidResolutionSettings)
			}
			else if ( deviceInfo.os == OSList.MAC || deviceInfo.os == OSList.WINDOWS )
			{
				if ( desktopStage )
				{
					starling.stage.stageWidth 	= desktopStage.width;
					starling.stage.stageHeight	= desktopStage.height;
				}
				else
				{
					starling.stage.stageWidth 	= StarlingMultiResConfig.viewPort.width;
					starling.stage.stageHeight 	= StarlingMultiResConfig.viewPort.height;
				}
			}
		}
		
		//------------------------------------------------------------------------------------

		/**
		 * match closest resolution of device with from list of device resolutions and recomended stage sizes 
		 */
		private static function matchClosestResolution(flStage : Stage, starling : Starling, data : Vector.<DeviceResolutionInfo>) : void
		{
			var screenSize 		: Rectangle = new Rectangle();
				screenSize.width 			= flStage.fullScreenWidth;
				screenSize.height 			= flStage.fullScreenHeight;
			
			var selectedResolution 	: int 		= -1;
			var diff 				: Rectangle = new Rectangle();
			var smallestDiff 		: Rectangle;
			var dri 				: DeviceResolutionInfo;
			var w 					: int;
			var h 					: int;

			for (var c : int = 0; c < data.length; c ++)
			{
				
				dri 		= data[c];
				diff.width 	= screenSize.width - dri.screenSize.width;
				diff.height = screenSize.height - dri.screenSize.height;
				
				if ( smallestDiff == null )
				{
					smallestDiff = diff.clone();
					selectedResolution = c;
				}
				else
				{
					if ( diff.width + diff.height < smallestDiff.width + smallestDiff.height )
					{
						selectedResolution = c;
						smallestDiff = diff.clone();
					}
					
				}
			}

			var landscape : Boolean = DeviceCapabilities.isLandscape();
			
			w = landscape ? data[selectedResolution].stageSize.width : data[selectedResolution].stageSize.height; 
			h = landscape ? data[selectedResolution].stageSize.height : data[selectedResolution].stageSize.width;

			updateAndMaintainAspectRatio( w , h , flStage , starling);

		}
		/**
		 * update starling stage and maintain aspect ratio of device
		 */
		private static function updateAndMaintainAspectRatio( _width : Number , _height : Number , flStage : Stage, starling : Starling ) : void
		{
			
			var fullScreenWidth 	: Number 	= flStage.fullScreenWidth
			var fullScreenHeight 	: Number 	= flStage.fullScreenHeight;
			var scale				: Number 	= Math.max(( fullScreenWidth / _width ), ( fullScreenHeight / _height ));
 
			starling.stage.stageWidth 		= ( fullScreenWidth / scale );
			starling.stage.stageHeight 		= ( fullScreenHeight / scale );
		}
		/**
		 * 
		 */
		private static function initResolutionInfo() : void
		{
			if ( !resolutionSettingInitFlag )
			{
				// Data Source: http://wiki.starling-framework.org/manual/multi-resolution_development
				androidResolutionSettings.push(new DeviceResolutionInfo(240, 320, 240, 320, DeviceAssetType.LD, 1));
				androidResolutionSettings.push(new DeviceResolutionInfo(320, 480, 320, 480, DeviceAssetType.LD, 1));
				androidResolutionSettings.push(new DeviceResolutionInfo(480, 640, 240, 320, DeviceAssetType.SD, 2));
				androidResolutionSettings.push(new DeviceResolutionInfo(480, 800, 240, 400, DeviceAssetType.SD, 2));
				androidResolutionSettings.push(new DeviceResolutionInfo(640, 960, 320, 480, DeviceAssetType.SD, 2));
				androidResolutionSettings.push(new DeviceResolutionInfo(768, 1024, 256, 341, DeviceAssetType.HD, 3));
				androidResolutionSettings.push(new DeviceResolutionInfo(720, 1280, 360, 640, DeviceAssetType.HD, 3));
				androidResolutionSettings.push(new DeviceResolutionInfo(752, 1280, 376, 640, DeviceAssetType.HD, 3));

				iPhoneResolutionSetting = new DeviceResolutionInfo(0, 0, 320, 480, DeviceAssetType.HD, 3);
				iPadResolutionSetting 	= new DeviceResolutionInfo(0, 0, 384, 512, DeviceAssetType.HD, 3);

				resolutionSettingInitFlag = true;
			}
		}
	}
}
