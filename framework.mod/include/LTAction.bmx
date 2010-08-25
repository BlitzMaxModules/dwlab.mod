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

Type LTAction Extends LTObject
	Method Do()
	End Method
	
	
	
	Method Undo()
	End Method
End Type





Function L_PushUndoList()
	If Not L_CurrentUndoList.IsEmpty() Then
		L_UndoStack.AddFirst( L_CurrentUndoList )
		L_CurrentUndoList = New TList
	End If
End Function





Function L_Undo()
	If L_UndoStack.IsEmpty() Then Return
	Local UndoList:TList = TList( L_UndoStack.First() )
	For Local Action:LTAction = Eachin UndoList
		Action.Undo()
	Next
	L_RedoStack.AddFirst( UndoList )
	L_UndoStack.RemoveFirst()
End Function





Function L_Redo()
	If L_RedoStack.IsEmpty() Then Return
	Local RedoList:TList = TList( L_RedoStack.First() )
	For Local Action:LTAction = Eachin RedoList
		Action.Do()
	Next
	L_UndoStack.AddFirst( RedoList )
	L_RedoStack.RemoveFirst()
End Function