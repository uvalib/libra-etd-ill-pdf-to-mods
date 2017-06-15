#!/usr/bin/perl

eval '$'.$1.'$2;' while $ARGV[0] =~ /^([A-Za-z_0-9]+=)(.*)/ && shift;
			# process any FOO=bar switches

$, = ' ';		# set output field separator
$\ = "\n";		# set output record separator


my $lines = do { local $/ = <> };
$count0 = (@asplit = split(/([ \n\f]+)/, $lines, -1));
#print 'count0 = ' . $count0;
$inabstract = 0;
$afterabstract = 0;
$any_output = 0;

for ($i = 0; $i < $count0; $i+=2) 
{
    # find beginning of abstract
    if ($inabstract == 0 && $asplit[$i] =~ /A[Bb][Ss][Tt][Rr][Aa][Cc][Tt][^A-Za-z]*/ && ($asplit[$i-1] =~ /.*[\n\f].*/ || $asplit[$i+1] =~ /.*[\n\f].*/) )
    {
        $inabstract = 1;
        $output_buffer = "";
        $asplit[$i] = "";
        for ( $j = $i+1; $j < $count0; $j++ )
        {
            if ($asplit[$j] =~ /[A-Z].*/)
            {
                last;
            }
            else
            {
               $asplit[$j] = "";
            }
        }
    }
    #elsif ($inabstract == 0 && $asplit[$i-1] =~ /.*[\n\f].*[\n\f].*/ && $asplit[$i] =~ /K[Ee][Yy][Ww][Oo][Rr][Dd][Ss].*/)
    #{
        ## found keywords with out finding abstract
        #$guessed = 0;
        #for ($k = $i-2; $k > 0; $k--)
        #{
            #if ($asplit[$k] =~ /.*[\n\f].*[\n\f].*/ && $asplit[$k+1] =~ /[A-Z].*/ )
            #{
    ##           print "Guessing start of Abstract";
               #$i = $k-1;
               #$inabstract = 1;
               #$guessed = 1;
               #last;
            #}
        #}
        #if ($guessed == 1)
        #{
            #next;
        ##}
    #}
    #find end of abstract
    if ( $inabstract == 1)
    {
        if ($asplit[$i-1] =~ /.*[\n\f].*/ && $asplit[$i] =~ /^[0-9][.]?$/ && $asplit[$i+1] =~ /[ ]+/ && $asplit[$i+2] =~ /[A-Z0-9].*/ )
        { $afterabstract = 1; }
        if ($asplit[$i-1] =~ /.*[\n\f].*/ && $asplit[$i] =~ /^I[.]?$/ && $asplit[$i+1] =~ /[ ]+/ && $asplit[$i+2] =~ /[A-Z0-9].*/ )
        { $afterabstract = 1; }
        if ($asplit[$i-1] =~ /.*[\n\f].*[\n\f].*/ && $asplit[$i] =~ /I$/ && $asplit[$i+1] =~ /[ ]+/ && $asplit[$i+2] =~ /./ && $asplit[$i+4] =~ /[A-Z].*/ )
        { $afterabstract = 1; }
        if ($asplit[$i-1] =~ /.*[\n\f].*/ && $asplit[$i] =~ /This/ && $asplit[$i+2] =~ /work|research/) 
        { $afterabstract = 1; }
        if ($asplit[$i-1] =~ /.*[\n\f].*/ && $asplit[$i] =~ /Supported/ && $asplit[$i+2] =~ /in$/ && split[$i+4] =~ /part$/ )
        { $afterabstract = 1; }
        if ($asplit[$i-1] =~ /.*[\n\f].*/ && $asplit[$i] =~ /I[Nn][Dd][Ee][Xx]$/ && $asplit[$i+2] =~ /T[Ee][Rr][Mm][Ss]/ )
        { $afterabstract = 1; }
        if ($asplit[$i-1] =~ /.*[\n\f].*/ && $asplit[$i] =~ /Key[Ww]ords.*/ )         
        { $afterabstract = 1; }
        if ($asplit[$i-1] =~ /.*[\n\f].*/ && $asplit[$i] =~ /Key/ && $asplit[$i+2] =~ /[Ww].*/)         
        { $afterabstract = 1; }
        if ($asplit[$i-1] =~ /.*[\n\f].*/ && $asplit[$i] =~ /Categories/)                               
        { $afterabstract = 1; }
        if ($asplit[$i-1] =~ /.*[\n\f].*/ && $asplit[$i] =~ /C[Hh][Aa][Pp][Tt][Ee][Rr]/ && $asplit[$i-2] !~ "in" ) 
        { $afterabstract = 1; }
        if ($asplit[$i-1] =~ /.*[\n\f].*/ && $asplit[$i] =~ /I[Nn][Tt][Rr][Oo]/)                        
        { $afterabstract = 1; }
        if ($asplit[$i-1] =~ /.*[\n\f].*/ && $asplit[$i] =~ /A[Cc][Kk][Nn][Oo][Ww].*/)                    
        { $afterabstract = 1; }
        if ($asplit[$i-1] =~ /.*[\n\f].*/ && $asplit[$i] =~ /B[Aa][Cc][Kk][Gg][Rr].*/)                    
        { $afterabstract = 1; }
        if ($asplit[$i-1] =~ /.*[\n\f].*/ && $asplit[$i] =~ /T[Aa][Bb][Ll][Ee]/)                        
        { $afterabstract = 1; }
        if ($asplit[$i-1] =~ /.*[\n\f].*/ && $asplit[$i] =~ /C[Oo][Nn][Tt][Ee].*/)                        
        { $afterabstract = 1; }
        #if (($asplit[$i-1] =~ /.*[\n\f].*[\n\f].*/ || $asplit[$i-1] =~ /\f/ ) && $asplit[$i] =~ /[A-Z].*/ && $asplit[$i+2] =~ /[A-Z].*/)
        #{ $afterabstract = 1; }
        if ($asplit[$i-1] =~ /.*[\n\f].*/ && $asplit[$i] =~ /(J[Aa][Nn].*|F[Ee][Bb].*|M[Aa][Rr][Cc][Hh]|A[Pp][Rr].*|M[Aa][Yy]|J[Uu][NnLl].*|A[Uu][Gg].*|S[Ee][Pp][Tt].*|O[Cc][Tt].*|N[Oo][Vv].*|D[Ee][Cc].*)[,]?/ && $asplit[$i+2] =~ /[0-9].*/ )                        
        { $afterabstract = 1; }
    }
    if ($afterabstract == 1 && length($output_buffer) < 100)  { $inabstract = 0; $afterabstract = 0; $output_buffer = ""; }
    if ($inabstract == 0 || $afterabstract == 1) { next; }
    $asplit[$i] =~ s/\xE2\x80\x99/\x27/g; 
    $asplit[$i] =~ s/\xE2\x80\x94/ - /g; 
    $asplit[$i] =~ s/\xE2\x80\x9C/\x22/g; 
    $asplit[$i] =~ s/\xE2\x80\x9D/\x22/g; 
    $joined = 0;
    #print 'i = ', $i ,' asplit[i] = ', $asplit[$i];
    # dehyphenate
    if ($asplit[$i] =~ /.*[a-z]+[ ]?[\-~][ ]?$/)
    {
        #if ($verbose = 1) { print 'i = ', $i ,' asplit[i] = ', $asplit[$i]; } 
        if ($asplit[$i+1] == "[\n\f]") 
        {
            for ($j = $i + 2; $j < $count0; $j+=2) 
            {
                #print 'length(asplit[j]) = ' . length($asplit[$j]);
                if (length($asplit[$j]) > 1) 
                {
                    last;
                }
	    }
            #print 'i = ' . $i . 'j = ' . $j . ' length of asplit[j] = ' . length($asplit[$j]);
	    #print 'Joining ' . $asplit[$i] . ' and >' . $asplit[$j] . '<';
	    $asplit[$i] = substr($asplit[$i], 0, length($asplit[$i]) - 1) . $asplit[$j];
	    $asplit[$j] = '';
	    $joined = 1;
	}
    }
    # fix word [space] [apostrophe] [space] s
    if ($asplit[$i+2] =~ /^\'$/ && $asplit[$i+4] == 's')
    {
        $asplit[$i] = $asplit[$i] . $asplit[$i+2] . $apslit[$i+4];
        $asplit[$i+1] = '';
        $asplit[$i+2] = '';
        $asplit[$i+3] = '';
        $asplit[$i+4] = '';
    }
    if ($asplit[$i] =~ /.*\xEF\xAC[\x80\x81\x82\x83\x84\x85].*/ )
    {
        #print "trying to expand $asplit[$i]";
        $expanded = $asplit[$i];
        if ($expanded =~ /.*[\"\'].*/) { next; } 
        #print "pre-expanded = $expanded";
        $expanded =~ s/(.*)\xEF\xAC[\x80\x81\x82\x83\x84\x85](.*)/$1ff$2 $1fl$2 $1fi$2 $1ffl$2 $1ffi$2 $1ft$2 $1fr$2/g;
        #print "post-expanded= $expanded";
        @expand = split(/[ ]/, $expanded, -1);
        #print "expand = @expand";
        open(SPELL, "echo \"$expanded\" | aspell --dict-dir=/lib_content22/Bulk-import/bin/aspell6-en-7.1-0 -a | ");
        $o = 0;
        $options=<SPELL>;  #burn the first line
        $found = 0;
        while ($options=<SPELL>)
        {
        #    print "output= $options";
            if ($options =~ /^[*].*/)
            {
                $any_output = 1;
                $output_buffer .= $expand[$o].' ';
                $found=1;
                last; 
            }
            $o++;
        }
        close(SPELL);
        if ($found == 0)
        {
           $asplit[$i] =~ s/(.*)\xEF\xAC\x80(.*)/$1ff$2/g;
           $asplit[$i] =~ s/(.*)\xEF\xAC\x81(.*)/$1fi$2/g;
           $asplit[$i] =~ s/(.*)\xEF\xAC\x82(.*)/$1fl$2/g;
           $asplit[$i] =~ s/(.*)\xEF\xAC\x83(.*)/$1ffi$2/g;
           $asplit[$i] =~ s/(.*)\xEF\xAC\x84(.*)/$1ffl$2/g;
           $asplit[$i] =~ s/(.*)\xEF\xAC\x85(.*)/$1ft$2/g;
           $any_output = 1;
           $output_buffer .= $asplit[$i] . ' ';
        }
        #print $asplit[$i] . ' ';
    }
    elsif (length($asplit[$i]) > 0)
    {
        if($joined == 1 && length($asplit[$i]) == 0) 
        {
            $output_buffer .= 'What the What<<<<<<<<';
        }
        $any_output = 1;
        $output_buffer .= $asplit[$i] . ' ';
    }
}
if ( $any_output == 1 )
{
    $output_buffer .= "\n";
    printf $output_buffer;
}

