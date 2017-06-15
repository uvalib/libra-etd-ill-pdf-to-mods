#!/usr/bin/env perl
use strict;
use warnings;
use Lingua::EN::Sentence qw(get_sentences add_acronyms);

sub normalize
{
    my($str) = @_;
    $str =~ s/\n/ /gm;
#    $str =~ s/\f/ /gm;
    $str =~ s/\t/ /gm;
    $str =~ s/\s\s+/ /gm;
    $str =~ s/ﬂ/fl/gm;
    $str =~ s/ﬁ/fi/gm;
    $str =~ s/([a-z])l<([a-z])/$1k$2/gm;
    return $str;
}

{
    add_acronyms('drs');
    local $/ = "\n\n";
    while (<>)
    {
        chomp;
#        print "Para: [[$_]]\n";
#        my @sentences = split m/(?<=[.!?])\s+/m, $_;
#        foreach my $sentence (@sentences)
#        {
#            $sentence = normalize $sentence;
#            print "$sentence\n";
#        }
       my $sref = get_sentences($_);
        foreach my $sentence (@$sref)
        {
            $sentence = normalize $sentence;
            print "$sentence\n";
        }
    }
}
