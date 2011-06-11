'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type LTLayer Extends LTGroup
	Field Bounds:LTShape
	
	
	
	Method CountSprites:Int()
		Local Count:Int = 0
		For Local Shape:LTShape = Eachin Children
			If LTSprite( Shape ) Then
				Count :+ 1
			ElseIf LTLayer( Shape ) Then
				Count :+ LTLayer( Shape ).CountSprites()
			End If
		Next
		Return Count
	End Method
	
	
	
	Method FindShape:LTShape( ShapeName:String, IgnoreError:Int = False )
		If Name = ShapeName Then Return Self
		For Local ChildShape:LTShape = Eachin Children
			If ChildShape.Name = ShapeName Then Return ChildShape
			Local ChildLayer:LTLayer = LTLayer( ChildShape )
			If ChildLayer Then
				Local Shape:LTShape = ChildLayer.FindShape( ShapeName, True )
				If Shape Then Return Shape
			End If
		Next
		If Not IgnoreError Then L_Error( "Shape ~q" + ShapeName + "~q not found." )
		Return Null
	End Method
	
	
	
	Method FindShapeWithType:LTShape( ShapeType:String, IgnoreError:Int = False )
		Return FindShapeWithTypeID( L_GetTypeID( ShapeType ), IgnoreError )
	End Method
	
	
	
	Method FindShapeWithTypeID:LTShape( ShapeTypeID:TTypeID, IgnoreError:Int = False )
		If TTypeID.ForObject( Self ) = ShapeTypeID Then Return Self
		For Local ChildShape:LTShape = Eachin Children
			If TTypeID.ForObject( ChildShape ) = ShapeTypeID Then Return ChildShape
			Local ChildLayer:LTLayer = LTLayer( ChildShape )
			If ChildLayer Then
				Local Shape:LTShape = ChildLayer.FindShapeWithTypeID( ShapeTypeID, True )
				If Shape Then Return Shape
			End If
		Next
		If Not IgnoreError Then L_Error( "Shape width type ~q" + ShapeTypeID.Name() + "~q not found." )
		Return Null
	End Method
	
	
	
	Method Remove( Shape:LTShape )
		Local Link:TLink = Children.FirstLink()
		While Link <> Null
			If LTLayer( Link.Value() ) Then LTLayer( Link.Value() ).Remove( Shape )
			If Link.Value() = Shape Then Link.Remove()
			Link = Link.NextLink()
		Wend
	End Method
	
	
	
	Method SetBounds( Shape:LTShape )
		If Not Bounds Then
			Bounds = New LTShape
			Bounds.Visualizer = Null
		End If
		Bounds.X = Shape.X
		Bounds.Y = Shape.Y
		Bounds.Width = Shape.Width
		Bounds.Height = Shape.Height
	End Method
	
	
	
	Method CopyTo( Shape:LTShape )
		Super.CopyTo( Shape )
		Local Layer:LTLayer = LTLayer( Shape )
		
		?debug
		If Not Layer Then L_Error( "Trying to copy layer ~q" + Shape.Name + "~q data to non-layer" )
		?
		
		If Bounds Then
			Layer.Bounds = New LTShape
			Bounds.CopyTo( Layer.Bounds )
		End If
	End Method
	
	
	
	Method XMLIO( XMLObject:LTXMLObject )
		Super.XMLIO( XMLObject )
		
		Bounds = LTShape( XMLObject.ManageObjectField( "bounds", Bounds ) )
	End Method
End Type
