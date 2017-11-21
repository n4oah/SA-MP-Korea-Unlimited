/*  <SA-MP Objects Physics - Handle collisions and more.>
    Copyright (C) <2013>  <Peppe>

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>. */

#include <a_samp>
#include <modelsizes>

#define PHY_TIMER_INTERVAL (20)
#define PHY_MAX_WALLS (512)

#define PHY_MODE_2D (0)
#define PHY_MODE_3D (1)


enum (<<= 1)
{
	PHY_OBJECT_USED = 0b01,
	PHY_OBJECT_MODE,
	PHY_OBJECT_GHOST_OBJECTS,
	PHY_OBJECT_GHOST_WALLS
}

enum E_PHY_OBJECT
{
	PHY_Properties,
	PHY_World,
	Float:PHY_Size,
	Float:PHY_Mass,
	Float:PHY_VX,
	Float:PHY_VY,
	Float:PHY_Friction,
	PHY_Roll
}

new
	PHY_Object[MAX_OBJECTS][E_PHY_OBJECT];


enum E_PHY_WALL
{
	PHY_Created,
	PHY_World,
	Float:PHY_X1,
	Float:PHY_Y1,
	Float:PHY_X2,
	Float:PHY_Y2,
	Float:PHY_M,
	Float:PHY_Q
}

new
	PHY_Wall[PHY_MAX_WALLS][E_PHY_WALL];


#define PHY_IsObjectUsingPhysics(%1) (PHY_Object[%1][PHY_Properties] & PHY_OBJECT_USED)
#define PHY_IsObjectUsing3D(%1) (PHY_Object[%1][PHY_Properties] & PHY_OBJECT_MODE)
#define PHY_IsObjectGhostWithObjects(%1) (PHY_Object[%1][PHY_Properties] & PHY_OBJECT_GHOST_OBJECTS)
#define PHY_IsObjectGhostWithWalls(%1) (PHY_Object[%1][PHY_Properties] & PHY_OBJECT_GHOST_WALLS)
#define PHY_IsObjectMoving(%1) (PHY_Object[%1][PHY_VX] != 0 || PHY_Object[%1][PHY_VY] != 0)
#define PHY_IsObjectRolling(%1) (PHY_Object[%1][PHY_Roll])
#define PHY_IsObjectDecelerated(%1) (PHY_Object[%1][PHY_Friction] != 0)

public OnGameModeInit()
{
	SetTimer("PHY_CoreTimer", PHY_TIMER_INTERVAL, true);
	
	CallLocalFunction("PHY_OnGameModeInit", "");
	return 1;
}

