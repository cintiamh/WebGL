var container, camera, scene, renderer, material;

function init() {
    container = document.getElementById("container");
    container.style.width = window.innerWidth + "px";
    container.style.height = window.innerHeight + "px";

    camera = new THREE.PerspectiveCamera(45, window.innerWidth / window.innerHeight, 1, 1000);
    camera.position.z = 700;

    scene = new THREE.Scene();

    scene.add(camera);

    renderer = new THREE.WebGLRenderer({antialias: true});
    renderer.setSize(window.innerWidth, window.innerHeight);

    container.appendChild(renderer.domElement);

    var cube = new THREE.Mesh(
        new THREE.CubeGeometry(50,50,50),
        new THREE.MeshBasicMaterial({color: 0xFF0000})
    );
    //scene.add(cube);

    // Spline curve

    var p1 = new THREE.Vector3(-150, 0, 0);
    var p2 = new THREE.Vector3(200, 3, 10);

    console.log(isVector3());

    drawCurve(p1, p2, 12);

    p3 = new THREE.Vector3(0, -10, 140);
    p4 = new THREE.Vector3(0, -10, -140);

    drawCurve(p3, p4);

    /*var geometry = new THREE.Geometry();
    var n_sub = 9;
    var position, index, colors = [];

    var points = [
        new THREE.Vector3(-150, 0, 0),
        new THREE.Vector3(0, 150, 0),
        new THREE.Vector3(150, 0, 0)
    ]
    var p1 = new THREE.Vector3(-150, 0, 0);
    var p2 = new THREE.Vector3(150, 0, 0);
    var dist = distance(p1, p2);
    var midPoint = findMidPoint(p1, p2);
    console.log(midPoint);

    var spline = new THREE.QuadraticBezierCurve3(points[0], points[1], points[2]);

    for (var i = 0; i < points.length * n_sub; i++) {
        index = i / (points.length * n_sub);
        position = spline.getPoint(index);
        geometry.vertices[i] = new THREE.Vector3(position.x, position.y, position.z);
        colors[i] = new THREE.Color(0xFF0000);
        //colors[i].setHSL(0.6, 1.0, Math.max(0, -position.x / 200) + 0.5);
    }

    geometry.colors = colors;
    //geometry.computeLineDistances();

    //material = new THREE.LineBasicMaterial({color: 0xFFFFFF, opacity: 1, linewidth: 3, vertexColors: THREE.VertexColors});
    material = new THREE.LineDashedMaterial({color: 0x841F27, dashSize: 2, gapSize: 0.5, linewidth: 3});

    var line, p, scale = 0.3, d = 225;
    var parameters = [
        material, scale * 1.5, [0, 0, 0], geometry
    ]

    //line = new THREE.Line(geometry, material, THREE.LinePieces);
    line = new THREE.Line( geometry, material, THREE.LinePieces );
    line.scale.x = line.scale.y = line.scale.z = parameters[1];
    scene.add(line);

    //var pointLight = new THREE.PointLight(0xFFFFFF);

    //pointLight.position.x = 0;
    //pointLight.position.y = 100;
    //pointLight.position.z = 130;

    //scene.add(pointLight);
    renderer.render(scene, camera);*/
    renderer.render(scene, camera);
}

function distance(p1, p2) {
    if (p1 && p2) {
        return Math.sqrt(Math.pow(p1.x - p2.x, 2) + Math.pow(p1.y - p2.y, 2) + Math.pow(p1.z - p2.z, 2));
    }
    return 0;
}

function findMidPoint(p1, p2) {
    if (p1 && p2) {
        var dist = distance(p1, p2);
        var height = dist / 2;
        return new THREE.Vector3((p2.x + p1.x) / 2, (p2.y + p1.y) / 2 + height, (p2.z + p1.z) / 2);
    }
    return new THREE.Vector3(0, 0, 0);
}

function drawCurve(p1, p2, subdivisions) {
    var geometry = new THREE.Geometry();
    var n_sub = subdivisions ? subdivisions : 9;
    var position, index, colors = [];

    var midPoint = findMidPoint(p1, p2);

    var points = [p1, midPoint, p2];

    var spline = new THREE.QuadraticBezierCurve3(p1, midPoint, p2);

    for (var i = 0; i < points.length * n_sub; i++) {
        index = i / (points.length * n_sub);
        position = spline.getPoint(index);
        geometry.vertices[i] = new THREE.Vector3(position.x, position.y, position.z);
        colors[i] = new THREE.Color(0xFFFFFF);
        colors[i].setHSL(Math.max(0, -position.x / 200) + 0.5, 1.0, 0.3);
    }

    geometry.computeLineDistances();
    geometry.colors = colors;

    material = new THREE.LineDashedMaterial({
        color: 0xFFFFFF,
        dashSize: 5,
        gapSize: 2,
        vertexColors: THREE.VertexColors,
        depthTest: false
    });

    console.log(material.gapSize);

    var line = new THREE.Line( geometry, material, THREE.LineStrip );
    scene.add(line);
}

function isVector3(vec) {
    if (vec) {
        if (isNumber(vec.x) && isNumber(vec.y) && isNumber(vec.z)) {
            return true;
        }
    }
    return false;
}

function isNumber(n) {
    return !isNaN(parseFloat(n)) && isFinite(n);
}

function animate(t) {
    //camera.position.x = Math.sin(t/1000) * 300;
    //camera.position.y = 150;
    //camera.position.z = Math.cos(t/1000) * 300;
    camera.position.x = 150;
    camera.position.y = Math.sin(t/1000) * 300;
    camera.position.z = Math.cos(t/1000) * 300;

    camera.lookAt(scene.position);
    renderer.render(scene, camera);
    window.requestAnimationFrame(animate, renderer.domElement);
}

window.onload = function() {
    init();
    animate(new Date().getTime());
}



