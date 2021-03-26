if get_option('shared_lib')
  libtype = 'shared_library'
else
  libtype = 'static_library'
endif

libbibtex_sources = [
  'BibTex.vala'
]


confh = configuration_data ()
confh.set_quoted('PACKAGE_LOCALE_DIR', join_paths(get_option('prefix'), get_option('datadir'), 'locale'))
confh.set_quoted('GETTEXT_PACKAGE', 'bibtex')
confh.set_quoted('VERSION', meson.project_version())
configure_file(output : 'config.h',
  configuration : confh)

inc_libh = include_directories ('.')
inc_libh_dep = declare_dependency (include_directories : inc_libh)

libbibtex = build_target('bibtex',
    sources: libbibtex_sources,
    dependencies: libbibtex_deps,
    override_options : [
      'debug=true',
      'strip=false',
    ],
    vala_args: [
        '--pkg=posix',
        '--vapidir=' + meson.source_root() + '/vapi'
        ],
    target_type: libtype,
    vala_header: 'bibtex.h',
    vala_vapi: 'bibtex.vapi',
    c_args: [ '-include', meson.current_build_dir() + '/config.h', '-w'],
    install_dir: [true, true, true],
    install: true,
)

libbibtex_dep = declare_dependency(
  include_directories: include_directories('.'),
            link_with: libbibtex,
)

pkg = import('pkgconfig')
pkg.generate(
    libraries: libbibtex,
      version: meson.project_version(),
         name: 'bibtex',
  description: 'Parse BibTex files.',
)
