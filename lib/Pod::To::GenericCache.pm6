use nqp;

unit role Pod::To::GenericCache;

has $.precomp-repo;
method pod (Str :$name) { ... };
method list-files (--> List ) { ... }
