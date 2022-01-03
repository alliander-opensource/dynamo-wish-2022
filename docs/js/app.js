(function () {
    var container = document.getElementById('container');

    var app = Elm.Wish.init({
        node: container,
        flags: {
            "puzzle": { "columns": 4, "rows": 4 },
            "image": { "src": "image/dynamo-small.png", "width": 1115, "height": 552 },
            "shuffle": { "minimum": 20, "maximum": 50 },
            "wish": { "message": "IyBEZSBiZXN0ZSB3ZW5zZW4gdm9vciAyMDIyCldpaiBraWprZW4gZXIgZGl0IGphYXIgd2VlciBuYWFyIHVpdCBvbSBzYW1lbiB0ZSB3ZXJrZW4gYWFuIG1vb2llIG9wbG9zc2luZ2VuIG9tIGRlIGVuZXJnaWUgdHJhbnNpdGllIHRlIHJlYWxpc2VyZW4uCgpEaXQgZG9lbiB3aWogZ3JhYWcgem9uZGVyIGVsa2FhciB1aXQgaGV0IG9vZyB0ZSB2ZXJsaWV6ZW4uIEhldCB6aWpuIGltbWVycyBkZSB2ZXJiaW5kaW5nZW4gZGllIGlldHMgd2FhcmRldm9sIG1ha2VuLgoKSGV0IER5bmFtbyB0ZWFtIHdlbnN0IGllZGVyZWVuIGRhYXJvbSBoZXQgYmVzdGUgdm9vciBoZXQgbmlldXdlIGphYXIuIFdpaiBob3BlbiBkYXQgaGV0IGVlbiBlbmVydmVyZW5kIGphYXIgd29yZHQgd2FhciBlciBtZWVyIHJ1aW10ZSBvbnN0YWF0IG9tIGRpZSB2ZXJiaW5kaW5nIHRlIHpvZWtlbiBlbiB0ZSB2b3JtZW4uCgpab2FscyBhbHRpamQKCk1hZGUgd2l0aCA8c3BhbiBjbGFzcz0iaGVhcnQiPiYjMTAwODQ7PC9zcGFuPiBieSBEeW5hbW8=" },
            "hints": { "indices": false, "solveAfter": 10 }
        }
    });
})()