#version 300 es

layout(location = 0) in vec4 position;
layout(location = 1) in vec4 color;
out vec4 v_color;

uniform mat4 modelViewProjectionMatrix;

void main()
{
    // Simple passthrough shader
    v_color = vec4(1.0, 0.0, 0.0, 1.0); // red

    gl_Position = modelViewProjectionMatrix * position;
}
