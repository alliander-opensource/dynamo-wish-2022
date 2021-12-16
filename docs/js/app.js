(function () {
    var container = document.getElementById('container');

    var app = Elm.Wish.init({
        node: container,
        flags: {
            "puzzle": { "columns": 4, "rows": 4 },
            "image": { "src": "image/star.jpg", "width": 197, "height": 197 },
            "shuffle": { "minimum": 20, "maximum": 50 },
            "wish": { "message": "SGVsbG8sIFdvcmxkIQo=" },
            "hints": { "indices": false }
        }
    });
})()