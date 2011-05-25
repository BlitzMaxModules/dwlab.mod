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
			Elseif LTTileMap( Shape ) Then
				NewShape = LoadTileMap( LTTileMap( Shape ) )
			ElseIf LTVectorSprite( Shape )
				NewShape = LoadVectorSprite( LTVectorSprite( Shape ) )
			ElseIf LTAngularSprite( Shape )
				NewShape = LoadAngularSprite( LTAngularSprite( Shape ) )
			Else
				NewShape = LoadStaticSprite( LTSprite( Shape ) )
			End If
			If NewShape <> Null Then NewLayer.AddLast( NewShape )
		Next
		Return NewLayer
	End Method
	
	
	
	Method LoadTilemap:LTTileMap( TileMap:LTTileMap )
		Local NewTileMap:LTTileMap = New LTTileMap
		TileMap.CopyTileMapTo( NewTileMap )
		Return NewTileMap
	End Method
	
	
	
	Method LoadStaticSprite:LTSprite( Sprite:LTSprite )
		Local NewSprite:LTSprite = New LTSprite
		Sprite.CopySpriteTo( NewSprite )
		Return NewSprite
	End Method
	
	
	
	Method LoadVectorSprite:LTVectorSprite( Sprite:LTVectorSprite )
		Local NewSprite:LTVectorSprite = New LTVectorSprite
		Sprite.CopyVectorSpriteTo( NewSprite )
		Return NewSprite
	End Method
	
	
	
	Method LoadAngularSprite:LTSprite( Sprite:LTAngularSprite )
		Local NewSprite:LTAngularSprite = New LTAngularSprite
		Sprite.CopyAngularSpriteTo( NewSprite )
		Return NewSprite
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