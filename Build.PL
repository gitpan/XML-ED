use Module::Build;
my $build = Module::Build->new
(
    module_name => 'XML::ED',
    c_source => 'lib/XML/ED/',
);

$build->create_build_script;
