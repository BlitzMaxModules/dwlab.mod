'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Global L_Window:LTWindow
Global L_ActiveTextField:LTTextField
Global L_GUICamera:LTCamera = LTCamera.Create()

Rem
bbdoc: Class for GUI window.
End Rem

Type LTWindow Extends LTProject
	Field World:LTWorld
	Field Layer:LTLayer
	Field MouseOver:TMap = New TMap
	
	
	
	Method GetName:String()
		Return Layer.GetName()
	End Method
	
	
	
	Method Render()
		If Not Layer.Visible Then Return
		If Modal Then L_CurrentCamera.Darken( 0.3 )
		Layer.Draw()
	End Method
	
	
	
	Function Load:LTWindow( World:LTWorld, Class:String, Camera:LTCamera = Null )
		L_ActiveTextField = Null
		L_Window = New LTWindow
		If Not Camera Then Camera = L_GUICamera
		
		L_Window.Layer = LTLayer( L_Window.LoadLayer( LTLayer( World.FindShapeWithParameter( "class", Class ) ) ) )
		Local Layer:LTLayer = L_Window.Layer
		
		Local Screen:LTShape = Layer.Bounds
		If Screen Then
			Local DY:Double = 0.5 * ( Camera.Height - Screen.Height * Camera.Width / Screen.Width )
			Select Layer.GetParameter( "vertical" )
				Case "top"
					DY = -DY
				Case "bottom"
				Default 
					DY = 0.0
			End Select
			Local K:Double = Camera.Width / Screen.Width
			For Local Shape:LTShape = Eachin Layer.Children	
				Shape.SetCoords( Camera.X + ( Shape.X - Screen.X ) * K, Camera.Y + ( Shape.Y - Screen.Y ) * K + DY )
				Shape.SetSize( Shape.Width * K, Shape.Height * K )
			Next
			Screen.JumpTo( Camera )
			Screen.AlterCoords( 0.0, DY )
			Screen.SetSize( Camera.Width, Screen.Height * Camera.Width / Screen.Width )
		End If

		L_Window.Modal = ( Layer.GetParameter( "modal" ) = "true" )
		L_Window.World = World
		L_Window.Init()
		
		FlushKeys
		
		Return L_Window
	End Function
	
	
	
	Method Logic()
		For Local Gadget:LTGadget = Eachin Layer.Children
			If Not Gadget.Active Then Continue
			
			If Gadget.CollidesWithSprite( L_Cursor ) Then
				If Not MouseOver.Contains( Gadget ) Then
					OnMouseOver( Gadget )
					Gadget.OnMouseOver()
					MouseOver.Insert( Gadget, Null )
				End If
				
				For Local ButtonAction:LTButtonAction = Eachin L_GUIButtons
					If ButtonAction.WasPressed() Then
						OnButtonPress( Gadget, ButtonAction )
						Gadget.OnButtonPress( ButtonAction )
					End If
					If ButtonAction.WasUnpressed() Then
						OnButtonUnpress( Gadget, ButtonAction )
						Gadget.OnButtonUnpress( ButtonAction )
					End If
					If ButtonAction.IsDown() Then
						OnButtonDown( Gadget, ButtonAction )
						Gadget.OnButtonDown( ButtonAction )
					Else
						OnButtonUp( Gadget, ButtonAction )
						Gadget.OnButtonUp( ButtonAction )
					End If
				Next
			ElseIf MouseOver.Contains( Gadget ) Then
				Gadget.OnMouseOut()
				OnMouseOut( Gadget )
				MouseOver.Remove( Gadget )
			End If
		Next
		
		If L_Enter.WasPressed() Then
			For Local Gadget:LTGadget = Eachin Layer.Children
				If Gadget.GetParameter( "action" ) = "save_and_close" Then OnButtonUnpress( Gadget, L_LeftMouseButton )
			Next
		ElseIf L_Esc.WasPressed() Then
			For Local Gadget:LTGadget = Eachin Layer.Children
				If Gadget.GetParameter( "action" ) = "close" Then OnButtonUnpress( Gadget, L_LeftMouseButton )
			Next
		End If
	
		If L_ActiveTextField Then
			If L_ActiveTextField.Active Then
				Local LeftPart:String = L_ActiveTextField.LeftPart
				Local RightPart:String = L_ActiveTextField.RightPart
				If LeftPart Then
					If L_CharacterLeft.WasPressed() Then
						L_ActiveTextField.RightPart = LeftPart[ LeftPart.Length - 1.. ] + RightPart
						L_ActiveTextField.LeftPart = LeftPart[ ..LeftPart.Length - 1 ]
					End If
					If L_DeletePreviousCharacter.WasPressed() Then L_ActiveTextField.LeftPart = LeftPart[ ..LeftPart.Length - 1 ]
				End If
				If RightPart Then
					If L_CharacterRight.WasPressed() Then
						L_ActiveTextField.LeftPart = LeftPart + RightPart[ ..1 ]
						L_ActiveTextField.RightPart = RightPart[ 1.. ]
					End If
					If L_DeleteNextCharacter.WasPressed() Then L_ActiveTextField.RightPart = RightPart[ 1.. ]
				End If
				Local Key:Int = GetChar()
				If Key >= 32 And ( L_ActiveTextField.MaxSymbols = 0 Or Len( L_ActiveTextField.LeftPart + L_ActiveTextField.RightPart ) < L_ActiveTextField.MaxSymbols ) Then
					L_ActiveTextField.LeftPart :+ Chr( Key )
				End If
				L_ActiveTextField.Text = L_ActiveTextField.LeftPart + L_ActiveTextField.RightPart
			End If
		End If
	End Method
	
	
	Rem
	bbdoc: Button pressing event method.
	about: Called when button just being pressed on window's gadget.
	
	See also: #OnButtonUnpress, #OnButtonDown, #OnButtonUp, #OnMouseOver, #OnMouseOut
	End Rem
	Method OnButtonPress( Gadget:LTGadget, ButtonAction:LTButtonAction )
	End Method
	
	
	
	Rem
	bbdoc: Button unpressing event method
	about: Called when button just being unpressed on window's gadget.
	Some standard commands are available (can be set in editor in "action" parameter):
	<ul><li>"save" - executes window's Save() method. Intended for saving data changed by window.
	<lI>"close" - closes the window.
	<li>"end" - forces exit from current project.
	<li>"window" - opens a window with given name
	<li>"window_class" - opens a window of given class
	<li>"save_and_close" - performs "save" and "close" actions
	<li>"save_and_end" - performs "save" and "end" actions</ul>
	
	See also: #OnButtonPress, #OnButtonDown, #OnButtonUp, #OnMouseOver, #OnMouseOut
	End Rem
	Method OnButtonUnpress( Gadget:LTGadget, ButtonAction:LTButtonAction )
		Select Gadget.GetParameter( "action" )
			Case "save"
				Save()
			Case "save_and_close"
				Save()
				Exiting = True
			Case "close"
				Exiting = True
			Case "save_and_end"
				Save()
				End
			Case "end"
				End
		End Select
		
		Local Class:String = Gadget.GetParameter( "window_class" )
		If Class Then LTWindow.Load( World, Class ) 
	End Method
	
	
	
	Rem
	bbdoc: Button down event method.
	about: Called when button is currently pressed and cursor is over window's gadget.
	
	See also: #OnButtonPress, #OnButtonUnpress, #OnButtonUp, #OnMouseOver, #OnMouseOut
	End Rem
	Method OnButtonDown( Gadget:LTGadget, ButtonAction:LTButtonAction )
	End Method
	
	
	
	Rem
	bbdoc: Button up event method.
	about: Called when button is currently released and cursor is over window's gadget.
	
	See also: #OnButtonPress, #OnButtonUnpress, #OnButtonUp, #OnMouseOver, #OnMouseOut
	End Rem
	Method OnButtonUp( Gadget:LTGadget, ButtonAction:LTButtonAction )
	End Method
	
	
	
	Rem
	bbdoc: Mouse cursor entering gadget event method.
	about: Called when mouse is just entered window's gadget area.
	
	See also: #OnButtonPress, #OnButtonUnpress, #OnButtonDown, #OnButtonUp, #OnMouseOut
	End Rem
	Method OnMouseOver( Gadget:LTGadget )
	End Method
	
	
	
	Rem
	bbdoc: Mouse cursor leaving gadget event method.
	about: Called when mouse is just left window's gadget area.
	
	See also: #OnButtonPress, #OnButtonUnpress, #OnButtonDown, #OnButtonUp, #OnMouseOver
	End Rem
	Method OnMouseOut( Gadget:LTGadget )
	End Method
	
	
	
	Rem
	bbdoc: Window data saving method.
	about: Can be executed via window gadget using standard command.
	Usually being executed before closing of the window.
	
	See also: #OnButtonUnpress
	End Rem
	Method Save()
	End Method
End Type





Function L_ReloadWindows()
	Local Link:TLink = L_Projects.FirstLink()
	While Link
		Local Window:LTWindow = LTWindow( Link.Value() )
		If Window Then Link._value = LTWindow.Load( Window.World, TTypeID.ForObject( Window ).Name(), Window.Camera )
		Link = Link.NextLink()
	Wend
End Function





Rem
bbdoc: Function which finds a window in opened windows by given name or class.
returns: Found window.
End Rem
Function L_FindWindow:LTWindow( Class:String = "" )
	Local TypeID:TTypeId = L_GetTypeID( Class )
	For Local Window:LTWindow = Eachin L_Projects
		If TTypeID.ForObject( Window.Layer ) = TypeID Then Return Window
	Next
	L_Error( "Window with class ~q" + Class + "~q is not found." )
End Function
