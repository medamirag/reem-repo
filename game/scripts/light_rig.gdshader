shader_type canvas_item;
// Light rig of one still picture (game/scripts/light_rig.gd): blink and mouth patches drawn over
// the picture, a swaying tail or ears, breathing and a small hop. The picture itself, its place
// and its size are never changed, so the room can still move it freely.

uniform vec2 canvas = vec2(1024.0, 1024.0);
uniform sampler2D eyes_tex : filter_linear;
uniform vec4 eyes_rect = vec4(0.0);  // left, top, width, height as fractions of the picture
uniform float blink = 0.0;
uniform sampler2D mouth_tex : filter_linear;
uniform vec4 mouth_rect = vec4(0.0);
uniform float mouth_on = 0.0;
uniform sampler2D extra_tex : filter_linear;  // tail or ears, same canvas as the picture
uniform float extra_on = 0.0;
uniform vec2 extra_anchor = vec2(0.0);  // in picture pixels
uniform float extra_angle = 0.0;
uniform float breath = 0.0;  // picture pixels the top rises
uniform float lift = 0.0;  // picture pixels the whole picture hops

varying vec4 tint;

void vertex() {
	tint = COLOR;
	VERTEX.y -= (1.0 - UV.y) * breath + lift;
}

vec4 patch(sampler2D tex, vec4 rect, vec2 uv) {
	vec2 at = (uv - rect.xy) / max(rect.zw, vec2(0.0001));
	if (at.x < 0.0 || at.y < 0.0 || at.x > 1.0 || at.y > 1.0) {
		return vec4(0.0);
	}
	return texture(tex, at);
}

void fragment() {
	vec4 c = texture(TEXTURE, UV);
	if (extra_on > 0.5) {
		// The tail (or ears) drawn in the picture is removed, then drawn again, turned.
		float was = texture(extra_tex, UV).a;
		vec2 p = UV * canvas - extra_anchor;
		float s = sin(-extra_angle);
		float k = cos(-extra_angle);
		vec2 q = (vec2(p.x * k - p.y * s, p.x * s + p.y * k) + extra_anchor) / canvas;
		vec4 e = vec4(0.0);
		if (q.x >= 0.0 && q.y >= 0.0 && q.x <= 1.0 && q.y <= 1.0) {
			e = texture(extra_tex, q);
		}
		// Where the turned piece no longer covers its old place: next to the body the old
		// pixels stay (no crack between tail and body); at the free edge they disappear.
		float keep = 0.0;
		if (was > 0.01 && e.a < 0.99) {
			vec2 reach = vec2(max(canvas.x, canvas.y) * 0.03) / canvas;
			for (int i = 0; i < 8; i++) {
				float turn = float(i) * 0.7853982;
				vec2 d = vec2(cos(turn), sin(turn)) * reach;
				for (int n = 1; n <= 2; n++) {
					vec2 u = UV + d * float(n) * 0.5;
					keep = max(keep, texture(TEXTURE, u).a * (1.0 - texture(extra_tex, u).a));
				}
			}
		}
		c.a *= 1.0 - was * (1.0 - keep);
		float a = e.a + c.a * (1.0 - e.a);
		c.rgb = a > 0.001 ? (e.rgb * e.a + c.rgb * c.a * (1.0 - e.a)) / a : c.rgb;
		c.a = a;
	}
	vec4 eyes = patch(eyes_tex, eyes_rect, UV);
	c.rgb = mix(c.rgb, eyes.rgb, eyes.a * blink);
	vec4 mouth = patch(mouth_tex, mouth_rect, UV);
	c.rgb = mix(c.rgb, mouth.rgb, mouth.a * mouth_on);
	COLOR = c * tint;
}
