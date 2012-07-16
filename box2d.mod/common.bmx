' Copyright (c) 2012 Michaël Lievens
' 
' Permission is hereby granted, free of charge, to any person obtaining a copy
' of this software and associated documentation files (the "Software"), to deal
' in the Software without restriction, including without limitation the rights
' to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
' copies of the Software, and to permit persons to whom the Software is
' furnished to do so, subject to the following conditions:
' 
' The above copyright notice and this permission notice shall be included in
' all copies or substantial portions of the Software.
' 
' THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
' IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
' FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
' AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
' LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
' OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
' THE SOFTWARE.

SuperStrict

Import "source.bmx"

Extern
	
	Function bmx_b2aabb_create:Byte Ptr(lowerBound:Byte Ptr, upperBound:Byte Ptr)
	Function bmx_b2aabb_delete(handle:Byte Ptr)
	Function bmx_b2aabb_get(handle:Byte Ptr, lowerBound:Byte Ptr, upperBound:Byte Ptr)
	Function bmx_b2aabb_set(handle:Byte Ptr, lowerBound:Byte Ptr, upperBound:Byte Ptr)
	Function bmx_b2aabb_getlowerbound:Byte Ptr(handle:Byte Ptr)
	Function bmx_b2aabb_setlowerbound(handle:Byte Ptr, lowerBound:Byte Ptr)
	Function bmx_b2aabb_getupperbound:Byte Ptr(handle:Byte Ptr)
	Function bmx_b2aabb_setupperbound(handle:Byte Ptr, upperBound:Byte Ptr)
	Function bmx_b2aabb_isvalid:Int(handle:Byte Ptr)
	Function bmx_b2aabb_getcenter:Byte Ptr(handle:Byte Ptr)
	Function bmx_b2aabb_getextents:Byte Ptr(handle:Byte Ptr)
	Function bmx_b2aabb_getperimeter:Float(handle:Byte Ptr)
	Function bmx_b2aabb_combine(handle:Byte Ptr, other:Byte Ptr)
	Function bmx_b2aabb_combine2(handle:Byte Ptr, other1:Byte Ptr, other2:Byte Ptr)
	Function bmx_b2aabb_raycast(handle:Byte Ptr, rayCastOutput:Byte Ptr, rayCastInput:Byte Ptr)
	Function bmx_b2aabb_contains:Int(handle:Byte Ptr, other:Byte Ptr)

	Function bmx_b2vec2_create:Byte Ptr(x:Float, y:Float)
	Function bmx_b2vec2_fromvect2:Byte Ptr(handle:Byte Ptr)
	Function bmx_b2vec2_delete(handle:Byte Ptr)
	Function bmx_b2vec2_copy(handle:Byte Ptr, vec:Byte Ptr)
	Function bmx_b2vec2_getx:Float(handle:Byte Ptr)
	Function bmx_b2vec2_gety:Float(handle:Byte Ptr)
	Function bmx_b2vec2_set(handle:Byte Ptr, x:Float, y:Float)
	Function bmx_b2vec2_setx(handle:Byte Ptr, x:Float)
	Function bmx_b2vec2_sety(handle:Byte Ptr, y:Float)
	Function bmx_b2vec2_setzero(handle:Byte Ptr)
	Function bmx_b2vec2_add(handle:Byte Ptr, vec:Byte Ptr)
	Function bmx_b2vec2_addnew:Byte Ptr(handle:Byte Ptr, vec:Byte Ptr)
	Function bmx_b2vec2_subtract(handle:Byte Ptr, vec:Byte Ptr)
	Function bmx_b2vec2_subtractnew:Byte Ptr(handle:Byte Ptr, vec:Byte Ptr)
	Function bmx_b2vec2_multiply(handle:Byte Ptr, value:Float)
	Function bmx_b2vec2_multiplynew:Byte Ptr(handle:Byte Ptr, value:Float)
	Function bmx_b2vec2_length:Float(handle:Byte Ptr)
	Function bmx_b2vec2_lengthsquared:Float(handle:Byte Ptr)
	Function bmx_b2vec2_normalize:Float(handle:Byte Ptr)
	Function bmx_b2vec2_isvalid:Int(handle:Byte Ptr)
	Function bmx_b2vec2_skew:Byte Ptr(handle:Byte Ptr)

	
	Function bmx_b2vec3_create:Byte Ptr(x:Float, y:Float, z:Float)
	Function bmx_b2vec3_fromvect3:Byte Ptr(handle:Byte Ptr)
	Function bmx_b2vec3_delete(handle:Byte Ptr)
	Function bmx_b2vec3_copy(handle:Byte Ptr, vec:Byte Ptr)
	Function bmx_b2vec3_getx:Float(handle:Byte Ptr)
	Function bmx_b2vec3_gety:Float(handle:Byte Ptr)
	Function bmx_b2vec3_getz:Float(handle:Byte Ptr)
	Function bmx_b2vec3_set(handle:Byte Ptr, x:Float, y:Float, z:Float)
	Function bmx_b2vec3_setx(handle:Byte Ptr, x:Float)
	Function bmx_b2vec3_sety(handle:Byte Ptr, y:Float)
	Function bmx_b2vec3_setz(handle:Byte Ptr, z:Float)
	Function bmx_b2vec3_setzero(handle:Byte Ptr)
	Function bmx_b2vec3_add(handle:Byte Ptr, vec:Byte Ptr)
	Function bmx_b2vec3_addnew:Byte Ptr(handle:Byte Ptr, vec:Byte Ptr)
	Function bmx_b2vec3_subtract(handle:Byte Ptr, vec:Byte Ptr)
	Function bmx_b2vec3_subtractnew:Byte Ptr(handle:Byte Ptr, vec:Byte Ptr)
	Function bmx_b2vec3_multiply(handle:Byte Ptr, value:Float)
	Function bmx_b2vec3_multiplynew:Byte Ptr(handle:Byte Ptr, value:Float)
		
	
	Function bmx_b2rot_create:Byte Ptr()
	Function bmx_b2rot_createrotation:Byte Ptr(angle:Float)
	Function bmx_b2rot_createrotationrad:Byte Ptr(angle:Float)
	Function bmx_b2rot_delete(handle:Byte Ptr)
	Function bmx_b2rot_setidentity(handle:Byte Ptr)
	Function bmx_b2rot_set(handle:Byte Ptr, angle:Float)
	Function bmx_b2rot_setrad(handle:Byte Ptr, angle:Float)
	Function bmx_b2rot_getangle:Float(handle:Byte Ptr)
	Function bmx_b2rot_getanglerad:Float(handle:Byte Ptr)
	Function bmx_b2rot_getxaxis:Byte Ptr(handle:Byte Ptr)
	Function bmx_b2rot_getyaxis:Byte Ptr(handle:Byte Ptr)
	Function bmx_b2rot_getsinus:Float(handle:Byte Ptr)
	Function bmx_b2rot_setsinus(handle:Byte Ptr, sinus:Float)
	Function bmx_b2rot_getcosinus:Float(handle:Byte Ptr)
	Function bmx_b2rot_setcosinus(handle:Byte Ptr, cosinus:Float)

	
	Function bmx_b2transform_create:Byte Ptr()
	Function bmx_b2transform_createtransform:Byte Ptr(position:Byte Ptr, rotation:Byte Ptr)
	Function bmx_b2transform_delete(handle:Byte Ptr)
	Function bmx_b2transform_setidentity(handle:Byte Ptr)
	Function bmx_b2transform_set(handle:Byte Ptr, position:Byte Ptr, angle:Float)
	Function bmx_b2transform_setrad(handle:Byte Ptr, position:Byte Ptr, angle:Float)
	Function bmx_b2transform_getposition:Byte Ptr(handle:Byte Ptr)
	Function bmx_b2transform_setposition(handle:Byte Ptr, position:Byte Ptr)
	Function bmx_b2transform_getrotation:Byte Ptr(handle:Byte Ptr)
	Function bmx_b2transform_setrotation(handle:Byte Ptr, rotation:Byte Ptr)

				
	Function bmx_b2raycastinput_create:Byte Ptr(p1:Byte Ptr, p2:Byte Ptr, maxFraction:Float)
	Function bmx_b2raycastinput_delete(handle:Byte Ptr)
	Function bmx_b2raycastinput_copy(handle:Byte Ptr, rayCastInput:Byte Ptr)
	Function bmx_b2raycastinput_get(handle:Byte Ptr, p1:Byte Ptr, p2:Byte Ptr, maxFraction:Float Ptr)
	Function bmx_b2raycastinput_set(handle:Byte Ptr, p1:Byte Ptr, p2:Byte Ptr, maxFraction:Float)
	Function bmx_b2raycastinput_getp1:Byte Ptr(handle:Byte Ptr)
	Function bmx_b2raycastinput_setp1(handle:Byte Ptr, p1:Byte Ptr)
	Function bmx_b2raycastinput_getp2:Byte Ptr(handle:Byte Ptr)
	Function bmx_b2raycastinput_setp2(handle:Byte Ptr, p2:Byte Ptr)
	Function bmx_b2raycastinput_getmaxfraction:Float(handle:Byte Ptr)
	Function bmx_b2raycastinput_setmaxfraction(handle:Byte Ptr, maxFraction:Float)


	Function bmx_b2raycastoutput_create:Byte Ptr(normal:Byte Ptr, fraction:Float)
	Function bmx_b2raycastoutput_delete(handle:Byte Ptr)
	Function bmx_b2raycastoutput_copy(handle:Byte Ptr, rayCastInput:Byte Ptr)
	Function bmx_b2raycastoutput_get(handle:Byte Ptr, normal:Byte Ptr, fraction:Float Ptr)
	Function bmx_b2raycastoutput_set(handle:Byte Ptr, normal:Byte Ptr, fraction:Float)
	Function bmx_b2raycastoutput_getnormal:Byte Ptr(handle:Byte Ptr)
	Function bmx_b2raycastoutput_setnormal(handle:Byte Ptr, normal:Byte Ptr)
	Function bmx_b2raycastoutput_getfraction:Float(handle:Byte Ptr)
	Function bmx_b2raycastoutput_setfraction(handle:Byte Ptr, fraction:Float)

	

	Function bmx_b2fixture_getmaxfixture:Object(handle:Byte Ptr)
	Function bmx_b2fixture_gettype:Int(handle:Byte Ptr)
	Function bmx_b2fixture_getbody:Byte Ptr(handle:Byte Ptr)
	Function bmx_b2fixture_issensor:Int(handle:Byte Ptr)
	Function bmx_b2fixture_testpoint:Int(handle:Byte Ptr, point:Byte Ptr)
