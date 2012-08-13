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
	Field Pan:TPan
	Field Window:TGadget
	Field Canvas:TGadget
	Field Layer:LTLayer
	
	
	
	Method Init()
		Window = CreateWindow( LocalizeString( "{{W_Simulation}}" ), 0, 0, 0, 0, Editor.Window, Window_Titlebar | Window_ClientCoords )
		MaximizeWindow( Window )
		Canvas = CreateCanvas( 0, 0, ClientWidth( Window ), ClientHeight( Window ), Window )
		Layer = LTLayer( Editor.SelectedShape.Clone() )
		'LTBox2DPhysics.InitWorld( World )
		Pan = TPan.Create( L_CurrentCamera )
	End Method
	
	
	
	Method Logic()
		'LTBox2DPhysics.Logic( 1.0 / L_LogicFPS )
		Pan.Act()
	End Method
	
	
	
	Method ProcessEvents()
		PollEvent()
		Select EventID()
			Case Event_WindowClose
				FreeGadget( Window )
				Exiting = True
		End Select
	End Method
	
	
	
	Method Render()
		SetGraphics( CanvasGraphics( Canvas ) )
		Cls
		Layer.Draw()
	End Method
End Type