#!/usr/bin/env perl
use strict;
use warnings;
use utf8;
use Text::Balanced qw(extract_bracketed);

binmode(STDIN,  ':encoding(UTF-8)');
binmode(STDOUT, ':encoding(UTF-8)');

my @months = ("", "janeiro","fevereiro","março","abril","maio","junho",
              "julho","agosto","setembro","outubro","novembro","dezembro");

my %allowed = map { $_ => 1 } qw(ultimo url titulo acessodata website lingua);

while (my $line = <STDIN>) {
    my $output = '';
    my $pos = 0;

    while ($pos < length($line)) {
        my $idx = index($line, '{{Citar web', $pos);
        last if $idx == -1;

        # append text before template
        $output .= substr($line, $pos, $idx - $pos);

        # extract balanced braces from here
        my ($template, $rest) = extract_bracketed(substr($line, $idx), '{}');
        unless ($template) {
            # fallback: copy rest of line and break
            $output .= substr($line, $idx);
            last;
        }

        $output .= process_template($template);
        $pos = $idx + length($template);
    }

    # append remaining text after last template
    $output .= substr($line, $pos);
    print $output;
}

sub process_template {
    my ($orig) = @_;
    my $inner = $orig;
    $inner =~ s/^\{\{Citar web\s*//;
    $inner =~ s/\}\}$//;
    $inner =~ s/^[[:space:]]*\|?//;
    $inner =~ s/[[:space:]]*$//;

    my %vals;
    my $unknown = 0;
    for my $part (split /\|/, $inner) {
        next if $part =~ /^[[:space:]]*$/;
        my ($k,$v) = split /=/, $part, 2;
        unless (defined $v) { $unknown=1; last }
        $k =~ s/^[[:space:]]+|[[:space:]]+$//g;
        $v =~ s/^[[:space:]]+|[[:space:]]+$//g;
        if (!$allowed{$k}) { $unknown=1; last }
        $vals{$k} = $v;
    }

    for my $req (qw(url titulo acessodata website)) {
        if (!exists $vals{$req} || $vals{$req} eq '') { $unknown=1; last }
    }

    return $orig if $unknown;

    my $ac = $vals{acessodata};
    if ($ac =~ /^(\d{4})-(\d{1,2})-(\d{1,2})$/) {
        my ($y,$m,$d) = ($1,int($2),int($3));
        my $mn = $months[$m] // $m;
        $ac = "$d de $mn de $y";
    }

    my $out = '';
    $out .= $vals{ultimo} . '. ' if (exists $vals{ultimo} && $vals{ultimo} ne '');
    $out .= '[' . $vals{url} . ' «' . $vals{titulo} . '»]. \'\''
          . $vals{website} . '\'\' Consultado em ' . $ac;
    return $out;
}

