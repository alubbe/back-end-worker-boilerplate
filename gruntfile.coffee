module.exports = (grunt) ->

  # Project configuration.
  grunt.initConfig
    coffee:
      app:
        expand: true
        cwd: 'src'
        src: ['**/*.coffee']
        dest: 'lib'
        ext: '.js'
        options:
          sourceMap: true
      tests:
        expand: true
        cwd: 'test'
        src: ['**/*.coffee']
        dest: 'test/lib'
        ext: '.js'
        options:
          sourceMap: true
    coffeelint:
      app: ['*.coffee', 'src/**/*.coffee', 'test/**/*.coffee']
      options:
        max_line_length:
          level: 'ignore'
        no_empty_param_list:
          level: 'error'
        no_stand_alone_at:
          level: 'error'
        arrow_spacing:
          level: 'error'
        empty_constructor_needs_parens:
          level: 'error'
        newlines_after_classes:
          level: 'error'
        space_operators:
          level: 'error'
    concurrent:
      tasks: ['watch', 'nodemon', 'node-inspector']
      options:
        logConcurrentOutput: true
    env:
      test:
        NODE_ENV: 'test'
    'node-inspector':
      custom:
        options:
          'web-port': 8080
          'web-host': 'localhost'
          'debug-port': 5858
          'save-live-edit': true
    mochaTest:
      test:
        options:
          reporter: 'spec'
          require: ['./test/test_setup']
          harmony: true
        src: ['test/lib/**/*.js']
      coverage:
        options:
          reporter: 'html-cov'
          quiet: true
          captureFile: './coverage/coverage.html'
          harmony: true
        src: ['test/lib/**/*.js']
    nodemon:
      dev:
        options:
          file: 'lib/server.js'
          args: []
          ignoredFiles: ['README.md', 'node_modules/**', '.DS_Store']
          watchedExtensions: ['js']
          watchedFolders: ['lib']
          debug: true
          nodeArgs: ['--debug', '--harmony']
          delayTime: 1
          env:
            PORT: 8000
          cwd: __dirname
    watch:
      app:
        files: '**/*.coffee'
        tasks: ['coffeelint', 'coffee']

  # These plugins provide necessary tasks.
  grunt.loadNpmTasks 'grunt-coffeelint'
  grunt.loadNpmTasks 'grunt-concurrent'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-env'
  grunt.loadNpmTasks 'grunt-mocha-test'
  grunt.loadNpmTasks 'grunt-nodemon'
  grunt.loadNpmTasks 'grunt-node-inspector'

  #Making grunt default to force in order not to break the project.
  grunt.option 'force', true

  # Default task(s).
  grunt.registerTask 'default', ['coffee', 'concurrent']

  # Test task.
  grunt.registerTask 'test', ['coffeelint', 'coffee', 'env:test', 'mochaTest']
