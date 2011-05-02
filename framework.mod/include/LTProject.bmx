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

Type LTProject Extends LTObject
	Field LogicFPS:Float = 75
	Field MinFPS:Float = 15
	Field Pass:Int
	Field Time:Float
	
	Field World:LTWorld
	Field MainLayer:LTLayer

	
	
	Method Init()
	End Method
  
  
  
	Method Render()
		MainLayer.Draw()
	End Method
	
	
	
	Method Logic()
		MainLayer.Act()
	End Method
	
	
	
	Method LoadLayer( LayerName:String, SetCollisionTilemap:Int = True )
		Local Layer:LTLayer = World.FindLayer( LayerName )
		?debug
		If Layer = Null Then L_Error( "Layer " + LayerName + " not found" )
		?
		MainLayer = Layer.LoadLayer( Self )
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
	
	
	
	Method DestroySprite( Sprite:LTSprite, Layer:LTLayer = Null )
		If Layer = Null Then Layer = MainLayer
		Local Link:TLink = Layer.Children.FirstLink()
		While Link <> Null
			If LTLayer( Link.Value() ) Then DestroySprite( Sprite, LTLayer( Link.Value() ) )
			If Link.Value() = Sprite Then Link.Remove()
			Link = Link.NextLink()
		Wend
		Sprite.Destroy()
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
	
	
	
	Method ShowFPS()
		DrawText( L_FPS, 0, 0 )
	End Method
End Type