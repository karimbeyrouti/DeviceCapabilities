/********************************************************************************************************************************************************************************
* 
* Class Name  	: 
* Version 	  	: 
* Description 	: 
* 
********************************************************************************************************************************************************************************
* 
* Author 		: Karim Beyrouti
* Date 			: 
* 
********************************************************************************************************************************************************************************
* 
* METHODS
* 
*
* PROPERTIES
* 
*
* EVENTS
* 
* 
********************************************************************************************************************************************************************************
* 				:
*
*
*********************************************************************************************************************************************************************************
* NOTES			:
**********************************************************************************************************************************************************************************/

package com.kurst.cfwrk.physics.loader{
	
	import com.kurst.cfwrk.events.PhysicsDataLoaderEvent;
	import com.kurst.cfwrk.physics.objects.RigidBody;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	
	public class PhysicsDataLoader extends EventDispatcher{
		
		private var _xmlLoader 		: URLLoader;
		private var json 			: Object;
		private var data			: Dictionary = new Dictionary();
		private var _inverseScalar 	: Number = 1; 
		
		//------------------------------------------------------------------------------------------------------------------------------------------------------------
		
		public function PhysicsDataLoader() {
			
			_xmlLoader = new URLLoader();
			_xmlLoader.addEventListener(Event.COMPLETE, onComplete, false, 0, true);
			_xmlLoader.addEventListener(IOErrorEvent.IO_ERROR, onLoadError, false, 0, true);
			
		}

		//------------------------------------------------------------------------------------------------------------------------------------------------------------
		//-PUBLIC-----------------------------------------------------------------------------------------------------------------------------------------------------
		//------------------------------------------------------------------------------------------------------------------------------------------------------------
	
		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		public function loadData( uri : String ) : void {
			
			_xmlLoader.load( new URLRequest( uri ) );
			
		}
		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		public function getShape( name : String ) : RigidBody {
			
			if ( data[name] != null ){
				
				var rb : RigidBody = data[name] as RigidBody;
				return rb.clone() ;
			}
			
			return null;
			
		}

		//------------------------------------------------------------------------------------------------------------------------------------------------------------
		//-PRIVATE-----------------------------------------------------------------------------------------------------------------------------------------------------
		//------------------------------------------------------------------------------------------------------------------------------------------------------------
			
		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		private function onLoadError( event : IOErrorEvent ) : void {
			
		}
		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		private function onComplete( event : Event ) : void {

			json 							= JSON.parse(event.target.data);
			
			var rigidBodies : Array 		= json.rigidBodies;
			var rigidBody 	: RigidBody;
			var shape		: Array;
			var obj 		: Object;
						
			for ( var c : int = 0 ; c < rigidBodies.length ; c++ ) {
				
				obj 			 		= rigidBodies[c]
				rigidBody 				= new RigidBody();
				rigidBody.inverseScalar	= _inverseScalar;
				rigidBody.name			= obj.name;
				shape 					= obj.shapes[0].vertices;
				
				for ( var d : int = 0 ; d < shape.length ; d ++ ){
					rigidBody.addPoint( shape[d] );
				}
				
				data[rigidBody.name] = rigidBody;
				
			}
			
			dispatchEvent( new PhysicsDataLoaderEvent(PhysicsDataLoaderEvent.LOADED ));
		}

		//------------------------------------------------------------------------------------------------------------------------------------------------------------
		//-GET / SET -----------------------------------------------------------------------------------------------------------------------------------------------------
		//------------------------------------------------------------------------------------------------------------------------------------------------------------

		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		public function get inverseScalar() : Number {
			return _inverseScalar;
		}
		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		public function set inverseScalar( inverseScalar : Number ) : void {
			_inverseScalar = inverseScalar;
		}


		
	}
}
