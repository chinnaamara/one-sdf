module.exports = (grunt) ->
  (require 'load-grunt-tasks')(grunt)

  grunt.registerTask 'default', ['concurrent:default']
  grunt.registerTask 'build', ['concurrent:lib']

  grunt.initConfig
    coffee:
      compileJoined:
        options:
          join: true
        files:
          'build/js/app.js': 'app/src/**/*.coffee'

    jade:
      compile:
        options:
          client: false
          pretty: true
        files: [{
          cwd: 'app/src/jade'
          src: ['**/*.jade', '!index.jade']
          dest: 'build/html/'
          expand: true
          ext: '.html'
        },{
          cwd: 'app/src/jade'
          src: ['index.jade']
          dest: 'build/'
          expand: true
          ext: '.html'
        }]

    cssmin:
      combine:
        files:
          'build/css/lib.min.css' : [
            'bower_components/bootstrap/dist/css/bootstrap.min.css',
            'bower_components/bootstrap/dist/css/bootstrap-theme.min.css',
            'bower_components/bootstrapValidator/dist/css/bootstrapValidator.min.css'
          ]
    , 'build/css/all.min.css' : 'app/src/**/*.css'

    copy:
      main:
        files:
          [
            {
              flatten: true
              src: ['bower_components/bootstrap/dist/fonts/*']
              expand: true
              dest: 'build/fonts/'
            },
            {
              flatten: true
              src: ['app/src/images/*']
              expand: true
              dest: 'build/images/'
            }
          ]

    concat:
      options:
        separator: ';'
      dist:
        src: ['bower_components/jquery/dist/jquery.js'
        , 'bower_components/angular/angular.js'
        , 'bower_components/firebase/firebase.js'
        , 'bower_components/bootstrap/dist/js/bootstrap.js'
        , 'bower_components/lodash/dist/lodash.compat.js'
        , 'bower_components/angular-ui-router/release/angular-ui-router.js'
        , 'bower_components/angularfire/angularfire.js'
        ]
        dest: 'build/js/lib.min.js'

    karma:
      spec:
        configFile: 'karma.conf.js'
        autoWatch: true

    connect:
      server:
        options:
          port: 8080
          base: ['build/']
          keepalive: true
          livereload: true

    watch:
      jade:
        files: ['app/src/jade/**/*.jade']
        tasks: ['jade']

      coffee:
        files: ['app/src/coffee/**/*.coffee']
        tasks: ['coffee']

      css:
        files: ['app/src/css/**/*.css']
        tasks: ['cssmin']

      options:
        spawn: true
        livereload: true

    concurrent:
      default: ['jade', 'coffee', 'copy', 'connect', 'watch']
      lib: ['concat', 'cssmin', 'copy', 'jade', 'coffee', 'connect', 'watch']
      options:
        logConcurrentOutput: true
