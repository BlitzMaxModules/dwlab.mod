'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Global L_UndoStack:TList = New TList
Global L_CurrentUndoList:TList = New TList
Global L_RedoStack:TList = New TList
Global L_CurrentRedoList:TList = New TList

Rem
bbdoc: Action class for implementing Undo/Redo technology.
End Rem
Type LTAction Extends LTObject
	Rem
	bbdoc: Action performing method.
	about: Execute it when you want to perform an action of this type.
	Fill this method with action initialization commands (which also need to store information for Undo operation).
	Also it can be executed automatically when you will execute L_Redo function.
	End Rem
	Method Do()
		L_CurrentUndoList.AddFirst( Self )
	End Method
	
	
	
	Rem
	bbdoc: Action undoing method.
	about: Fill it with commands which will perform rolling back changes done by Do() method.
	Can be executed automatically when you will execute L_Undo function.
	End Rem
	Method Undo()
		L_CurrentRedoList.AddFirst( Self )
	End Method
End Type





Rem
bbdoc: Function for finalizing current action list as single step and pushing it to Undo stack.
about: See also: #LTAction example
End Rem
Function L_PushActionsList()
	If Not L_CurrentUndoList.IsEmpty() Then
		L_UndoStack.AddFirst( L_CurrentUndoList )
		L_CurrentUndoList = New TList
	End If
End Function





Rem
bbdoc: Function for performing single step of Undo.
about: Executes all Undo() methods for every action in head action list of Undo stack and moves this list to Redo stack.

See also: #LTAction example
End Rem
Function L_Undo()
	If L_UndoStack.IsEmpty() Then Return
	Local UndoList:TList = TList( L_UndoStack.First() )
	For Local Action:LTAction = Eachin UndoList
		Action.Undo()
	Next
	L_RedoStack.AddFirst( UndoList )
	L_UndoStack.RemoveFirst()
End Function





Rem
bbdoc: Function for performing single step of Redo.
about: Executes all Redo() methods for every action in head action list of Redo stack and moves this list to Undo stack.

See also: #LTAction example
End Rem
Function L_Redo()
	If L_RedoStack.IsEmpty() Then Return
	Local RedoList:TList = TList( L_RedoStack.First() )
	For Local Action:LTAction = Eachin RedoList
		Action.Do()
	Next
	L_UndoStack.AddFirst( RedoList )
	L_RedoStack.RemoveFirst()
End Function