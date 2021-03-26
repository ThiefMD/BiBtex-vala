project('bibtex', ['vala', 'c'],
  default_options: [
    'default_library=shared',
  ],
  version: '0.0.1'
)

add_project_arguments(['--vapidir', join_paths(meson.current_source_dir(), 'vapi')], language: 'vala')

libbibtex_deps = [
  dependency('glib-2.0'),
  dependency('gobject-2.0'),
  dependency('gee-0.8'),
  dependency('gtk+-3.0')
]

subdir('vapi')
subdir('src')
subdir('tests')