forward PHY_CoreTimer();
public PHY_CoreTimer()
{
	new
		Float:x1,
	    Float:y1,
	    Float:z1,
	    Float:x2,
	    Float:y2,
	    Float:z2,
	    Float:rx,
	    Float:ry,
	    Float:rz,
	    Float:speed,
	    Float:dx,
	    Float:dy,
		Float:dist,
		Float:maxdist,
		Float:angle,
		Float:dvx,
		Float:dvy,
		Float:mag,
		Float:tmpvx1,
		Float:tmpvx2,
		Float:newvy1,
		Float:newvy2,
		Float:newvx1,
		Float:newvx2;
	for(new a; a < sizeof PHY_Object; a++)
	{
	    if(PHY_Object[a][PHY_Properties] & PHY_OBJECT_USED)
	    {
	        if(PHY_IsObjectMoving(a))
	        {
	            GetObjectPos(a, x1, y1, z1);
	            x1 += (PHY_Object[a][PHY_VX] * PHY_TIMER_INTERVAL)/1000;
				y1 += (PHY_Object[a][PHY_VY] * PHY_TIMER_INTERVAL)/1000;
				SetObjectPos(a, x1, y1, z1);
				if(PHY_IsObjectDecelerated(a))
				{
				    if(PHY_Object[a][PHY_VX] > 0)
					{
						PHY_Object[a][PHY_VX] -= (PHY_Object[a][PHY_Friction] * PHY_TIMER_INTERVAL)/1000;
						if(PHY_Object[a][PHY_VX] < 0)
						    PHY_Object[a][PHY_VX] = 0.0;
					}
					else if(PHY_Object[a][PHY_VX] < 0)
					{
						PHY_Object[a][PHY_VX] += (PHY_Object[a][PHY_Friction] * PHY_TIMER_INTERVAL)/1000;
						if(PHY_Object[a][PHY_VX] > 0)
						    PHY_Object[a][PHY_VX] = 0.0;
					}
				    if(PHY_Object[a][PHY_VY] > 0)
					{
						PHY_Object[a][PHY_VY] -= (PHY_Object[a][PHY_Friction] * PHY_TIMER_INTERVAL)/1000;
						if(PHY_Object[a][PHY_VY] < 0)
						    PHY_Object[a][PHY_VY] = 0.0;
					}
					else if(PHY_Object[a][PHY_VY] < 0)
					{
						PHY_Object[a][PHY_VY] += (PHY_Object[a][PHY_Friction] * PHY_TIMER_INTERVAL)/1000;
						if(PHY_Object[a][PHY_VY] > 0)
						    PHY_Object[a][PHY_VY] = 0.0;
					}
				}
				if(PHY_IsObjectRolling(a))
				{
				    angle = atan2(PHY_Object[a][PHY_VY], PHY_Object[a][PHY_VX]) - 90.0;
				    speed = floatsqroot(PHY_Object[a][PHY_VX] * PHY_Object[a][PHY_VX] + PHY_Object[a][PHY_VY] * PHY_Object[a][PHY_VY]);
				    GetObjectRot(a, rx, ry, rz);
					rx -= ((speed * PHY_TIMER_INTERVAL)/1000) * (180/3.14159) / PHY_Object[a][PHY_Size];
					if(rx < 0.0)
					    rx += 360.0;
					if(angle < 0.0)
					    angle += 360.0;
		            rz = angle;
		            SetObjectRot(a, rx, ry, rz);
				}
				if(!PHY_IsObjectGhostWithObjects(a))
				{
					for(new b; b < sizeof PHY_Object; b++)
					{
					    if(PHY_Object[b][PHY_Properties] & PHY_OBJECT_USED && !PHY_IsObjectGhostWithObjects(b) && (!PHY_Object[a][PHY_World] || !PHY_Object[b][PHY_World] || PHY_Object[a][PHY_World] == PHY_Object[b][PHY_World]))
					    {
					        GetObjectPos(b, x2, y2, z2);
					        dx = x1 - x2;
					        dy = y1 - y2;
					        dist = (dx * dx) + (dy * dy);
					        maxdist = PHY_Object[a][PHY_Size] + PHY_Object[b][PHY_Size];
					        if(dist <= (maxdist * maxdist))
					        {
								dvx = PHY_Object[a][PHY_VX] - PHY_Object[b][PHY_VX];
		            	        dvy = PHY_Object[a][PHY_VY] - PHY_Object[b][PHY_VX];
		            	        mag = dvx * dx + dvy * dy;

		            	        if(mag < 0.0)
		            	        {
                           			angle = -atan2(dy, dx);
		            	            tmpvx1 = PHY_Object[a][PHY_VX] * floatcos(angle, degrees) - PHY_Object[a][PHY_VY] * floatsin(angle, degrees);
		            	            newvy1 = PHY_Object[a][PHY_VX] * floatsin(angle, degrees) + PHY_Object[a][PHY_VY] * floatcos(angle, degrees);
		            	            tmpvx2 = PHY_Object[b][PHY_VX] * floatcos(angle, degrees) - PHY_Object[b][PHY_VY] * floatsin(angle, degrees);
		            	            newvy2 = PHY_Object[b][PHY_VX] * floatsin(angle, degrees) + PHY_Object[b][PHY_VY] * floatcos(angle, degrees);

		            	            newvx1 = ((PHY_Object[a][PHY_Mass] - PHY_Object[b][PHY_Mass]) * tmpvx1 + 2 * PHY_Object[b][PHY_Mass] * tmpvx2) / (PHY_Object[a][PHY_Mass] + PHY_Object[b][PHY_Mass]);
		            	            newvx2 = ((PHY_Object[b][PHY_Mass] - PHY_Object[a][PHY_Mass]) * tmpvx2 + 2 * PHY_Object[a][PHY_Mass] * tmpvx1) / (PHY_Object[a][PHY_Mass] + PHY_Object[b][PHY_Mass]);

									angle = -angle;
                                    PHY_Object[a][PHY_VX] = newvx1 * floatcos(angle, degrees) - newvy1 * floatsin(angle, degrees);
		            	            PHY_Object[a][PHY_VY] = newvx1 * floatsin(angle, degrees) + newvy1 * floatcos(angle, degrees);
                           			PHY_Object[b][PHY_VX] = newvx2 * floatcos(angle, degrees) - newvy2 * floatsin(angle, degrees);
		            	            PHY_Object[b][PHY_VY] = newvx2 * floatsin(angle, degrees) + newvy2 * floatcos(angle, degrees);
								}
					        }
					    }
					}
				}
				if(!PHY_IsObjectGhostWithWalls(a))
				{
					for(new w; w < sizeof PHY_Wall; w++)
					{
					    if(PHY_Wall[w][PHY_Created] && (!PHY_Object[a][PHY_World] || !PHY_Wall[w][PHY_World] || PHY_Object[a][PHY_World] == PHY_Wall[w][PHY_World]))
					    {
					        dist = floatabs((y1 - PHY_Wall[w][PHY_M] * x1 - PHY_Wall[w][PHY_Q])/floatsqroot(1 + PHY_Wall[w][PHY_M] * PHY_Wall[w][PHY_M]));
					        if(dist <= PHY_Object[a][PHY_Size] && PHY_Wall[w][PHY_X1] - PHY_Object[a][PHY_Size] <= x1 <= PHY_Wall[w][PHY_X2] + PHY_Object[a][PHY_Size])
					        {
					            angle = -atan(PHY_Wall[w][PHY_M]);
       	         				newvx1 = PHY_Object[a][PHY_VX] * floatcos(angle, degrees) - PHY_Object[a][PHY_VY] * floatsin(angle, degrees);
		            	        newvy1 = PHY_Object[a][PHY_VX] * floatsin(angle, degrees) + PHY_Object[a][PHY_VY] * floatcos(angle, degrees);
								newvy1 = -newvy1;
								angle = -angle;
                                PHY_Object[a][PHY_VX] = newvx1 * floatcos(angle, degrees) - newvy1 * floatsin(angle, degrees);
        						PHY_Object[a][PHY_VY] = newvx1 * floatsin(angle, degrees) + newvy1 * floatcos(angle, degrees);
					        }
					    }
					}
				}
	        }
	    }
	}
	return 1;
}

