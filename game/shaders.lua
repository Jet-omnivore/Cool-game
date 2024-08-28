shader = love.graphics.newShader[[
    float WhiteFactor = 1.0;
    
    vec4 effect(vec4 vcolor, Image tex, vec2 texcoord, vec2 pixcoord)
    {
        vec4 outputcolor = Texel(tex, texcoord) * vcolor;
        outputcolor.rgb += vec3(WhiteFactor);
        return outputcolor;
    }
    ]]
  
light_shader_code = 
[[
  
  #define NUM_LIGHTS 32
  
  struct Light {
    vec2 position;
    vec3 diffuse;
    float power;
  };
  
  
  extern Light lights[NUM_LIGHTS];
  extern int num_lights;
  
  extern vec2 screen;
  
  const float constant = 1.0;
  const float linear = 0.09;
  const float quadratic = 0.032;
  
  
  vec4 effect (vec4 color, Image image, vec2 uvs, vec2 screen_cords){
    
    vec4 pixel = Texel(image, uvs);
    
    vec2 norm_screen = screen_cords / screen;
    vec3 diffuse = vec3(0);
    float distance;
    
    for (int i = 0; i < num_lights; i++){
      Light light = lights[i];
      vec2 norm_pos = light.position / screen;
      
      distance = length(norm_pos - norm_screen) * light.power;
      float attenuation = 1.0/(constant * linear * distance * quadratic * (distance * distance));
      
      diffuse += light.diffuse * attenuation ;
    }
    diffuse = clamp(diffuse, 0.6, 1.0/(clamp(distance, 4.5, 5.0)/5.0));
    return pixel * vec4(diffuse, 1.0);
  }
  
]]
