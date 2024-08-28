function new_projectile(x,y,speed,acceleration,angle,img, tag, scale)
  
  local self = {}
  self.x = x
  self.y = y
  self.speed = speed
  self.angle = angle
  self.img = img
  self.tag = tag
  self.last_x = self.x
  self.last_y = self.y
  self.acceleration = acceleration
  if img~=nil  then
    self.img_w,self.img_h = self.img:getDimensions()
  end
  self.collided=false
  self.trail_length = 1
  if scale == nil then self.scale = {1,1} else self.scale = scale end
  
  self.render=function(color)
    love.graphics.setBlendMode('add')
    if self.speed>450 then 
      local angle = math.atan2(self.y  - self.last_y, self.x - self.last_x)
      local points={self.x + math.cos(angle- math.pi/2)* 2.5, self.y+math.sin(angle-math.pi/2)* 2.5, self.x + math.cos(angle - math.pi)*self.trail_length ,self.y+math.sin(angle - math.pi)*self.trail_length ,self.x+math.cos(angle+math.pi/2) * 2.5, self.y+math.sin(angle+math.pi/2)*2.5}
      love.graphics.setColor(color[1],color[2],color[3], 125/255)
      if self.img~=nil then
        love.graphics.setBlendMode('add')
        love.graphics.polygon('fill',points) 
      end
        
    end
    love.graphics.setColor(color[1],color[2],color[3],1)
    if self.img~=nil then 
      love.graphics.draw(self.img, self.x, self.y, self.angle, self.scale[1], self.scale[2],self.img_w/2,self.img_h/2)
    else
      love.graphics.line(self.x,self.y,self.x-math.cos(self.angle)*8,self.y-math.sin(self.angle)*8)
    end
    love.graphics.setBlendMode('alpha')
  end
    
  self.update = function(dt, collidable)
    self.last_x, self.last_y = self.x, self.y
    self.x = self.x+ (math.cos(self.angle)*self.speed * dt)
    self.y = self.y+ (math.sin(self.angle)*self.speed * dt)
    self.speed = self.speed * self.acceleration
    
    if collidable then 
      if  map[math.floor(self.y/16)]~=nil then
        if map[math.floor(self.y/16)][math.floor(self.x/16)] ~= 0 then self.collided=true
        end
      end
    end
    
    if self.trail_length < 40 then 
      self.trail_length = self.trail_length+(dt*60*5)
    end
    
  end
  
  return self
end