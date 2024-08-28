function Spark(pos,angle,speed,scale,emmisionRate,color)
  local t={}
  t.pos=pos
  t.angle=angle
  t.speed=speed
  t.emmisionRate=emmisionRate
  t.r,t.g,t.b=color[1],color[2],color[3]
  if scale==nil then t.scale=1 else t.scale=scale end
  t.alive=true
  
  t.move=function(dt)
    
    local movement={math.cos(t.angle)*t.speed*dt,math.sin(t.angle)*t.speed*dt}
    t.pos[1]=t.pos[1]+movement[1]
    t.pos[2]=t.pos[2]+movement[2]
    
    t.speed=t.speed-t.emmisionRate*dt
    
    if t.speed<=0 then t.alive=false end
    
    end
  
  t.draw=function () 
    if t.alive then
      
      local vertexes={t.pos[1]+math.cos(t.angle)*t.scale*t.speed/2, t.pos[2]+math.sin(t.angle)*t.scale*t.speed/2,
        t.pos[1]+math.cos(t.angle+math.pi/2)*t.scale*t.speed*0.3, t.pos[2]+math.sin(t.angle+math.pi/2)*t.scale*t.speed*0.3,
        t.pos[1]-math.cos(t.angle)*t.scale*t.speed*3.5, t.pos[2]-math.sin(t.angle)*t.scale*t.speed*3.5,
        t.pos[1]+math.cos(t.angle-math.pi/2)*t.scale*t.speed*0.3, t.pos[2]-math.sin(t.angle+math.pi/2)*t.scale*t.speed*0.3,
      }
      
      love.graphics.setColor(t.r,t.g,t.b)
      
      love.graphics.polygon("fill",vertexes)
      
    end
  end
  
  return t
  
end