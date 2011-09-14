'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Include "LTWorld.bmx"

Rem
bbdoc: Layer is the group of sprites which have bounds.
End Rem
Type LTLayer Extends LTGroup
	Rem
	bbdoc: Rectangular shape of layer bounds.
	End Rem
	Field Bounds:LTShape
	
	Rem
	bbdoc: Flag which defines if layer content should be mixed while displaying.
	about: Some conditions should be met to display mixed content correctly:
	<ul><li>Mixed content layer should contain at least one tile map.
	<li>All maps in layer should have equal tile/cell size.
	<li>All tile maps in layer should have equal corner coordinates like ( N * CellWidth, M * CellHeight ) where N and M is integer.
	<li>All tile maps in layer should have equal horizontal and vertical size in tiles.</ul>
	If this layer contains sprites or other layers they will not be drawn.
	End Rem
	Field MixContent:Int
	
	' ==================== Drawing ===================	
	
	Method Draw()
		DrawUsingVisualizer( Visualizer )
	End Method
	
	
	
	Method DrawUsingVisualizer( Vis:LTVisualizer )
		If MixContent Then
			Local Shapes:TList = New TList
			Local MainTileMap:LTTileMap
			For Local Shape:LTShape = EachIn Children
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
			If MainTileMap Then
				If Shapes.Count() = 1 Then Shapes = Null
				Vis.DrawUsingTileMap( MainTileMap, Shapes )
				Return
			End If
		End If
		
		If Vis = Visualizer Then
			Super.Draw()
		Else
			Super.DrawUsingVisualizer( Vis )
		End If
	End Method
	
	' ==================== Shape management ===================	
	
	Rem
	bbdoc: Finds shape with given name.
	returns: First found shape with given name.
	about: IgnoreError parameter should be set to True if you aren't sure is the corresponding shape inside this layer.
	End Rem
	Method FindShape:LTShape( Name:String, IgnoreError:Int = False )
		If GetName() = Name Then Return Self
		For Local ChildShape:LTShape = EachIn Children
			If ChildShape.GetName() = Name Then Return ChildShape
			Local ChildLayer:LTLayer = LTLayer( ChildShape )
			If ChildLayer Then
				Local Shape:LTShape = ChildLayer.FindShape( Name, True )
				If Shape Then Return Shape
			Else
				Local SpriteMap:LTSpriteMap = LTSpriteMap( ChildShape )
				If SpriteMap Then
					For Local Sprite:LTSprite = EachIn SpriteMap.Sprites.Keys()
						If Sprite.GetName() = Name Then Return Sprite
					Next
				End If
			End If
		Next
		If Not IgnoreError Then L_Error( "Shape ~q" + Name + "~q not found." )
		Return Null
	End Method
	
	
	
	Rem
	bbdoc: Finds shape of class with given name.
	returns: First found shape of class of class with given name.
	about: IgnoreError parameter should be set to True if you aren't sure is the corresponding shape inside this layer.
	You can specify optional Name parameter to check only shapes with this name.
	End Rem
	Method FindShapeWithType:LTShape( ShapeType:String, Name:String = "", IgnoreError:Int = False )
		Return FindShapeWithTypeID( L_GetTypeID( ShapeType ), Name, IgnoreError )
	End Method
	
	
	
	Method FindShapeWithTypeID:LTShape( ShapeTypeID:TTypeId, Name:String = "", IgnoreError:Int = False )
		If TTypeId.ForObject( Self ) = ShapeTypeID Then Return Self
		For Local ChildShape:LTShape = EachIn Children
			If TTypeId.ForObject( ChildShape ) = ShapeTypeID Then
				If Not Name Or Name = ChildShape.GetName() Then Return ChildShape
			End If
			Local ChildLayer:LTLayer = LTLayer( ChildShape )
			If ChildLayer Then
				Local Shape:LTShape = ChildLayer.FindShapeWithTypeID( ShapeTypeID, Name, True )
				If Shape Then Return Shape
			Else
				Local SpriteMap:LTSpriteMap = LTSpriteMap( ChildShape )
				If SpriteMap Then
					For Local Sprite:LTSprite = EachIn SpriteMap.Sprites.Keys()
						If TTypeId.ForObject( Sprite ) = ShapeTypeID Then Return Sprite
					Next
				End If
			End If
		Next
		If Not IgnoreError Then L_Error( "Shape with type ~q" + ShapeTypeID.Name() + "~q not found." )
		Return Null
	End Method
	
	
	
	Rem
	bbdoc: Finds shape of class with given name with parameter with given name and value.
	returns: First found layer shape of class with given name and parameter with given name and value.
	about: IgnoreError parameter should be set to True if you aren't sure is the corresponding shape inside this layer.
	End Rem
	Method FindShapeWithParameter:LTShape( ShapeType:String, ParameterName:String, ParameterValue:String, IgnoreError:Int = False )
		Return FindShapeWithParameterID( L_GetTypeID( ShapeType ), ParameterName, ParameterValue, IgnoreError )
	End Method
	
	
	
	Method FindShapeWithParameterID:LTShape( ShapeTypeID:TTypeID, ParameterName:String, ParameterValue:String, IgnoreError:Int = False )
		If TTypeId.ForObject( Self ) = ShapeTypeID Then If GetParameter( ParameterName ) = ParameterValue Then Return Self
		For Local ChildShape:LTShape = EachIn Children
			If TTypeId.ForObject( ChildShape ) = ShapeTypeID Then
				If ChildShape.GetParameter( ParameterName ) = ParameterValue Then Return ChildShape
			End If
			Local ChildLayer:LTLayer = LTLayer( ChildShape )
			If ChildLayer Then
				Local Shape:LTShape = ChildLayer.FindShapeWithParameterID( ShapeTypeID, ParameterName, ParameterValue, True )
				If Shape Then Return Shape
			Else
				Local SpriteMap:LTSpriteMap = LTSpriteMap( ChildShape )
				If SpriteMap Then
					For Local Sprite:LTSprite = EachIn SpriteMap.Sprites.Keys()
						If TTypeId.ForObject( Sprite ) = ShapeTypeID Then
							If Sprite.GetParameter( ParameterName ) = ParameterValue Then Return Sprite
						End If
					Next
				End If
			End If
		Next
		If Not IgnoreError Then L_Error( "Shape with type ~q" + ShapeTypeID.Name() + "~q and parameter " + ParameterName + " = " + ..
				ParameterValue + " not found." )
		Return Null
	End Method
	
	
	
	Rem
	bbdoc: Removes the shape from layer.
	about: Included layers and sprite maps will be also checked.
	End Rem
	Method Remove( Shape:LTShape )
		Local Sprite:LTSprite = LTSprite( Shape )
		Local Link:TLink = Children.FirstLink()
		While Link <> Null
			Local Value:Object = Link.Value()
			Local Layer:LTLayer = LTLayer( Value )
			If Layer Then
				Layer.Remove( Shape )
			ElseIf Sprite Then
				Local SpriteMap:LTSpriteMap = LTSpriteMap( Value )
				If SpriteMap Then SpriteMap.RemoveSprite( Sprite )
			End If
			If Value = Shape Then Link.Remove()
			Link = Link.NextLink()
		Wend
	End Method
	
	' ==================== Other ===================	
	
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

	
	
	Rem
	bbdoc: Counts quantity of sprites inside the layer.
	returns: Quantity of sprites inside layer and included layers.
	about: 
	End Rem
	Method CountSprites:Int()
		Local Count:Int = 0
		For Local Shape:LTShape = EachIn Children
			If LTSprite( Shape ) Then
				Count :+ 1
			ElseIf LTLayer( Shape ) Then
				Count :+ LTLayer( Shape ).CountSprites()
			End If
		Next
		Return Count
	End Method
	
	
	
	Rem
	bbdoc: Shows all behavior models attached to shape with their status.
	End Rem
	Method ShowModels:Int( Y:Int = 0, Shift:String = "" )
		If BehaviorModels.IsEmpty() Then 
			If Children.IsEmpty() Then Return Y
			DrawText( Shift + GetTitle() + ":", 0, Y )
	    	Y :+ 16
		Else
			Y = Super.ShowModels( Y, Shift )
		End If
		For Local Shape:LTShape = Eachin Children
			Y = Shape.ShowModels( Y, Shift + " " )
		Next
		Return Y
	End Method
	
	' ==================== Cloning ===================	
	
	Method CopyTo( Shape:LTShape )
		Super.CopyTo( Shape )
		Local Layer:LTLayer = LTLayer( Shape )
		
		?debug
		If Not Layer Then L_Error( "Trying to copy layer ~q" + Shape.GetName() + "~q data to non-layer" )
		?
		
		If Bounds Then
			Layer.Bounds = New LTShape
			Bounds.CopyTo( Layer.Bounds )
		End If
		Layer.MixContent = MixContent
	End Method
	

	
	Method Clone:LTShape()
		Local NewLayer:LTLayer = New LTLayer
		CopyTo( NewLayer )
		For Local Shape:LTShape = Eachin Children
			NewLayer.Children.AddLast( Shape )
		Next
		Return NewLayer
	End Method
	
	' ==================== Saving / loading ===================

	Method XMLIO( XMLObject:LTXMLObject )
		Super.XMLIO( XMLObject )
		
		Bounds = LTShape( XMLObject.ManageObjectField( "bounds", Bounds ) )
		XMLObject.ManageIntAttribute( "mix-content", MixContent )
	End Method
End Type