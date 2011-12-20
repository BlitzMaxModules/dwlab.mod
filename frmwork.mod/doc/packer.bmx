SuperStrict

Framework brl.basic
Import brl.stream
Import brl.retro

Local EqualNames:String[] = [ "Example", "TCursor", "TBall", "TKolobok" ]

Local All:TStream = WriteFile( "all.bmx" )
WriteLine( All, "SuperStrict" )
WriteLine( All, "Framework brl.basic" )
WriteLine( All, "Import dwlab.frmwork" )
WriteLine( All, "Import dwlab.graphicsdrivers" )
WriteLine( All, "Import dwlab.audiodrivers" )
WriteLine( All, "L_InitGraphics()" )
WriteLine( All, "L_PrintText( ~qPress ESC to start~q, 0, 0, LTAlign.ToCenter, LTAlign.ToCenter )" )
WriteLine( All, "Flip" )
WriteLine( All, "Waitkey" )
WriteLine( All, "EndGraphics()" )


Local Dir:Int = ReadDir( CurrentDir() )
Local Num:Int = 1
Local Incbins:TList = New TList
Repeat
	Local FileName:String = NextFile( Dir )
	If Not FileName Then Exit
	
	If ExtractExt( FileName ) <> "bmx" Then Continue
	If TList.FromArray( [ "packer.bmx", ".bmx", "LTBehaviorModel.bmx", "LTSpring.bmx", "all.bmx" ] ).Contains( FileName ) Then Continue
	
	Local File:TStream = ReadFile( FileName )
	Local TypeArea:Int = -1
	Local Consts:TList = New TList
	
	While Not EOF( File )
		Local Line:String = ReadLine( File )
		If Line.StartsWith( "SuperStrict" ) Then
			 If Line.EndsWith( "Skip" ) Then Exit
			 Continue
		End If
		If Line.StartsWith( "Framework" ) Or Line.StartsWith( "Import" ) Then Continue
		
		If Line.StartsWith( "Const" ) Then
			Local ConstName:String = Line[ 6..Line.Find( ":" ) ]
			WriteLine( All, Line.Replace( ConstName, ConstName + Num ) )
			Consts.AddLast( ConstName )
			Continue
		End If
		
		If Line.StartsWith( "Incbin" ) Then
			If Incbins.Contains( Line ) Then Continue
			Incbins.AddLast( Line )
			WriteLine( All, Line )
			Continue
		End If
		
		If Trim( Line ) And Not Line.StartsWith( "'" ) Then
			If TypeArea = -1 Then
				WriteLine( All, "'" + FileName )
				WriteLine( All, "L_CurrentCamera = LTCamera.Create()" )
				If Line.StartsWith( "Global Example" ) Or Line.StartsWith( "Local Example" ) Then
					TypeArea = 1
				Else
					WriteLine( All, "Ex" + Num + "()" )
					WriteLine( All, "Function Ex" + Num + "()" )
					TypeArea = 0
				End If
			End If
			
			If Not TypeArea And ( Line.StartsWith( "Type" ) Or Line.StartsWith( "Function" ) ) Then
				WriteLine( All, "End Function" )
				TypeArea = True
			End If
			
			For Local EqualName:String = Eachin EqualNames
				Line = Line.Replace( EqualName, EqualName + Num )
			Next
			For Local ConstName:String = Eachin Consts
				Line = Line.Replace( ConstName, ConstName + Num )
			Next
		End If
		WriteLine( All, Line )
	WEnd
	CloseFile( File )
	If TypeArea >= 0 WriteLine( All, "EndGraphics()" ); Num :+ 1
	If TypeArea = 0 Then WriteLine( All, "End Function" )
Forever

WriteLine( All, "L_InitGraphics()" )
WriteLine( All, "L_PrintText( ~qPress ESC to end~q, 0, 0, LTAlign.ToCenter, LTAlign.ToCenter )" )
WriteLine( All, "Flip" )
WriteLine( All, "Waitkey" )
CloseFile( All )
