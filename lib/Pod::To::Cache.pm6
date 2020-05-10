use Pod::To::GenericCache;
use nqp;

unit class Pod::To::Cache; 

has $.precomp-repo;

submethod BUILD(Str :$dir) {
    $!precomp-repo = CompUnit::PrecompilationRepository::Default.new(
        :store(CompUnit::PrecompilationStore::File.new(:prefix($dir.IO))),
    );
}

method pod (Str :$pod-file-path ) {
    my $handle = $!precomp-repo.try-load(
        CompUnit::PrecompilationDependency::File.new(
            :src($pod-file-path),
            :id(CompUnit::PrecompilationId.new-from-string($pod-file-path)),
            :spec(CompUnit::DependencySpecification.new(:short-name($pod-file-path))),
        ),
    );
    my $pod = nqp::atkey($handle.unit, '$=pod');

}

method list-files () {return ();}