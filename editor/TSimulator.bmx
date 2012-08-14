'
' Digital Wizard's Lab world editor
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Attribution-NonCommercial-ShareAlike 3.0 License terms, as
' specified in the license2.txt file distributed with this
' code, or available from
' http://creativecommons.org/licenses/by-nc-sa/3.0/
'

Global Simulator:TSimulator = New TSimulator

Type TSimulator Extends LTProject
	Field Window:TGadget
	Field Canvas:TGadget
	Field Camera:LTCamera = New LTCamera
	Field Pan:TPan
	Field Layer:LTLayer
	Field InitialWidth:Double
	Field Z:Int
	
	
	
	Method Init()
		Window = CreateWindow( LocalizeString( "{{W_Simulation}}" ), 0, 0, 0, 0, Editor.Window, Window_Titlebar | Window_ClientCoords )
		MaximizeWindow( Window )
		Canvas = CreateCanvas( 0, 0, ClientWidth( Window ), ClientHeight( Window ), Window )
		Layer = LTLayer( Editor.SelectedShape.Clone() )
		Camera = New LTCamera
		Camera.Viewport.SetCoordsAndSize( 0, 0, ClientWidth( Window ), ClientHeight( Window ) )
		Camera.JumpTo( Layer.Bounds )
		Camera.SetSizeAs( Layer.Bounds )
		Camera.Update()
		InitialWidth = Camera.Width
		'LTBox2DPhysics.InitWorld( World )
		Pan = TPan.Create( Camera )
	End Method
	
	
	
	Method Logic()
		'LTBox2DPhysics.Logic( 1.0 / L_LogicFPS )
		Pan.Act()
		Camera.MoveUsingArrows( Camera.Width )
		Editor.SetCameraMagnification( Camera, Canvas, Z, InitialWidth )
	End Method
	
	
	
	Method ProcessEvents()
		PollEvent()
		Select EventID()
			Case Event_WindowClose
				Exiting = True
			Case Event_KeyDown
				Select EventData()
					Case Key_NumAdd
						Z :+ 1
					Case Key_NumSubtract
						Z :- 1
				End Select
			Case Event_MouseWheel
				Z :+ EventData()
		End Select
	End Method
	
	
	
	Method Render()
		L_CurrentCamera = Camera 
		SetGraphics( CanvasGraphics( Canvas ) )
		SetClsColor( 255, 255, 255 )
		Cls
		Layer.Draw()
		Flip( False )
	End Method
	
	
	
	Method DeInit()
		FreeGadget( Window )
	End Method
End Type