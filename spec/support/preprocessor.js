var coffee = require('coffee-script');

var Preprocessor = {
  process: function(src, path) {
    if (path.match(/\.coffee$/)) {
      return coffee.compile(src, {'bare': true});
    }

    return src;
  }
};

module.exports = Preprocessor;
