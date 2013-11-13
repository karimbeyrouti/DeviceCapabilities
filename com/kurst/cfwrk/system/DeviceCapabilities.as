/********************************************************************************************************************************************************************************
* 
* Class Name  	: DeviceCapabilities
* Version 	  	: 1
* Description 	: returns information about the environment and device this code is running on
* 
********************************************************************************************************************************************************************************
* 
* Author 		: Based on Starling's DeviceCapabilities class, and	
* 				  the following thread: http://forum.starling-framework.org/topic/detect-device-modelperformance , and my additiong
* 				  Karim Beyrouti ( karim@kurst.co.uk )
* 
********************************************************************************************************************************************************************************
* 
* METHODS
* 
* 	DeviceCapabilities.init( stage : Stage , default_orientation : String = "landscape" ) : void
* 	DeviceCapabilities.handleLostContext( ) : Boolean
* 	DeviceCapabilities.isLandscape( ) : Boolean
* 	DeviceCapabilities.isTablet( ) : Boolean
* 	DeviceCapabilities.isPhone( ) : Boolean
* 	DeviceCapabilities.isDesktop( ) : Boolean 
* 	DeviceCapabilities.screenInchesX( ) : Number
* 	DeviceCapabilities.screenInchesY( ) : Number
* 	DeviceCapabilities.deviveInformation( ) : DeviceInfo
*
* PROPERTIES
* 
* 	tabletScreenMinimumInches 	: Number ( get / set )
* 	screenPixelWidth 			: Number ( get / set )
* 	screenPixelHeight 			: Number ( get / set )
* 	orientation					: String ( get )
* 	dpi							: String ( get )
* 	debugEnabled				: String ( get )
* 	
*********************************************************************************************************************************************************************************
* NOTES	 
* 
* 	run DeviceCapabilities.init( stage : Stage ) before using any of the methods in this class
* 	
**********************************************************************************************************************************************************************************/
package com.kurst.cfwrk.system {
	import com.kurst.cfwrk.system.constants.DeviceOrientation;
	import com.kurst.cfwrk.system.constants.OSList;
	import com.kurst.cfwrk.system.constants.DeviceList;
	import com.kurst.cfwrk.system.data.DeviceInfo;
	import flash.display.Stage;
	import flash.display.StageOrientation;
	import flash.system.Capabilities;

	/**
	 * Using values from the Stage and Capabilities classes, makes educated
	 * guesses about the physical size and type of device this code is running on.
	 */
	public class DeviceCapabilities {
		
		//------------------------------------------------------------------------------------------------------------------------------------------------------------
		// Variables
		//------------------------------------------------------------------------------------------------------------------------------------------------------------
		
		private static var m_default_orientation		: String	= DeviceOrientation.LANDSCAPE;
		private static var m_isDebugger					: Boolean 	= Capabilities.isDebugger;
		private static var m_tabletScreenMinimumInches 	: Number 	= 5;
		private static var m_screenPixelWidth 			: Number 	= NaN;
		private static var m_screenPixelHeight 			: Number 	= NaN;
		private static var m_dpi 						: int 		= Capabilities.screenDPI;
		private static var m_orientation 				: String;
		private static var m_stage 						: Stage;
		
		//------------------------------------------------------------------------------------------------------------------------------------------------------------
		//-GET/SET----------------------------------------------------------------------------------------------------------------------------------------------------
		//------------------------------------------------------------------------------------------------------------------------------------------------------------
		
		/**
		 * The minimum physical size, in inches, of the device's larger side to
		 * be considered a tablet.
		 */
		public static function get tabletScreenMinimumInches() : Number {
			
			return m_tabletScreenMinimumInches;
			
		}
		public static function set tabletScreenMinimumInches( inches : Number ) : void {
			
			m_tabletScreenMinimumInches = inches;
			
		}
		/**
		 * A custom width, in pixels, to use for calculations of the device's
		 * physical screen size. Set to NaN to use the actual width.
		 */
		public static function get screenPixelWidth() : Number {
			
			assertStageInitialised();
			
			if ( isNaN( m_screenPixelWidth ) ) return m_stage.fullScreenWidth;
			return m_screenPixelWidth;
			
		}
		public static function set screenPixelWidth( pixels : Number ) : void {
			
			m_screenPixelWidth = pixels;
			
		}
		/**
		 * A custom height, in pixels, to use for calculations of the device's
		 * physical screen size. Set to NaN to use the actual height.
		 */
		public static function get screenPixelHeight() : Number {
			
			assertStageInitialised();
			
			if ( isNaN( m_screenPixelHeight ) ) return m_stage.fullScreenHeight;
			return m_screenPixelHeight;
			
		}
		public static function set screenPixelHeight( pixels : Number ) : void {
			
			m_screenPixelHeight = pixels;
			
		}
		/**
		 * returns <code>Capabilities.screenDPI</code> 
		 */
		public static function get dpi() : Number {
			
			return m_dpi;
			
		}
		/**
		 * returns orientation of the device:
		 * 	
		 * 		DeviceCapabilities.landscappe
		 * 		DeviceCapabilities.portrait
		 * 
		 */
		public static function get orientation() : String {
			
			assertStageInitialised();
			
			return m_orientation;
			
		}
		/**
		 * return true if running in debug player / mode;
		 */
		public static function get debugEnabled() : Boolean {
			
			return m_isDebugger;
			
		}
		
		//------------------------------------------------------------------------------------------------------------------------------------------------------------
		//-PUBLIC-----------------------------------------------------------------------------------------------------------------------------------------------------
		//------------------------------------------------------------------------------------------------------------------------------------------------------------
	
		/**
		 * Initialise the DeviceCapabilities class & store a reference to the stage for future use; 
		 * and default orientation in case stage returns a StageOrientation.UNKNOWN orientation
		 */
		public static function init( stage : Stage , default_orientation : String = "landscape" ) : void { //DeviceOrientation.LANDSCAPE ) : void {
			
			m_default_orientation 	= default_orientation;
			m_stage 				= stage;
			
			isLandscape();
			
		}
		/**
		 * returns recommended setting whether the device this is running on 
		 * needs to handle a lost Stage3D context
		 *  
		 * Recomendations are: 
		 * 
		 * 		Android / Windows need to handle lost contexts
		 * 		iOS / Mac do not need to handle a lost context
		 * 		 
		 */
		public static function handleLostContextOnDevice( ) : Boolean {
			
			assertStageInitialised();
			
			var os : String = DeviceCapabilities.deviceInformation( ).os
			return os == OSList.ANDROID || os == OSList.WINDOWS;
			
		}
		/**
		 * returns device orientation
		 */
		public static function isLandscape( ) : Boolean {
			
			assertStageInitialised();

			var isLandscape : Boolean;
			
			switch( m_stage.deviceOrientation ){
				
				case StageOrientation.ROTATED_RIGHT :
				case StageOrientation.ROTATED_LEFT :
				
					m_orientation 	= DeviceOrientation.LANDSCAPE;//landscape;
					isLandscape 	= true;
					
					break;
					
				case StageOrientation.UPSIDE_DOWN: 
				case StageOrientation.DEFAULT :
				
					m_orientation 	= DeviceOrientation.PORTRAIT;//landscape;
					isLandscape 	= false; 
					
					break;
					
				case StageOrientation.UNKNOWN : 
					
					// if unknown user default / user value
					isLandscape 	= ( m_default_orientation == DeviceOrientation.LANDSCAPE); 
					break;
					
			}
			
			
			return isLandscape;

		}
		/**
		 * Determines if this device is probably a tablet, based on the physical
		 * width and height, in inches, calculated using the full-screen
		 * dimensions and the screen DPI.
		 */
		public static function isTablet( ) : Boolean {
			
			assertStageInitialised();
			
			const screenWidth 	: Number = isNaN( m_screenPixelWidth ) ? m_stage.fullScreenWidth : m_screenPixelWidth;
			const screenHeight 	: Number = isNaN( m_screenPixelHeight ) ? m_stage.fullScreenHeight : m_screenPixelHeight;

			return ( (Math.max( screenWidth , screenHeight ) / m_dpi) >= m_tabletScreenMinimumInches ) && ! isDesktop( ) ;
			
		}
		/**
		 * Determines if this device is probably a phone, based on the physical
		 * width and height, in inches, calculated using the full-screen
		 * dimensions and the screen DPI.
		 */
		public static function isPhone( ) : Boolean {
			
			assertStageInitialised();
			
			return !isTablet( ) && ! isDesktop( );
		}
		/**
		 * Determines if this code is running on the desktop;
		 */
		public static function isDesktop( ) : Boolean {
			
			assertStageInitialised();
			
			var platform : String = deviceInformation( ).os;
			return ( platform == DeviceList.DESKTOP || platform == DeviceList.DESKTOP );
			
		}
		/**
		 * The physical width of the device, in inches. Calculated using the
		 * full-screen width and the screen DPI.
		 */
		public static function screenInchesX( ) : Number {
					
			assertStageInitialised();
				
			const screenWidth : Number = isNaN( m_screenPixelWidth ) ? m_stage.fullScreenWidth : m_screenPixelWidth;
			return screenWidth / m_dpi;
			
		}
		/**
		 * The physical height of the device, in inches. Calculated using the
		 * full-screen height and the screen DPI.
		 */
		public static function screenInchesY( ) : Number {
			
			assertStageInitialised();
			
			const screenHeight : Number = isNaN( m_screenPixelHeight ) ? m_stage.fullScreenHeight : m_screenPixelHeight;
			return screenHeight / m_dpi;
			
		}
		/**
		 * Returns a DeviceInfo object containing information about the environment this code is running on.
		 * 
		 * If no successfull detection is made:
		 * 
		 * 		DeviceInfo.os 		will equal OSList.DETECTION_ERROR, and
		 * 		DeviceInfo.device  	will equal DeviceList.DETECTION_ERROR
		 * 		
		 */
		public static function deviceInformation( simulateDevice : String = null ) : DeviceInfo {
			
			assertStageInitialised();
			
			var result			: DeviceInfo	= new DeviceInfo();
			var hwModel			: String 		= ( simulateDevice == null ) ? Capabilities.os : simulateDevice;

			if ( hwModel.substr(0,5) == "Linux"){ // Android ( could also possibly Linux - but I am ignoring that for now )

				result.width 		= Capabilities.screenResolutionX;
				result.height 		= Capabilities.screenResolutionY;	
				result.os			= OSList.ANDROID;
				result.supported	= true;	// Might not be true for all devices
				
				return result;	// no need to correct for device orientation - return result here;

			} else if ( hwModel.indexOf( "Mac" ) != -1 ){

				result.width 		= Capabilities.screenResolutionX;
				result.height 		= Capabilities.screenResolutionY;
				result.device 		= DeviceList.DESKTOP;
				result.os			= OSList.MAC;
				result.supported	= true;
							
				return result;	// no need to correct for device orientation - return result here;
				
			} else if ( hwModel.indexOf( "Win" ) != -1 ){

				result.width 		= Capabilities.screenResolutionX;
				result.height 		= Capabilities.screenResolutionY;
				result.device 		= DeviceList.DESKTOP;
				result.os			= OSList.WINDOWS;
				result.supported	= true;
				
				return result;	// no need to correct for device orientation - return result here;
				
			} else {
				
				// The following width and height values are in portrait mode, 
				// they get converted later
				
				if ( hwModel.indexOf( "iPhone1,1" ) != -1 ) {// NEEDS TESTING
					
					result.width 		= 480;
					result.height 		= 320;
					result.device 		= DeviceList.IPHONE_1;
					result.scale 		= 1;
					result.os			= OSList.IOS;
					result.supported	= false;
				
				} else if ( hwModel.indexOf( "iPhone1,2" ) != -1 ) {// NEEDS TESTING
					
					result.width 		= 480;
					result.height 		= 320;
					result.device 		= DeviceList.IPHONE_3G;
					result.scale 		= 1;
					result.os			= OSList.IOS;
					result.supported	= false;
					
				} else if ( hwModel.indexOf( "iPhone2,1" ) != -1 ) {
					
					result.width 		= 480;
					result.height 		= 320;
					result.device 		= DeviceList.IPHONE_3GS;
					result.scale 		= 1;
					result.os			= OSList.IOS;
					result.supported	= true;
					
				} else if ( hwModel.indexOf( "iPhone3,1" ) != -1 ) {// NEEDS TESTING
					
					result.width 		= 960;
					result.height 		= 640;
					result.device 		= DeviceList.IPHONE_4;
					result.scale 		= 2;
					result.os			= OSList.IOS;
					result.supported	= true;
					
				} else if ( hwModel.indexOf( "iPhone4,1" ) != -1 ) {// NEEDS TESTING
					
					result.width 		= 960;
					result.height 		= 640;
					result.device 		= DeviceList.IPHONE_4S;
					result.scale 		= 2;
					result.os			= OSList.IOS;
					result.supported	= true;
				
				} else if ( hwModel.indexOf( "iPad1" ) != -1 ) { 
					
					result.width 		= 1024;
					result.height 		= 768;
					result.device 		= DeviceList.IPAD_1;
					result.scale 		= 1;
					result.os			= OSList.IOS;
					result.supported	= true;
					
				} else if ( hwModel.indexOf( "iPad2,5" ) != -1 ) {// NEEDS TESTING
					
					result.width 		= 1024;
					result.height 		= 768;
					result.device 		= DeviceList.IPAD_MINI;
					result.scale 		= 1;
					result.os			= OSList.IOS;
					result.supported	= true;
					
				} else if ( hwModel.indexOf( "iPad2" ) != -1 ) {// NEEDS TESTING
					
					result.width 		= 1024;
					result.height 		= 768;
					result.device 		= DeviceList.IPAD_2;
					result.scale 		= 1;
					result.os			= OSList.IOS;
					result.supported	= true;
					
				} else if ( hwModel.indexOf( "iPad3" ) != -1 ) { // NEEDS TESTING
					
					result.width 		= 2048;
					result.height 		= 1536;
					result.device 		= DeviceList.IPAD_3;
					result.scale 		= 2; 
					result.os			= OSList.IOS;
					result.supported	= true;
					
				} else if ( hwModel.indexOf( "iPhone5" ) != -1 ) {// NEEDS TESTING
	
					result.width 		= 1136;
					result.height 		= 640;
					result.device 		= DeviceList.IPHONE_5;
					result.scale 		= 2;
					result.os			= OSList.IOS;
					result.supported	= true; 
					
				} else if ( hwModel.indexOf( "iPhone6" ) != -1 ) {// NEEDS TESTING
	
					result.width 		= 1136;
					result.height 		= 640;
					result.device 		= DeviceList.IPHONE_5S;
					result.scale 		= 2;
					result.os			= OSList.IOS;
					result.supported	= true; 
					
				} else if ( hwModel.indexOf( "iPod1" ) != -1 ) {// NEEDS TESTING
	
					result.width 		= 480;
					result.height 		= 320;
					result.device 		= DeviceList.IPOD_TOUCH_1;
					result.scale 		= 1;
					result.os			= OSList.IOS;
					result.supported	= false; 
					
				} else if ( hwModel.indexOf( "iPod2" ) != -1 ) {// NEEDS TESTING
	
					result.width 		= 480;
					result.height 		= 320;
					result.device 		= DeviceList.IPOD_TOUCH_2;
					result.scale 		= 1;
					result.os			= OSList.IOS;
					result.supported	= false; 
					
				} else if ( hwModel.indexOf( "iPod3" ) != -1 ) {// NEEDS TESTING
	
					result.width 		= 480;
					result.height 		= 320;
					result.device 		= DeviceList.IPOD_TOUCH_3;
					result.scale 		= 1;
					result.os			= OSList.IOS;
					result.supported	= false; 
					
				} else if ( hwModel.indexOf( "iPod4" ) != -1 ) {// NEEDS TESTING
	
					result.width 		= 1136;
					result.height 		= 640;
					result.device 		= DeviceList.IPOD_TOUCH_4;
					result.scale 		= 2;
					result.os			= OSList.IOS;
					result.supported	= true; 
					
				} else if ( hwModel.indexOf( "iPod5" ) != -1 ) {// NEEDS TESTING
	
					result.width 		= 1136;
					result.height 		= 640;
					result.device 		= DeviceList.IPOD_TOUCH_5;
					result.scale 		= 2;
					result.os			= OSList.IOS;
					result.supported	= true; 
					
				} else {
						
					result.device 		= DeviceList.DETECTION_ERROR;
					result.os			= OSList.IOS; // ERROR DETECTING IOS DEVICE - or could be simulated from desktop
					
					return result;
					 
				}
				
			}
			
			// Default width / height formatted in landscape mode, values needs to be swapped to adjust for device orientation 
			if ( !isLandscape() ) {
				
				var w : Number = result.width;
				var h : Number = result.height;
				
				result.width 	= h;
				result.height 	= w;
				
			}

			
			return result;
			
		}
		
		//------------------------------------------------------------------------------------------------------------------------------------------------------------
		//-PRIVATE-----------------------------------------------------------------------------------------------------------------------------------------------------
		//------------------------------------------------------------------------------------------------------------------------------------------------------------

		/**
		 * Check stage has been intialised / throw an error if not.
		 * 		
		 */
		private static function assertStageInitialised() : void {
			
			if ( ! m_stage )
				throw new Error( "DeviceCapabilities - stage not initialised. Run DeviceCapabilities.init( stage ) before using DeviceCapabilities");
		}
	}
}
