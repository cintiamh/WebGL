var camera, scene, renderer;
var geometry, material;
var cube, light, litCube, planeGeo, planeMat, plane;

init();
//animate();

function init() {
    camera = new THREE.PerspectiveCamera(45, window.innerWidth / window.innerHeight, 1, 10000);
    camera.position.z = 300;

    scene = new THREE.Scene();

    light = new THREE.SpotLight(0xFFFFFF);
    light.castShadow = true;
    light.shadowDarkness = 0.5;
    light.position.set(170, 330, -160);
    scene.add(light);
    scene.shadowMapEnabled = true;

    cube = new THREE.Mesh(
        new THREE.CubeGeometry(50, 50, 50),
        new THREE.MeshBasicMaterial({ color: 0x000000 }));
    scene.add(cube);

    litCube = new THREE.Mesh(
        new THREE.CubeGeometry(50, 50, 50),
        new THREE.MeshLambertMaterial({color: 0xFFFFFF})
        //new THREE.MeshBasicMaterial({color: 0xFFFFFF})
    );
    litCube.position.y = 50;
    litCube.castShadow = true;
    litCube.receiveShadow = true;
    scene.add(litCube);

    planeGeo = new THREE.PlaneGeometry(400, 200, 10, 10);
    planeMat = new THREE.MeshLambertMaterial({color:0xFFFFFF});
    plane = new THREE.Mesh(planeGeo, planeMat);
    plane.rotation.x = -Math.PI/2;
    plane.rotation.y = -25;
    plane.receiveShadow = true;
    scene.add(plane);

    renderer = new THREE.CanvasRenderer();
    renderer.setSize( window.innerWidth, window.innerHeight );

    renderer.shadowMapEnabled = true;
    renderer.shadowMapSoft = true;

    document.body.appendChild(renderer.domElement);

    renderer.setClearColorHex(0xEEEEEE, 1.0);
    renderer.clear();
}

function animate(t) {

    litCube.position.x = Math.cos(t/600) * 85;
    litCube.position.y = 60 - Math.sin(t/900) * 25;
    litCube.position.z = Math.sin(t/600) * 85;
    litCube.rotation.x = t/500;
    litCube.rotation.y = t/800;

    camera.position.x = Math.sin(t/1000) * 300;
    camera.position.y = 150;
    camera.position.z = Math.cos(t/1000) * 300;

    camera.lookAt(scene.position);

    renderer.render(scene, camera);
    window.requestAnimationFrame(animate, renderer.domElement);
}

animate(new Date().getTime());
