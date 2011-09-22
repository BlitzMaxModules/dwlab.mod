'
' Menu - Digital Wizard's Lab framework template
' Copyright (C) 2011, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'



L_Visualizers.Insert( TTypeId.ForName( "LTWindow" ), LTRasterFrameVisualizer.Create( "frames/window.png", 3, 3, 31, 3 ) )
L_Visualizers.Insert( TTypeId.ForName( "LTButton" ), LTRasterFrameVisualizer.Create( "frames/button.png", 2, 2, 2, 2 ) )
L_Visualizers.Insert( TTypeId.ForName( "LTTextField" ), LTRasterFrameVisualizer.Create( "frames/text_field.png", 2, 1, 2, 1 ) )
L_Visualizers.Insert( "panel", LTRasterFrameVisualizer.Create( "frames/panel.png", 9, 9, 9, 9 ) )
