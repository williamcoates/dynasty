module.exports = (grunt) ->
  grunt.initConfig
    clean:
      main:
        src: 'dist'
    copy:
      files:
        cwd: 'src/'
        src: '**/*.{html,css}'
        dest: 'dist/'
        expand: true
    express:
      dev:
        options:
          script: 'dist/server.js'
    bower:
      install:
        options:
          targetDir: './dist/public/bower_components'
    coffee:
      compile:
        expand: true
        cwd: 'src/'
        src: ['**/*.coffee']
        dest: 'dist/'
        ext: '.js'
      compileTests:
        files: [ 'test/test.dynasty.js': ['test/src/**/*.coffee'] ]    
    coffeelint:
      app: ['src/**/*.coffee']
      options:
        max_line_length:
          level: "ignore"
    shell:
      publish:
        options:
          stdout: true
        command: 'npm publish'
    simplemocha:
      options:
        globals: ['should']
        timeout: 300
        ignoreLeaks: false
        ui: 'bdd'
        reporter: 'spec'
      all:
        src: ['test/**/*.js']
    watch:
      files: ['Gruntfile.coffee', 'src/**/*.coffee', 'test/src/**/*.coffee']
      tasks: ['coffeelint', 'coffee', 'simplemocha']

  grunt.loadNpmTasks 'grunt-coffeelint'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-simple-mocha'
  grunt.loadNpmTasks 'grunt-shell'
  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-contrib-copy'
  grunt.loadNpmTasks 'grunt-contrib-connect'
  grunt.loadNpmTasks 'grunt-express-server'
  grunt.loadNpmTasks 'grunt-bower-task'

  grunt.registerTask 'test', ['coffee', 'simplemocha']
  grunt.registerTask 'publish', ['coffee', 'shell:publish']
  grunt.registerTask 'default', ['clean', 'copy', 'coffee', 'bower', 'express', 'watch']