'	Function bmx_b2fixture_getbody:Byte Ptr(handle:Byte Ptr)
'	Function bmx_b2fixture_getnext:Byte Ptr(handle:Byte Ptr)
'	Function bmx_b2fixture_testpoint:Int(handle:Byte Ptr, xf:Byte Ptr, p:Byte Ptr)
'	Function bmx_b2fixture_getsweepradius:Float(handle:Byte Ptr)
'	Function bmx_b2fixture_getfriction:Float(handle:Byte Ptr)
'	Function bmx_b2fixture_getrestitution:Float(handle:Byte Ptr)
'	Function bmx_b2fixture_computeaabb(handle:Byte Ptr, aabb:Byte Ptr, xf:Byte Ptr)
'	Function bmx_b2fixture_computesweptaabb(handle:Byte Ptr, aabb:Byte Ptr, xf1:Byte Ptr, xf2:Byte Ptr)
'	Function bmx_b2fixture_computemass(handle:Byte Ptr, data:Byte Ptr)
'	Function bmx_b2fixture_getfilterdata:Byte Ptr(handle:Byte Ptr)
'	Function bmx_b2fixture_setfilterdata(handle:Byte Ptr, data:Byte Ptr)
'	Function bmx_b2fixture_setfriction(handle:Byte Ptr, friction:Float)
'	Function bmx_b2fixture_setrestitution(handle:Byte Ptr, restitution:Float)
'	Function bmx_b2fixture_getdensity:Float(handle:Byte Ptr)
'	Function bmx_b2fixture_setdensity(handle:Byte Ptr, density:Float)


	Function bmx_b2filter_create:Byte Ptr(categoryBits:Short, maskBits:Short, groupIndex:Int)
	Function bmx_b2filter_delete(handle:Byte Ptr)
	Function bmx_b2filter_getcategorybits:Short(handle:Byte Ptr)
	Function bmx_b2filter_setcategorybits(handle:Byte Ptr, categoryBits:Short)
	Function bmx_b2filter_getmaskbits:Short(handle:Byte Ptr)
	Function bmx_b2filter_setmaskbits(handle:Byte Ptr, maskBits:Short)
	Function bmx_b2filter_getgroupindex:Int(handle:Byte Ptr)
	Function bmx_b2filter_setgroupindex(handle:Byte Ptr, groupIndex:Int)

	
	Function bmx_b2fixturedef_create:Byte Ptr()
	Function bmx_b2fixturedef_getshape:Byte Ptr(handle:Byte Ptr)
	Function bmx_b2fixturedef_setshape(handle:Byte Ptr, shape:Byte Ptr)
	Function bmx_b2fixturedef_getfriction:Float(handle:Byte Ptr)
	Function bmx_b2fixturedef_setfriction(handle:Byte Ptr, friction:Float)
	Function bmx_b2fixturedef_getrestitution:Float(handle:Byte Ptr)
	Function bmx_b2fixturedef_setrestitution(handle:Byte Ptr, restitution:Float)
	Function bmx_b2fixturedef_getdensity:Float(handle:Byte Ptr)
	Function bmx_b2fixturedef_setdensity(handle:Byte Ptr, density:Float)
	Function bmx_b2fixturedef_issensor:Int(handle:Byte Ptr)
	Function bmx_b2fixturedef_setissensor(handle:Byte Ptr, sensor:Int)
	Function bmx_b2fixturedef_setfilter(handle:Byte Ptr, filter:Byte Ptr)
	Function bmx_b2fixturedef_getfilter:Byte Ptr(handle:Byte Ptr)


	
