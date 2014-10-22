use strict;
use warnings;

use Test::More 0.96;

use Test::Fatal;
use Data::Handle;

my $id = 0;

sub checkisa {
  my ( $exception, @types ) = @_;
  my $needdiag = 0;
  $id++;
  subtest "checkisa $id" => sub {
    note explain \@types;

    for my $type (@types) {
      $needdiag = 1
        unless isa_ok( $exception, $type, 'Expected Exception Type ' . $type );
    }
    diag($exception) if $needdiag;
  };
}

use lib 't/lib';
use Data;

my ( $handle, $e );

isnt(
  $e = exception {
    Data::Handle->_get_data_symbol('Data_That_Isn\'t_there');
  },
  undef,
  '_get_data_symbol Fails if DATA is not there'
);

checkisa(
  $e,
  (
    'Data::Handle::Exception::Internal::BadGet',
    'Data::Handle::Exception::Internal',
    'Data::Handle::Exception',
  )
);

isnt(
  $e = exception {
    Data::Handle->_get_start_offset('Data_That_Really_Isn\'t_there');
  },
  undef,
  '_get_start_offset Fails if DATA is not there.'
);

checkisa(
  $e,
  (
    'Data::Handle::Exception::Internal::BadGet',
    'Data::Handle::Exception::Internal',
    'Data::Handle::Exception',
  )
);

isnt(
  $e = exception {
    Data::Handle->_is_valid_data_tell('Data_That_Really_Isn\'t_there_at_all');
  },
  undef,
  '_is_valid_data_tell Fails if DATA is not there.'
);

checkisa(
  $e,
  (
    'Data::Handle::Exception::Internal::BadGet',
    'Data::Handle::Exception::Internal',
    'Data::Handle::Exception',
  )
);

isnt(
  $e = exception {
    Data::Handle->new('Data')->_readline( 1, 2, 3 );
  },
  undef,
  '_readline Fails with params'
);

checkisa(
  $e,
  (
    'Data::Handle::Exception::API::Invalid::Params',
    'Data::Handle::Exception::API::Invalid',
    'Data::Handle::Exception::API',
    'Data::Handle::Exception',
  )
);

isnt(
  $e = exception {
    Data::Handle->new('Data')->_read(1);
  },
  undef,
  '_read Fails with < 2 params'
);
checkisa(
  $e,
  (
    'Data::Handle::Exception::API::Invalid::Params',
    'Data::Handle::Exception::API::Invalid',
    'Data::Handle::Exception::API',
    'Data::Handle::Exception',
  )
);

isnt(
  $e = exception {
    Data::Handle->new('Data')->_read( 1, 2, 3, 4 );
  },
  undef,
  '_read Fails with > 3 params'
);

checkisa(
  $e,
  (
    'Data::Handle::Exception::API::Invalid::Params',
    'Data::Handle::Exception::API::Invalid',
    'Data::Handle::Exception::API',
    'Data::Handle::Exception',
  )
);

isnt(
  $e = exception {
    Data::Handle->new('Data')->_getc(1);
  },
  undef,
  '_getc Fails with params'
);

checkisa(
  $e,
  (
    'Data::Handle::Exception::API::Invalid::Params',
    'Data::Handle::Exception::API::Invalid',
    'Data::Handle::Exception::API',
    'Data::Handle::Exception',
  )
);

isnt(
  $e = exception {
    Data::Handle->new('Data')->_seek(1);
  },
  undef,
  '_seek Fails with params !=2'
);

checkisa(
  $e,
  (
    'Data::Handle::Exception::API::Invalid::Params',
    'Data::Handle::Exception::API::Invalid',
    'Data::Handle::Exception::API',
    'Data::Handle::Exception',
  )
);

isnt(
  $e = exception {
    Data::Handle->new('Data')->_seek( 1, 4 );
  },
  undef,
  '_seek Fails with whences not 0-2'
);

