gulp = require 'gulp'
gutil = require 'gulp-util'
watch = require 'gulp-watch'
slim = require 'gulp-slim'
browserify = require 'browserify'
coffeeify = require 'gulp-coffeeify'
source = require 'vinyl-source-stream'
concat = require 'gulp-concat'
uglify = require 'gulp-uglify'
rename = require 'gulp-rename'

gulp.task 'default', ['coffee']

gulp.task 'watch', ->
  gulp.watch('./src/coffee/**/*.coffee', ['coffee'])
  gulp.watch('./node_modules/**/*.js', ['coffee'])
  # gulp.watch('./src/slim/**/*.slim', ['slim'])

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

gulp.task 'build', ['coffee', 'slim', 'ugly']

gulp.task 'slim', ->
  gulp.src './src/slim/*.slim'
  .pipe slim pretty: true
  .pipe gulp.dest './dist/html/'
