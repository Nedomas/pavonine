gulp = require 'gulp'
gutil = require 'gulp-util'
watch = require 'gulp-watch'
coffeeify = require 'gulp-coffeeify'
concat = require 'gulp-concat'
uglify = require 'gulp-uglify'
rename = require 'gulp-rename'
mocha = require 'gulp-mocha'
chai  = require 'chai'
sinon = require 'sinon'
sinonChai = require 'sinon-chai'

gulp.task 'default', ['build']

gulp.task 'watch', ->
  gulp.watch('./src/coffee/**/*.coffee', ['coffee'])
  gulp.watch('./node_modules/**/*.js', ['coffee'])
  gulp.watch('./test/**/*.coffee', ['test'])

gulp.task 'coffee', ->
  gulp
    .src('./src/coffee/pavonine.coffee')
    .pipe(coffeeify())
    .pipe(gulp.dest('./dist/js/'))

  gulp
    .src('./src/coffee/core.coffee')
    .pipe(coffeeify())
    .pipe(gulp.dest('./dist/js/'))

gulp.task 'ugly', ->
  gulp
    .src('./src/coffee/pavonine.coffee')
    .pipe(coffeeify())
    .pipe(uglify())
    .pipe(rename('pavonine.min.js'))
    .pipe(gulp.dest('./dist/js/'))

  gulp
    .src('./src/coffee/core.coffee')
    .pipe(coffeeify())
    .pipe(uglify())
    .pipe(rename('core.min.js'))
    .pipe(gulp.dest('./dist/js/'))

gulp.task 'test', ->
  chai.use(sinonChai)
  global.expect = chai.expect
  gulp.src('./spec/**/*.coffee', read: false)
  .pipe(mocha(
    reporter: 'spec'
  ).on("error", gutil.log))

gulp.task 'build', ['coffee', 'ugly', 'watch']
