package com.kurst.cfwrk.system.data {

	public class DeviceInfo {
			
		public var supported 	: Boolean;
		/*
		 * Identified device - Constant from DeviceList
		 */
		public var device 		: String; //
		/*
		 * Detected Operating system - Constant from OSList
		 */
		public var os 			: String; 
		/*
		 * Width of running environment
		 */	
		public var width 		: Number;
		/*
		 * Height of running environment
		 */
		public var height  		: Number;
		/*
		 * Scale of running environment
		 */
		public var scale 		: Number = 1;
		/*
		 */
		public function toString() : String {
			
			var result : String = '';
			
				result += "Device: " 	+ device + ' ';
				result += "Supported: " + supported + ' ';
				result += "Platform: " 	+ os + ' ';
				result += "Width: " 	+ width + ' ';
				result += "Height: " 	+ height + ' ';
				result += "Scale: " 	+ scale
				
			return result;
				
			
			
		}
				
	}
}