'	Function bmx_b2shape_issensor:Int(handle:Byte Ptr)
'	Function bmx_b2shape_getbody:Byte Ptr(handle:Byte Ptr)
'	Function bmx_b2shape_getnext:Byte Ptr(handle:Byte Ptr)
'	Function bmx_b2shape_testpoint:Int(handle:Byte Ptr, xf:Byte Ptr, p:Byte Ptr)
'	Function bmx_b2shape_getsweepradius:Float(handle:Byte Ptr)
'	Function bmx_b2shape_getfriction:Float(handle:Byte Ptr)
'	Function bmx_b2shape_getrestitution:Float(handle:Byte Ptr)
'	Function bmx_b2shape_computeaabb(handle:Byte Ptr, aabb:Byte Ptr, xf:Byte Ptr)
'	Function bmx_b2shape_computesweptaabb(handle:Byte Ptr, aabb:Byte Ptr, xf1:Byte Ptr, xf2:Byte Ptr)
'	Function bmx_b2shape_computemass(handle:Byte Ptr, data:Byte Ptr)
'	Function bmx_b2shape_getfilterdata:Byte Ptr(handle:Byte Ptr)
'	Function bmx_b2shape_setfilterdata(handle:Byte Ptr, data:Byte Ptr)
'	Function bmx_b2shape_setfriction(handle:Byte Ptr, friction:Float)
'	Function bmx_b2shape_setrestitution(handle:Byte Ptr, restitution:Float)
'	Function bmx_b2shape_getdensity:Float(handle:Byte Ptr)
'	Function bmx_b2shape_setdensity(handle:Byte Ptr, density:Float)



	Function bmx_b2circleshape_create:Byte Ptr()



	Function bmx_b2polygonshape_create:Byte Ptr()
	Function bmx_b2polygonshape_setasbox(handle:Byte Ptr, hx:Float, hy:Float)
	Function bmx_b2polygondef_setasorientedbox(handle:Byte Ptr, hx:Float, hy:Float, center:Byte Ptr, angle:Float)
	Function bmx_b2polygondef_setasorientedboxrad(handle:Byte Ptr, hx:Float, hy:Float, center:Byte Ptr, angle:Float)
	
