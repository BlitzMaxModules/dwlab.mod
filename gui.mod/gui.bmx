SuperStrict

Rem
bbdoc: Digital Wizard's Lab framework GUI module
End Rem
Module dwlab.gui

ModuleInfo "Version: 1.0"
ModuleInfo "Author: Matt Merkulov"
ModuleInfo "License: Artistic License 2.0"
ModuleInfo "Modserver: DWLAB"

ModuleInfo "History: v1.0 (09.10.11)"
ModuleInfo "History: &nbsp; &nbsp; Initial release."

Import dwlab.frmwork
Import maxgui.localization

Include "include\LTGUIProject.bmx"
Include "include\LTWindow.bmx"
Include "include\LTGadget.bmx"

Global L_LeftMouseButton:LTButtonAction = LTButtonAction.Create( LTMouseButton.Create( 1 ) )
Global L_RightMouseButton:LTButtonAction = LTButtonAction.Create( LTMouseButton.Create( 2 ) )
Global L_MiddleMouseButton:LTButtonAction = LTButtonAction.Create( LTMouseButton.Create( 3 ) )

Global L_CharacterLeft:LTButtonAction = LTButtonAction.Create( LTKeyboardKey.Create( Key_Left ) )
Global L_CharacterRight:LTButtonAction = LTButtonAction.Create( LTKeyboardKey.Create( Key_Right ) )
Global L_DeletePreviousCharacter:LTButtonAction = LTButtonAction.Create( LTKeyboardKey.Create( Key_Backspace ) )
Global L_DeleteNextCharacter:LTButtonAction = LTButtonAction.Create( LTKeyboardKey.Create( Key_Delete ) )

Global L_GUIButtons:TList = New TList
L_GUIButtons.AddLast( L_LeftMouseButton )
L_GUIButtons.AddLast( L_RightMouseButton )
L_GUIButtons.AddLast( L_MiddleMouseButton )
