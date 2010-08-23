' 2DLab - 2D application developing environment 
' Copyright (C) 2010, Matt Merkulov
' Distrbuted under GNU General Public License version 3

SeedRnd( Millisecs() )

Const L_Version:String = "0.1"

Include "include/LTObject.bmx"
Include "include/LTProject.bmx"
Include "include/LTModel.bmx"
Include "include/LTVisual.bmx"
Include "include/LTCamera.bmx"
Include "include/LTDrag.bmx"
Include "include/LTXML.bmx"

Global L_ScreenXSize:Int = 800
Global L_ScreenYSize:Int = 600

L_CurrentCamera = New LTCamera
L_CurrentCamera.XSize = 32.0
L_CurrentCamera.YSize = 24.0
L_CurrentCamera.DX = 16.0
L_CurrentCamera.DY = 12.0
L_CurrentCamera.XK = 25.0
L_CurrentCamera.YK = 25.0

Graphics L_ScreenXSize, L_ScreenYSize