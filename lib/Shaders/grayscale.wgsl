@group(0) @binding(0)
var inputTexture: texture_2d<f32>;

@group(0) @binding(1)
var outputTexture: texture_storage_2d<rgba8unorm, write>;

@compute @workgroup_size(8, 8)
fn main(@builtin(global_invocation_id) gid: vec3<u32>) {
    let dims = textureDimensions(inputTexture, 0);

    // Prevent out-of-bounds writes
    if (gid.x >= dims.x || gid.y >= dims.y) {
        return;
    }

    let coord = vec2<i32>(gid.xy);

    // Read input pixel
    let color = textureLoad(inputTexture, coord, 0);

    // Convert to grayscale (luminance)
    let gray =
          0.299 * color.r +
          0.587 * color.g +
          0.114 * color.b;

    let grayColor = vec4<f32>(gray, gray, gray, color.a);

    // Write result
    textureStore(outputTexture, coord, grayColor);
}
