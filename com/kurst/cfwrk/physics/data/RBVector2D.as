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

package com.kurst.cfwrk.physics.data {

	import com.kurst.cfwrk.physics.math.Vector2D;
	import com.kurst.cfwrk.physics.objects.RigidBody;

	public final class RBVector2D extends Vector2D {
		
		//------------------------------------------------------------------------------------------------------------------------------------------------------------
		
		private var rigidBody 	: RigidBody;
		public var rbX 			: Number =0;
		public var rbY 			: Number =0;

		
		//------------------------------------------------------------------------------------------------------------------------------------------------------------
		
		public final function RBVector2D( px : Number = 0 , py : Number = 0 , rigidBody : RigidBody = null ) {
			
			super( px , py );
			this.rigidBody = rigidBody;
			
		}
		
		//------------------------------------------------------------------------------------------------------------------------------------------------------------

		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		public final function dispose() : void {
			
			rigidBody = null;
			
		}
		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		public final function calcScaledValues() : void {
			
			// scaled and adjusted position of rigid body ( values from physics editor are between 0-1 ( but not nessesarilly scaled and normalized to 1 )
			rbX = x * rigidBody.width + rigidBody.x ;  
			rbY = (  1 - y * rigidBody.maxYInverse  ) * rigidBody.height + rigidBody.y;
			
		}
		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		public final function cloneRB( rb : RigidBody ) : RBVector2D {
			
			return new RBVector2D( x , y , rb );
			 
		}
	}
}
