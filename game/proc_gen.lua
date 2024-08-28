
local function getTileBits(u,r,d,l) --up, right, down, left
  
  return u + (r*2) + (d*4) +(l*8)
  
end

function tile_and_shadows_Arrangement(map)
  
  local shadows={}
  shadows['2']={}
  shadows['10']={}
  shadows['9']={}
  shadows['8']={}
  shadows['3']={}
  shadows['11']={}
  shadows['1']={}
  
  for i,y in pairs(map) do
    for j,x in pairs(y) do
      
      if x~=0 then 
        
        local u,r,d,l = 0,0,0,0
        
        if map[i-1] ~= nil then 
            if map[i-1][j] ~= 0 then u=1 end end
        if map[i][j+1] ~= 0 then r=1 end 
        if map[i+1] ~= nil then 
            if map[i+1][j] ~= 0 then d=1 end end
        if map[i][j-1] ~= 0 then l=1 end 
        
        map[i][j]= getTileBits(u,r,d,l)
        
        --------corners--smooth tiles--#
        if map[i][j]==15 then 
          if map[i+1] then
            if map[i+1][j+1]==0 then map[i][j]=100 end
          end
          if map[i-1] then
            if map[i-1][j-1]==0 then map[i][j]=100 end
          end
          if map[i-1] then
            if map[i-1][j+1]==0 then map[i][j]=100 end
          end
          if map[i+1] then
            if map[i+1][j-1]==0 then map[i][j]=100 end
          end
        end
        
        --shadows--------#
        if map[i][j] == 2 or map[i][j] == 10 or map[i][j] == 9 or map[i][j] == 8 or map[i][j] == 3 or map[i][j] == 11 or map[i][j]==1 then
          
          if map[i+1]~= nil then 
            table.insert(shadows[tostring(map[i][j])],{j*16,(i*16)+16}) --pos of shadow
          end
          
        end
        
      end
    end
  end
  
  return map,shadows
  
end

function generate_map(grid_w, grid_h, tile_w, tile_h, range , depth)
  
  math.randomseed(os.clock())
  
  local map={}
  
  for y=0, grid_h, tile_h do
    local layer = {}
    for x=0, grid_w, tile_w do
      table.insert(layer,1)
    end
    table.insert(map,layer)
  end
  
  
  local start_x, start_y = math.floor(#map[1]/2), math.floor(#map/2)
  
  for _t_=0 ,depth do
    local current_x, current_y = start_x, start_y
    local previous_direction=0
    for i=0,range do
      
      local direction = math.random(1,4) -- 1 = up , 2= down , 3 = left 4= right
      
      if direction == 1 and previous_direction ~= 2 then current_y = current_y+1
      elseif direction == 2 and previous_direction ~= 1 then current_y = current_y-1 
      elseif direction == 3 and previous_direction ~= 4 then current_x = current_x-1
      elseif direction == 4 and previous_direction ~= 3 then current_x = current_x+1 end
      
      if current_x<2 then current_x=2 end
      if current_y<2 then current_y=2 end
      if current_x > #map[1]-1 then current_x= current_x-1 end
      if current_y > #map-1 then current_y= current_y-1 end
      
      if map[current_y][current_x]~=0 then 
          map[current_y][current_x]=0
      end
      
      previous_direction=direction
      
    end
  end
  
  map,shadows= tile_and_shadows_Arrangement(map,shadows)
    
  return map,shadows
  
end

return generate_map,tile_and_shadows_Arrangement