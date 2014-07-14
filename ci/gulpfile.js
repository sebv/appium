"use strict";

var gulp = require('gulp'),
    path = require('path'),
    _ = require('underscore'),
    //spawn = require('child_process').spawn,
    spawn = require('gulp-spawn'),
    File = require('vinyl'),
    // Duplexer = require("plexer"),
    Stream = require('stream');

function tarBz2Src(targetTar) {
  var stream = new Stream.PassThrough({objectMode: true});
  var tarFile = new File({
    cwd: "/",
    base: "/",
    path: "/" + targetTar,
    contents: new Stream.PassThrough({objectMode: true})
  });
  stream.push(tarFile);
  stream.emit('end');
  return stream;
}



// function tarBzDirSrc(srcDir, targetTar) {
//   var resStream = new Stream.PassThrough({objectMode: true});

//   var tarFile = new File({
//     cwd: "/",
//     base: "/",
//     path: "/" + targetTar,
//     contents: new Stream.PassThrough({objectMode: true})
//   });

//   // directories to exclude
//   var exclusions = _([
//     '.git',
//     'submodules'
//   ]).map(function (dir) {
//     return '--exclude=' + dir;
//   });

//   // Generate arguments
//   var args = ['cjf','-','-L'];
//   args = args.concat(exclusions);
//   args.push("lib");
//   var env = _.clone(process.env);
//   // Execute tar
//   var _child = spawn('tar', args, {cwd: srcDir, env:env});
//   _child.stderr.pipe(process.stderr);
//   tarFile.contents = tarFile.contents
//     .pipe(new Duplexer(_child.stdin, _child.stdout));

//   resStream.push(tarFile);

//   // If there's an error running the process. See http://nodejs.org/api/child_process.html#child_process_event_error
//   _child.on('error', function (e) {
//     console.log(e.stack);
//     resStream.emit('error', new Error('upload-appium', e));
//   });
//   // When done...
//   _child.on('close', function (code) {
//     // If code is not zero (falsy)
//     if (code) {
//       resStream.emit('error', new Error('upload-appium', 'Mocha exited with code ' + code));
//     }
//     resStream.emit('end');
//   });
//   return resStream;
// }

// gulp.task('upload-appium', function () {
//   var appiumDir = path.resolve('..');

//   return tarBzDirSrc(appiumDir, 'bid.tar')
//     .pipe(gulp.dest('/tmp/bid'));
// });

gulp.task('upload-appium', function () {
  var appiumDir = path.resolve('..');

  // directories to exclude
  var exclusions = _([
    '.git',
    'submodules'
  ]).map(function (dir) {
    return '--exclude=' + dir;
  });

  // Generate arguments
  var args = ['cjf','-','-L'];
  args = args.concat(exclusions);
  args.push("lib");
  var env = _.clone(process.env);

  return tarBz2Src('bid.tar.bz2')
    .pipe(spawn('tar', args, {cwd:appiumDir, env:env }))
    .pipe(gulp.dest('/tmp/bid'));
});