'	Function bmx_b2polygonshape_getobb:Byte Ptr(handle:Byte Ptr)
'	Function bmx_b2polygonshape_getcentroid:Byte Ptr(handle:Byte Ptr)
'	Function bmx_b2polygonshape_getvertexcount:Int(handle:Byte Ptr)
'	Function bmx_b2polygonshape_getfirstvertex:Byte Ptr(handle:Byte Ptr, xf:Byte Ptr)
'	Function bmx_b2polygonshape_centroid:Byte Ptr(handle:Byte Ptr, xf:Byte Ptr)
'	Function bmx_b2polygonshape_support:Byte Ptr(handle:Byte Ptr, xf:Byte Ptr, d:Byte Ptr)

'	Function bmx_b2polygonshape_getvertices:b2Vec2[] (handle:Byte Ptr)
'	Function bmx_b2polygonshape_getcorevertices:b2Vec2[](handle:Byte Ptr)
'	Function bmx_b2polygonshape_getnormals:b2Vec2[](handle:Byte Ptr)
	

	Function bmx_b2body_getmaxbody:Object(handle:Byte Ptr)
	Function bmx_b2body_createfixture:Byte Ptr(handle:Byte Ptr, def:Byte Ptr)
	Function bmx_b2body__createfixture:Byte Ptr(handle:Byte Ptr, shape:Byte Ptr, density:Float)
	Function bmx_b2body_destroyfixture(handle:Byte Ptr, fixture:Byte Ptr)
	Function bmx_b2body_getposition:Byte Ptr(handle:Byte Ptr)
	Function bmx_b2body_getangle:Float(handle:Byte Ptr)
	Function bmx_b2body_getanglerad:Float(handle:Byte Ptr)
	Function bmx_b2body_getnext:Byte Ptr(handle:Byte Ptr)
	Function bmx_b2body_getfixturelist:Byte Ptr(handle:Byte Ptr)
	Function bmx_b2body_isawake:Int(handle:Byte Ptr)
	Function bmx_b2body_setawake(handle:Byte Ptr, flag:Int)
	Function bmx_b2body_isbullet:Int(handle:Byte Ptr)
	Function bmx_b2body_setbullet(handle:Byte Ptr, flag:Int)
	Function bmx_b2body_getworldcenter:Byte Ptr(handle:Byte Ptr)
	Function bmx_b2body_getlocalcenter:Byte Ptr(handle:Byte Ptr)
	Function bmx_b2body_setlinearvelocity(handle:Byte Ptr, v:Byte Ptr)
	Function bmx_b2body_getlinearvelocity:Byte Ptr(handle:Byte Ptr)
	Function bmx_b2body_setangularvelocity(handle:Byte Ptr, omega:Float)
	Function bmx_b2body_getangularvelocity:Float(handle:Byte Ptr)
	Function bmx_b2body_applyforce(handle:Byte Ptr, force:Byte Ptr, point:Byte Ptr)
	Function bmx_b2body_applytorque(handle:Byte Ptr, torque:Float)
	Function bmx_b2body_applylinearimpulse(handle:Byte Ptr, impulse:Byte Ptr, point:Byte Ptr)
	Function bmx_b2body_getmass:Float(handle:Byte Ptr)
	Function bmx_b2body_getinertia:Float(handle:Byte Ptr)
	Function bmx_b2body_getworldpoint:Byte Ptr(handle:Byte Ptr, localPoint:Byte Ptr)
	Function bmx_b2body_getworldvector:Byte Ptr(handle:Byte Ptr, localVector:Byte Ptr)
	Function bmx_b2body_getlocalpoint:Byte Ptr(handle:Byte Ptr, worldPoint:Byte Ptr)
	Function bmx_b2body_getlocalvector:Byte Ptr(handle:Byte Ptr, worldVector:Byte Ptr)
	Function bmx_b2body_getjointlist:Byte Ptr(handle:Byte Ptr)
	Function bmx_b2body_getworld:Byte Ptr(handle:Byte Ptr)
	Function bmx_b2body_setmassdata(handle:Byte Ptr, massData:Byte Ptr)
	Function bmx_b2body_gettype:Int(handle:Byte Ptr)
	Function bmx_b2body_settype(handle:Byte Ptr, bodyType:Int)



	Function bmx_b2bodydef_create:Byte Ptr()
	Function bmx_b2bodydef_delete(handle:Byte Ptr)
	Function bmx_b2bodydef_getposition:Byte Ptr(handle:Byte Ptr)
	Function bmx_b2bodydef_setposition(handle:Byte Ptr, position:Byte Ptr)
	Function bmx_b2bodydef_setpositionxy(handle:Byte Ptr, x:Float, y:Float)
	Function bmx_b2bodydef_getangle:Float(handle:Byte Ptr)
	Function bmx_b2bodydef_setangle(handle:Byte Ptr, angle:Float)
	Function bmx_b2bodydef_getanglerad:Float(handle:Byte Ptr)
	Function bmx_b2bodydef_setanglerad(handle:Byte Ptr, angle:Float)
	Function bmx_b2bodydef_getlinearvelocity:Byte Ptr(handle:Byte Ptr)
	Function bmx_b2bodydef_setlinearvelocity(handle:Byte Ptr, velocity:Byte Ptr)
	Function bmx_b2bodydef_getangularvelocity:Float(handle:Byte Ptr)
	Function bmx_b2bodydef_setangularvelocity(handle:Byte Ptr, velocity:Float)
	Function bmx_b2bodydef_getlineardamping:Float(handle:Byte Ptr)
	Function bmx_b2bodydef_setlineardamping(handle:Byte Ptr, damping:Float)
	Function bmx_b2bodydef_getangulardamping:Float(handle:Byte Ptr)
	Function bmx_b2bodydef_setangulardamping(handle:Byte Ptr, damping:Float)
	Function bmx_b2bodydef_getallowsleep:Int(handle:Byte Ptr)
	Function bmx_b2bodydef_setallowsleep(handle:Byte Ptr, allow:Int)
	Function bmx_b2bodydef_getawake:Int(handle:Byte Ptr)
	Function bmx_b2bodydef_setawake(handle:Byte Ptr, allow:Int)
	Function bmx_b2bodydef_getfixedrotation:Int(handle:Byte Ptr)
	Function bmx_b2bodydef_setfixedrotation(handle:Byte Ptr, fixed:Int)
	Function bmx_b2bodydef_getbullet:Int(handle:Byte Ptr)
	Function bmx_b2bodydef_setbullet(handle:Byte Ptr, bullet:Int)
	Function bmx_b2bodydef_getactive:Int(handle:Byte Ptr)
	Function bmx_b2bodydef_setactive(handle:Byte Ptr, active:Int)
	Function bmx_b2bodydef_gettype:Int(handle:Byte Ptr)
	Function bmx_b2bodydef_settype(handle:Byte Ptr, bodyType:Int)
	Function bmx_b2bodydef_getgravityscale:Float(handle:Byte Ptr)
	Function bmx_b2bodydef_setgravityscale(handle:Byte Ptr, gravityScale:Float)
	


	Function bmx_b2destructionlistener_create:Byte Ptr(handle:Object)
	Function bmx_b2destructionlistener_delete(handle:Byte Ptr)


	
	Function bmx_b2querycallback_create:Byte Ptr(handle:Object)
	Function bmx_b2querycallback_reportfixture:Int(handle:Byte Ptr, fixture:Byte Ptr)

	
	
	Function bmx_b2draw_create:Byte Ptr(handle:Object)
	Function bmx_b2draw_setflags(handle:Byte Ptr, flags:Int)
	Function bmx_b2draw_getflags:Int(handle:Byte Ptr)
	Function bmx_b2draw_appendflags(handle:Byte Ptr, flags:Int)
	Function bmx_b2draw_clearflags(handle:Byte Ptr, flags:Int)
	
	
	
	Function bmx_b2joint_getmaxjoint:Object(handle:Byte Ptr)
	Function bmx_b2joint_gettype:Int(handle:Byte Ptr)
	Function bmx_b2joint_getbodya:Byte Ptr(handle:Byte Ptr)
	Function bmx_b2joint_getbodyb:Byte Ptr(handle:Byte Ptr)
	Function bmx_b2joint_isactive:Int(handle:Byte Ptr)
	
	Function bmx_b2mousejoint_getanchora:Byte Ptr(handle:Byte Ptr)
	Function bmx_b2mousejoint_getanchorb:Byte Ptr(handle:Byte Ptr)
	Function bmx_b2mousejoint_getreactionforce:Byte Ptr(handle:Byte Ptr, inv_dt:Float)
	Function bmx_b2mousejoint_getreactiontorque:Float(handle:Byte Ptr, inv_dt:Float)
	Function bmx_b2mousejoint_gettarget:Byte Ptr(handle:Byte Ptr)
	Function bmx_b2mousejoint_settarget(handle:Byte Ptr, target:Byte Ptr)
	Function bmx_b2mousejoint_getmaxforce:Float(handle:Byte Ptr)
	Function bmx_b2mousejoint_setmaxforce(handle:Byte Ptr, force:Float)
	Function bmx_b2mousejoint_getfrequency:Float(handle:Byte Ptr)
	Function bmx_b2mousejoint_setfrequency(handle:Byte Ptr, frequency:Float)
	Function bmx_b2mousejoint_getdampingratio:Float(handle:Byte Ptr)
	Function bmx_b2mousejoint_setdampingratio(handle:Byte Ptr, damping:Float)
	Function bmx_b2mousejoint_shiftorigin(handle:Byte Ptr, newOrigin:Byte Ptr)
	Function bmx_b2mousejoint_dump(handle:Byte Ptr)
	
	
