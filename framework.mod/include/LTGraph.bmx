' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
' Distrbuted under GNU General Public License version 3
' You can read it at http://www.gnu.org/licenses/gpl.txt

Type LTGraph Extends LTModel
	Field Pivots:TMap = New TMap
	Field Lines:TMap = New TMap
	
	
	
	Method	DrawPivotsUsing( Visual:LTVisual )
		For Local Pivot:LTPivot = Eachin Pivots.Keys()
			'debugstop
			Pivot.DrawUsingVisual( Visual )
		Next
	End Method
	
	
	
	Method DrawLinesUsing( Visual:LTVisual )
		For Local Line:LTLine = Eachin Lines.Keys()
			
			Line.DrawUsingVisual( Visual )
		Next
	End Method
	
	
	
	Method AddPivot:TList( Pivot:LTPivot )
		Local List:TList = TList( Lines.ValueForKey( Pivot ) )
		If Not List Then
			List = New TList
			Pivots.Insert( Pivot, List )
		End If
		Return List
	End Method
	
	
	
	Method AddLine( Line:LTLine )
		If Line.Pivot[ 0 ] = Line.Pivot[ 1 ] Then Return
		If Lines.ValueForKey( Line ) Then Return
		
		For local N:Int = 0 To 1
			AddPivot( Line.Pivot[ N ] ).AddLast( Line )
		Next
		Lines.Insert( Line, Line )
	End Method
	
	
	
	Method FindLine:LTLine( Pivot1:LTPivot, Pivot2:LTPivot )
		If Pivot1 = Pivot2 Then Return Null
		
		For Local KeyValue:TKeyValue = Eachin Pivots
			If KeyValue.Key() = Pivot1 Then
				For Local Line:LTLine = Eachin TList( KeyValue.Value() )
					If Line.Pivot[ 0 ] = Pivot2 Or Line.Pivot[ 1 ] = Pivot2 Then Return Line
				Next
			End If
		Next
	End Method
	
	
	
	Method FindPivotCollidingWith:LTPivot( Model:LTModel )
		For Local Pivot:LTPivot = Eachin Pivots.Keys()
			If Pivot.CollidesWith( Model ) Then Return Pivot
		Next
	End Method



	Method XMLIO( XMLObject:LTXMLObject )
		Super.XMLIO( XMLObject )
		Local List:TList
		If L_XMLMode = L_XMLGet Then
			XMLObject.ManageChildList( List )
			For Local Line:LTLine = Eachin List
				AddLine( Line )
			Next
		Else
			List = New TList
			For Local Line:LTLine = Eachin Lines.Keys()
				List.AddLast( Line )
			Next
			XMLObject.ManageChildList( List )
		End If
	End Method
End Type