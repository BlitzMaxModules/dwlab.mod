'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Global L_CurrentProject:LTProject
Global L_FPS:Int
Global L_MemoryUsed:Int
Global L_DeltaTime:Float

Type LTProject Extends LTObject
	Field LogicFPS:Float = 75
	Field MinFPS:Float = 15
	Field Pass:Int
	Field ProjectTime:Float
	
	
	
	Method Init()
	End Method
  
  
  
	Method Render()
	End Method
	
	
	
	Method Logic()
	End Method
	
	
	
	Method LoadPage( World:LTWorld, PageName:String )
		Local Page:LTPage = World.FindPage( PageName )
		L_Assert( Page <> Null, "Page " + PageName + " not found" )
		For Local Sprite:LTSprite = Eachin Page.Sprites
			LoadSprite( Sprite, L_GetPrefix( Sprite.GetName() ) )
		Next
	End Method
	
	
	
	Method LoadSprite( Sprite:LTSprite, Name:String )
	End Method
	
	
	
	Method Execute()
		FlushKeys
		FlushMouse
	    
		Pass = 1
		L_DeltaTime = 0
		
		Init()
		
		Local StartTime:Int = MilliSecs()
		Local FPSTime:Int = 0
		Local FPSCount:Int = 0
		
		Local RealTime:Float = 0
		Local LastRenderTime:Float = 0
		Local MaxRenderPeriod:Float = 1.0 / MinFPS
		
		L_DeltaTime = 1.0 / LogicFPS
	    
		Repeat
			ProjectTime :+  L_DeltaTime
			
			Logic()
	      
			For Local Joint:LTJoint = Eachin L_JointList
				Joint.Operate()
			Next
		
			Repeat
				RealTime = 0.001 * ( Millisecs() - StartTime )
				If RealTime >= ProjectTime And ( RealTime - LastRenderTime ) < MaxRenderPeriod Then Exit
				
				Cls
				Render()
				Flip
		      
				LastRenderTime = 0.001 * ( Millisecs() - StartTime )
				FPSCount :+ 1
			Forever
	      
			If Millisecs() >= 1000 + FPSTime Then
				L_FPS = FPSCount
				FPSCount = 0
				FPSTime = Millisecs()
				L_MemoryUsed = Int( GCMemAlloced() / 1024 )
			End If
			
			PollSystem()
			Pass :+ 1
		Forever
	End Method
End Type