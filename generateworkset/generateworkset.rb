
  TEMPDIR='tmp'

  #
  # get a mapping of the work ids and supporting file(s)
  #
  def get_mapping_list( filename )
    res = {}

    File.open( filename ).each do |line|
      tokens = line.split( "," )
      next if tokens.length < 2

      fname = tokens[ 0 ]
      id = tokens[ 1 ]
      if res.include?( id )
        res[ id ] << fname unless res[ id ].include? fname
      else
        res[ id ] = [ fname ]
      end
    end

    return res
  end

  #
  # create workset file using the provided id, metadata and asset file names
  #
  def create_workset( dirname, id, metadata_name, asset_names )

    f = File.join( dirname, "#{id}.workset" )
    File.open( f, 'w') do |file|
      file.write( "metadata : #{metadata_name}\n" )
      asset_names.each do |a|
        file.write( "asset : #{a}\n" )
      end
    end

  end

  #
  # create the workset files
  #
  def create_all_worksets( dirname, maps )

    maps.each do|id, assets|

      puts "Creating workset file for #{id} with #{assets.length} asset(s)"
      assets = assets.map { |a| "#{a}.pdf" }
      metadata_file = "#{assets[ 0 ]}.xml"
      create_workset( dirname, id, metadata_file, assets )
    end
  end

  def usage( )
    puts "use: ruby #{$PROGRAM_NAME} <mapping file> <work directory>"
    exit( 0 )
  end

  #
  # main entry point
  #
  if __FILE__ == $PROGRAM_NAME

    # check arguments
    map_file = ARGV[ 0 ]
    usage( ) if map_file.nil?

    working_dir = ARGV[ 1 ]
    usage( ) if working_dir.nil?

    if File.exists?( map_file ) == false
      puts "ERROR: file #{map_file} does not exist or is not readable, aborting"
      exit( 1 )
    end

    if Dir.exists?( working_dir ) == false
      puts "ERROR: directory #{working_dir} does not exist or is not readable, aborting"
      exit( 1 )
    end

    # get a map of the ids and corresponding files
    maps = get_mapping_list( map_file )
    #maps.each do |k, v|
    #  puts "==> #{k} -> #{v}"
    #end

    # create the workset files
    create_all_worksets( working_dir, maps )

  end

  exit( 0 )