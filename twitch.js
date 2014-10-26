var BASE = "https://api.twitch.tv/kraken";

function request_json(verb, base, endpoint, obj, cb) {
    var xhr = new XMLHttpRequest();
    xhr.onreadystatechange = function() {
        if(xhr.readyState === XMLHttpRequest.DONE) {
            if(cb) {
                var res = JSON.parse(xhr.responseText.toString());
                cb(res);
            }
        }
    }
    xhr.open(verb, base + (endpoint?'/' + endpoint:''));
    xhr.setRequestHeader('Content-Type', 'application/json');
    xhr.setRequestHeader("Accept", "application/vnd.twitchtv.v2+json");
    var data = obj?JSON.stringify(obj):''
    xhr.send(data);
}

function request_uri(verb, base, endpoint, obj, cb) {
    var xhr = new XMLHttpRequest();
    xhr.onreadystatechange = function() {
        if(xhr.readyState === XMLHttpRequest.DONE) {
            if(cb) {
                var res = xhr.responseText.toString();
                cb(res);
            }
        }
    }
    xhr.open(verb, base + (endpoint?'/' + endpoint:''));
    var data = obj?JSON.stringify(obj):''
    xhr.send(data);
}

function get_featured_streams(cb) {
    request_json("GET", BASE, "streams/featured?hls=true", null, cb);
}

function get_stream_url(channel, cb) {
    request_json("GET", "http://api.twitch.tv/api", "channels/" + channel + "/access_token", null, function(e) {
        request_uri("GET", "http://usher.twitch.tv", "select/" + channel + ".json?nauthsig=" + encodeURIComponent(e.sig) + "&nauth=" + encodeURIComponent(e.token) + "&allow_source=true", null, function(f) {
            print(f);
        });
    });
}
