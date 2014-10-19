gulp = require 'gulp'
coffee = require 'gulp-coffee'
gutil = require 'gulp-util'
watch = require 'gulp-watch'
slim = require 'gulp-slim'

gulp.task 'default', ['coffee', 'slim']

gulp.task 'watch', ->
  gulp.watch('./src/coffee/*.coffee', ['coffee'])
  gulp.watch('./src/slim/*.slim', ['slim'])

gulp.task 'coffee', ->
  gulp
    .src('./src/coffee/*.coffee')
    .pipe(coffee(bare: true)
    .on('error', gutil.log))
    .pipe gulp.dest('./dist/js/')

gulp.task 'slim', ->
  gulp.src './src/slim/*.slim'
  .pipe slim pretty: true
  .pipe gulp.dest './dist/html/'
