'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Include "LTPivot.bmx"
Include "LTOval.bmx"
Include "LTRectangle.bmx"
Include "LTRay.bmx"
Include "LTTopLeftTriangle.bmx"
Include "LTTopRightTriangle.bmx"
Include "LTBottomLeftTriangle.bmx"
Include "LTBottomRightTriangle.bmx"
Include "LTRaster.bmx"

Type LTShapeType Extends LTObject Abstract
	Global ShapeTypes:TList = New TList
		
	Method GetNum:Int()
	End Method
	
	Method GetName:String()
	End Method
		
	Method Singleton:Int()
		Return True
	End Method

	Method GetTileSprite:LTSprite( Sprite:LTSprite, DX:Double, DY:Double, XScale:Double, YScale:Double )
	End Method
	
	Function GetByNum:LTShapeType( Num:Int )
		For Local ShapeType:LTShapeType = Eachin ShapeTypes
			If ShapeType.GetNum() = Num Then Return ShapeType
		Next
	End Function
	
	Function Register( ShapeType:LTShapeType )
		Local Num:Int = ShapeType.GetNum()
		If GetByNum( Num ) Then L_Error( "Trying to add shape type with number which assigned to already registered shape type" )
		If Num < 0 Or Num > ShapeTypes.Count() Then L_Error( "Wrong shape type number" )
		ShapeTypes.AddLast( ShapeType )
	End Function
End Type