'	Function bmx_b2jointdef_create:Byte Ptr()
	Function bmx_b2jointdef_gettype:Int(handle:Byte Ptr)
	Function bmx_b2jointdef_settype(handle:Byte Ptr, jointType:Int)
	Function bmx_b2jointdef_getbodya:Byte Ptr(handle:Byte Ptr)
	Function bmx_b2jointdef_setbodya(handle:Byte Ptr, body:Byte Ptr)
	Function bmx_b2jointdef_getbodyb:Byte Ptr(handle:Byte Ptr)
	Function bmx_b2jointdef_setbodyb(handle:Byte Ptr, body:Byte Ptr)
	Function bmx_b2jointdef_setcollideconnected(handle:Byte Ptr, flag:Int)
	Function bmx_b2jointdef_getcollideconnected:Int(handle:Byte Ptr)
	
	Function bmx_b2mousejointdef_create:Byte Ptr()
	Function bmx_b2mousejointdef_gettarget:Byte Ptr(handle:Byte Ptr)
	Function bmx_b2mousejointdef_settarget(handle:Byte Ptr, target:Byte Ptr)
	Function bmx_b2mousejointdef_getmaxforce:Float(handle:Byte Ptr)
	Function bmx_b2mousejointdef_setmaxforce(handle:Byte Ptr, force:Float)
	Function bmx_b2mousejointdef_getfrequencyhz:Float(handle:Byte Ptr)
	Function bmx_b2mousejointdef_setfrequencyhz(handle:Byte Ptr, frequency:Float)
	Function bmx_b2mousejointdef_getdampingratio:Float(handle:Byte Ptr)
	Function bmx_b2mousejointdef_setdampingratio(handle:Byte Ptr, damping:Float)

				
	
	Function bmx_b2shape_getradius:Float(handle:Byte Ptr)
	Function bmx_b2shape_setradius:Float(handle:Byte Ptr, radius:Float)
	
	
		
	Function bmx_b2world_create:Byte Ptr(gravity:Byte Ptr)
	Function bmx_b2world_free(handle:Byte Ptr)
	Function bmx_b2world_dostep(handle:Byte Ptr, timeStep:Float, velocityIterations:Int, positionIterations:Int)
	Function bmx_b2world_createbody:Byte Ptr(handle:Byte Ptr, def:Byte Ptr, body:Object)
	Function bmx_b2world_destroybody(handle:Byte Ptr, body:Byte Ptr)
	Function bmx_b2world_getallowsleeping:Int(handle:Byte Ptr)
	Function bmx_b2world_setallowsleeping(handle:Byte Ptr, flag:Int)
	Function bmx_b2world_getwarmstarting:Int(handle:Byte Ptr)
	Function bmx_b2world_setwarmstarting(handle:Byte Ptr, flag:Int)
	Function bmx_b2world_getcontinuousphysics:Int(handle:Byte Ptr)
	Function bmx_b2world_setcontinuousphysics(handle:Byte Ptr, flag:Int)
	Function bmx_b2world_getsubstepping:Int(handle:Byte Ptr)
	Function bmx_b2world_setsubstepping(handle:Byte Ptr, flag:Int)
	Function bmx_b2world_DrawDebugData(handle:Byte Ptr)
	Function bmx_b2world_setdebugDraw(handle:Byte Ptr, debugDraw:Byte Ptr)
	
	Function bmx_b2world_createjoint:Byte Ptr(handle:Byte Ptr, def:Byte Ptr)
	Function bmx_b2world_destroyjoint(handle:Byte Ptr, joint:Byte Ptr)
