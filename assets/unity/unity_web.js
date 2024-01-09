var mainUnityInstance;

window['handleUnityMessage'] = function (params) {
    window.parent.postMessage({
        name: 'onUnityMessage',
        data: params,
    }, '*');
};

window['handleUnitySceneLoaded'] = function (name, buildIndex, isLoaded, isValid) {
    window.parent.postMessage({
        name: 'onUnitySceneLoaded',
        data: {
            'name': name,
            'buildIndex': buildIndex,
            'isLoaded': isLoaded == 1,
            'isValid': isValid == 1,
        }
    }, '*');
};

window.parent.addEventListener('unityFlutterBiding', function (args) {
    const obj = JSON.parse(args.data);
    mainUnityInstance.SendMessage(obj.gameObject, obj.methodName, obj.message);
});

window.parent.addEventListener('unityFlutterBidingFnCal', function (args) {
    mainUnityInstance.SendMessage('GameManager', 'HandleWebFnCall', args);
});

let unityInstance;

var unityScript = document.createElement('script');

function createUnityNative(canvasName) {
    // unityScript.onload = function () {
    // };
    // unityScript.src = "unity/Build/UnityLibrary.loader.js";
    // document.body.appendChild(unityScript);

    try {
        let element = document.querySelector("#" + canvasName);
        if (element == null) return;

        // if (unityInstance != null) unityInstance = null;
        if (unityInstance == null) {
            createUnityInstance(element, {
                dataUrl: "unity/Build/UnityLibrary.data.unityweb",
                frameworkUrl: "unity/Build/UnityLibrary.framework.js.unityweb",
                codeUrl: "unity/Build/UnityLibrary.wasm.unityweb",
                streamingAssetsUrl: "StreamingAssets",
                companyName: "Seerslab",
                productName: "AvatarViewer",
                productVersion: "0.1",
                // matchWebGLToCanvasSize: false, // Uncomment this to separately control WebGL canvas render size and DOM element size.
                // devicePixelRatio: 1, // Uncomment this to override low DPI rendering on high DPI displays.
            }).then(onSuccess).catch(onError);
        }

    } catch (e) {
    }
}

function onSuccess(instance) {
    unityInstance = instance;
}

function onError() {
    console.log("error");
}

document.body.addEventListener('DOMNodeRemoved', (e) => {
        if (e.target.innerHTML && e.target.innerHTML.search(/flt-platform-view/)) {
            console.log('platform view removed');
            // deleteUnityNative();

            // unityInstance = null;
        }
    }
);

function removeJS(filename) {
    var tags = document.getElementsByTagName('script');
    for (var i = tags.length; i >= 0; i--) {
        if (tags[i] && tags[i].getAttribute('src') != null
            && tags[i].getAttribute('src').startsWith(filename)) {
            console.log('platform view removed2');
            tags[i].parentNode.removeChild(tags[i]);
        }
    }
}

function deleteUnityNative() {
    try {
        if (unityInstance != null) {
            unityInstance.Quit().then(function() {
                console.log("quit");
                unityInstance = null;
                // removeJS("blob");
            });
            // unityInstance = null;
            // removeJS("blob");
        } else {
            // removeJS("blob");
        }
    } catch (e) {
    }
}