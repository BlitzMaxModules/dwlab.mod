SuperStrict

Framework brl.basic
Import dwlab.frmwork
Import dwlab.graphicsdrivers

Global Example:TExample = New TExample
Example.Execute()

Type TExample Extends LTProject
	Const PivotsQuantity:Int = 150
	Const MaxDistance:Double = 3.0
	Const MinDistance:Double = 1.0
	
	Field Graph:LTGraph = New LTGraph
	Field SelectedPivot:LTSprite
	Field Path:TList
	Field PivotVisualizer:LTVisualizer = LTVisualizer.FromHexColor( "4F4FFF" )
	Field LineVisualizer:LTVisualizer = LTContourVisualizer.FromWidthAndHexColor( 0.15, "FF4F4F", , 3.0 )
	Field PathVisualizer:LTVisualizer = LTContourVisualizer.FromWidthAndHexColor( 0.15, "4FFF4F", , 4.0 )
	
	Method Init()
		L_InitGraphics()
		L_Cursor = LTSprite.FromShape( 0, 0, 0.5, 0.5, LTSprite.Oval )
		For Local N:Int = 0 Until PivotsQuantity
			Repeat
				Local X:Double = Rnd( -15,15 )
				Local Y:Double = Rnd( -11, 11 )
				Local Passed:Int = True
				For Local Pivot:LTSprite = Eachin Graph.Pivots.Keys()
					If Pivot.DistanceToPoint( X, Y ) < MinDistance Then
						Passed = False 
						Exit
					End If
				Next
				If Passed Then
					Graph.AddPivot( LTSprite.FromShape( X, Y, 0.3, 0.3, LTSprite.Oval ) )
					Exit
				End If
			Forever
		Next
		For Local Pivot1:LTSprite = Eachin Graph.Pivots.Keys()
			For Local Pivot2:LTSprite = Eachin Graph.Pivots.Keys()
				If Pivot1 <> Pivot2 And Pivot1.DistanceTo( Pivot2 ) <= MaxDistance Then
					Local Passed:Int = True
					Local NewLine:LTLine = LTLine.FromPivots( Pivot1, Pivot2 )
					For Local Line:LTLine = Eachin Graph.Lines.Keys()
						If Line.CollidesWithLine( NewLine, False ) Then
							Passed = False
							Exit
						End If
					Next
					If Passed Then Graph.AddLine( NewLine, False )
				End If
			Next
		Next
	End Method
	
	Method Logic()
		If MouseHit( 1 ) Then
			SelectedPivot = Graph.FindPivotCollidingWithSprite( L_Cursor )
			Path = Null
		End If
		If MouseHit( 2 ) And SelectedPivot Then
			Local SelectedPivot2:LTSprite = Graph.FindPivotCollidingWithSprite( L_Cursor )
			If SelectedPivot2 Then Path = Graph.FindPath( SelectedPivot, SelectedPivot2 )
		End If
		If AppTerminate() Or KeyHit( Key_Escape ) Then Exiting = True
	End Method

	Method Render()
		Graph.DrawLinesUsing( LineVisualizer )
		LTGraph.DrawPath( Path, PathVisualizer )
		Graph.DrawPivotsUsing( PivotVisualizer )
		If SelectedPivot Then SelectedPivot.DrawUsingVisualizer( PathVisualizer )
		DrawText( "Select first pivot with left mouse button and second with right one", 0, 0 )
		L_PrintText( "LTGraph, FindPath, CollidesWithLine example", 0, 12, LTAlign.ToCenter, LTAlign.ToBottom )
	End Method
End Type