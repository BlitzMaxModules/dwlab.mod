import brl.blitz
import brl.random
import brl.reflection
import brl.retro
import brl.max2d
import brl.audio
L_Version$=$"0.12.4"
LTObject^brl.blitz.Object{
.Name$&
-New%()="_dwlab_frmwork_LTObject_New"
-Delete%()="_dwlab_frmwork_LTObject_Delete"
-GetNamePart$(Num%=1)="_dwlab_frmwork_LTObject_GetNamePart"
-XMLIO%(XMLObject:LTXMLObject)="_dwlab_frmwork_LTObject_XMLIO"
-SaveToFile%(FileName$)="_dwlab_frmwork_LTObject_SaveToFile"
}="dwlab_frmwork_LTObject"
L_LoadFromFile:LTObject(FileName$)="dwlab_frmwork_L_LoadFromFile"
LTProject^LTObject{
.LogicFPS#&
.MinFPS#&
.FPS%&
.Pass%&
.Time#&
-New%()="_dwlab_frmwork_LTProject_New"
-Delete%()="_dwlab_frmwork_LTProject_Delete"
-Init%()="_dwlab_frmwork_LTProject_Init"
-Render%()="_dwlab_frmwork_LTProject_Render"
-Logic%()="_dwlab_frmwork_LTProject_Logic"
-LoadLayer:LTLayer(Layer:LTLayer)="_dwlab_frmwork_LTProject_LoadLayer"
-Execute%()="_dwlab_frmwork_LTProject_Execute"
-PerSecond#(Value#)="_dwlab_frmwork_LTProject_PerSecond"
-ShowDebugInfo%(MainLayer:LTLayer)="_dwlab_frmwork_LTProject_ShowDebugInfo"
}="dwlab_frmwork_LTProject"
L_Red%=0
L_Green%=1
L_Blue%=2
L_Alpha%=3
L_RGB%=4
L_Overwrite%=0
L_Add%=1
L_Multiply%=2
L_Max%=3
L_Min%=4
LTFloatMap^LTMap{
CircleBound#=0.707107#
.Value#&[,]&
-New%()="_dwlab_frmwork_LTFloatMap_New"
-Delete%()="_dwlab_frmwork_LTFloatMap_Delete"
-SetResolution%(NewXQuantity%,NewYQuantity%)="_dwlab_frmwork_LTFloatMap_SetResolution"
-ToNewImage:LTImage(Channel%=4)="_dwlab_frmwork_LTFloatMap_ToNewImage"
-ToNewPixmap:brl.pixmap.TPixmap(Channel%=4)="_dwlab_frmwork_LTFloatMap_ToNewPixmap"
-ToImage%(Image:LTImage,XShift%=0,YShift%=0,Frame%=0,Channel%=4)="_dwlab_frmwork_LTFloatMap_ToImage"
-ToPixmap:brl.pixmap.TPixmap(Pixmap:brl.pixmap.TPixmap,XShift%=0,YShift%=0,Channel%=4)="_dwlab_frmwork_LTFloatMap_ToPixmap"
-Paste%(SourceMap:LTFloatMap,X%,Y%,Mode%=0)="_dwlab_frmwork_LTFloatMap_Paste"
-ExtractTo%(TileMap:LTIntMap,VFrom#,VTo#,TileNum%)="_dwlab_frmwork_LTFloatMap_ExtractTo"
-Blur%()="_dwlab_frmwork_LTFloatMap_Blur"
-PerlinNoise%(StartingXFrequency%,StartingYFrequency#,StartingAmplitude#,DAmplitude#,LayersQuantity%)="_dwlab_frmwork_LTFloatMap_PerlinNoise"
-DrawCircle%(XCenter#,YCenter#,Radius#,Color#=1#)="_dwlab_frmwork_LTFloatMap_DrawCircle"
-Limit%()="_dwlab_frmwork_LTFloatMap_Limit"
}="dwlab_frmwork_LTFloatMap"
LTTileset^LTObject{
.Categories:brl.linkedlist.TList&
.TilesQuantity%&
.TileCategory%&[]&
.BlockWidth%&[]&
.BlockHeight%&[]&
-New%()="_dwlab_frmwork_LTTileset_New"
-Delete%()="_dwlab_frmwork_LTTileset_Delete"
-Init%()="_dwlab_frmwork_LTTileset_Init"
-Enframe%(TileMap:LTTileMap,X%,Y%)="_dwlab_frmwork_LTTileset_Enframe"
-GetTileCategory%(TileMap:LTTileMap,X%,Y%)="_dwlab_frmwork_LTTileset_GetTileCategory"
-XMLIO%(XMLObject:LTXMLObject)="_dwlab_frmwork_LTTileset_XMLIO"
}="dwlab_frmwork_LTTileset"
LTTileCategory^LTObject{
.Num%&
.TileRules:brl.linkedlist.TList&
-New%()="_dwlab_frmwork_LTTileCategory_New"
-Delete%()="_dwlab_frmwork_LTTileCategory_Delete"
-XMLIO%(XMLObject:LTXMLObject)="_dwlab_frmwork_LTTileCategory_XMLIO"
}="dwlab_frmwork_LTTileCategory"
LTTileRule^LTObject{
.TileNums%&[]&
.TilePositions:brl.linkedlist.TList&
.X%&
.Y%&
.XDivider%&
.YDivider%&
-New%()="_dwlab_frmwork_LTTileRule_New"
-Delete%()="_dwlab_frmwork_LTTileRule_Delete"
-TilesQuantity%()="_dwlab_frmwork_LTTileRule_TilesQuantity"
-XMLIO%(XMLObject:LTXMLObject)="_dwlab_frmwork_LTTileRule_XMLIO"
}="dwlab_frmwork_LTTileRule"
LTTilePos^LTObject{
.DX%&
.DY%&
.TileNum%&
.Category%&
-New%()="_dwlab_frmwork_LTTilePos_New"
-Delete%()="_dwlab_frmwork_LTTilePos_Delete"
-XMLIO%(XMLObject:LTXMLObject)="_dwlab_frmwork_LTTilePos_XMLIO"
}="dwlab_frmwork_LTTilePos"
LTIntMap^LTMap{
.Value%&[,]&
-New%()="_dwlab_frmwork_LTIntMap_New"
-Delete%()="_dwlab_frmwork_LTIntMap_Delete"
-SetResolution%(NewXQuantity%,NewYQuantity%)="_dwlab_frmwork_LTIntMap_SetResolution"
+FromFile:LTIntMap(Filename$)="_dwlab_frmwork_LTIntMap_FromFile"
-Stretch:LTIntMap(XMultiplier%,YMultiplier%)="_dwlab_frmwork_LTIntMap_Stretch"
-EnframeBy%(Tileset:LTTileset)="_dwlab_frmwork_LTIntMap_EnframeBy"
-XMLIO%(XMLObject:LTXMLObject)="_dwlab_frmwork_LTIntMap_XMLIO"
}="dwlab_frmwork_LTIntMap"
LTCollisionMap^LTMap{
.Sprites:brl.linkedlist.TList&[,]&
.XScale#&
.YScale#&
-New%()="_dwlab_frmwork_LTCollisionMap_New"
-Delete%()="_dwlab_frmwork_LTCollisionMap_Delete"
-SetResolution%(NewXQuantity%,NewYQuantity%)="_dwlab_frmwork_LTCollisionMap_SetResolution"
-SetMapScale%(NewXScale#,NewYScale#)="_dwlab_frmwork_LTCollisionMap_SetMapScale"
-InsertSprite%(Sprite:LTSprite,ChangeCollisionMapField%=1)="_dwlab_frmwork_LTCollisionMap_InsertSprite"
-RemoveSprite%(Sprite:LTSprite,ChangeCollisionMapField%=1)="_dwlab_frmwork_LTCollisionMap_RemoveSprite"
+Create:LTCollisionMap(XQuantity%,YQuantity%)="_dwlab_frmwork_LTCollisionMap_Create"
}="dwlab_frmwork_LTCollisionMap"
LTMap^LTObject{
.XQuantity%&
.YQuantity%&
.XMask%&
.YMask%&
.Masked%&
-New%()="_dwlab_frmwork_LTMap_New"
-Delete%()="_dwlab_frmwork_LTMap_Delete"
-SetResolution%(NewXQuantity%,NewYQuantity%)="_dwlab_frmwork_LTMap_SetResolution"
-WrapX%(Value%)="_dwlab_frmwork_LTMap_WrapX"
-WrapY%(Value%)="_dwlab_frmwork_LTMap_WrapY"
-Stretch:LTMap(XMultiplier%,YMultiplier%)="_dwlab_frmwork_LTMap_Stretch"
-XMLIO%(XMLObject:LTXMLObject)="_dwlab_frmwork_LTMap_XMLIO"
}="dwlab_frmwork_LTMap"
LTWorld^LTLayer{
-New%()="_dwlab_frmwork_LTWorld_New"
-Delete%()="_dwlab_frmwork_LTWorld_Delete"
+FromFile:LTWorld(Filename$)="_dwlab_frmwork_LTWorld_FromFile"
}="dwlab_frmwork_LTWorld"
LTLayer^LTGroup{
.Bounds:LTShape&
-New%()="_dwlab_frmwork_LTLayer_New"
-Delete%()="_dwlab_frmwork_LTLayer_Delete"
-FindTilemap:LTTileMap()="_dwlab_frmwork_LTLayer_FindTilemap"
-CountSprites%()="_dwlab_frmwork_LTLayer_CountSprites"
-FindShape:LTShape(ShapeName$)="_dwlab_frmwork_LTLayer_FindShape"
-Remove%(Shape:LTShape)="_dwlab_frmwork_LTLayer_Remove"
-XMLIO%(XMLObject:LTXMLObject)="_dwlab_frmwork_LTLayer_XMLIO"
}="dwlab_frmwork_LTLayer"
LTGroup^LTSprite{
.Children:brl.linkedlist.TList&
-New%()="_dwlab_frmwork_LTGroup_New"
-Delete%()="_dwlab_frmwork_LTGroup_Delete"
-Draw%()="_dwlab_frmwork_LTGroup_Draw"
-DrawUsingVisualizer%(Vis:LTVisualizer)="_dwlab_frmwork_LTGroup_DrawUsingVisualizer"
-Act%()="_dwlab_frmwork_LTGroup_Act"
-SpriteGroupCollisions%(Sprite:LTSprite,CollisionType%)="_dwlab_frmwork_LTGroup_SpriteGroupCollisions"
-AddLast:brl.linkedlist.TLink(Shape:LTShape)="_dwlab_frmwork_LTGroup_AddLast"
-Remove%(Shape:LTShape)="_dwlab_frmwork_LTGroup_Remove"
-Clear%()="_dwlab_frmwork_LTGroup_Clear"
-ValueAtIndex:LTShape(Index%)="_dwlab_frmwork_LTGroup_ValueAtIndex"
-ObjectEnumerator:brl.linkedlist.TListEnum()="_dwlab_frmwork_LTGroup_ObjectEnumerator"
-Update%()="_dwlab_frmwork_LTGroup_Update"
-XMLIO%(XMLObject:LTXMLObject)="_dwlab_frmwork_LTGroup_XMLIO"
}="dwlab_frmwork_LTGroup"
LTAngularSprite^LTSprite{
.Angle#&
.Velocity#&
-New%()="_dwlab_frmwork_LTAngularSprite_New"
-Delete%()="_dwlab_frmwork_LTAngularSprite_Delete"
-MoveTowards%(Shape:LTShape)="_dwlab_frmwork_LTAngularSprite_MoveTowards"
-MoveForward%()="_dwlab_frmwork_LTAngularSprite_MoveForward"
-MoveUsingWSAD%()="_dwlab_frmwork_LTAngularSprite_MoveUsingWSAD"
-MoveUsingArrows%()="_dwlab_frmwork_LTAngularSprite_MoveUsingArrows"
-MoveUsingKeys%(KUp%,KDown%,KLeft%,KRight%)="_dwlab_frmwork_LTAngularSprite_MoveUsingKeys"
-DirectAs%(Sprite:LTAngularSprite)="_dwlab_frmwork_LTAngularSprite_DirectAs"
-Turn%(TurningSpeed#)="_dwlab_frmwork_LTAngularSprite_Turn"
-DirectTo%(Shape:LTShape)="_dwlab_frmwork_LTAngularSprite_DirectTo"
-Clone:LTShape()="_dwlab_frmwork_LTAngularSprite_Clone"
-CopyTo%(Shape:LTShape)="_dwlab_frmwork_LTAngularSprite_CopyTo"
-XMLIO%(XMLObject:LTXMLObject)="_dwlab_frmwork_LTAngularSprite_XMLIO"
}="dwlab_frmwork_LTAngularSprite"
LTVectorSprite^LTSprite{
.DX#&
.DY#&
-New%()="_dwlab_frmwork_LTVectorSprite_New"
-Delete%()="_dwlab_frmwork_LTVectorSprite_Delete"
-MoveForward%()="_dwlab_frmwork_LTVectorSprite_MoveForward"
-Clone:LTShape()="_dwlab_frmwork_LTVectorSprite_Clone"
-CopyTo%(Shape:LTShape)="_dwlab_frmwork_LTVectorSprite_CopyTo"
-XMLIO%(XMLObject:LTXMLObject)="_dwlab_frmwork_LTVectorSprite_XMLIO"
}="dwlab_frmwork_LTVectorSprite"
LTCamera^LTSprite{
.Viewport:LTShape&
.XK#&
.YK#&
.DX#&
.DY#&
.ViewportClipping%&
-New%()="_dwlab_frmwork_LTCamera_New"
-Delete%()="_dwlab_frmwork_LTCamera_Delete"
-ScreenToField%(ScreenX#,ScreenY#,FieldX# Var,FieldY# Var)="_dwlab_frmwork_LTCamera_ScreenToField"
-SizeScreenToField%(ScreenWidth#,ScreenHeight#,FieldWidth# Var,FieldHeight# Var)="_dwlab_frmwork_LTCamera_SizeScreenToField"
-DistScreenToField#(ScreenDist#)="_dwlab_frmwork_LTCamera_DistScreenToField"
-FieldToScreen%(FieldX#,FieldY#,ScreenX# Var,ScreenY# Var)="_dwlab_frmwork_LTCamera_FieldToScreen"
-SizeFieldToScreen%(FieldWidth#,FieldHeight#,ScreenWidth# Var,ScreenHeight# Var)="_dwlab_frmwork_LTCamera_SizeFieldToScreen"
-DistFieldToScreen#(ScreenDist#)="_dwlab_frmwork_LTCamera_DistFieldToScreen"
-SetCameraViewport%()="_dwlab_frmwork_LTCamera_SetCameraViewport"
-ResetViewport%()="_dwlab_frmwork_LTCamera_ResetViewport"
-SetMagnification%(NewXK#,NewYK#)="_dwlab_frmwork_LTCamera_SetMagnification"
-ShiftCameraToPoint%(NewX#,NewY#)="_dwlab_frmwork_LTCamera_ShiftCameraToPoint"
-AlterCameraMagnification%(NewXK#,NewYK#)="_dwlab_frmwork_LTCamera_AlterCameraMagnification"
-Update%()="_dwlab_frmwork_LTCamera_Update"
+Create:LTCamera(Width#,Height#,UnitSize#)="_dwlab_frmwork_LTCamera_Create"
}="dwlab_frmwork_LTCamera"
InitGraphics%(Width%=800,Height%=600,UnitSize#=32#)="dwlab_frmwork_InitGraphics"
SetGraphicsParameters%()="dwlab_frmwork_SetGraphicsParameters"
L_Inaccuracy#=1e-006#
L_PivotWithPivot%(Pivot1X#,Pivot1Y#,Pivot2X#,Pivot2Y#)="dwlab_frmwork_L_PivotWithPivot"
L_PivotWithCircle%(PivotX#,PivotY#,CircleX#,CircleY#,CircleDiameter#)="dwlab_frmwork_L_PivotWithCircle"
L_PivotWithRectangle%(PivotX#,PivotY#,RectangleX#,RectangleY#,RectangleWidth#,RectangleHeight#)="dwlab_frmwork_L_PivotWithRectangle"
L_CircleWithCircle%(Circle1X#,Circle1Y#,Circle1Diameter#,Circle2X#,Circle2Y#,Circle2Diameter#)="dwlab_frmwork_L_CircleWithCircle"
L_CircleWithRectangle%(CircleX#,CircleY#,CircleDiameter#,RectangleX#,RectangleY#,RectangleWidth#,RectangleHeight#)="dwlab_frmwork_L_CircleWithRectangle"
L_RectangleWithRectangle%(Rectangle1X#,Rectangle1Y#,Rectangle1Width#,Rectangle1Height#,Rectangle2X#,Rectangle2Y#,Rectangle2Width#,Rectangle2Height#)="dwlab_frmwork_L_RectangleWithRectangle"
L_CircleWithLine%(CircleX#,CircleY#,CircleDiameter#,LineX1#,LineY1#,LineX2#,LineY2#)="dwlab_frmwork_L_CircleWithLine"
L_CircleOverlapsCircle%(Circle1X#,Circle1Y#,Circle1Diameter#,Circle2X#,Circle2Y#,Circle2Diameter#)="dwlab_frmwork_L_CircleOverlapsCircle"
L_RectangleOverlapsRectangle%(Rectangle1X#,Rectangle1Y#,Rectangle1Width#,Rectangle1Height#,Rectangle2X#,Rectangle2Y#,Rectangle2Width#,Rectangle2Height#)="dwlab_frmwork_L_RectangleOverlapsRectangle"
LTFixedJoint^LTJoint{
.ParentPivot:LTAngularSprite&
.Pivot:LTAngularSprite&
.Angle#&
.Distance#&
.DAngle#&
-New%()="_dwlab_frmwork_LTFixedJoint_New"
-Delete%()="_dwlab_frmwork_LTFixedJoint_Delete"
+Create:LTFixedJoint(ParentPivot:LTAngularSprite,Pivot:LTAngularSprite)="_dwlab_frmwork_LTFixedJoint_Create"
-Operate%()="_dwlab_frmwork_LTFixedJoint_Operate"
}="dwlab_frmwork_LTFixedJoint"
LTRevoluteJoint^LTJoint{
.ParentPivot:LTAngularSprite&
.Pivot:LTSprite&
.Angle#&
.Distance#&
-New%()="_dwlab_frmwork_LTRevoluteJoint_New"
-Delete%()="_dwlab_frmwork_LTRevoluteJoint_Delete"
+Create:LTRevoluteJoint(ParentPivot:LTAngularSprite,Pivot:LTAngularSprite)="_dwlab_frmwork_LTRevoluteJoint_Create"
-Operate%()="_dwlab_frmwork_LTRevoluteJoint_Operate"
}="dwlab_frmwork_LTRevoluteJoint"
L_SetJointList%(List:brl.linkedlist.TList="bbNullObject")="dwlab_frmwork_L_SetJointList"
L_OperateJoints%(List:brl.linkedlist.TList)="dwlab_frmwork_L_OperateJoints"
LTJoint^LTObject{
-New%()="_dwlab_frmwork_LTJoint_New"
-Delete%()="_dwlab_frmwork_LTJoint_Delete"
-Operate%()="_dwlab_frmwork_LTJoint_Operate"
}="dwlab_frmwork_LTJoint"
L_WedgingValuesOfCircleAndCircle%(Circle1X#,Circle1Y#,Circle1Diameter#,Circle2X#,Circle2Y#,Circle2Diameter#,DX# Var,DY# Var)="dwlab_frmwork_L_WedgingValuesOfCircleAndCircle"
L_WedgingValuesOfCircleAndRectangle%(CircleX#,CircleY#,CircleDiameter#,RectangleX#,RectangleY#,RectangleWidth#,RectangleHeight#,DX# Var,DY# Var)="dwlab_frmwork_L_WedgingValuesOfCircleAndRectangle"
L_WedgingValuesOfRectangleAndRectangle%(Rectangle1X#,Rectangle1Y#,Rectangle1Width#,Rectangle1Height#,Rectangle2X#,Rectangle2Y#,Rectangle2Width#,Rectangle2Height#,DX# Var,DY# Var)="dwlab_frmwork_L_WedgingValuesOfRectangleAndRectangle"
L_Separate%(Pivot1:LTSprite,Pivot2:LTSprite,DX#,DY#,Mass1#,Mass2#)="dwlab_frmwork_L_Separate"
LTSprite^LTShape{
Pivot%=0
Circle%=1
Rectangle%=2
.ShapeType%&
.Frame%&
.CollisionMap:LTCollisionMap&
-New%()="_dwlab_frmwork_LTSprite_New"
-Delete%()="_dwlab_frmwork_LTSprite_Delete"
-Draw%()="_dwlab_frmwork_LTSprite_Draw"
-DrawUsingVisualizer%(Vis:LTVisualizer)="_dwlab_frmwork_LTSprite_DrawUsingVisualizer"
-CollidesWithSprite%(Sprite:LTSprite)="_dwlab_frmwork_LTSprite_CollidesWithSprite"
-CollidesWithLine%(Line:LTLine)="_dwlab_frmwork_LTSprite_CollidesWithLine"
-TileCollidesWithSprite%(Sprite:LTSprite,DX#,DY#,XScale#,YScale#)="_dwlab_frmwork_LTSprite_TileCollidesWithSprite"
-Overlaps%(Sprite:LTSprite)="_dwlab_frmwork_LTSprite_Overlaps"
-CollisionsWithGroup%(Group:LTGroup,CollisionType%)="_dwlab_frmwork_LTSprite_CollisionsWithGroup"
-CollisionsWithSprite%(Sprite:LTSprite,CollisionType%)="_dwlab_frmwork_LTSprite_CollisionsWithSprite"
-CollisionsWithTileMap%(TileMap:LTTileMap,CollisionType%)="_dwlab_frmwork_LTSprite_CollisionsWithTileMap"
-CollisionsWithLine%(Line:LTLine,CollisionType%)="_dwlab_frmwork_LTSprite_CollisionsWithLine"
-CollisionsWithCollisionMap%(CollisionMap:LTCollisionMap,CollisionType%)="_dwlab_frmwork_LTSprite_CollisionsWithCollisionMap"
-SpriteGroupCollisions%(Sprite:LTSprite,CollisionType%)="_dwlab_frmwork_LTSprite_SpriteGroupCollisions"
-HandleCollisionWithSprite%(Sprite:LTSprite,CollisionType%)="_dwlab_frmwork_LTSprite_HandleCollisionWithSprite"
-HandleCollisionWithTile%(TileMap:LTTileMap,Shape:LTShape,TileX%,TileY%,CollisionType%)="_dwlab_frmwork_LTSprite_HandleCollisionWithTile"
-HandleCollisionWithLine%(Line:LTLine,CollisionType%)="_dwlab_frmwork_LTSprite_HandleCollisionWithLine"
-WedgeOffWithSprite%(Sprite:LTSprite,SelfMass#,SpriteMass#)="_dwlab_frmwork_LTSprite_WedgeOffWithSprite"
-PushFromSprite%(Sprite:LTSprite)="_dwlab_frmwork_LTSprite_PushFromSprite"
-PushFromTile%(TileMap:LTTileMap,TileX%,TileY%)="_dwlab_frmwork_LTSprite_PushFromTile"
-PushFromTileSprite%(TileSprite:LTSprite,DX#,DY#,XScale#,YScale#)="_dwlab_frmwork_LTSprite_PushFromTileSprite"
-SetCoords%(NewX#,NewY#)="_dwlab_frmwork_LTSprite_SetCoords"
-MoveForward%()="_dwlab_frmwork_LTSprite_MoveForward"
-SetCoordsRelativeTo%(Sprite:LTAngularSprite,NewX#,NewY#)="_dwlab_frmwork_LTSprite_SetCoordsRelativeTo"
-SetSize%(NewWidth#,NewHeight#)="_dwlab_frmwork_LTSprite_SetSize"
-SetAsTile%(TileMap:LTTileMap,TileX%,TileY%)="_dwlab_frmwork_LTSprite_SetAsTile"
-Animate%(Project:LTProject,Speed#,FramesQuantity%=0,FrameStart%=0,StartingTime#=0#,PingPong%=0)="_dwlab_frmwork_LTSprite_Animate"
-LimitByWindow%(X#,Y#,Width#,Height#)="_dwlab_frmwork_LTSprite_LimitByWindow"
-RemoveWindowLimit%()="_dwlab_frmwork_LTSprite_RemoveWindowLimit"
-AttachModel%(Model:LTBehaviorModel,Activated%=1)="_dwlab_frmwork_LTSprite_AttachModel"
-FindModel:LTBehaviorModel(TypeName$)="_dwlab_frmwork_LTSprite_FindModel"
-ActivateModel%(TypeName$)="_dwlab_frmwork_LTSprite_ActivateModel"
-DeactivateModel%(TypeName$)="_dwlab_frmwork_LTSprite_DeactivateModel"
-ToggleModel%(TypeName$)="_dwlab_frmwork_LTSprite_ToggleModel"
-RemoveModel%(TypeName$)="_dwlab_frmwork_LTSprite_RemoveModel"
-Clone:LTShape()="_dwlab_frmwork_LTSprite_Clone"
-CopyTo%(Shape:LTShape)="_dwlab_frmwork_LTSprite_CopyTo"
-Act%()="_dwlab_frmwork_LTSprite_Act"
-XMLIO%(XMLObject:LTXMLObject)="_dwlab_frmwork_LTSprite_XMLIO"
}="dwlab_frmwork_LTSprite"
LTTileMap^LTShape{
.FrameMap:LTIntMap&
.TileShape:LTShape&[]&
.TilesQuantity%&
.Wrapped%&
-New%()="_dwlab_frmwork_LTTileMap_New"
-Delete%()="_dwlab_frmwork_LTTileMap_Delete"
-GetCellWidth#()="_dwlab_frmwork_LTTileMap_GetCellWidth"
-GetCellHeight#()="_dwlab_frmwork_LTTileMap_GetCellHeight"
-GetTileTemplate:LTShape(TileX%,TileY%)="_dwlab_frmwork_LTTileMap_GetTileTemplate"
-SetResolution%(NewXQuantity%,NewYQuantity%)="_dwlab_frmwork_LTTileMap_SetResolution"
-Draw%()="_dwlab_frmwork_LTTileMap_Draw"
-DrawUsingVisualizer%(Visizer:LTVisualizer)="_dwlab_frmwork_LTTileMap_DrawUsingVisualizer"
-TileCollisionsWithSprite%(Sprite:LTSprite)="_dwlab_frmwork_LTTileMap_TileCollisionsWithSprite"
-EnframeBy%(Tileset:LTTileset)="_dwlab_frmwork_LTTileMap_EnframeBy"
-GetTile%(TileX%,TileY%)="_dwlab_frmwork_LTTileMap_GetTile"
-SetTile%(TileX%,TileY%,TileNum%)="_dwlab_frmwork_LTTileMap_SetTile"
+Create:LTTileMap(XQuantity%,YQuantity%,TileWidth%,TileHeight%,TilesQuantity%)="_dwlab_frmwork_LTTileMap_Create"
-Clone:LTShape()="_dwlab_frmwork_LTTileMap_Clone"
-CopyTo%(Shape:LTShape)="_dwlab_frmwork_LTTileMap_CopyTo"
-XMLIO%(XMLObject:LTXMLObject)="_dwlab_frmwork_LTTileMap_XMLIO"
}="dwlab_frmwork_LTTileMap"
LTLine^LTShape{
.Pivot:LTSprite&[]&
-New%()="_dwlab_frmwork_LTLine_New"
-Delete%()="_dwlab_frmwork_LTLine_Delete"
-Create:LTLine(Pivot1:LTSprite,Pivot2:LTSprite)="_dwlab_frmwork_LTLine_Create"
-Draw%()="_dwlab_frmwork_LTLine_Draw"
-DrawUsingVisualizer%(Vis:LTVisualizer)="_dwlab_frmwork_LTLine_DrawUsingVisualizer"
-SpriteGroupCollisions%(Sprite:LTSprite,CollisionType%)="_dwlab_frmwork_LTLine_SpriteGroupCollisions"
-XMLIO%(XMLObject:LTXMLObject)="_dwlab_frmwork_LTLine_XMLIO"
}="dwlab_frmwork_LTLine"
LTGraph^LTShape{
.Pivots:brl.map.TMap&
.Lines:brl.map.TMap&
-New%()="_dwlab_frmwork_LTGraph_New"
-Delete%()="_dwlab_frmwork_LTGraph_Delete"
-DrawPivotsUsing%(Visualizer:LTVisualizer)="_dwlab_frmwork_LTGraph_DrawPivotsUsing"
-DrawLinesUsing%(Visualizer:LTVisualizer)="_dwlab_frmwork_LTGraph_DrawLinesUsing"
-AddPivot:brl.linkedlist.TList(Pivot:LTSprite)="_dwlab_frmwork_LTGraph_AddPivot"
-AddLine%(Line:LTLine)="_dwlab_frmwork_LTGraph_AddLine"
-RemovePivot%(Pivot:LTSprite)="_dwlab_frmwork_LTGraph_RemovePivot"
-RemoveLine%(Line:LTLine)="_dwlab_frmwork_LTGraph_RemoveLine"
-FindPivotCollidingWith:LTSprite(Sprite:LTSprite)="_dwlab_frmwork_LTGraph_FindPivotCollidingWith"
-FindLineCollidingWith:LTLine(Sprite:LTSprite)="_dwlab_frmwork_LTGraph_FindLineCollidingWith"
-ContainsPivot%(Pivot:LTSprite)="_dwlab_frmwork_LTGraph_ContainsPivot"
-ContainsLine%(Line:LTLine)="_dwlab_frmwork_LTGraph_ContainsLine"
-FindLine:LTLine(Pivot1:LTSprite,Pivot2:LTSprite)="_dwlab_frmwork_LTGraph_FindLine"
-XMLIO%(XMLObject:LTXMLObject)="_dwlab_frmwork_LTGraph_XMLIO"
}="dwlab_frmwork_LTGraph"
LTAddPivotToGraph^LTAction{
.Graph:LTGraph&
.Pivot:LTSprite&
-New%()="_dwlab_frmwork_LTAddPivotToGraph_New"
-Delete%()="_dwlab_frmwork_LTAddPivotToGraph_Delete"
+Create:LTAddPivotToGraph(Graph:LTGraph,Pivot:LTSprite)="_dwlab_frmwork_LTAddPivotToGraph_Create"
-Do%()="_dwlab_frmwork_LTAddPivotToGraph_Do"
-Undo%()="_dwlab_frmwork_LTAddPivotToGraph_Undo"
}="dwlab_frmwork_LTAddPivotToGraph"
LTAddLineToGraph^LTAction{
.Graph:LTGraph&
.Line:LTLine&
-New%()="_dwlab_frmwork_LTAddLineToGraph_New"
-Delete%()="_dwlab_frmwork_LTAddLineToGraph_Delete"
+Create:LTAddLineToGraph(Graph:LTGraph,Line:LTLine)="_dwlab_frmwork_LTAddLineToGraph_Create"
-Do%()="_dwlab_frmwork_LTAddLineToGraph_Do"
-Undo%()="_dwlab_frmwork_LTAddLineToGraph_Undo"
}="dwlab_frmwork_LTAddLineToGraph"
LTRemovePivotFromGraph^LTAction{
.Graph:LTGraph&
.Pivot:LTSprite&
.Lines:brl.linkedlist.TList&
-New%()="_dwlab_frmwork_LTRemovePivotFromGraph_New"
-Delete%()="_dwlab_frmwork_LTRemovePivotFromGraph_Delete"
+Create:LTRemovePivotFromGraph(Graph:LTGraph,Pivot:LTSprite)="_dwlab_frmwork_LTRemovePivotFromGraph_Create"
-Do%()="_dwlab_frmwork_LTRemovePivotFromGraph_Do"
-Undo%()="_dwlab_frmwork_LTRemovePivotFromGraph_Undo"
}="dwlab_frmwork_LTRemovePivotFromGraph"
LTRemoveLineFromGraph^LTAction{
.Graph:LTGraph&
.Line:LTLine&
-New%()="_dwlab_frmwork_LTRemoveLineFromGraph_New"
-Delete%()="_dwlab_frmwork_LTRemoveLineFromGraph_Delete"
+Create:LTRemoveLineFromGraph(Graph:LTGraph,Line:LTLine)="_dwlab_frmwork_LTRemoveLineFromGraph_Create"
-Do%()="_dwlab_frmwork_LTRemoveLineFromGraph_Do"
-Undo%()="_dwlab_frmwork_LTRemoveLineFromGraph_Undo"
}="dwlab_frmwork_LTRemoveLineFromGraph"
LTShape^LTObject{
Horizontal%=0
Vertical%=1
.X#&
.Y#&
.Width#&
.Height#&
.Visualizer:LTVisualizer&
.Visible%&
.Active%&
.BehaviorModels:brl.linkedlist.TList&
-New%()="_dwlab_frmwork_LTShape_New"
-Delete%()="_dwlab_frmwork_LTShape_Delete"
-Draw%()="_dwlab_frmwork_LTShape_Draw"
-DrawUsingVisualizer%(Vis:LTVisualizer)="_dwlab_frmwork_LTShape_DrawUsingVisualizer"
-SpriteGroupCollisions%(Sprite:LTSprite,CollisionType%)="_dwlab_frmwork_LTShape_SpriteGroupCollisions"
-TileCollidesWithSprite%(Sprite:LTSprite,DX#,DY#,XScale#,YScale#)="_dwlab_frmwork_LTShape_TileCollidesWithSprite"
-LeftX#()="_dwlab_frmwork_LTShape_LeftX"
-TopY#()="_dwlab_frmwork_LTShape_TopY"
-RightX#()="_dwlab_frmwork_LTShape_RightX"
-BottomY#()="_dwlab_frmwork_LTShape_BottomY"
-DistanceToPoint#(PointX#,PointY#)="_dwlab_frmwork_LTShape_DistanceToPoint"
-DistanceTo#(Shape:LTShape)="_dwlab_frmwork_LTShape_DistanceTo"
-IsAtPositionOf%(Shape:LTShape)="_dwlab_frmwork_LTShape_IsAtPositionOf"
-SetCoords%(NewX#,NewY#)="_dwlab_frmwork_LTShape_SetCoords"
-AlterCoords%(DX#,DY#)="_dwlab_frmwork_LTShape_AlterCoords"
-SetCornerCoords%(NewX#,NewY#)="_dwlab_frmwork_LTShape_SetCornerCoords"
-JumpTo%(Shape:LTShape)="_dwlab_frmwork_LTShape_JumpTo"
-SetMouseCoords%()="_dwlab_frmwork_LTShape_SetMouseCoords"
-Move%(DX#,DY#)="_dwlab_frmwork_LTShape_Move"
-PlaceBetween%(Shape1:LTShape,Shape2:LTShape,K#)="_dwlab_frmwork_LTShape_PlaceBetween"
-LimitWith%(Rectangle:LTShape)="_dwlab_frmwork_LTShape_LimitWith"
-LimitLeftWith%(Rectangle:LTShape,UpdateFlag%=1)="_dwlab_frmwork_LTShape_LimitLeftWith"
-LimitTopWith%(Rectangle:LTShape,UpdateFlag%=1)="_dwlab_frmwork_LTShape_LimitTopWith"
-LimitRightWith%(Rectangle:LTShape,UpdateFlag%=1)="_dwlab_frmwork_LTShape_LimitRightWith"
-LimitBottomWith%(Rectangle:LTShape,UpdateFlag%=1)="_dwlab_frmwork_LTShape_LimitBottomWith"
-LimitHorizontallyWith%(Rectangle:LTShape,UpdateFlag%=1)="_dwlab_frmwork_LTShape_LimitHorizontallyWith"
-LimitVerticallyWith%(Rectangle:LTShape,UpdateFlag%=1)="_dwlab_frmwork_LTShape_LimitVerticallyWith"
-DirectionToPoint#(PointX#,PointY#)="_dwlab_frmwork_LTShape_DirectionToPoint"
-DirectionTo#(Shape:LTShape)="_dwlab_frmwork_LTShape_DirectionTo"
-SetSize%(NewWidth#,NewHeight#)="_dwlab_frmwork_LTShape_SetSize"
-SetDiameter%(NewDiameter#)="_dwlab_frmwork_LTShape_SetDiameter"
-CorrectHeight%()="_dwlab_frmwork_LTShape_CorrectHeight"
-Init%()="_dwlab_frmwork_LTShape_Init"
-CopyTo%(Shape:LTShape)="_dwlab_frmwork_LTShape_CopyTo"
-Act%()="_dwlab_frmwork_LTShape_Act"
-Update%()="_dwlab_frmwork_LTShape_Update"
-Destroy%()="_dwlab_frmwork_LTShape_Destroy"
-XMLIO%(XMLObject:LTXMLObject)="_dwlab_frmwork_LTShape_XMLIO"
}="dwlab_frmwork_LTShape"
LTMoveShape^LTAction{
.Shape:LTShape&
.OldX#&
.OldY#&
.NewX#&
.NewY#&
-New%()="_dwlab_frmwork_LTMoveShape_New"
-Delete%()="_dwlab_frmwork_LTMoveShape_Delete"
+Create:LTMoveShape(Shape:LTShape,X#=0#,Y#=0#)="_dwlab_frmwork_LTMoveShape_Create"
-Do%()="_dwlab_frmwork_LTMoveShape_Do"
-Undo%()="_dwlab_frmwork_LTMoveShape_Undo"
}="dwlab_frmwork_LTMoveShape"
LTImage^LTObject{
.BMaxImage:brl.max2d.TImage&
.Filename$&
.XCells%&
.YCells%&
-New%()="_dwlab_frmwork_LTImage_New"
-Delete%()="_dwlab_frmwork_LTImage_Delete"
+FromFile:LTImage(Filename$,XCells%=1,YCells%=1)="_dwlab_frmwork_LTImage_FromFile"
-Split%(XCells%,YCells%)="_dwlab_frmwork_LTImage_Split"
-Init%()="_dwlab_frmwork_LTImage_Init"
-SetHandle%(X#,Y#)="_dwlab_frmwork_LTImage_SetHandle"
+Create:LTImage(Width%,Height%,Frames%=1)="_dwlab_frmwork_LTImage_Create"
-CopyFrame%(Frame%,FromImage:LTImage,FromFrame%)="_dwlab_frmwork_LTImage_CopyFrame"
-FramesQuantity%()="_dwlab_frmwork_LTImage_FramesQuantity"
-Width#()="_dwlab_frmwork_LTImage_Width"
-Height#()="_dwlab_frmwork_LTImage_Height"
-XMLIO%(XMLObject:LTXMLObject)="_dwlab_frmwork_LTImage_XMLIO"
}="dwlab_frmwork_LTImage"
LTAnimatedTileMapVisualizer^LTImageVisualizer{
.TileNum%&[]&
-New%()="_dwlab_frmwork_LTAnimatedTileMapVisualizer_New"
-Delete%()="_dwlab_frmwork_LTAnimatedTileMapVisualizer_Delete"
-DrawTile%(FrameMap:LTIntMap,X#,Y#,TileX%,TileY%)="_dwlab_frmwork_LTAnimatedTileMapVisualizer_DrawTile"
}="dwlab_frmwork_LTAnimatedTileMapVisualizer"
LTImageVisualizer^LTVisualizer{
.Image:LTImage&
.DX#&
.DY#&
-New%()="_dwlab_frmwork_LTImageVisualizer_New"
-Delete%()="_dwlab_frmwork_LTImageVisualizer_Delete"
+FromFile:LTImageVisualizer(Filename$,XCells%=1,YCells%=1)="_dwlab_frmwork_LTImageVisualizer_FromFile"
+FromImage:LTImageVisualizer(Image:LTImage)="_dwlab_frmwork_LTImageVisualizer_FromImage"
-GetImage:LTImage()="_dwlab_frmwork_LTImageVisualizer_GetImage"
-SetImage%(NewImage:LTImage)="_dwlab_frmwork_LTImageVisualizer_SetImage"
-SetDXDY%(NewDX#,NewDY#)="_dwlab_frmwork_LTImageVisualizer_SetDXDY"
-DrawUsingSprite%(Sprite:LTSprite)="_dwlab_frmwork_LTImageVisualizer_DrawUsingSprite"
-DrawUsingTileMap%(TileMap:LTTileMap)="_dwlab_frmwork_LTImageVisualizer_DrawUsingTileMap"
-DrawTile%(FrameMap:LTIntMap,X#,Y#,TileX%,TileY%)="_dwlab_frmwork_LTImageVisualizer_DrawTile"
-XMLIO%(XMLObject:LTXMLObject)="_dwlab_frmwork_LTImageVisualizer_XMLIO"
}="dwlab_frmwork_LTImageVisualizer"
LTFilledPrimitive^LTVisualizer{
-New%()="_dwlab_frmwork_LTFilledPrimitive_New"
-Delete%()="_dwlab_frmwork_LTFilledPrimitive_Delete"
-DrawUsingSprite%(Sprite:LTSprite)="_dwlab_frmwork_LTFilledPrimitive_DrawUsingSprite"
-DrawUsingLine%(Line:LTLine)="_dwlab_frmwork_LTFilledPrimitive_DrawUsingLine"
}="dwlab_frmwork_LTFilledPrimitive"
LTEmptyPrimitive^LTVisualizer{
.LineWidth#&
-New%()="_dwlab_frmwork_LTEmptyPrimitive_New"
-Delete%()="_dwlab_frmwork_LTEmptyPrimitive_Delete"
-DrawUsingSprite%(Sprite:LTSprite)="_dwlab_frmwork_LTEmptyPrimitive_DrawUsingSprite"
-DrawUsingLine%(Line:LTLine)="_dwlab_frmwork_LTEmptyPrimitive_DrawUsingLine"
-SetProperLineWidth%()="_dwlab_frmwork_LTEmptyPrimitive_SetProperLineWidth"
}="dwlab_frmwork_LTEmptyPrimitive"
LTMarchingAnts^LTVisualizer{
-New%()="_dwlab_frmwork_LTMarchingAnts_New"
-Delete%()="_dwlab_frmwork_LTMarchingAnts_Delete"
-DrawUsingSprite%(Sprite:LTSprite)="_dwlab_frmwork_LTMarchingAnts_DrawUsingSprite"
+DrawMARect%(X#,Y#,Width#,Height#)="_dwlab_frmwork_LTMarchingAnts_DrawMARect"
}="dwlab_frmwork_LTMarchingAnts"
LTWindowedVisualizer^LTVisualizer{
.Viewport:LTShape&
.Visualizer:LTVisualizer&
-New%()="_dwlab_frmwork_LTWindowedVisualizer_New"
-Delete%()="_dwlab_frmwork_LTWindowedVisualizer_Delete"
-DrawUsingSprite%(Sprite:LTSprite)="_dwlab_frmwork_LTWindowedVisualizer_DrawUsingSprite"
}="dwlab_frmwork_LTWindowedVisualizer"
LTVisualizer^LTObject{
.Red#&
.Green#&
.Blue#&
.Alpha#&
.XScale#&
.YScale#&
.Scaling%&
.Angle#&
.Rotating%&
-New%()="_dwlab_frmwork_LTVisualizer_New"
-Delete%()="_dwlab_frmwork_LTVisualizer_Delete"
-SetVisualizerScale%(NewXScale#,NewYScale#)="_dwlab_frmwork_LTVisualizer_SetVisualizerScale"
-GetImage:LTImage()="_dwlab_frmwork_LTVisualizer_GetImage"
-SetImage%(NewImage:LTImage)="_dwlab_frmwork_LTVisualizer_SetImage"
-SetDXDY%(NewDX#,NewDY#)="_dwlab_frmwork_LTVisualizer_SetDXDY"
-DrawUsingSprite%(Sprite:LTSprite)="_dwlab_frmwork_LTVisualizer_DrawUsingSprite"
-DrawUsingLine%(Line:LTLine)="_dwlab_frmwork_LTVisualizer_DrawUsingLine"
-DrawUsingTileMap%(TileMap:LTTileMap)="_dwlab_frmwork_LTVisualizer_DrawUsingTileMap"
-SetColorFromHex%(S$)="_dwlab_frmwork_LTVisualizer_SetColorFromHex"
-SetColorFromRGB%(NewRed#,NewGreen#,NewBlue#)="_dwlab_frmwork_LTVisualizer_SetColorFromRGB"
-AlterColor%(D1#,D2#)="_dwlab_frmwork_LTVisualizer_AlterColor"
-ApplyColor%()="_dwlab_frmwork_LTVisualizer_ApplyColor"
-XMLIO%(XMLObject:LTXMLObject)="_dwlab_frmwork_LTVisualizer_XMLIO"
}A="dwlab_frmwork_LTVisualizer"
LTBehaviorModel^LTObject{
.Active%&
.Link:brl.linkedlist.TLink&
-New%()="_dwlab_frmwork_LTBehaviorModel_New"
-Delete%()="_dwlab_frmwork_LTBehaviorModel_Delete"
-Init%(Sprite:LTSprite)="_dwlab_frmwork_LTBehaviorModel_Init"
-Activate%(Sprite:LTSprite)="_dwlab_frmwork_LTBehaviorModel_Activate"
-Deactivate%(Sprite:LTSprite)="_dwlab_frmwork_LTBehaviorModel_Deactivate"
-ApplyTo%(Sprite:LTSprite)="_dwlab_frmwork_LTBehaviorModel_ApplyTo"
-Remove%()="_dwlab_frmwork_LTBehaviorModel_Remove"
}="dwlab_frmwork_LTBehaviorModel"
L_AlignToRight%=0
L_AlignToTop%=0
L_AlignToCenter%=1
L_AlignToLeft%=2
L_AlignToBottom%=0
L_Stretch%=3
LTFont^LTObject{
.LetterLength%&[]&
.FromNum%&
.ToNum%&
.BMaxImage:brl.max2d.TImage&
.XScale#&
.YScale#&
-New%()="_dwlab_frmwork_LTFont_New"
-Delete%()="_dwlab_frmwork_LTFont_Delete"
-SetFontScale%(NewXScale#,NewYScale#)="_dwlab_frmwork_LTFont_SetFontScale"
-Print%(Text$,X#,Y#,HorizontalAlignment%=0,VerticalAlignment%=0)="_dwlab_frmwork_LTFont_Print"
-Width%(Text$)="_dwlab_frmwork_LTFont_Width"
-Height%()="_dwlab_frmwork_LTFont_Height"
+FromFile:LTFont(FileName$,FromNum%=32,ToNum%=255,SymbolsPerRow%=16,VariableLength%=0)="_dwlab_frmwork_LTFont_FromFile"
}="dwlab_frmwork_LTFont"
LTChannelPack^LTObject{
.Channel:brl.audio.TChannel&[]&
.ChannelsQuantity%&
-New%()="_dwlab_frmwork_LTChannelPack_New"
-Delete%()="_dwlab_frmwork_LTChannelPack_Delete"
+Create:LTChannelPack(ChannelsQuantity%)="_dwlab_frmwork_LTChannelPack_Create"
-Play%(Sound:brl.audio.TSound)="_dwlab_frmwork_LTChannelPack_Play"
}="dwlab_frmwork_LTChannelPack"
LTPath^LTObject{
.Pivots:brl.linkedlist.TList&
-New%()="_dwlab_frmwork_LTPath_New"
-Delete%()="_dwlab_frmwork_LTPath_Delete"
+Find:LTPath(FromPivot:LTSprite,ToPivot:LTSprite,Graph:LTGraph)="_dwlab_frmwork_LTPath_Find"
}="dwlab_frmwork_LTPath"
LTDrag^LTObject{
.DraggingState%&
-New%()="_dwlab_frmwork_LTDrag_New"
-Delete%()="_dwlab_frmwork_LTDrag_Delete"
-DragKey%()="_dwlab_frmwork_LTDrag_DragKey"
-DraggingConditions%()="_dwlab_frmwork_LTDrag_DraggingConditions"
-StartDragging%()="_dwlab_frmwork_LTDrag_StartDragging"
-Dragging%()="_dwlab_frmwork_LTDrag_Dragging"
-EndDragging%()="_dwlab_frmwork_LTDrag_EndDragging"
-Execute%()="_dwlab_frmwork_LTDrag_Execute"
}="dwlab_frmwork_LTDrag"
LTAction^LTObject{
-New%()="_dwlab_frmwork_LTAction_New"
-Delete%()="_dwlab_frmwork_LTAction_Delete"
-Do%()="_dwlab_frmwork_LTAction_Do"
-Undo%()="_dwlab_frmwork_LTAction_Undo"
}="dwlab_frmwork_LTAction"
L_PushUndoList%()="dwlab_frmwork_L_PushUndoList"
L_Undo%()="dwlab_frmwork_L_Undo"
L_Redo%()="dwlab_frmwork_L_Redo"
L_XMLGet%=0
L_XMLSet%=1
LTXMLObject^LTObject{
.Attributes:brl.linkedlist.TList&
.Children:brl.linkedlist.TList&
.Fields:brl.linkedlist.TList&
.Closing%&
-New%()="_dwlab_frmwork_LTXMLObject_New"
-Delete%()="_dwlab_frmwork_LTXMLObject_Delete"
-GetAttribute$(AttrName$)="_dwlab_frmwork_LTXMLObject_GetAttribute"
-SetAttribute%(AttrName$,AttrValue$)="_dwlab_frmwork_LTXMLObject_SetAttribute"
-GetField:LTXMLObject(FieldName$)="_dwlab_frmwork_LTXMLObject_GetField"
-SetField:LTXMLObjectField(FieldName$,XMLObject:LTXMLObject)="_dwlab_frmwork_LTXMLObject_SetField"
-ManageIntAttribute%(AttrName$,AttrVariable% Var,DefaultValue%=0)="_dwlab_frmwork_LTXMLObject_ManageIntAttribute"
-ManageFloatAttribute%(AttrName$,AttrVariable# Var,DefaultValue#=0#)="_dwlab_frmwork_LTXMLObject_ManageFloatAttribute"
-ManageStringAttribute%(AttrName$,AttrVariable$ Var)="_dwlab_frmwork_LTXMLObject_ManageStringAttribute"
-ManageObjectAttribute:LTObject(AttrName$,Obj:LTObject)="_dwlab_frmwork_LTXMLObject_ManageObjectAttribute"
-ManageIntArrayAttribute%(AttrName$,IntArray%&[] Var)="_dwlab_frmwork_LTXMLObject_ManageIntArrayAttribute"
-ManageObjectField:LTObject(FieldName$,FieldObject:LTObject)="_dwlab_frmwork_LTXMLObject_ManageObjectField"
-ManageListField%(FieldName$,List:brl.linkedlist.TList Var)="_dwlab_frmwork_LTXMLObject_ManageListField"
-ManageObjectMapField%(FieldName$,Map:brl.map.TMap Var)="_dwlab_frmwork_LTXMLObject_ManageObjectMapField"
-ManageObjectArrayField%(FieldName$,FieldObjectsArray:LTObject&[] Var)="_dwlab_frmwork_LTXMLObject_ManageObjectArrayField"
-ManageObject:LTObject(Obj:LTObject)="_dwlab_frmwork_LTXMLObject_ManageObject"
-ManageChildList%(List:brl.linkedlist.TList Var)="_dwlab_frmwork_LTXMLObject_ManageChildList"
-ManageChildArray%(ChildArray:LTObject&[] Var)="_dwlab_frmwork_LTXMLObject_ManageChildArray"
+ReadFromFile:LTXMLObject(Filename$)="_dwlab_frmwork_LTXMLObject_ReadFromFile"
-WriteToFile%(Filename$)="_dwlab_frmwork_LTXMLObject_WriteToFile"
+ReadObject:LTXMLObject(Txt$ Var,N% Var,FieldName$ Var)="_dwlab_frmwork_LTXMLObject_ReadObject"
-WriteObject%(File:brl.stream.TStream,Indent$=$"")="_dwlab_frmwork_LTXMLObject_WriteObject"
-ReadAttributes%(Txt$ Var,N% Var,FieldName$ Var)="_dwlab_frmwork_LTXMLObject_ReadAttributes"
+IDSym%(Sym%)="_dwlab_frmwork_LTXMLObject_IDSym"
}="dwlab_frmwork_LTXMLObject"
LTXMLAttribute^brl.blitz.Object{
.Name$&
.Value$&
-New%()="_dwlab_frmwork_LTXMLAttribute_New"
-Delete%()="_dwlab_frmwork_LTXMLAttribute_Delete"
}="dwlab_frmwork_LTXMLAttribute"
LTXMLObjectField^brl.blitz.Object{
.Name$&
.Value:LTXMLObject&
-New%()="_dwlab_frmwork_LTXMLObjectField_New"
-Delete%()="_dwlab_frmwork_LTXMLObjectField_Delete"
}="dwlab_frmwork_LTXMLObjectField"
L_HexToInt%(HexString$)="dwlab_frmwork_L_HexToInt"
L_DrawEmptyRect%(X1#,Y1#,X2#,Y2#)="dwlab_frmwork_L_DrawEmptyRect"
L_DeleteList%(List:brl.linkedlist.TList)="dwlab_frmwork_L_DeleteList"
L_TrimFloat$(Val#)="dwlab_frmwork_L_TrimFloat"
L_FirstZeroes$(Value%,TotalSymbols%)="dwlab_frmwork_L_FirstZeroes"
L_Symbols$(Symbol$,Times%)="dwlab_frmwork_L_Symbols"
L_LimitFloat#(Value#,FromValue#,ToValue#)="dwlab_frmwork_L_LimitFloat"
L_LimitInt%(Value%,FromValue%,ToValue%)="dwlab_frmwork_L_LimitInt"
L_IsPowerOf2%(Value%)="dwlab_frmwork_L_IsPowerOf2"
L_WrapInt%(Value%,Size%)="dwlab_frmwork_L_WrapInt"
L_WrapInt2%(Value%,FromValue%,ToValue%)="dwlab_frmwork_L_WrapInt2"
L_WrapFloat#(Value#,Size#)="dwlab_frmwork_L_WrapFloat"
L_TryExtensions$(Filename$,Extensions$&[])="dwlab_frmwork_L_TryExtensions"
L_ClearPixmap%(Pixmap:brl.pixmap.TPixmap,Red#=0#,Green#=0#,Blue#=0#,Alpha#=1#)="dwlab_frmwork_L_ClearPixmap"
L_Round#(Value#)="dwlab_frmwork_L_Round"
L_Distance#(DX#,DY#)="dwlab_frmwork_L_Distance"
ChopFilename$(Filename$)="dwlab_frmwork_ChopFilename"
L_AddItemToIntArray%(Array%&[] Var,Item%)="dwlab_frmwork_L_AddItemToIntArray"
L_RemoveItemFromIntArray%(Array%&[] Var,Index%)="dwlab_frmwork_L_RemoveItemFromIntArray"
L_IntInLimits%(Value%,FromValue%,ToValue%)="dwlab_frmwork_L_IntInLimits"
L_GetTypeID:brl.reflection.TTypeId(TypeName$)="dwlab_frmwork_L_GetTypeID"
L_Error%(Text$)="dwlab_frmwork_L_Error"
L_IDMap:brl.map.TMap&=mem:p("dwlab_frmwork_L_IDMap")
L_RemoveIDMap:brl.map.TMap&=mem:p("dwlab_frmwork_L_RemoveIDMap")
L_DefinitionsMap:brl.map.TMap&=mem:p("dwlab_frmwork_L_DefinitionsMap")
L_Definitions:LTXMLObject&=mem:p("dwlab_frmwork_L_Definitions")
L_IDNum%&=mem("dwlab_frmwork_L_IDNum")
L_IDArray:LTObject&[]&=mem:p("dwlab_frmwork_L_IDArray")
LayerName$&=mem:p("dwlab_frmwork_LayerName")
L_CollisionChecks%&=mem("dwlab_frmwork_L_CollisionChecks")
L_DeltaTime#&=mem:f("dwlab_frmwork_L_DeltaTime")
L_ProlongTiles%&=mem("dwlab_frmwork_L_ProlongTiles")
L_CurrentCamera:LTCamera&=mem:p("dwlab_frmwork_L_CurrentCamera")
L_CameraSpeed#&=mem:f("dwlab_frmwork_L_CameraSpeed")
L_CameraMagnificationSpeed#&=mem:f("dwlab_frmwork_L_CameraMagnificationSpeed")
L_DefaultJointList:brl.linkedlist.TList&=mem:p("dwlab_frmwork_L_DefaultJointList")
L_JointList:brl.linkedlist.TList&=mem:p("dwlab_frmwork_L_JointList")
L_LoadImages%&=mem("dwlab_frmwork_L_LoadImages")
L_EmptyTilemapFrame%&=mem("dwlab_frmwork_L_EmptyTilemapFrame")
L_DefaultVisualizer:LTFilledPrimitive&=mem:p("dwlab_frmwork_L_DefaultVisualizer")
L_UndoStack:brl.linkedlist.TList&=mem:p("dwlab_frmwork_L_UndoStack")
L_CurrentUndoList:brl.linkedlist.TList&=mem:p("dwlab_frmwork_L_CurrentUndoList")
L_RedoStack:brl.linkedlist.TList&=mem:p("dwlab_frmwork_L_RedoStack")
L_CurrentRedoList:brl.linkedlist.TList&=mem:p("dwlab_frmwork_L_CurrentRedoList")
L_XMLMode%&=mem("dwlab_frmwork_L_XMLMode")