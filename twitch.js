var BASE = "https://api.twitch.tv/kraken";

function request(verb, endpoint, obj, cb) {
    var xhr = new XMLHttpRequest();
    xhr.onreadystatechange = function() {
        if(xhr.readyState === XMLHttpRequest.DONE) {
            if(cb) {
                var res = JSON.parse(xhr.responseText.toString());
                cb(res);
            }
        }
    }
    xhr.open(verb, BASE + (endpoint?'/' + endpoint:''));
    xhr.setRequestHeader('Content-Type', 'application/json');
    xhr.setRequestHeader("Accept", "application/vnd.twitchtv.v2+json");
    var data = obj?JSON.stringify(obj):''
    xhr.send(data);
}

function get_featured_streams(cb) {
    request("GET", "/streams/featured?hls=true", null, cb);
}

