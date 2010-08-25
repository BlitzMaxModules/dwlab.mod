' 2DLab - 2D application developing environment 
' Copyright (C) 2010, Matt Merkulov
' Distrbuted under GNU General Public License version 3

SeedRnd( Millisecs() )

Const L_Version:String = "0.1"

Include "include/LTObject.bmx"
Include "include/LTProject.bmx"
Include "include/LTModel.bmx"
Include "include/LTVisual.bmx"
Include "include/LTPath.bmx"
Include "include/LTCamera.bmx"
Include "include/LTDrag.bmx"
Include "include/LTAction.bmx"
Include "include/LTText.bmx"
Include "include/LTXML.bmx"
Include "include/Service.bmx"


Global L_ScreenXSize:Int
Global L_ScreenYSize:Int

Function Init( ScreenXSize:Int, ScreenYSize:Int )
	L_ScreenXSize = ScreenXSize
	L_ScreenYSize = ScreenYSize
	
	L_CurrentCamera = New LTCamera
	L_CurrentCamera.XSize = 32.0
	L_CurrentCamera.YSize = -24.0
	L_CurrentCamera.DX = 16.0
	L_CurrentCamera.DY = 12.0
	L_CurrentCamera.XK = L_ScreenXSize / 32.0
	L_CurrentCamera.YK = L_ScreenYSize / 24.0
	
	Graphics L_ScreenXSize, L_ScreenYSize
End Function