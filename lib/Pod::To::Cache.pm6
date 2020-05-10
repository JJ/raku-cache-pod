use Pod::To::GenericCache;
use nqp;

unit class Pod::To::Cache; 

has $.precomp-repo;
has $.doc-dir;
has $.cache-dir;

submethod BUILD(Str :$doc-dir,  Str :$cache-dir) {
    sub write-final-slash ($s) { 
        my $has-final-slash = so $s ~~ /\/$/;
        if ($has-final-slash) {return $s};
        return $s~"/":  
    }

    $!doc-dir = write-final-slash($doc-dir);
    $!cache-dir = write-final-slash($cache-dir);

    $!precomp-repo = CompUnit::PrecompilationRepository::Default.new(
        :store(CompUnit::PrecompilationStore::File.new(:prefix($!cache-dir.IO))),
    );
}

method pod (Str :$pod-name ) {
    my $pod-file-path = $!doc-dir ~ $pod-name;
    my $have-pod-file-extension = so $pod-file-path ~~ /\.pod6$/;
    $pod-file-path = $pod-file-path ~ ".pod6" unless $have-pod-file-extension;

    my $handle = $!precomp-repo.try-load(
        CompUnit::PrecompilationDependency::File.new(
            :src($pod-file-path),
            :id(CompUnit::PrecompilationId.new-from-string($pod-file-path)),
            :spec(CompUnit::DependencySpecification.new(:short-name($pod-file-path))),
        ),
    );
    my $pod = nqp::atkey($handle.unit, '$=pod')[0];

}

method list-files () {return ();}