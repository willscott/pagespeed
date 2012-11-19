var page = require('webpage').create(),
    t, address;

if (phantom.args.length === 0) {
    console.log('Usage: loadspeed.js <some URL>');
    phantom.exit();
} else {
    t = Date.now();
    address = phantom.args[0];
    setTimeout(function() {
      console.log('FAIL page never loaded');
      phantom.exit();
    }, 100000);
    page.open(address, function (status) {
        if (status !== 'success') {
            console.log('FAIL to load the address');
        } else {
            t = Date.now() - t;
            console.log(t);
        }
        phantom.exit();
    });
}