'	Function bmx_b2world_getbodylist:Byte Ptr(handle:Byte Ptr)
'	Function bmx_b2world_getjointlist:Byte Ptr(handle:Byte Ptr)
'	Function bmx_b2world_setfilter(handle:Byte Ptr, filter:Byte Ptr)
'	Function bmx_b2world_setcontactlistener(handle:Byte Ptr, listener:Byte Ptr)
'	Function bmx_b2world_setboundarylistener(handle:Byte Ptr, listener:Byte Ptr)
	Function bmx_b2world_getgravity:Byte Ptr(handle:Byte Ptr)
	Function bmx_b2world_setgravity(handle:Byte Ptr, gravity:Byte Ptr)
'	Function bmx_b2world_getcontactlist:Byte Ptr(handle:Byte Ptr)
	Function bmx_b2world_getproxycount:Int(handle:Byte Ptr)
	Function bmx_b2world_getcontactcount:Int(handle:Byte Ptr)
	Function bmx_b2world_getbodycount:Int(handle:Byte Ptr)
	Function bmx_b2world_getjointcount:Int(handle:Byte Ptr)
	Function bmx_b2world_gettreeheight:Int(handle:Byte Ptr)
	Function bmx_b2world_gettreebalance:Int(handle:Byte Ptr)
	Function bmx_b2world_setdestructionlistener(handle:Byte Ptr, listener:Byte Ptr)