stock PHY_InitObject(objectid, modelid = 0, Float:mass = 1.0, Float:size = 0.0, mode = 0)
{
	if(IsValidObject(objectid))
	{
	    PHY_Object[objectid][PHY_Properties] = PHY_OBJECT_USED | (mode ? PHY_OBJECT_MODE : 0);
	    PHY_Object[objectid][PHY_Mass] = mass;
	    PHY_Object[objectid][PHY_World] = 0;
	    PHY_Object[objectid][PHY_VX] = 0;
	    PHY_Object[objectid][PHY_VY] = 0;
	    if(size == 0.0)
		{
			if(modelid)
			    PHY_Object[objectid][PHY_Size] = GetColSphereRadius(modelid);
		}
		else
			PHY_Object[objectid][PHY_Size] = size;
	    return 1;
	}
	return 0;
}

stock PHY_ObjectDelete(objectid)
{
	PHY_Object[objectid][PHY_Properties] = 0;
	return 1;
}

stock PHY_MoveObject(objectid, Float:vx, Float:vy)
{
	if(PHY_Object[objectid][PHY_Properties] & PHY_OBJECT_USED)
	{
	    PHY_Object[objectid][PHY_VX] = vx;
	    PHY_Object[objectid][PHY_VY] = vy;
	    return 1;
	}
	return 0;
}

stock PHY_RollObject(objectid)
{
	if(PHY_Object[objectid][PHY_Properties] & PHY_OBJECT_USED)
	{
	    PHY_Object[objectid][PHY_Roll] = 1;
	    return 1;
	}
	return 0;
}

stock PHY_SetFriction(objectid, Float:acceleration)
{
	if(PHY_Object[objectid][PHY_Properties] & PHY_OBJECT_USED)
	{
	    PHY_Object[objectid][PHY_Friction] = acceleration;
	    return 1;
	}
	return 0;
}

stock PHY_SetObjectWorld(objectid, world)
{
	if(PHY_Object[objectid][PHY_Properties] & PHY_OBJECT_USED)
	{
	    PHY_Object[objectid][PHY_World] = world;
	    return 1;
	}
	return 0;
}

stock PHY_CreateWall(Float:x1, Float:y1, Float:x2, Float:y2)
{
	for(new i; i < sizeof PHY_Wall; i++)
	{
	    if(!PHY_Wall[i][PHY_Created])
	    {
	        PHY_Wall[i][PHY_Created] = 1;
	        PHY_Wall[i][PHY_World] = 0;
	        if(x2 > x1)
	        {
				PHY_Wall[i][PHY_X1] = x1;
		        PHY_Wall[i][PHY_Y1] = y1;
		        PHY_Wall[i][PHY_X2] = x2;
		        PHY_Wall[i][PHY_Y2] = y2;
	        }
	        else
	        {
				PHY_Wall[i][PHY_X1] = x2;
		        PHY_Wall[i][PHY_Y1] = y2;
		        PHY_Wall[i][PHY_X2] = x1;
		        PHY_Wall[i][PHY_Y2] = y1;
	        }
	        PHY_Wall[i][PHY_M] = (y2 - y1)/(x2 - x1);
			PHY_Wall[i][PHY_Q] = -((y2 - y1) * x1)/(x2 - x1) + y1;
	        return i;
	    }
	}
	return -1;
}

stock PHY_DestroyWall(wallid)
{
	PHY_Wall[wallid][PHY_Created] = 0;
	return 1;
}

stock PHY_SetWallWorld(id, world)
{
	if(PHY_Wall[wallid][PHY_Created])
	{
	    PHY_Wall[wallid][PHY_World] = world;
	    return 1;
	}
	return 0;
}


#if defined _ALS_OnGameModeInit
    #undef OnGameModeInit
#else
    #define _ALS_OnGameModeInit
#endif
#define OnGameModeInit PHY_OnGameModeInit

forward OnGameModeInit();
