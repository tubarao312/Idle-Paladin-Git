//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;

uniform float width;
uniform float height;
uniform vec3 COLOUR;

void main()
{
    float alpha0 = texture2D( gm_BaseTexture, v_vTexcoord ).a;
	
	float alpha1 = texture2D( gm_BaseTexture, vec2(v_vTexcoord.x-width,v_vTexcoord.y)).a;
    float alpha2 = texture2D( gm_BaseTexture, vec2(v_vTexcoord.x+width,v_vTexcoord.y)).a;
    float alpha3 = texture2D( gm_BaseTexture, vec2(v_vTexcoord.x,v_vTexcoord.y-height)).a;
    float alpha4 = texture2D( gm_BaseTexture, vec2(v_vTexcoord.x,v_vTexcoord.y+height)).a;
	
	bool drawOutline = (((alpha1+alpha2+alpha3+alpha4) > 0.0) && (alpha0 == 0.0));
	
	if (drawOutline == true) {
		gl_FragColor = vec4(COLOUR,1.0);
	} else {
		gl_FragColor = texture2D( gm_BaseTexture, v_vTexcoord );
	}
}