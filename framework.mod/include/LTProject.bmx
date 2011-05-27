'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Global L_DeltaTime:Float
Global L_FPS:Int
Global L_CollisionChecks:Int

Type LTProject Extends LTObject
	Field LogicFPS:Float = 75
	Field MinFPS:Float = 15
	Field Pass:Int
	Field Time:Float

	
	
	Method Init()
	End Method
  
  
  
	Method Render()
	End Method
	
	
	
	Method Logic()
	End Method
	
	
	
	Method LoadLayer:LTLayer( Layer:LTLayer )
		Local NewLayer:LTLayer = New LTLayer
		For Local Shape:LTShape = Eachin Layer.Children
			Local NewShape:LTShape
			If LTLayer( Shape ) Then
				NewShape = LoadLayer( LTLayer( Shape ) )
			Else
				Local CommaPos:Int = Shape.Name.Find( "," )
				Local TypeName:String = Shape.Name
				Local RealName:String = ""
				If CommaPos >= 0 Then
					TypeName = Shape.Name[ ..CommaPos ]
					RealName = Shape.Name[ CommaPos + 1.. ]
				End If
				Local TypeID:TTypeId = TTypeID.ForName( TypeName )
				
				?debug
				If Not TypeID Then L_Error( "Type ~q" + TypeName + "~q not found" )
				?
				
				NewShape = LTShape( TypeID.NewObject() )
				Shape.CopyTo( NewShape )
				NewShape.Name = RealName
				NewShape.Init()
			End If
			NewLayer.AddLast( NewShape )
		Next
		Return NewLayer
	End Method
	
	
	
	Method Execute()
		FlushKeys
		FlushMouse
	    
		Pass = 1
		L_DeltaTime = 0
		
		Init()
		
		Local StartTime:Int = MilliSecs()
		
		Local RealTime:Float = 0
		Local LastRenderTime:Float = 0
		Local MaxRenderPeriod:Float = 1.0 / MinFPS
		Local FPSCount:Int
		Local FPSTime:Int
		
		L_DeltaTime = 1.0 / LogicFPS
	    
		Repeat
			Time :+  L_DeltaTime
			
			L_CollisionChecks = 0
			Logic()
	      
			For Local Joint:LTJoint = Eachin L_JointList
				Joint.Operate()
			Next
		
			Repeat
				RealTime = 0.001 * ( Millisecs() - StartTime )
				If RealTime >= Time And ( RealTime - LastRenderTime ) < MaxRenderPeriod Then Exit
				
				Cls
				Render()
				Flip( False )
		      
				LastRenderTime = 0.001 * ( Millisecs() - StartTime )
				FPSCount :+ 1
			Forever
	      
			If Millisecs() >= 1000 + FPSTime Then
				L_FPS = FPSCount
				FPSCount = 0
				FPSTime = Millisecs()
			End If
			
			PollSystem()
			Pass :+ 1
		Forever
	End Method
	
	
	
	Method ShowDebugInfo( MainLayer:LTLayer )
		DrawText( "FPS: " + L_FPS, 0, 0 )
		DrawText( "Memory: " + Int( GCMemAlloced() / 1024 ) + "kb", 0, 16 )
		DrawText( "Sprites: " + MainLayer.CountSprites(), 0, 32 )
		DrawText( "Collisions: " + L_CollisionChecks, 0, 48 )
	End Method
End Type