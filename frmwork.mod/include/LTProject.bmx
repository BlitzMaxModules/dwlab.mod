'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Global L_CollisionChecks:Int
Global L_DeltaTime:Double

Type LTProject Extends LTObject
	Field LogicFPS:Double = 75
	Field MinFPS:Double = 15
	Field FPS:Int
	Field Pass:Int
	Field Time:Double
	Field CurrentPause:LTPause
	Field Exiting:Int

	
	
	Method Init()
	End Method
  
  
  
	Method Render()
	End Method
	
	
	
	Method Logic()
	End Method
	
	
	
	Method LoadAndInitLayer( NewLayer:LTLayer Var, Layer:LTLayer )
		NewLayer = LoadLayer( Layer )
		NewLayer.Init()
	End Method
	
	
	
	Method LoadLayer:LTLayer( Layer:LTLayer )
		Local NewLayer:LTLayer = LTLayer( CreateShape( Layer ) )
		For Local Shape:LTShape = Eachin Layer.Children
			Local NewShape:LTShape
			If LTLayer( Shape ) Then
				NewShape = LoadLayer( LTLayer( Shape ) )
			Else
				NewShape = CreateShape( Shape )
			End If
			NewLayer.AddLast( NewShape )
		Next
		Return NewLayer
	End Method
	
	
	Method CreateShape:LTShape( Shape:LTShape )
		Local CommaPos:Int = Shape.Name.Find( "," )
		Local TypeName:String = Shape.Name
		Local RealName:String = ""
		If CommaPos >= 0 Then
			TypeName = Shape.Name[ ..CommaPos ]
			RealName = Shape.Name[ CommaPos + 1.. ]
		End If
		Local NewShape:LTShape = LTShape( L_GetTypeID( TypeName ).NewObject() )
		Shape.CopyTo( NewShape )
		NewShape.Name = RealName
		Return NewShape
	End Method
	
	
	
	Method Execute()
		FlushKeys
		FlushMouse
	    
		Exiting = False
		Pass = 1
		L_DeltaTime = 0
		
		Init()
		
		Local StartTime:Int = MilliSecs()
		
		Local RealTime:Double = 0
		Local LastRenderTime:Double = 0
		Local MaxRenderPeriod:Double = 1.0 / MinFPS
		Local FPSCount:Int
		Local FPSTime:Int
		
		L_DeltaTime = 1.0 / LogicFPS
	    
		Repeat
			Time :+  L_DeltaTime
			
			L_CollisionChecks = 0
			
			If CurrentPause Then
				CurrentPause.Update()
			Else
				Logic()
				If Exiting Then Exit
			End If
		
			Repeat
				RealTime = 0.001 * ( Millisecs() - StartTime )
				If RealTime >= Time And ( RealTime - LastRenderTime ) < MaxRenderPeriod Then Exit
				
				Cls
				Render()
				If CurrentPause Then CurrentPause.Render()
				Flip( False )
		      
				LastRenderTime = 0.001 * ( Millisecs() - StartTime )
				FPSCount :+ 1
			Forever
	      
			If Millisecs() >= 1000 + FPSTime Then
				FPS = FPSCount
				FPSCount = 0
				FPSTime = Millisecs()
			End If
			
			PollSystem()
			Pass :+ 1
		Forever
	End Method
	
	
	
	Method PerSecond:Double( Value:Double )
		Return Value * L_DeltaTime
	End Method
	
	
	
	Method ShowDebugInfo( MainLayer:LTLayer )
		DrawText( "FPS: " + FPS, 0, 0 )
		DrawText( "Memory: " + Int( GCMemAlloced() / 1024 ) + "kb", 0, 16 )
		DrawText( "Sprites: " + MainLayer.CountSprites(), 0, 32 )
		DrawText( "Collisions: " + L_CollisionChecks, 0, 48 )
	End Method
	
	
	
	Method ApplyPause( NewPause:LTPause, Key:Int )
		NewPause.Project = Self
		NewPause.Key = Key
		NewPause.PreviousPause = CurrentPause
		CurrentPause = NewPause
	End Method
End Type