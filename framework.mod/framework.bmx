' 2DLab - 2D application developing environment 
' Copyright (C) 2010, Matt Merkulov
' Distrbuted under GNU General Public License version 3

SeedRnd( Millisecs() )

Const L_Version:String = "0.10.1"

Include "include/LTObject.bmx"
Include "include/LTList.bmx"
Include "include/LTProject.bmx"
Include "include/LTCamera.bmx"
Include "include/LTMap.bmx"
Include "include/LTShape.bmx"
Include "include/LTVisualizer.bmx"
Include "include/LTText.bmx"
Include "include/LTPath.bmx"
Include "include/LTDrag.bmx"
Include "include/LTAction.bmx"
Include "include/LTXML.bmx"
Include "include/Service.bmx"


Global L_ScreenXSize:Int
Global L_ScreenYSize:Int





Function Init( ScreenXSize:Int, ScreenYSize:Int )
	L_ScreenXSize = ScreenXSize
	L_ScreenYSize = ScreenYSize
	
	L_CurrentCamera = New LTCamera
	L_CurrentCamera.XSize = 32.0
	L_CurrentCamera.YSize = 24.0
	L_CurrentCamera.Viewport.XSize = ScreenXSize
	L_CurrentCamera.Viewport.YSize = ScreenYSize
	L_CurrentCamera.Viewport.X = 0.5 * ScreenXSize
	L_CurrentCamera.Viewport.Y = 0.5 * ScreenYSize
	L_CurrentCamera.Update()
	
	Graphics( L_ScreenXSize, L_ScreenYSize )
	AutoImageFlags( FILTEREDIMAGE | DYNAMICIMAGE )
	SetBlend( AlphaBlend )
End Function





Function L_Assert( Condition:Int, Text:String )
	If Not Condition Then
		Notify( Text, True )
		DebugStop
		End
	End If
End Function