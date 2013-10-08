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
                no_trailing_semicolons:
                    level: 'ignore' # ignoring until clutchski/coffeelint#147 is available in upstream
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
