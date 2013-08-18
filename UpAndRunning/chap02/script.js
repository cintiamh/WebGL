document.onload = onLoad();

function onLoad() {
    var container = document.getElementById("container");

    var renderer = new THREE.WebGLRenderer();
    renderer.setSize(container.offsetWidth, container.offsetHeight);
    container.appendChild(renderer.domElement);

    var scene = new THREE.Scene();

    var camera = new THREE.PerspectiveCamera(45, container.offsetWidth / container.offsetHeight, 1, 4000);
    camera.position.set(0, 0, 3.3333);
    scene.add(camera);

    var geometry = new THREE.PlaneGeometry(1, 1);
    var mesh = new THREE.Mesh(geometry, new THREE.MeshBasicMaterial());
    scene.add(mesh);

    renderer.render(scene, camera);
}