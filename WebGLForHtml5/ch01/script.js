window.onload = setupWebGL;
var gl = null;

function setupWebGL() {
    var canvas = document.getElementById("my-canvas");
    try {
        gl = canvas.getContext("experimental-webgl");
    } catch(e) {

    }
    if (gl) {
        // set the clear color to red
        gl.clearColor(1.0, 0.0, 0.0, 1.0);
        gl.clear(gl.COLOR_BUFFER_BIT);
    }
    else {
        alert("Error: Your browser does not appear to support WebGL.");
    }
}
