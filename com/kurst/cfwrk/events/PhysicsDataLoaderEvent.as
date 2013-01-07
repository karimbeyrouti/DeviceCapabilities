package com.kurst.cfwrk.events {
	import flash.events.Event;

	/**
	 * @author karim
	 */
	public class PhysicsDataLoaderEvent extends Event {
		public static const LOADED : String = "LOADED";
		public function PhysicsDataLoaderEvent( type : String , bubbles : Boolean = false , cancelable : Boolean = false ) {
			super( type , bubbles , cancelable );
		}
	}
}
