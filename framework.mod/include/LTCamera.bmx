' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
' Distrbuted under GNU General Public License version 3
' You can read it at http://www.gnu.org/licenses/gpl.txt

Global L_CurrentCamera:LTCamera

Type LTCamera Extends LTRectangle
	Field SourceRectangle:LTRectangle = New LTRectangle
	Field XK:Float = 1.0, YK:Float = 1.0
	Field DX:Float, DY:Float
	Field ViewportClipping:Int = 1
	
	
	
	Method ScreenToField( ScreenX:Float, ScreenY:Float, FieldX:Float Var, FieldY:Float Var )
		FieldX = ScreenX / XK - DX
		FieldY = ScreenY / YK - DY
	End Method

	
	
	Method SizeScreenToField( ScreenXSize:Float, ScreenYSize:Float, FieldXSize:Float Var, FieldYSize:Float Var )
		FieldXSize = ScreenXSize / XK
		FieldYSize = ScreenYSize / YK
	End Method

	
	
	Method DistScreenToField:Float( ScreenDist:Float )
		Return ScreenDist / XK
	End Method
	
	
	
	Method FieldToScreen( FieldX:Float, FieldY:Float, ScreenX:Float Var, ScreenY:Float Var )
		ScreenX = ( FieldX + DX ) * XK
		ScreenY = ( FieldY + DY ) * YK
	End Method

	
	
	Method SizeFieldToScreen( FieldXSize:Float, FieldYSize:Float, ScreenXSize:Float Var, ScreenYSize:Float Var )
		ScreenXSize = FieldXSize * XK
		ScreenYSize = FieldYSize * YK
	End Method

	
	
	Method DistFieldToScreen:Float( ScreenDist:Float )
		Return ScreenDist * XK
	End Method
	
	
	
	Method SetCameraViewport()
		If Not ViewportClipping Then Return
	
		SetViewport X - 0.5 * XSize, Y - 0.5 * YSize, XSize, YSize
	End Method
	
	
	
	Method ResetViewport()
		SetViewport 0, 0, L_ScreenXSize, L_ScreenYSize
	End Method
	
	
	
	Method Update()
		ScreenToField( X, Y, SourceRectangle.X, SourceRectangle.Y )
		SizeScreenToField( XSize, YSize, SourceRectangle.XSize, SourceRectangle.YSize )
		'debugstop
	End Method
End Type