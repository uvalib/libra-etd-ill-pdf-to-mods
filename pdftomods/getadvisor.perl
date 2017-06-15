

use feature 'unicode_strings';
use utf8;
use open qw(:std :utf8);

$pages=0;
$has_advisor=0;
$after_candidacy=0;
$found_front=0;
$multi_name="(?<NAME>(((MD[.]?|Dr[s]?[.]?|[Pp]rof[.]?|[Pp]rofessor[s]?) )?([[:upper:]][-.'[:alpha:]]*( [[:upper:]][-.'[:alpha:]]*){1,3})(, )?([ ]?and )?)+)";

while ($_ = <STDIN>) 
{
    $found_front=0;
#    if (/my advisor/)   { print $_; }
    if (/\f/) { $pages++; }
    if (/Candidacy for the Degree/) { $after_candidacy=1; }
    if (/^[ ]*(Dr[s]?[.]?|[Pp]rof([.]|essor))[ ]+([[:upper:]][.[:alpha:]]*[ ]+[[:upper:]][-.'[:alpha:]]*([ ]+[[:upper:]][-.'[:alpha:]]*)*)[,]?[ ]*([(]?(([Dd]issertation|[Tt]hesis)?[ ]?([Mm]entor|([Cc]o[-~])?[Aa]dvis[oe]r|Chair|Committee Member))[)]?)$/ ) 
    { 
        print "Candidate Sentance (F1): $_";
        if ($has_advisor == 0) 
        {
            print "Advisor (cover page): $3\n";
            $has_advisor=1;
        }
        else
        {
            print "Committee (cover page): $3\n";
        }
        $found_front=1;
    }
    #  Susan Mintz, PhD., Co-Advisor
    elsif (/^[ ]*(Dr[s]?[.]?|[Pp]rof([.]|essor))?[ ]*([[:upper:]][.[:alpha:]]*[ ]+[[:upper:]][-.'[:alpha:]]*([ ]+[[:upper:]][-.'[:alpha:]]*)*)(, Ph[.]?D[.]?)?[,]?[ ]*([(]?(([Dd]issertation|[Tt]hesis)?[ ]?([Mm]entor|([Cc]o[-~])?[Aa]dvis[oe]r|[Cc]hair|[Cc]ommittee [Mm]ember|Professor of [[:alpha:]]*))[)]?)$/ ) 
    { 
        print "Candidate Sentance (F2): $_";
        if ($has_advisor == 0) 
        {
            print "Advisor (cover page): $3\n";
            $has_advisor=1;
        }
        else
        {
            print "Committee (cover page): $3\n";
        }
        $found_front=1;
    }
    #Advisor: Sara Dexter
    elsif (/^[ ]*([Cc]o[-~])?[Aa]dvis[oe]r[-:,][ ]*(Dr[s]?[.]?|[Pp]rof([.]|essor))?[ ]*([[:upper:]][.[:alpha:]]*[ ]+[[:upper:]][-.'[:alpha:]]*([ ]+[[:upper:]][-.'[:alpha:]]*)*)/ ) 
    { 
        print "Candidate Sentance (F3): $_";
        if ($has_advisor == 0) 
        {
            print "Advisor (cover page): $4\n";
            $has_advisor=1;
        }
        else
        {
            print "Committee (cover page): $4\n";
        }
        $found_front=1;
    }
    elsif ($pages < 2 && /^[ ]*(Dr[s]?[.]?|[Pp]rof([.]|essor))[ ]+([[:upper:]][.[:alpha:]]*[ ]+[[:upper:]][-.'[:alpha:]]*([ ]+[[:upper:]][-.'[:alpha:]]*)*)[ ]*([(]([Cc]o[-~])?[Aa]dvis[oe]r[)])?[^[:alpha:]]*$/ ) 
    { 
        print "Candidate Sentance (F4): $_";
        if ($has_advisor == 0) 
        {
            print "Advisor (cover page): $3\n";
            $has_advisor=1;
        }
        else
        {
            print "Committee (cover page): $3\n";
        }
        $found_front=1;
    }
    elsif ($after_candidacy && $pages < 1 && /^[ ]*([[:upper:]]([a-z]*|[.])[ ]+[[:upper:]]([a-z]*|[.])([ ]+[[:upper:]][-a-z.]*)*)[ ]*([(](co[-~])?[Aa]dvis[oe]r[)])$/ ) 
    { 
        print "Candidate Sentance (F5): $_";
        if ($has_advisor == 0) 
        {
            print "Advisor (cover page no Prof): $1\n";
            $has_advisor=1;
        }
        else
        {
            print "Committee (cover page no Prof): $1\n";
        }
        $found_front=1;
    }
    #elsif ($after_candidacy && $pages < 1 && /^[ ]*([[:upper:]]([a-z]*|[.])[ ]+[[:upper:]]([a-z]*|[.])([ ]+[[:upper:]][-a-z.]*)*)[ ]*([(](co[-~])?[Aa]dvis[oe]r[)])?$/ ) 
    #{ 
        #if ($has_advisor == 0) 
        #{
            #print "Advisor (cover page no Prof): $1\n";
            #$has_advisor=1;
        #}
        #else
        #{
            #print "Committee (cover page no Prof): $1\n";
        #}
        #$found_front=1;
    #}
    if ($found_front == 1)
    {
        next;
    }
    if (/[Mm]y (princip(al|le) |main )?(doctoral |dissertation |thesis )?advis[oe]r[,]? ((Dr[s]?[.]?|[Pp]rof[.]?|[Pp]rofessor[s]?) )?([[:upper:]][-.'[:alpha:]]*( [[:upper:]][-.'[:alpha:]]*){1,3})/ )    
    { 
        print "Candidate Sentance (A1): $_";
        print "Advisor (text): $6\n"; 
    }
    #  I would like to thank my advisors David Rekosh and Marie-Louise Hammarskjöld for their generous mentorship and guidance towards my project.
    # First, I would like to thank my thesis advisors Ira Bashkow and Daniel Lefkowitz for their patience and sage advice at every step along the way.
    elsif (/(two|[Mm]y) (former )?(thesis |research |dissertation |primary |academic )*(co[-~])?(mentor[s]?|advis[eo]r[s]?|supervisor[s]?)[,]? ((((Dr[s]?[.]?|[Pp]rof[.]?|[Pp]rofessor[s]?) )?([[:upper:]][-.'[:alpha:]]*( [[:upper:]][-.'[:alpha:]]*){1,3})(, )?([ ]?and )?)+)/)
    {
        $not_advisor = 0;
        print "Candidate Sentance (A2): $_";
        print "Candidate Fragment: $6\n";
        if ($2 eq "former ") {  $not_advisor = 1; } 
        $frag = $6;
        @advisors = split(/, and |, | and /, $frag);
        foreach my $loopvar (@advisors)
        {
            if ( $loopvar =~ /((Dr[s]?[.]?|[Pp]rof[.]?|[Pp]rofessor[s]?) )(.*)/ )
            {
                $loopvar = $3; 
            } 
            if ( $not_advisor == 1) { print "NOT "; }
            print "Committe members: $loopvar\n";
        }
    }
    #  A special thank you goes to my advisor, dissertation chair, and guardian angel, Dr. Elizabeth Merwin, for providing unparalleled ... 
    elsif (/[Mm]y advis[oe]r([,]? [-a-z ]*)*[,]? ((Dr[s]?[.]?|[Pp]rof[.]?|[Pp]rofessor[s]?) )?([[:upper:]][-.'[:alpha:]]*( [[:upper:]][-.'[:alpha:]]*){1,3})/ )    
    { 
        print "Candidate Sentance (A3): $_";
        print "Advisor (text): $4\n"; 
    }
    # I gratefully thank my supervisory committee, Dr. Howard Epstein, Dr. Bob Davis, Dr. Gerard Learmonth, Dr. Guy Larocque, and most importantly my committee chair and advisor, Dr. Herman H. Shugart for their time and effort.
    elsif (/[Mm]y ([a-z ]*)+and advis[oe]r([,]? [a-z ]*)*[,]? ((Dr[s]?[.]?|[Pp]rof[.]?|[Pp]rofessor[s]?) )?([[:upper:]][-.'[:alpha:]]*( [[:upper:]][-.'[:alpha:]]*){1,3})/ )    
    { 
        print "Candidate Sentance (A4): $_";
        print "Advisor (my xxxx and advisor, XXX): $5\n"; 
    }
    # I would like to thank Dr. Amy Bouton for her mentorship and support over the past several years
    elsif (/((Dr[s]?[.]?|[Pp]rof[.]?|[Pp]rofessor[s]?) )([[:upper:]][-.'[:alpha:]]*( [[:upper:]][-.'[:alpha:]]*){1,3}) for [ [:lower:]]* mentorship/ )    
    { 
        print "Candidate Sentance (A5): $_";
        print "Advisor (text): $3\n"; 
    }
    #   I would like to first thank my mentor, Dr. Victor Engelhard, for the time I have spent in his laboratory. 
    elsif (/[Mm]y (committee chairman|chair|(faculty )?mentor[s]?)(, [a-z ]*)*[,]? ((Dr[s]?[.]?|[Pp]rof[.]?|[Pp]rofessor[s]?) )?([[:upper:]][-.'[:alpha:]]*( [[:upper:]][-.'[:alpha:]]*){1,3})/ )    
    { 
        print "Candidate Sentance (A6): $_";
        print "Advisor (text): $6\n"; 
    }
    # To the chair, John Shepherd, who has read not only the body of my dissertation, but every last tiny Chinese character in the footnotes, I owe a great debt.
    elsif ($prev_sentence =~ /committee/ && /the chair, ((Dr[s]?[.]?|[Pp]rof[.]?|[Pp]rofessor[s]?) )?([[:upper:]][-.'[:alpha:]]*( [[:upper:]][-.'[:alpha:]]*){1,3})/)
    {
        print "Candidate Sentance (A7): $_";
        print "Advisor (text \"the chair\"'): $3\n";
    }
    # Thank you to Dr. Bob Nakamoto, my advisor
    # I am especially thankful to Dr. Doug DeSimone as my advisor for giving me great help and freedom to explore the frog world.
    elsif ( /((Dr[s]?[.]?|[Pp]rof[.]?|[Pp]rofessor[s]?)]?[.]? )?([[:upper:]][-.'[:alpha:]]*( [[:upper:]][-.'[:alpha:]]*){1,3})(, )?(as )?my (primary |thesis |dissertation |research |capstone |doctoral )?(former | undergraduate )?advisor/)
    {
        print "Candidate Sentence (A8): $_";
        if ( $8 eq "" ) 
        {
            print "Advisor (text \", my advisor\"'): $3\n";
        }
    }
    # Steve Plog chaired my dissertation committee along with committee members Rachel Most, Susan McKinnon, Paul Minnis, and Bethany Nowviskie and I am extraordinarily grateful for their infinite patience, support, and guidance.
    # I would like to thank Kodi Ravichandran for serving as the head of my committee as well as the other members, Jim Casanova, Joanna Goldberg, Barry Gumbiner, and Robert Kadner.
    elsif ( /((Dr[s]?[.]?|[Pp]rof[.]?|[Pp]rofessor[s]?) )?([[:upper:]][-.'[:alpha:]]*( [[:upper:]][-.'[:alpha:]]*){1,3}) ([ [:lower:]]*) my (dissertation |thesis |capstone )?committee/ )
    {
        print "Candidate Sentence (A9): $_";
        print "Advisor (text \", chaired my committee\"'): $3\n";
    }
    # I would like to thank Dr. Sidney Hecht for his guidance and support.
    elsif (/((to thank)|(thanks to)) ((Dr[s]?[.]?|[Pp]rof[.]?|[Pp]rofessor[s]?) )([[:upper:]][-.'[:alpha:]]*( [[:upper:]][-.'[:alpha:]]*){1,3}) ([a-z]+ )*(guidance)/)
    {
        print "Candidate Sentence (A10): $_";
        print "Advisor (text): $6\n"; 
    }
    # Under the direction of Glen Bull
    elsif (/[Uu]nder the (direction |guidance )of ((Dr[s]?[.]?|[Pp]rof[.]?|[Pp]rofessor[s]?) )?([[:upper:]][-.'[:alpha:]]*( [[:upper:]][-.'[:alpha:]]*){1,3})/)
    {
        print "Candidate Sentence (A11): $_";
        print "Advisor (under the direction of): $4\n"; 
    }
    # and to [Pp]rofessor Jennifer Wicke of the University of Virginia, advisor to this project, for inspiring faith in myself.
    elsif (/to ((Dr[s]?[.]?|[Pp]rof[.]?|[Pp]rofessor[s]?) )?([[:upper:]][-.'[:alpha:]]*( [[:upper:]][-.'[:alpha:]]*){1,3})( of [^,]*)?[,]? advis[eo]r (to|for|of)/)
    {
        print "Candidate Sentence (A12): $_";
        print "Advisor (to XXX advisor to ): $3\n"; 
    }
    # Dissertation Advisor: Jorge Secada
    elsif (/([Tt]hesis|[Dd]issertation) [Aa]dvis[eo]r[:,;][ ]?((Dr[s]?[.]?|[Pp]rof[.]?|[Pp]rofessor[s]?) )?([[:upper:]][-.'[:alpha:]]*( [[:upper:]][-.'[:alpha:]]*){1,3})/)
    {
        print "Candidate Sentence (A13): $_";
        print "Advisor : $4\n";
    }
    # I would most of all like to acknowledge Lucy Pemberton for being such a wonderful mentor.
    elsif (/((Dr[s]?[.]?|[Pp]rof[.]?|[Pp]rofessor[s]?) )?([[:upper:]][-.'[:alpha:]]*( [[:upper:]][-.'[:alpha:]]*){1,3}) for being ([ ,[:alpha:]]*)(mentor|advis[oe]r)/)
    {
        print "Candidate Sentence (A14): $_";
        if ($2 ne ""  || $6 ne "mentor")
        {
            print "Advisor (XXX for being ... mentor): $3\n";
        }
    }
    # I am grateful for the guidance David Waldner offered, ﬁrst, in the graduate seminar that sparked my interest in regime change, and then, as the chair of my committee.
    elsif (/((Dr[s]?[.]?|[Pp]rof[.]?|[Pp]rofessor[s]?) )?([[:upper:]][-.'[:alpha:]]*( [[:upper:]][-.'[:alpha:]]*){1,3}) ([ ,[:alpha:]]*)as the chair/)
    {
        print "Candidate Sentence (A15): $_";
        print "Advisor (XXX ... as the chair): $3\n";
    }
    # guidance and support of XXX
    elsif (/(guidance and support|support and guidance) of ((Dr[s]?[.]?|[Pp]rof[.]?|[Pp]rofessor[s]?) )?([[:upper:]][-.'[:alpha:]]*( [[:upper:]][-.'[:alpha:]]*){1,3})/)
    {
        print "Candidate Sentence (A16): $_";
        print "Advisor (guidance and support of XXX): $4\n";
    }
    elsif (/[Aa]dvis[oe]r/)
    {
        print "Candidate Sentance: $_";
    }

    # Committee Members
    #  I would also like to thank my thesis committee members; Dr. Marcia McDuffie, Dr. Klaus Ley, Dr. Timothy Bender, Dr. Timothy Bullock, and Dr. Loren Erickson for t
    # I would like to begin by thanking my committee members: Lisa Reilly, my advisor, Louis Nelson, Richard Guy Wilson, John Dobbins, and Stephen Driscoll.
    if (/(the|[Mm]y) (thesis |dissertation |capstone )?committee member[s]?[-,:; ]*((((MD[.]?|Dr[s]?[.]?|[Pp]rof[.]?|[Pp]rofessor[s]) )?([[:upper:]][-.'[:alpha:]]*( van| der?)?( [[:upper:]][-.'[:alpha:]]*){1,3})(, )?([ ]?and |[ ]?my advisor, )?)+)/)
    {
        print "Candidate Sentence (C1): $_";
        print "Candidate Fragment: $3\n";
        $frag = $3;
        @members = split(/, and |, | and /, $frag);
        foreach my $loopvar (@members)
        {
            if ( $loopvar =~ /((MD[.]?|Dr[s]?[.]?|[Pp]rof[.]?|[Pp]rofessor[s]?) )(.*)/ )
            {
                $loopvar = $3; 
            } 
            if ( $loopvar =~ /([[:upper:]][-.'[:alpha:]]*( van| der?)?( [[:upper:]][-.'[:alpha:]]*){1,3})/ )
            { 
                $loopvar = $1;
                print "Committe members: $loopvar\n";
            }
        }
    }
    # First and foremost, I would like to thank my doctoral committee, Jeffrey Hantman, Stephen Plog, Patricia Wattenmaker, and Bethany Nowviskie for their ...
    # I am most grateful to the members of my committee – Dr. Gorav Ailawadi, Dr. Gary K. Owens, Dr. Gilbert R. Upchurch Jr., 
    #      Dr. Avril V. Somlyo, and Dr. Nobert Leitinger for their time, encouragement, and expertise throughout this work.
    # I also want to thank the members of my dissertation committee: Dinko Počanić, Kent Paschke, Simonetta Liuti, and Slava Krushkal.
    # Thanks to my advisory committee Linda Blum, Karen McG|athery, and Patricia Wiberg.
    # I also want to thank the other members of my dissertation committee, from the University of Virginia, Peter Ochs, Cindy Hoehler-Fatton and Elizabeth Thompson, for all of their helpful, thorough comments and suggestions.

    # In particular, I would like to thank my committee for their assistance (Dr. James Demas, Dr. Jill Venton, Dr. Ralph Allen and Dr. Patrick Grant).
    # I would like to thank my entire dissertation committee: Drs. Ann Beyer, Dan Engel, Patrick Grant, Bryce Paschal, and past members Mitch Smith and Gary Kupfer, for their advice and guidance during the past several years.
    elsif (/(members of )?[Mm]y (entire )?(doctoral |graduate |thesis |dissertation |capstone |supervisory |advisory )*committee( for [, [:lower:]]*| consisting of |[,]? from [- &[:alpha:]]*)?[-(,–:; ]*((((Dr[s]?[.]?|[Pp]rof[.]?|[Pp]rofessor[s]?) )?([[:upper:]][-.'[:alpha:]]*( [[:upper:]][-.'[:alpha:]]*){1,3})(, )?([ ]?and )?)+)/)
    #elsif (/(members of )?my (graduate |thesis |dissertation |capstone |supervisory |advisory )?committee( for [, [:lower:]]*| consisting of)?[-(,–:; ]*$multiname/)
    {
        print "Candidate Sentence (C2): $_";
        print "Candidate Fragment: $5\n";
        $frag = $5;
        @members = split(/, and |, | and /, $frag);
        foreach my $loopvar (@members)
        {
            if ( $loopvar =~ /((Dr[s]?[.]?|[Pp]rof[.]?|[Pp]rofessor[s]?) )(.*)/ )
            {
                $loopvar = $3; 
            } 
            print "Committe members: $loopvar\n";
        }
    }
    # Steve Plog chaired my dissertation committee along with committee members Rachel Most, Susan McKinnon, Paul Minnis, and Bethany Nowviskie and I am extraordinarily grateful for their infinite patience, support, and guidance.
    # I would like to thank Kodi Ravichandran for serving as the head of my committee as well as the other members, Jim Casanova, Joanna Goldberg, Barry Gumbiner, and Robert Kadner.
    elsif (/(comm[t]?ittee|the other) mem[e]?ber[s]?[,:; ]*((((Dr[s]?[.]?|[Pp]rof[.]?|[Pp]rofessor[s]?) )?([[:upper:]][-.'[:alpha:]]*( [[:upper:]][-.'[:alpha:]]*){1,3})(, )?([ ]?and )?)+)/)
    {
        print "Candidate Sentence (C3): $_";
        print "Candidate Fragment: $2\n";
        $frag = $2;
        @members = split(/, and |, | and /, $frag);
        foreach my $loopvar (@members)
        {
            if ( $loopvar =~ /((Dr[s]?[.]?|[Pp]rof[.]?|[Pp]rofessor[s]?) )(.*)/ )
            {
                $loopvar = $3; 
            } 
            print "Committe members: $loopvar\n";
        }
    }
    # I also thank Paolo D'Odorico and Howard Epstein for serving on my committee, and their invaluable guidance on all of this work.
    # .... and Dr. Robert Emery for agreeing to join the dissertation committee.
    # Patrick Meyer and Christian Steinmetz completed my committee.
    elsif (/(?<NAME>(((Dr[s]?[.]?|[Pp]rof[.]?|[Pp]rofessor[s]?) )?([[:upper:]][-.'[:alpha:]]*( [[:upper:]][-.'[:alpha:]]*){1,3})(, )?([ ]?and )?)+)[,]?[ ]?(members of |served |for serving |for agreeing to join |agreed to serve |completed )?(as |on )?(the|my)( dissertation| thesis| capstone)?( committee| (co-)?chair)+/)
    {
        print "Candidate Sentence (C4): $_";
        print "Candidate Fragment: $1\n";
        print "Candidate Fragment(named): $+{NAME}\n";
        $frag = $+{NAME};
        @members = split(/, and |, | and /, $frag);
        foreach my $loopvar (@members)
        {
            if ( $loopvar =~ /((Dr[s]?[.]?|[Pp]rof[.]?|[Pp]rofessor[s]?) )(.*)/ )
            {
                $loopvar = $3; 
            } 
            print "Committe members: $loopvar\n";
        }
    }
    # I would also like to thank to Frank Warnock, a committee member, who has generously given his time, comments and encouragement.
    elsif (/((((Dr[s]?[.]?|[Pp]rof[.]?|[Pp]rofessor[s]?) )?([[:upper:]][-.'[:alpha:]]*( [[:upper:]][-.'[:alpha:]]*){1,3})(, )?([ ]?and )?)+)[,]?[ ]? (a )?committee member/)
    {
        print "Candidate Sentence (C5): $_";
        print "Candidate Fragment: $1\n";
        $frag = $1;
        @members = split(/, and |, | and /, $frag);
        foreach my $loopvar (@members)
        {
            if ( $loopvar =~ /((Dr[s]?[.]?|[Pp]rof[.]?|[Pp]rofessor[s]?) )(.*)/ )
            {
                $loopvar = $3; 
            } 
            print "Committe members: $loopvar\n";
        }
    }
    # I want to acknowledge the time and commitment of my committee members, my first reader Dorothy Schafer and invaluable help throughout my 
    #     career as a graduate student, Keith Kozminski, always so funny and available, Jim Casanova for his insightful comments during my meetings and 
    #     Ray and Barry for stepping in when required.
    # I was very fortunate not only to benefit from the input of my committee but also from the perspectives and insight of other Anthropology Department faculty.
    elsif (/(my committee|committee member[s]?)[,:;]+[ ,[:lower:]]*((((Dr[s]?[.]?|[Pp]rof[.]?|[Pp]rofessor[s]?) )?([[:upper:]][-.'[:alpha:]]*( [[:upper:]][-.'[:alpha:]]*){1,3})[ ,[:lower:]]*)+)/)
    {
        print "Candidate Sentence (C6): $_";
        print "Candidate Fragment: $2\n";
        $frag = $2;
        @members = split(/, and |, | and /, $frag);
        foreach my $loopvar (@members)
        {
            if ( $loopvar =~ /((Dr[s]?[.]?|[Pp]rof[.]?|[Pp]rofessor[s]?) )(.*)/ )
            {
                $loopvar = $3; 
            } 
            if ( $loopvar =~ /([[:upper:]][-.'[:alpha:]]*( [[:upper:]][-.'[:alpha:]]*){1,3})/ )
            { 
                $loopvar = $1;
                print "Committe members: $loopvar\n";
            }
        }
    }
    # I would also like to thank my other readers, Sophie Rosenfeld and Carrie Douglass, for their careful attention and insightful questions.
    elsif (/my other readers[,]? ((((Dr[s]?[.]?|[Pp]rof[.]?|[Pp]rofessor[s]?) )?([[:upper:]][-.'[:alpha:]]*( [[:upper:]][-.'[:alpha:]]*){1,3})(, )?([ ]?and )?)+)/)
    {
        print "Candidate Sentence (C7): $_";
        print "Candidate Fragment: $1\n";
        $frag = $1;
        @members = split(/, and |, | and /, $frag);
        foreach my $loopvar (@members)
        {
            if ( $loopvar =~ /((Dr[s]?[.]?|[Pp]rof[.]?|[Pp]rofessor[s]?) )(.*)/ )
            {
                $loopvar = $3; 
            } 
            print "Committe members: $loopvar\n";
        }
    }
    # I am grateful to Dan Bell, John Milbank, Kenneth Surin, Corey Walker, Charles Marsh, and Slavoj i ek, who served as readers for this dissertation.
    # I am also grateful for the help of Karen Parshall, who, like my advisor, read multiple drafts of my dissertation.
    elsif (/((((Dr[s]?[.]?|[Pp]rof[.]?|[Pp]rofessor[s]?) )?([[:upper:]][-.'[:alpha:]]*( [[:upper:]][-.'[:alpha:]]*){1,3})(, )?([ ]?and )?)+).*who(, [- [:lower:]]*,)? (read|served as readers)/)
    {
        print "Candidate Sentence (C8): $_";
        print "Candidate Fragment: $1\n";
        $frag = $1;
        @members = split(/, and |, | and /, $frag);
        foreach my $loopvar (@members)
        {
            if ( $loopvar =~ /((Dr[s]?[.]?|[Pp]rof[.]?|[Pp]rofessor[s]?) )(.*)/ )
            {
                $loopvar = $3; 
            } 
            print "Committe members: $loopvar\n";
        }
    }
    elsif (/committee member/)
    {
        print "Candidate Sentance: $_";
    }
    $prev_sentence = $_;
}


