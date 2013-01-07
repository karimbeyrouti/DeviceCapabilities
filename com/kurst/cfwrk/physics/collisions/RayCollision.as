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

package com.kurst.cfwrk.physics.collisions {
	import com.kurst.cfwrk.physics.data.RBVector2D;
	import com.kurst.cfwrk.physics.math.Vector2D;
	import com.kurst.cfwrk.physics.objects.RigidBody;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;

	public final class RayCollision {

		//------------------------------------------------------------------------------------------------------------------------------------------------------------
		
		private static var rbI				: Point 		= new Point(); // Optimisation for isPointInsideShape;
		private static var rbJ				: Point 		= new Point(); // Optimisation for isPointInsideShape;
		
		private static var bLineCache		: Dictionary 	= new Dictionary(); // Optimisation - Result cache for createLineBresenham && efla
		private static var bVectCache		: Dictionary 	= new Dictionary(); // Optimisation - Result cache for createLineBresenham && efla
		
		private static var eflaCounter		: int			= 0; 
		private static var eflaLoopVector	: Vector2D
		private static var eflaCacheVector	: Vector2D		= new Vector2D();
		
		//------------------------------------------------------------------------------------------------------------------------------------------------------------


		/**
		 * initialise result Vector Cache
		 * 
		 * @param id of cache
		 * @param number of items in cache
		 */
		public static function initCache( id : String , length : int ) : void {
			
			var result : Vector.<Vector2D> = new Vector.<Vector2D>();
			
			for ( var c: int = 0 ; c < length ; c ++ ){
				
				result.push( new Vector2D() );
				
			}
			
			bLineCache[id] = result;
			bVectCache[id] = new Vector2D();
			
		}
		/**
		 * Ray generation. 
		 * 
		 * http://www.simppa.fi/blog/extremely-fast-line-algorithm-as3-optimized/ 
		 * 
		 * @param x : int - Start X position of Ray
		 * @param y : int - Start Y position of Ray
		 * @param x2 : int - End X position of Ray
		 * @param y2 : int - End Y position of Ray
		 * @param id : String - Cache ID
		 * 
		 * @return Ray of Vector2D objects
		 */
		public static function efla(x:int, y:int, x2:int, y2:int , id : String )  : Vector.<Vector2D>  {
			
			var shortLen	: int = y2-y;
			var longLen		: int = x2-x;
		  
			if((shortLen ^ (shortLen >> 31) ) - (shortLen >> 31) > (longLen ^ (longLen >> 31) ) - (longLen >> 31)) {
			
				shortLen 	^= longLen;
				longLen 	^= shortLen;
				shortLen 	^= longLen;
			
				var yLonger:Boolean = true;
				
			} else { yLonger = false; }
		
			var inc			: int 				= longLen < 0 ? -1 : 1;
			var multDiff	: Number 			= longLen == 0 ? shortLen : shortLen / longLen;
			var cache 		: Vector.<Vector2D> = bLineCache[id];
			var points 		: Vector.<Vector2D> = new Vector.<Vector2D>();

			eflaCounter							= 0;
			
			if (yLonger) {
				
			    for ( var i : int = 0 ; i != longLen ; i += inc ) {
					
					eflaLoopVector 	= cache[eflaCounter]
					eflaLoopVector.x = x + i*multDiff;
					eflaLoopVector.y = y+i;
					
					points.push( eflaLoopVector );
					eflaCounter++;
					
				}
				
			} else {
				
			    for ( i = 0 ; i != longLen ; i += inc ) {

					eflaLoopVector 	= cache[eflaCounter]
					eflaLoopVector.x = x+i;
					eflaLoopVector.y = y+i*multDiff;
					
					points.push( eflaLoopVector );
					eflaCounter++;
				  
			    }
			
			}
			
			return points;
		}
		/**
		 * Line / Ray - poing in shape testing 
		 * 
		 * http://www.simppa.fi/blog/extremely-fast-line-algorithm-as3-optimized/ 
		 * 
		 * @param x : int - Start X position of Ray
		 * @param y : int - Start Y position of Ray
		 * @param x2 : int - End X position of Ray
		 * @param y2 : int - End Y position of Ray
		 * @param id : String - Cache ID
		 * @param rigidBody : RigidBody - rigid body to test
		 * 
		 * @return Null if no intesection is found || Vector2D point of first intersection
		 */
		public static function eflaPointInShape(x:int, y:int, x2:int, y2:int , id : String , rigidBody : RigidBody )  : Vector2D  {
			
			var shortLen	: int = y2-y;
			var longLen		: int = x2-x;
		  
			if((shortLen ^ (shortLen >> 31) ) - (shortLen >> 31) > (longLen ^ (longLen >> 31) ) - (longLen >> 31)) {
			
				shortLen 	^= longLen;
				longLen 	^= shortLen;
				shortLen 	^= longLen;
			
				var yLonger:Boolean = true;
				
			} else { yLonger = false; }
		
			eflaCacheVector 							= bVectCache[id];
			
			var inc				: int 					= longLen < 0 ? -1 : 1;
			var multDiff		: Number 				= longLen == 0 ? shortLen : shortLen / longLen;
			var shapeVertices 	: Vector.<RBVector2D> 	= rigidBody.vertices;
			var oddNodes 		: Boolean 				= false;
			var i 				: int 					= 0;
			var numberOfSides 	: int 					= shapeVertices.length;
			var d 				: int
			var k 				: int;
			var j 				: int;
			
			if (yLonger) {
				
			    for ( d = 0 ; d != longLen ; d += inc ) {
					
					eflaCacheVector.x = x + d*multDiff;
					eflaCacheVector.y = y+d;
						
					j 	  				= numberOfSides - 1;
					k					= 0;
					oddNodes			= false;
					
					// isPointInsideShape
					
					while (k < numberOfSides) {
		
						rbI.x = shapeVertices[k].rbX;
						rbI.y = shapeVertices[k].rbY; 
						
						rbJ.x = shapeVertices[j].rbX;
						rbJ.y = shapeVertices[j].rbY;
						 
						if ( ( rbI.y < eflaCacheVector.y && rbJ.y >= eflaCacheVector.y ) || ( rbJ.y < eflaCacheVector.y && rbI.y >= eflaCacheVector.y ) ) {
								
							if (rbI.x + ((( eflaCacheVector.y - rbI.y) / (rbJ.y - rbI.y)) * (rbJ.x - rbI.x)) < eflaCacheVector.x) {
							
								oddNodes = !oddNodes;
							
							}
							
						}
		
						j = k;
						k ++;
						
					}
					
					i++;
					
					if ( oddNodes ) // Collision found - return Vector2D
						return eflaCacheVector;
						
					
				}
				
			} else {
				
			    for ( d = 0 ; d != longLen ; d += inc ) {

					eflaCacheVector.x = x+d;
					eflaCacheVector.y = y+d*multDiff;
					
	
					j 	  				= numberOfSides - 1;
					k					= 0;
					oddNodes			= false;
					
					// isPointInsideShape
					
					while (k < numberOfSides) {
		
						rbI.x = shapeVertices[k].rbX;
						rbI.y = shapeVertices[k].rbY; 
						
						rbJ.x = shapeVertices[j].rbX;
						rbJ.y = shapeVertices[j].rbY;
						 
						if ( ( rbI.y < eflaCacheVector.y && rbJ.y >= eflaCacheVector.y ) || ( rbJ.y < eflaCacheVector.y && rbI.y >= eflaCacheVector.y ) ) {
								
							if (rbI.x + ((( eflaCacheVector.y - rbI.y) / (rbJ.y - rbI.y)) * (rbJ.x - rbI.x)) < eflaCacheVector.x) {
							
								oddNodes = !oddNodes;
							
							}
							
						}
		
						j = k;
						k ++;
						
					}
					
					i++;
					
					if ( oddNodes ) // Collision found - return Vector2D
						return eflaCacheVector;
						
				  
			    }
			
			}
			
			return null;
		}
		
		public static function eflaPointInShapeB(x:int, y:int, x2:int, y2:int , id : String , rigidBody : RigidBody )  : Vector2D  {
			
			var shortLen	: int = y2-y;
			var longLen		: int = x2-x;
		  
			if((shortLen ^ (shortLen >> 31) ) - (shortLen >> 31) > (longLen ^ (longLen >> 31) ) - (longLen >> 31)) {
			
				shortLen 	^= longLen;
				longLen 	^= shortLen;
				shortLen 	^= longLen;
			
				var yLonger:Boolean = true;
				
			} else { yLonger = false; }
		
			eflaCacheVector 							= bVectCache[id];
			
			var inc				: int 					= longLen < 0 ? -1 : 1;
			var multDiff		: Number 				= longLen == 0 ? shortLen : shortLen / longLen;
			var shapeVertices 	: Vector.<RBVector2D> 	= rigidBody.vertices;
			var oddNodes 		: Boolean 				= false;
			var i 				: int 					= 0;
			var numberOfSides 	: int 					= shapeVertices.length;
			var d 				: int
			var k 				: int;
			var j 				: int;
			var e				: int;
			
			if (yLonger) {
				
			    for ( d = 0 ; d != longLen ; d += inc ) {
					
					eflaCacheVector.x = x + d*multDiff;
					eflaCacheVector.y = y+d;
						
					j 	  				= numberOfSides - 1;
				//	k					= 0;
					oddNodes			= false;
					
					// isPointInsideShape
					
					for (k = 0 ; k < numberOfSides; k++ ){
						
					//}
					//while (k < numberOfSides) {
		
						rbI.x = shapeVertices[k].rbX;
						rbI.y = shapeVertices[k].rbY; 
						
						rbJ.x = shapeVertices[j].rbX;
						rbJ.y = shapeVertices[j].rbY;
						 
						if ( ( rbI.y < eflaCacheVector.y && rbJ.y >= eflaCacheVector.y ) || ( rbJ.y < eflaCacheVector.y && rbI.y >= eflaCacheVector.y ) ) {
								
							if (rbI.x + ((( eflaCacheVector.y - rbI.y) / (rbJ.y - rbI.y)) * (rbJ.x - rbI.x)) < eflaCacheVector.x) {
							
								oddNodes = !oddNodes;
							
							}
							
						}
		
						j = k;
						//k ++;
						
					}
					
					i++;
					
					if ( oddNodes ) // Collision found - return Vector2D
						return eflaCacheVector;
						
					
				}
				
			} else {
				
			    for ( d = 0 ; d != longLen ; d += inc ) {

					eflaCacheVector.x = x+d;
					eflaCacheVector.y = y+d*multDiff;
					
	
					j 	  				= numberOfSides - 1;
					k					= 0;
					oddNodes			= false;
					
					// isPointInsideShape
					
					for (k = 0 ; k < numberOfSides; k++ ){
						
					//}
					//while (k < numberOfSides) {
		
						rbI.x = shapeVertices[k].rbX;
						rbI.y = shapeVertices[k].rbY; 
						
						rbJ.x = shapeVertices[j].rbX;
						rbJ.y = shapeVertices[j].rbY;
						 
						if ( ( rbI.y < eflaCacheVector.y && rbJ.y >= eflaCacheVector.y ) || ( rbJ.y < eflaCacheVector.y && rbI.y >= eflaCacheVector.y ) ) {
								
							if (rbI.x + ((( eflaCacheVector.y - rbI.y) / (rbJ.y - rbI.y)) * (rbJ.x - rbI.x)) < eflaCacheVector.x) {
							
								oddNodes = !oddNodes;
							
							}
							
						}
		
						j = k;
						//k ++;
						
					}
					
					i++;
					
					if ( oddNodes ) // Collision found - return Vector2D
						return eflaCacheVector;
						
				  
			    }
			
			}
			
			return null;
		}
		
		/**
		 * isPointInsideShape( point : Vector2D , rigidBody : RigidBody ) : Boolean 
		 * 
		 * @param point : Vector2D - point to test
		 * @param rigidBody : RigidBody - rigid body to test
		 * 
		 * @return False if no interection is found || True if intersection found
		 */
		public static function isPointInsideShape( point : Vector2D , rigidBody : RigidBody ) : Boolean {
			
			var shapeVertices 	: Vector.<RBVector2D> = rigidBody.vertices;
			var numberOfSides 	: int = shapeVertices.length;
			var k 				: int = 0;
			var j 				: int = numberOfSides - 1;
			var oddNodes 		: Boolean = false;
			
			while (k < numberOfSides) {

				rbI.x = shapeVertices[k].rbX;
				rbI.y = shapeVertices[k].rbY; 
				
				rbJ.x = shapeVertices[j].rbX;
				rbJ.y = shapeVertices[j].rbY;
				 
				if ( ( rbI.y < point.y && rbJ.y >= point.y ) || ( rbJ.y < point.y && rbI.y >= point.y ) ) {
						
					if (rbI.x + ((( point.y - rbI.y) / (rbJ.y - rbI.y)) * (rbJ.x - rbI.x)) < point.x) {
					
						oddNodes = !oddNodes;
					
					}
					
				}

				j = k;
				k ++;
				
			}

			return oddNodes;
		}
		/**
		 * isPointInsideShape( point : Vector2D , rigidBody : RigidBody ) : Boolean 
		 * 
		 * @param ray : Vector.<Vector2D>
		 * @param rigidBody : RigidBody
		 * 
		 * @return Vector2D of first intersection - Null if no intersection is found
		 */
		public static function checkRayCollision( ray : Vector.<Vector2D> , rigidBody : RigidBody ) : Vector2D {
			
			var rayLength 	: int = ray.length;
			var i 			: int = 0;

			
			while (i < rayLength) {
				
				if (isPointInsideShape( ray[i] , rigidBody )) {
					
					return ray[i];
					
				}

				i++;
			}


			return null;
		}

	}
}