checkisa(
  $e,
  (
    'Data::Handle::Exception::API::Invalid::Whence',
    'Data::Handle::Exception::API::Invalid',
    'Data::Handle::Exception::API',
    'Data::Handle::Exception',
  )
);

isnt(
  $e = exception {
    Data::Handle->new('Data')->_tell(1);
  },
  undef,
  '_tell Fails with params'
);

checkisa(
  $e,
  (
    'Data::Handle::Exception::API::Invalid::Params',
    'Data::Handle::Exception::API::Invalid',
    'Data::Handle::Exception::API',
    'Data::Handle::Exception',
  )
);

isnt(
  $e = exception {
    Data::Handle->new('Data')->_eof(5);
  },
  undef,
  '_eof Fails with params other than (1)'
);

checkisa(
  $e,
  (
    'Data::Handle::Exception::API::Invalid::Params',
    'Data::Handle::Exception::API::Invalid',
    'Data::Handle::Exception::API',
    'Data::Handle::Exception',
  )
);

isnt(
  $e = exception {
    Data::Handle->new('Data')->_binmode();
  },
  undef,
  '_binmode Fails.'
);

checkisa(
  $e,
  (
    'Data::Handle::Exception::API::NotImplemented',
    'Data::Handle::Exception::API',
    'Data::Handle::Exception',
  )
);

for my $meth (qw( _open _close _printf _print _write )) {
  isnt(
    $e = exception {
      my $instance = Data::Handle->new('Data');
      my $method   = $instance->can($meth);
      $method->($instance);
    },
    undef,
    $meth . ' Fails'
  );

  checkisa(
    $e,
    (
      'Data::Handle::Exception::API::Invalid', 'Data::Handle::Exception::API',
      'Data::Handle::Exception',
    )
  );
}

isnt(
  $e = exception {
    my $instance = Data::Handle->new('Data');
    syswrite $instance, "hello";
  },
  undef,
  'syswrite $instance Fails'
);

checkisa(
  $e,
  (
    'Data::Handle::Exception::API::Invalid', 'Data::Handle::Exception::API',
    'Data::Handle::Exception',
  )
);

isnt(
  $e = exception {
    my $instance = Data::Handle->new('Data');
    print {$instance} "Hello";
  },
  undef,
  'print { $instance } Fails'
);

checkisa(
  $e,
  (
    'Data::Handle::Exception::API::Invalid', 'Data::Handle::Exception::API',
    'Data::Handle::Exception',
  )
);

isnt(
  $e = exception {
    my $instance = Data::Handle->new('Data');
    printf {$instance} "Hello %s", 'foo';
  },
  undef,
  'printf { $instance } Fails'
);

checkisa(
  $e,
  (
    'Data::Handle::Exception::API::Invalid', 'Data::Handle::Exception::API',
    'Data::Handle::Exception',
  )
);

isnt(
  $e = exception {
    my $instance = Data::Handle->new('Data');
    close $instance;
  },
  undef,
  'close $instance Fails'
);

checkisa(
  $e,
  (
    'Data::Handle::Exception::API::Invalid', 'Data::Handle::Exception::API',
    'Data::Handle::Exception',
  )
);

isnt(
  $e = exception {
    my $instance = Data::Handle->new('Data');
    binmode $instance, ':raw';
  },
  undef,
  'binmode $instance Fails'
);

checkisa(
  $e,
  (
    'Data::Handle::Exception::API::NotImplemented',
    'Data::Handle::Exception::API',
    'Data::Handle::Exception',
  )
);

isnt(
  $e = exception {
    my $instance = Data::Handle->new('Data');
    my $string   = "";
    open $instance, '<', \$string;
  },
  undef,
  'open $instance Fails'
);

checkisa(
  $e,
  (
    'Data::Handle::Exception::API::Invalid', 'Data::Handle::Exception::API',
    'Data::Handle::Exception',
  )
);

done_testing;
