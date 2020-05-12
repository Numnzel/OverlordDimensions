// (C) 2019 Sterling Parker (aka "Caligari87")
// This software is provided 'as-is', without any express or implied warranty. In no event will the authors be held liable for any damages arising from the use of this software.
// 
// Permission is granted to anyone to use this software for any purpose, including commercial applications, and to alter it and redistribute it freely, subject to the following restrictions:
//
// 	The origin of this software must not be misrepresented; you must not claim that you wrote the original software. If you use this software in a product, an acknowledgment in the product documentation would be appreciated but is not required.
// 	Altered source versions must be plainly marked as such, and must not be misrepresented as being the original software.
// 	This notice may not be removed or altered from any source distribution.
//
// zlib License: https://opensource.org/licenses/Zlib
// Original source: https://gist.github.com/caligari87/daa5b127a3bc522794eb050067b5a95e

// ------------------------ //
// USER CONFIGURABLE VALUES //
// ------------------------ //

// Resolution reduction
// 4 = 1/4th screen resolution
int resfactor = 4;

// Enable horizontal and/or vertical scanlines
bool hscan = true;
bool vscan = false;

// Color filter
// Values are the relative strengths of the RGB channels
// Filter colors are normalized so don't worry about unbalanced values
// All zeros means greyscale / monochrome filter
// Whiteclip is how white the brightest areas are. This can be negative.
vec3 posfilter = normalize(vec3(0.00, 1.0, 0.75)); // primary NVG color (positive exposure)
vec3 negfilter = normalize(vec3(1.0, 0.0, 0.0)); // secondary NVG color (negative exposure)
float whiteclip = 1.0;

// ----------------------------------- //
// USER CONFIGURABLE VALUES STOP HERE  //
// ----------------------------------- //

// Custom nitevision shader for HD by Caligari87
void main(){
	// Uniforms from script
	float exp = abs(exposure);
	float expcurve = 3.0 * ((125.0 - abs(exposure)) / 125.0);
	exp = exp / expcurve;

	// Limit resfactor
	resfactor = max(resfactor, 1);

	// Downsample coordinate system
	vec2 res = TexCoord;
	res *= textureSize(InputTexture,0).xy / resfactor;
	res = vec2(int(res.x),int(res.y));
	res /= textureSize(InputTexture,0).xy / resfactor;

	// Scanlines are 1 real pixel black;
	// No scanlines if resfactor = 1
	if(hscan && (resfactor > 1) && (int(TexCoord.y * textureSize(InputTexture,0).y) % resfactor == 0)){
		FragColor = vec4(0,0,0,0);
		return;
	}
	if(vscan && (resfactor > 1) && (int(TexCoord.x * textureSize(InputTexture,0).x) % resfactor == 0)){
		FragColor = vec4(0,0,0,0);
		return;
	}

	// Get pixels and
	vec3 color  = texture(InputTexture, res).rgb;

	// Desaturate and multiply
	color = mix(vec3(dot(color.rgb, vec3(0.56, 0.3, 0.14))), color.rgb, 0.0);
	color *= max(exp, 1.0);

	// Clamp
	color = vec3(
		clamp(color.r, 0.0, 1.0),
		clamp(color.g, 0.0, 1.0),
		clamp(color.b, 0.0, 1.0));

	// Filter channels for preferred color
	if (exposure > 0) { color *= clamp(posfilter + (color * whiteclip), 0.0, 1.0); }
	if (exposure < 0) { color *= clamp(negfilter + (color * whiteclip), 0.0, 1.0); }

	// Output
	FragColor = vec4(color, 1.0);
}