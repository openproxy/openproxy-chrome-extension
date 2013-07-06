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
        regarde:
            coffee:
                files: '<%= project.source %>/scripts/*.coffee'
                tasks: ['coffee:compile']
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
                dest: '<%= project.target %>'
                privateKey: '~/.ssh/private_key.pem'

    # load all grunt tasks defined in package.json
    grunt.loadNpmTasks task for own task of grunt.config.get('pkg').
        devDependencies when task.indexOf('grunt-') is 0

    grunt.registerTask 'unpacked', ['clean', 'coffee:compile', 'copy']
    grunt.registerTask 'default', ['unpacked', 'regarde']
    grunt.registerTask 'pack', ['unpacked', 'crx']
