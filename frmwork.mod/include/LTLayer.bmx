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
about: See also #DirectTo example.
End Rem
Type LTLayer Extends LTShape
	Rem
	bbdoc: List of shapes.
	End Rem
	Field Children:TList = New TList
	
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
	
	
	
	Method GetClassTitle:String()
		Return "Layer"
	End Method
	
	' ==================== Drawing ===================	
	
	Method Draw()
		DrawUsingVisualizer( Visualizer )
	End Method
	
	
	
	Method DrawUsingVisualizer( Vis:LTVisualizer )
		If Not Visible Then Return
		
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
			For Local Shape:LTShape = Eachin Children
				Shape.Draw()
			Next
		Else
			For Local Shape:LTShape = Eachin Children
				Shape.DrawUsingVisualizer( Vis )
			Next
		End If
	End Method
	
	' ==================== Managing ===================
	
	Rem
	bbdoc: Initialization method.
	about: Every child shape will be initialized by default.
	End Rem
	Method Init()
		For Local Obj:LTShape = Eachin Children
			Obj.Init()
		Next
	End Method
	
	

	Rem
	bbdoc: Acting method.
	about: Every child shape will be acted.
	End Rem
	Method Act()
		If Active Then
			Super.Act()
			For Local Obj:LTShape = Eachin Children
				If Obj.Active Then
					?debug
					L_SpriteActed = False
					?
					
					Obj.Act()
					
					?debug
					If LTSprite( Obj ) And Not L_SpriteActed Then L_SpritesActed :+ 1
					?
				End If
			Next
		End If
	End Method
	
	' ==================== Collisions ===================
	
	Method LayerFirstSpriteCollision:LTSprite( Sprite:LTSprite )
		Return Sprite.FirstCollidedSpriteOfLayer( Self )
	End Method
	
	
	
	Method SpriteLayerCollisions( Sprite:LTSprite, Handler:LTSpriteCollisionHandler )
		Sprite.CollisionsWithLayer( Self, Handler )
	End Method
	
	

	Method TileShapeCollisionsWithSprite( Sprite:LTSprite, DX:Double, DY:Double, XScale:Double, YScale:Double, TileMap:LTTileMap, TileX:Int, TileY:Int, Handler:LTSpriteAndTileCollisionHandler )
		For Local GroupSprite:LTSprite = Eachin Children
			If GroupSprite.TileSpriteCollidesWithSprite( Sprite, DX, DY, XScale, YScale ) Then
				Handler.HandleCollision( Sprite, TileMap, TileX, TileY, GroupSprite )
				Return
			End If
		Next
	End Method	
	
	' ==================== Shape management ===================	
	
	Method InsertBeforeShape:Int( Sprite:LTSprite = Null, SpritesList:TList = Null, BeforeShape:LTShape )
		Local Link:TLink = Children.FirstLink()
		While Link <> Null
			Local Value:Object = Link.Value()
			If Value = BeforeShape Then
				If Sprite Then Children.InsertBeforeLink( Sprite, Link )
				If SpritesList Then
					For Local ListSprite:LTSprite =Eachin SpritesList
						Children.InsertBeforeLink( ListSprite, Link )
					Next
				End If
				Return True
			Else
				Local Layer:LTLayer = LTLayer( Value )
				If Layer Then
					If Layer.InsertBeforeShape( Sprite, SpritesList, BeforeShape ) Then Return True
				Else
					Local SpriteMap:LTSpriteMap = LTSpriteMap( Value )
					If SpriteMap Then
						If SpriteMap.Sprites.Contains( BeforeShape ) Then
							If Sprite Then SpriteMap.InsertSprite( Sprite )
							If SpritesList Then
								For Local ListSprite:LTSprite =Eachin SpritesList
									SpriteMap.InsertSprite( ListSprite )
								Next
							End If
							Return True
						End If
					End If
				End If
			End If
			Link = Link.NextLink()
		Wend
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
			If Value = Shape Then
				Link.Remove()
			Else
				Local Layer:LTLayer = LTLayer( Value )
				If Layer Then
					Layer.Remove( Shape )
				ElseIf Sprite Then
					Local SpriteMap:LTSpriteMap = LTSpriteMap( Value )
					If SpriteMap Then SpriteMap.RemoveSprite( Sprite )
				End If
			End If
			Link = Link.NextLink()
		Wend
	End Method
	
	
	
	Rem
	bbdoc: Removes all shapes of class with given name from layer.
	about: Included layers will be also checked.
	End Rem
	Method RemoveAllOfType( TypeName:String )
		RemoveAllOfTypeID( L_GetTypeID( TypeName ) )
	End Method 
	
	
	
	Method RemoveAllOfTypeID( TypeID:TTypeID )
		Local Link:TLink = Children.FirstLink()
		While Link <> Null
			Local Value:Object = Link.Value()
			If TTypeId.ForObject( Value ) = TypeID Then
				Link.Remove()
			Else
				Local Layer:LTLayer = LTLayer( Value )
				If Layer Then Layer.RemoveAllOfTypeID( TypeID )
			End If
			Link = Link.NextLink()
		Wend
	End Method
	
	' ==================== Other ===================	

	Method SetCoords( NewX:Double, NewY:Double )
		For Local Shape:LTShape = Eachin Children
			Shape.SetCoords( Shape.X + NewX - X, Shape.Y + NewY - Y )
		Next
		X = NewX
		Y = NewY
		Update()
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
		
	' ==================== List wrapping methods ====================
	
	Method AddFirst:TLink( Shape:LTShape )
		Return Children.AddFirst( Shape )
	End Method
	
	
	
	
	Method AddLast:TLink( Shape:LTShape )
		Return Children.AddLast( Shape )
	End Method
	
	
	
	Method Clear()
		Children.Clear()
	End Method
	
	
	
	Method ValueAtIndex:LTShape( Index:Int )
		Return LTShape( Children.ValueAtIndex( Index ) )
	End Method
	
	
	
	Method ObjectEnumerator:TListEnum()
		Return Children.ObjectEnumerator()
	End Method
	
	
	
	Method FindShapeWithParameterIDInChildShapes:LTShape( ParameterName:String, ParameterValue:String, ShapeTypeID:TTypeID )
		For Local ChildShape:LTShape = EachIn Children
			Local Shape:LTShape = ChildShape.FindShapeWithParameterID( ParameterName, ParameterValue, ShapeTypeID, True )
			If Shape Then Return Shape
		Next
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
			NewLayer.Children.AddLast( Shape.Clone() )
		Next
		Return NewLayer
	End Method
	
	' ==================== Saving / loading ===================

	Method XMLIO( XMLObject:LTXMLObject )
		Super.XMLIO( XMLObject )
		
		XMLObject.ManageChildList( Children )
		Bounds = LTShape( XMLObject.ManageObjectField( "bounds", Bounds ) )
		XMLObject.ManageIntAttribute( "mix-content", MixContent )
	End Method
End Type