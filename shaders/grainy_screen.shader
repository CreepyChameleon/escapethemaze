shader_type canvas_item;

uniform float noiselevel = 0.4;
uniform float rgbshiftlevel = 0.01;
uniform float ghostreflectionlevel = 0.03;
uniform bool bypass = false;

float rand(vec2 co){
	return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

void fragment()
{
	vec2 iResolution = 1.0 / SCREEN_PIXEL_SIZE;
	vec2 uv = FRAGCOORD.xy / iResolution.xy;

	float randomValue = rand(vec2(uv.x+sin(TIME), uv.y+cos(TIME)));
	float rgbShift = sin(TIME+randomValue)*rgbshiftlevel;

	if(randomValue > 0.95-ghostreflectionlevel)
		uv.x+=sin(TIME/5.0)*0.5;

	uv.y += (cos(TIME*randomValue)+0.5) * (randomValue*0.01);
	
	float colorr = texture(SCREEN_TEXTURE, vec2(uv.x, uv.y)).r;
	float colorg = texture(SCREEN_TEXTURE, vec2(uv.x, uv.y)).g;
	float colorb = texture(SCREEN_TEXTURE, vec2(uv.x, uv.y)).b;

	vec4 movieColor = vec4(colorr,colorg,colorb, 1.0);
	vec4 noiseColor = vec4(randomValue,randomValue,randomValue,1.0);

	if(randomValue > 0.55-ghostreflectionlevel)
		noiseColor = abs(noiseColor - 0.2);

	if(bypass)
		COLOR = texture(SCREEN_TEXTURE, FRAGCOORD.xy / iResolution.xy); 
	else
		COLOR = mix(movieColor, noiseColor, noiselevel);
}