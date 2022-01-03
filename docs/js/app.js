(function () {
    var container = document.getElementById('container');

    var app = Elm.Wish.init({
        node: container,
        flags: {
            "puzzle": { "columns": 4, "rows": 4 },
            "image": { "src": "image/dynamo-small.png", "width": 1115, "height": 552 },
            "shuffle": { "minimum": 20, "maximum": 50 },
            "wish": { "message": "IyBEZSBiZXN0ZSB3ZW5zZW4gdm9vciAyMDIyCldpaiBraWprZW4gZXIgZGl0IGphYXIgd2VlciBuYWFyIHVpdCBvbSBzYW1lbiB0ZSB3ZXJrZW4gYWFuIG1vb2llIG9wbG9zc2luZ2VuIG9tIGRlIGVuZXJnaWV0cmFuc2l0aWUgdGUgcmVhbGlzZXJlbi4KCkRpdCBkb2VuIHdpaiBncmFhZyB6b25kZXIgZWxrYWFyIHVpdCBoZXQgb29nIHRlIHZlcmxpZXplbi4gSGV0IHppam4gaW1tZXJzIGRlIHZlcmJpbmRpbmdlbiBkaWUgaWV0cyB3YWFyZGV2b2wgbWFrZW4uCgpIZXQgRHluYW1vIHRlYW0gd2Vuc3QgaWVkZXJlZW4gZGFhcm9tIGhldCBiZXN0ZSB2b29yIGhldCBuaWV1d2UgamFhci4gV2lqIGhvcGVuIGRhdCBoZXQgZWVuIGVuZXJ2ZXJlbmQgamFhciB3b3JkdCB3YWFyIGVyIG1lZXIgcnVpbXRlIG9uc3RhYXQgb20gZGllIHZlcmJpbmRpbmcgdGUgem9la2VuIGVuIHRlIHZvcm1lbi4KClpvYWxzIGFsdGlqZAoKTWFkZSB3aXRoIDxzcGFuIGNsYXNzPSJoZWFydCI+JiMxMDA4NDs8L3NwYW4+IGJ5IER5bmFtbw==" },
            "hints": { "indices": false, "solveAfter": 10 }
        }
    });
})()