'	Function bmx_b2world_raycastone:Byte Ptr(handle:Byte Ptr, segment:Byte Ptr, lambda:Float Ptr, normal:Byte Ptr, solidShapes:Int)
'	Function bmx_b2world_createcontroller:Byte Ptr(handle:Byte Ptr, def:Byte Ptr, _type:Int)
'	Function bmx_b2world_destroycontroller(handle:Byte Ptr, controller:Byte Ptr)

	Function bmx_b2world_queryaabb(handle:Byte Ptr, callback:Byte Ptr, aabb:Byte Ptr)
'	Function bmx_b2world_raycast:Int(handle:Byte Ptr, segment:Byte Ptr, shapes:b2Shape[], solidShapes:Int)
		
End Extern

Rem
bbdoc: Point does not exist
endrem
Const b2_nullState:Int = 0

Rem
bbdoc: Point was added in the update
endrem
Const b2_addState:Int = 1

Rem
bbdoc: Point persisted across the update
endrem
Const b2_persistState:Int = 2

Rem
bbdoc: Point was removed in the update
endrem
Const b2_removeState:Int = 3


Rem
bbdoc: Static: zero mass, zero velocity, may be manually moved.
endrem
Const b2_staticBody:Int = 0

Rem
bbdoc:Kinematic:zero mass, non - zero velocity set by user, moved by solver.
endrem
Const b2_kinematicBody:Int = 1

