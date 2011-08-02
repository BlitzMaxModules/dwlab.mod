'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Rem
bbdoc: Layer is the group of sprites which have bounds.
End Rem
Type LTLayer Extends LTGroup
	Rem
	bbdoc: Rectangular shape of layer bounds.
	End Rem
	Field Bounds:LTShape
	
	
	
	Method Draw()
		If L_CurrentCamera.Isometric Then
			Local Shapes:TList = New TList
			Local MainTileMap:LTTileMap
			For Local Shape:LTShape = Eachin Children
				Local TileMap:LTTileMap = LTTileMap( Shape )
				If TileMap Then
					If TileMap.TileSet.Image Then
						MainTileMap = LTTileMap( Shape )
						Shapes.AddLast( Shape )
					End If
				ElseIf LTSpriteMap( Shape ) Then
					Shapes.AddLast( Shape )
				End If
			Next
			Visualizer.DrawUsingTileMap( MainTileMap, Shapes )
		Else
			Super.Draw()
		End If
	End Method
	
	
	
	Rem
	bbdoc: Counts quantity of sprites inside the layer.
	returns: Quantity of sprites inside layer and included layers.
	about: 
	End Rem
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
	
	
	
	Rem
	bbdoc: Finds shape with given name.
	returns: First found layer shape with given name.
	about: IgnoreError parameter should be set to True if you aren't sure is the corresponding shape inside this layer.
	End Rem
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
	
	
	
	Rem
	bbdoc: Finds shape of class with given name.
	returns: First found layer shape of class with given name.
	about: IgnoreError parameter should be set to True if you aren't sure is the corresponding shape inside this layer.
	End Rem
	Method FindShapeWithType:LTShape( ShapeType:String, Name:String = "", IgnoreError:Int = False )
		Return FindShapeWithTypeID( L_GetTypeID( ShapeType ), Name, IgnoreError )
	End Method
	
	
	
	Method FindShapeWithTypeID:LTShape( ShapeTypeID:TTypeID, Name:String = "", IgnoreError:Int = False )
		If TTypeID.ForObject( Self ) = ShapeTypeID Then Return Self
		For Local ChildShape:LTShape = Eachin Children
			If TTypeID.ForObject( ChildShape ) = ShapeTypeID Then
				If Not Name Or Name = ChildShape.Name Then Return ChildShape
			End If
			Local ChildLayer:LTLayer = LTLayer( ChildShape )
			If ChildLayer Then
				Local Shape:LTShape = ChildLayer.FindShapeWithTypeID( ShapeTypeID, Name, True )
				If Shape Then Return Shape
			End If
		Next
		If Not IgnoreError Then L_Error( "Shape with type ~q" + ShapeTypeID.Name() + "~q not found." )
		Return Null
	End Method
	
	
	
	Rem
	bbdoc: Removes the shape from layer.
	about: Included layers will be also checked.
	End Rem
	Method Remove( Shape:LTShape )
		Local Link:TLink = Children.FirstLink()
		While Link <> Null
			If LTLayer( Link.Value() ) Then LTLayer( Link.Value() ).Remove( Shape )
			If Link.Value() = Shape Then Link.Remove()
			Link = Link.NextLink()
		Wend
	End Method
	
	
	
	Rem
	bbdoc: Sets the bounds of layer to given shape.
	End Rem
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
