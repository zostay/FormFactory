package Form::Factory::Feature::Role::BuildAttribute;
use Moose::Role;

requires qw( build_attribute );

=head1 NAME

Form::Factory::Feature::Role::BuildAttribute - control features that modify the action attribute

=head1 SYNOPSIS

  package MyApp::Feature::AddPredicate;
  use Moose;

  with qw(
      Form::Factory::Feature
      Form::Factory::Feature::Role::BuildAttribute
      Form::Factory::Feature::Role::Control
  );

  sub build_attribute {
      my ($class, $options, $meta, $name, $attr) = @_;
      $attr->{predicate} = 'has_' . $name;
  }

  package Form::Factory::Feature::Control::Custom::AddPredicate;
  sub register_implementation { 'MyApp::Feature::FillFromRecord' }

=head1 DESCRIPTION

Control features that implement this role are given the opportunity to directly modify the action attribute just before it is added to the meta-class. 

This is done by implementing the C<build_attribute> class method. This method will be passed a hash representing the feature arguments for this feature (since the feature will not yet exist as an object). It will then be passed the meta-class object, the name of the attribute being added, and a normalized hash of attribute parameters.

You may use these arguments to manipulate the attribute before it is created, create additional attributes, etc.

=head1 AUTHOR

Andrew Sterling Hanenkamp C<< <hanenkamp@cpan.org> >>

=head1 COPYRIGHT AND LICENSE

Copyright 2009 Qubling Software LLC.

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