Rem
bbdoc:Dynamic:positive mass, non - zero velocity determined by forces, moved by solver.
endrem
Const b2_dynamicBody:Int = 2


Rem
bbdoc: b2Shape::Type - Circle
endrem
Const e_circle:Int = 0
Rem
bbdoc: b2Shape::Type - Edge
endrem
Const e_edge:Int = 1
Rem
bbdoc: b2Shape::Type - Polygon
endrem
Const e_polygon:Int = 2
Rem
bbdoc: b2Shape::Type - Chain
endrem
Const e_chain:Int = 3
Rem
bbdoc: b2Shape::Type - Reserved
endrem
Const e_typeCount:Int = 4


Rem
bbdoc: b2JointType - Unknown Joint
endrem
Const e_unknownJoint:Int = 0
Rem
bbdoc: b2JointType - Revolute Joint
endrem
Const e_revoluteJoint:Int = 1
Rem
bbdoc: b2JointType - Prismatic Joint
endrem
Const e_prismaticJoint:Int = 2
Rem
bbdoc: b2JointType - Distance Joint
endrem
Const e_distanceJoint:Int = 3
Rem
bbdoc: b2JointType - Pulley Joint
endrem
Const e_pulleyJoint:Int = 4
Rem
bbdoc: b2JointType - Mouse Joint
endrem
Const e_mouseJoint:Int = 5
Rem
bbdoc: b2JointType - Gear Joint
endrem
Const e_gearJoint:Int = 6
Rem
bbdoc: b2JointType - Wheel Joint
endrem
Const e_wheelJoint:Int = 7
Rem
bbdoc: b2JointType - Weld Joint
endrem
Const e_weldJoint:Int = 8
Rem
bbdoc: b2JointType - Friction Joint
endrem
Const e_frictionJoint:Int = 9
Rem
bbdoc: b2JointType - Rope Joint
endrem
Const e_ropeJoint:Int = 10
Rem
bbdoc: b2JointType - Motor Joint
endrem
Const e_motorJoint:Int = 11


Rem
bbdoc: b2LimitState - Inactive Limit
endrem
Const e_inactiveLimit:Int = 0
Rem
bbdoc: b2LimitState - At Lower Limit
endrem
Const e_atLowerLimit:Int = 1
Rem
bbdoc: b2LimitState - At Upper Limit
endrem
Const e_atUpperLimit:Int = 2
Rem
bbdoc: b2LimitState - Equal Limits
endrem
Const e_equalLimits:Int = 3



Rem
bbdoc: b2TOIOutput::State - Unknown
endrem
Const e_unknown:Int = 0
Rem
bbdoc: b2TOIOutput::State - Failed
endrem
Const e_failed:Int = 1
Rem
bbdoc: b2TOIOutput::State - Overlapped
endrem
Const e_overlapped:Int = 2
Rem
bbdoc: b2TOIOutput::State - Touching
endrem
Const e_touching:Int = 3
Rem
bbdoc: b2TOIOutput::State - Separated
endrem
Const e_separated:Int = 4
