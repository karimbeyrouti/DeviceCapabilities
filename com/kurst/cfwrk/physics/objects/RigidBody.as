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

package com.kurst.cfwrk.physics.objects {

	import com.kurst.cfwrk.physics.data.RBVector2D;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class RigidBody {

		//------------------------------------------------------------------------------------------------
				
		public var vertices 			: Vector.<RBVector2D> 	= new Vector.<RBVector2D>();
		public var rect					: Rectangle				= new Rectangle();
		public var name 				: String		 		= '';
		public var width				: Number				= 1;
		public var height				: Number				= 1;
		public var x 					: Number				= 0;
		public var y 					: Number				= 0;
		public var maxYInverse			: Number				= 0;
		public var maxY					: Number				= 0;
		public var maxX					: Number				= 0;
		public var enabled				: Boolean				= true;
		
		//------------------------------------------------------------------------------------------------
		
		private var _inverseScalar		: Number				= 1;
		
		//------------------------------------------------------------------------------------------------
		
		public function RigidBody( ) : void {
			
		}
		
		//------------------------------------------------------------------------------------------------

		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		public function dispose() : void {
			
			for ( var c : int = 0 ; c < vertices.length ;c ++ ){
				
				vertices[c].dispose();
				
			}
			
			vertices = null;
			
		}
		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		public function updateData() : void {

			var l 		: int 			= vertices.length;
			
			for ( var c : int = 0 ; c < l ; c++ ){
				vertices[c].calcScaledValues();
			}
			
			rect.x 		= x;
			rect.y 		= y;
			rect.width 	= width;
			rect.height = height;
			
		}
		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		public function clone() : RigidBody{
			
			var l 		: int 			= vertices.length;
			
			var result 	: RigidBody 	= new RigidBody();
				result.name 			= name;
				result.width 			= width;
				result.height 			= height;
				result.x 				= x;
				result.y 				= y;
				result.inverseScalar 	= _inverseScalar;
				
			for ( var c : int = 0 ; c < l ; c++ ){
				
				result.addPoint( { x: vertices[c].x , y: vertices[c].y });
				
			}
			
			return result;
			
			
		}
		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		public function update( px : Number , py : Number , pwidth : Number , pheight : Number ) : void {
			
			x 			= px;
			y 			= py;
			width 		= pwidth;
			height 		= pheight;
			
			rect.x 		= x;
			rect.y 		= y;
			rect.width 	= width;
			rect.height = height;
			
		}
		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		public function addPoint ( obj : Object ) : void {
			
			var p : RBVector2D = new RBVector2D( obj.x , obj.y , this );
			 
			//if ( vertices.length > 0 ) vertices[vertices.length - 1 ].next = p;
				
			 
			if ( p.y > maxY ){
				
				maxY 		= p.y;
				maxYInverse = _inverseScalar/maxY;
				
			}
			
			if ( p.x > maxX ){
				maxX 		= p.x;
			}

			vertices.push( p );

		}
		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		public function getTransformedPoint( pointID : int ) : Point {
			
			return new Point( vertices[pointID].rbX , vertices[pointID].rbY);			
		
		}
		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		public function get inverseScalar() : Number {
			return _inverseScalar;
		}
		public function set inverseScalar( inverseScalar : Number ) : void {
			_inverseScalar = inverseScalar;
		}

	}
}
