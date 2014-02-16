module.exports = (grunt) ->

    grunt.initConfig
        pkg: grunt.file.readJSON 'package.json'
        project:
            source: 'src/chrome-extension'
            transient: 'target/unpacked'
            target: 'target'
        clean:
            target: '<%= project.target %>'
        coffee:
            compile:
                expand: true
                cwd: '<%= project.source %>/scripts'
                src: ['*.coffee']
                dest: '<%= project.transient %>/scripts'
                ext: '.js'
        coffeelint:
            options:
                indentation:
                    value: 4
                max_line_length:
                    value: 120
                line_endings:
                    value: 'unix'
            source: ['gruntfile.coffee', '<%= project.source %>/scripts/*.coffee']
        watch:
            coffee:
                files: '<%= project.source %>/scripts/*.coffee'
                tasks: ['coffeelint', 'coffee:compile']
            resources:
                files: ['<%= project.source %>/*', '<%= project.source %>/images/*']
                tasks: ['copy']
        copy:
            target:
                expand: true
                cwd: '<%= project.source %>'
                src: ['**', '!**/*.coffee']
                dest: '<%= project.transient %>'
        bump:
            options:
                files: ['package.json', '<%= project.source %>/manifest.json'],
                commitMessage: '%VERSION%'
                tagName: '%VERSION%'
                tagMessage: '%VERSION%'
                pushTo: 'origin'
        crx:
            target:
                src: '<%= project.transient %>'
                dest: '<%= project.target %>/<%= pkg.name %>-<%= pkg.version %>.crx'
                privateKey: '~/.ssh/openproxy-chrome-extension.pem'

    # load all grunt tasks defined in package.json
    grunt.loadNpmTasks task for own task of grunt.config.get('pkg').
        devDependencies when task.indexOf('grunt-') is 0

    grunt.registerTask 'unpacked', ['clean', 'coffeelint', 'coffee:compile', 'copy']
    grunt.registerTask 'default', ['unpacked', 'watch']
    grunt.registerTask 'pack', ['unpacked', 'crx']
