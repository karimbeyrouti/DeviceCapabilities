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
 *	_resolutionConfig = new StarlingMultiResConfig(stage, _starling);
 *	
 *	Simulate an IOS device:		_resolutionConfig.set( null , null , OSList.IOS );
 * 	Simulate an Android device: _resolutionConfig.set( null , null , OSList.ANDROID );
 * 	Production / no simulation: _resolutionConfig.set( );
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
		
		private var resolutionSettingInitFlag 	: Boolean 						= false;
		private var _viewPort 					: Rectangle 					= new Rectangle();
		private var _useDefaultAndroidResolutions		: Boolean 						= true;
		private var _defaultAndroidSettings 	: Vector.<DeviceResolutionInfo> = new Vector.<DeviceResolutionInfo>();
		private var _androidSettings 			: Vector.<DeviceResolutionInfo> = new Vector.<DeviceResolutionInfo>();
		private var _iPhoneSetting 				: DeviceResolutionInfo;
		private var _iPadSetting 				: DeviceResolutionInfo;
		private var _stage						: Stage;
		private var _starling					: Starling;
		
		//------------------------------------------------------------------------------------
		
		public function StarlingMultiResConfig(stage : Stage, starling : Starling)
		{
			init(stage, starling);
		}

		//------------------------------------------------------------------------------------
		
		/**
		 * 
		 * Configure starling stage depending on device resolution. 
		 * 
		 * viewPort 		: Rectangle = null 	- Custom view port size - will use fullScreenWidth / fullScreenHeight if not set
		 * desktopStage 	: Rectangle = null	- Size of starling stage for desktop apps
		 * simulateDevice 	: String 	= null	- Simulate device ( OSList.IOS /  OSList.ANDROID )
		 *  
		 */
		public function set( viewPort : Rectangle = null, desktopStage : Rectangle = null, simulateDevice : String = null) : void
		{
		
			DeviceCapabilities.init(_stage);
			initResolutionSettings();

			if ( ! viewPort )
			{
				_viewPort.width 	= _stage.fullScreenWidth;
				_viewPort.height = _stage.fullScreenHeight;
			}
			else
			{
				_viewPort = viewPort;
			}

			_starling.viewPort 			= _viewPort;
			
			var landscape : Boolean 	= DeviceCapabilities.isLandscape();
			var deviceInfo : DeviceInfo = DeviceCapabilities.deviceInformation(simulateDevice);

			if ( deviceInfo.os == OSList.IOS )
			{
				if ( DeviceCapabilities.isTablet() )
				{
					updateAndMaintainAspectRatio( 	landscape ? _iPadSetting.stageSize.width : _iPadSetting.stageSize.height , 
													landscape ? _iPadSetting.stageSize.height : _iPadSetting.stageSize.width );
				}
				else
				{
					updateAndMaintainAspectRatio( 	landscape ? _iPhoneSetting.stageSize.width : _iPhoneSetting.stageSize.height , 
													landscape ? _iPhoneSetting.stageSize.height : _iPhoneSetting.stageSize.width );
				}
				
			}
			else if ( deviceInfo.os == OSList.ANDROID )
			{
				if ( _useDefaultAndroidResolutions )
				{
					matchClosestResolution( _defaultAndroidSettings );
				}
				else
				{
					matchClosestResolution( _androidSettings );
				}
			}
			else if ( deviceInfo.os == OSList.MAC || deviceInfo.os == OSList.WINDOWS )
			{
				if ( desktopStage )
				{
					_starling.stage.stageWidth 	= desktopStage.width;
					_starling.stage.stageHeight	= desktopStage.height;
				}
				else
				{
					_starling.stage.stageWidth 		= _viewPort.width;
					_starling.stage.stageHeight 	= _viewPort.height;
				}
			}
		}
		/**
		 * 
		 */
		public function init(stage : Stage, starling : Starling) : void
		{
			_stage = stage;
			_starling = starling;
		}
		/**
		 * 
		 */
		public function addAndroidResolution( dri : DeviceResolutionInfo ) : void
		{
			_androidSettings.push( dri );
		}
		
		//------------------------------------------------------------------------------------

		/**
		 * match closest resolution of device with from list of device resolutions and recomended stage sizes 
		 */
		private function matchClosestResolution( data : Vector.<DeviceResolutionInfo>) : void
		{
			var screenSize 		: Rectangle = new Rectangle();
				screenSize.width 			= _stage.fullScreenWidth;
				screenSize.height 			= _stage.fullScreenHeight;
			
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

			updateAndMaintainAspectRatio( w , h );

		}
		/**
		 * update starling stage and maintain aspect ratio of device
		 */
		private function updateAndMaintainAspectRatio( _width : Number , _height : Number ) : void
		{
			
			var fullScreenWidth 	: Number 	= _stage.fullScreenWidth
			var fullScreenHeight 	: Number 	= _stage.fullScreenHeight;
			var scale				: Number 	= Math.max(( fullScreenWidth / _width ), ( fullScreenHeight / _height ));
 
			_starling.stage.stageWidth 			= ( fullScreenWidth / scale );
			_starling.stage.stageHeight 		= ( fullScreenHeight / scale );
		}
		/**
		 * 
		 */
		private function initResolutionSettings() : void
		{
			if ( !resolutionSettingInitFlag )
			{
				// Data Source: http://wiki.starling-framework.org/manual/multi-resolution_development
				_defaultAndroidSettings.push(new DeviceResolutionInfo(240, 320, 240, 320, DeviceAssetType.LD, 1));
				_defaultAndroidSettings.push(new DeviceResolutionInfo(320, 480, 320, 480, DeviceAssetType.LD, 1));
				_defaultAndroidSettings.push(new DeviceResolutionInfo(480, 640, 240, 320, DeviceAssetType.SD, 2));
				_defaultAndroidSettings.push(new DeviceResolutionInfo(480, 800, 240, 400, DeviceAssetType.SD, 2));
				_defaultAndroidSettings.push(new DeviceResolutionInfo(640, 960, 320, 480, DeviceAssetType.SD, 2));
				_defaultAndroidSettings.push(new DeviceResolutionInfo(768, 1024, 256, 341, DeviceAssetType.HD, 3));
				_defaultAndroidSettings.push(new DeviceResolutionInfo(720, 1280, 360, 640, DeviceAssetType.HD, 3));
				_defaultAndroidSettings.push(new DeviceResolutionInfo(752, 1280, 376, 640, DeviceAssetType.HD, 3));

				_iPhoneSetting 	= new DeviceResolutionInfo(0, 0, 320, 480, DeviceAssetType.HD, 3);
				_iPadSetting 	= new DeviceResolutionInfo(0, 0, 384, 512, DeviceAssetType.HD, 3);

				resolutionSettingInitFlag = true;
			}
		}

		//------------------------------------------------------------------------
		
		/*
		 * 
		 */
		public function get useDefaultAndroidResolutions() : Boolean
		{
			return _useDefaultAndroidResolutions;
		}
		public function set useDefaultAndroidResolutions(useDefaultResolutions : Boolean) : void
		{
			_useDefaultAndroidResolutions = useDefaultResolutions;
		}
		/*
		 * 
		 */
		public function get androidSettings() : Vector.<DeviceResolutionInfo>
		{
			return _androidSettings;
		}
		public function set androidSettings(androidSettings : Vector.<DeviceResolutionInfo>) : void
		{
			_androidSettings = androidSettings;
		}
		/*
		 * 
		 */
		public function get defaultAndroidSettings() : Vector.<DeviceResolutionInfo>
		{
			return _defaultAndroidSettings;
		}
		/*
		 * 
		 */
		public function get iPhoneSetting() : DeviceResolutionInfo
		{
			return _iPhoneSetting;
		}
		public function set iPhoneSetting(iPhoneSetting : DeviceResolutionInfo) : void
		{
			_iPhoneSetting = iPhoneSetting;
		}
		/*
		 * 
		 */
		public function get iPadSetting() : DeviceResolutionInfo
		{
			return _iPadSetting;
		}
		public function set iPadSetting(iPadSetting : DeviceResolutionInfo) : void
		{
			_iPadSetting = iPadSetting;
		}
	
	}
}
