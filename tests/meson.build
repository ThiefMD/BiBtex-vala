if get_option('build_tests')

  example_deps = libbibtex_deps + [ libbibtex_dep ]

  executable('hello-bibtex', 'hello-bibtex.vala',
    dependencies: example_deps,
    vala_args: [
        '--pkg=posix',
        '--vapidir=' + meson.source_root() + '/vapi'
        ],
    install: false
  )

endif
