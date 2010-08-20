' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
' Distrbuted under GNU General Public License version 3
' You can read it at http://www.gnu.org/licenses/gpl.txt

Type LTLine Extends LTModel
	Field Pivot:TPivot[] = New TPivot[ 2 ]
End Type



Type LTGraph Extends LTModel
	Field Pivots:TMap = New TMap
	Field Lines:TMap = New TMap
	
	
	
	Method	DrawPivotsUsing( Visual:LTVisual )
		For Local Pivot:LTPivot = Eachin Pivots.Keys()
			Visual.DrawPivot( Pivot )
		Next
	End Method
	
	
	
	Method DrawLinesUsing( Visual:LTVisual )
		For Local Line:LTLine = Eachin Lines.Keys()
			Visual.DrawLine( Line )
		Next
	End Method
	
	
	
	Method AddPivot:TList( Pivot:LTPivot )
		Local List:TList = TList( Lines.ValueForKey( Pivot ) )
		If Not List Then
			List = New List
			Pivots.Insert( Pivot, List )
		End If
		Return List
	End Method
	
	
	
	Method AddLine( Line:LTLine )
		If Lines.ValueForKey( Line ) Then Return
		For local N:Int = 0 To 1
			AddPivot( Line.Pivot[ N ] ).AddLast( Line )
		Next
		Lines.Insert( Line, Line )
	End Method
End Type