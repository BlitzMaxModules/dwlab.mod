' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
' Distrbuted under GNU General Public License version 3
' You can read it at http://www.gnu.org/licenses/gpl.txt

Include "../framework.bmx"

Type LTEditor Extends LTPorject
	Field Graph:LTGraph = New LTGraph
	Field Cursor:LTCircle = New LTCircle
	Field LineVisual:LTVisual
	Field PivotVisual:LTVisual
	
	
	Method Init()
		LineVisual = ( New LTPrimitive ).Attach( LTUseColor.Create( "" ) )
	End Method
	
	
	
	Method Logic()
		
	End Method
	
	
	
	Method Render()
		Graph.DrawLinesUsing( LineVisual )
		Graph.DrawPivotsUsing( PivotVisual )
		If CurrentPivot Then CurrentPivot.DrawWith( CurrentPivotVisual )
		Cursor.DrawWith( CursorVisual )
	End Method
End Type