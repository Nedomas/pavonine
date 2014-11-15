gulp = require 'gulp'
gutil = require 'gulp-util'
watch = require 'gulp-watch'
browserify = require 'browserify'
coffeeify = require 'gulp-coffeeify'
source = require 'vinyl-source-stream'
concat = require 'gulp-concat'
uglify = require 'gulp-uglify'
rename = require 'gulp-rename'
jade = require 'gulp-jade'
sass = require 'gulp-sass'
mocha = require 'gulp-mocha'
chai  = require 'chai'

gulp.task 'default', ['build']

gulp.task 'watch', ->
  gulp.watch('./src/coffee/**/*.coffee', ['coffee'])
  gulp.watch('./node_modules/**/*.js', ['coffee'])
  gulp.watch('./src/jade/*.jade', ['jade'])
  gulp.watch('./src/scss/*.scss', ['sass'])
  gulp.watch('./test/**/*.coffee', ['test'])

gulp.task 'jade', ->
  gulp.src('./src/jade/*.jade')
  .pipe(jade({
    locals: {}
  }))
  .pipe(gulp.dest('./dist/html/'))

gulp.task 'sass', ->
  gulp.src('./src/scss/*.scss')
  .pipe(sass())
  .pipe(gulp.dest('./dist/css/'))

gulp.task 'coffee', ->
  gulp
    .src('./src/coffee/cornflake.coffee')
    .pipe(coffeeify())
    .pipe(gulp.dest('./dist/js/'))

  gulp
    .src('./src/coffee/compiler.coffee')
    .pipe(coffeeify())
    .pipe(gulp.dest('./dist/js/'))

gulp.task 'ugly', ->
  gulp
    .src('./src/coffee/cornflake.coffee')
    .pipe(coffeeify())
    .pipe(uglify())
    .pipe(rename('cornflake.min.js'))
    .pipe(gulp.dest('./dist/js/'))


gulp.task 'test', ->
  global.expect = chai.expect
  gulp.src('./test/**/*.coffee', read: false)
  .pipe(mocha(
    reporter: 'spec'
  ))

gulp.task 'build', ['coffee', 'jade', 'ugly', 'watch']
