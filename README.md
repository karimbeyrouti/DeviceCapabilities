DeviceCapabilities
==================

AS3 Utility class - DeviceCapabilities / Detection. Example usage:


'''
package {
  import com.kurst.cfwrk.system.constants.DeviceOrientation;
	import com.kurst.cfwrk.system.DeviceCapabilities;
	import flash.display.Sprite;

	public class DeviceInfoTest extends Sprite {
		public function DeviceInfoTest() {

			DeviceCapabilities.init( stage , DeviceOrientation.LANDSCAPE );

			trace( 'DeviceCapabilities.dpi: ' 				      , DeviceCapabilities.dpi );			
			trace( 'DeviceCapabilities.screenInchesY: ' 	  , DeviceCapabilities.screenInchesY());
			trace( 'DeviceCapabilities.screenInchesX: ' 	  , DeviceCapabilities.screenInchesX());
			trace( 'DeviceCapabilities.isPhone: ' 			    , DeviceCapabilities.isPhone());
			trace( 'DeviceCapabilities.isDesktop: ' 		    , DeviceCapabilities.isDesktop());
			trace( 'DeviceCapabilities.isTablet: ' 			    , DeviceCapabilities.isTablet());
			trace( 'DeviceCapabilities.isLandscape: ' 		  , DeviceCapabilities.isLandscape());
			trace( 'DeviceCapabilities.deviceInformation: ' , DeviceCapabilities.deviceInformation().toString() ); 

		}
	}
}
'''
