' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
' Distrbuted under GNU General Public License version 3
' You can read it at http://www.gnu.org/licenses/gpl.txt

Type LTPath Extends LTObject
	Field Pivots:TList = New TList
	
	
	
	Function Find:LTPath( FromPivot:LTPivot, ToPivot:LTPivot, Graph:LTGraph )
		Local ShortestPath:LTPath= New LTPath	
	
		Local Paths:TList = New TList
		Local RightPaths:TList = New TList
		Local Path:TList = New TList
		Path.AddLast( FromPivot )
		Paths.AddLast( Path )
		While Not Paths.IsEmpty()
			Local NewPaths:TList = New TList
			For Path = Eachin Paths
				Local EndingPivot:LTPivot = LTPivot( Path.Last() )
				For Local Line:LTLine = Eachin TList( Graph.Pivots.ValueForKey( EndingPivot ) )
					Local NextPivot:LTPivot
					If Line.Pivot[ 0 ] = EndingPivot Then NextPivot = Line.Pivot[ 1 ] Else NextPivot = Line.Pivot[ 0 ]
					If Not Path.Contains( NextPivot ) Then
						Local NewPath:TList = New TList
						For Local Pivot:LTPivot = Eachin Path
							NewPath.AddLast( Pivot )
						Next
						NewPath.AddLast( NextPivot )
						If NextPivot = ToPivot Then RightPaths.AddLast( NewPath ) Else NewPaths.AddLast( NewPath )
					End If
				Next
			Next
			'L_DeleteList( Paths )
			Paths = NewPaths
		WEnd
		
		Local PathLength:Float = 0.0
		For Path = Eachin RightPaths
			Local Pivot1:LTPivot = Null
			Local CurrentPathLength:Float
			For Local Pivot2:LTPivot = Eachin Path
				If Pivot1 Then CurrentPathLength :+ Pivot1.DistanceTo( Pivot2 )
				Pivot1 = Pivot2
			Next
			If CurrentPathLength < PathLength Or PathLength = 0.0 Then
				PathLength = CurrentPathLength
				ShortestPath.Pivots = Path
			End If
		Next
		
		'L_DeleteList( Paths )
		'L_DeleteList( RightPaths )
		
		Return ShortestPath
	End Function
End Type





Function L_DeleteList( List:TList )
	List.Clear()
	List._head._pred = Null
	List._head._succ = Null
End Function