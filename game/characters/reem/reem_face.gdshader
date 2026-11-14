shader_type canvas_item;
// Blank only the measured baked-feature rectangles; source crops restore the exact
// neutral face. Alternate states keep the original silhouette alpha and anchors.
varying vec4 part_modulate;
void vertex() { part_modulate = COLOR; }
void fragment() {
 vec2 p = UV * vec2(1254.0);
 vec4 c = texture(TEXTURE, UV);
 float original_alpha = c.a;
 if (p.x >= 680.0 && p.x < 757.0 && p.y >= 194.0 && p.y < 283.0) {
  vec4 left_skin = texture(TEXTURE, vec2(675.0, p.y) / 1254.0);
  vec4 right_skin = texture(TEXTURE, vec2(760.0, p.y) / 1254.0);
  c = mix(left_skin, right_skin, (p.x - 680.0) / 77.0);
 }
 if (p.x >= 732.0 && p.x < 775.0 && p.y >= 311.0 && p.y < 335.0) {
  float t = clamp((p.y - 311.0) / 24.0, 0.0, 1.0);
  vec2 a = vec2(min(p.x, 770.0), 308.0) / 1254.0;
  vec2 b = vec2(min(p.x, 770.0), 338.0) / 1254.0;
  c = mix(texture(TEXTURE, a), texture(TEXTURE, b), t);
 }
 c.a = original_alpha;
 COLOR = c * part_modulate;
}
