
  TEMPDIR='tmp'

  #
  # get a list of assets in the specified directory that match the supplied pattern
  #
  def get_file_list( dirname, pattern )
    res = []
    begin
      Dir.foreach( dirname ) do |f|
        if pattern.match( f )
          res << f
        end
      end
    rescue => e
    end

    return res
  end

  #
  # extract the barcode from the specified filename
  #
  def barcode_from_filename( filename )
     return filename[ 0..9 ]
  end

  #
  # extract the external ID from the specified barcode
  #
  def id_from_barcode( barcode )
    f = File.join( TEMPDIR, "#{barcode}_index_out.txt" )
    File.open( f ).each do |line|
      if /^.* : id = /.match( line )
        id = /^.* : id = (.*)$/.match( line ).captures[ 0 ]
        return id
      end
    end
    return nil
  end

  #
  # return the asset filename given the metadata filename
  #
  def asset_filename_from_metadata_filename( filename )
    return filename.gsub( '.xml', '' )
  end

  #
  # return the metadata filename given the asset filename
  #
  def metadata_filename_from_asset_filename( filename )
    return "#{filename}.xml"
  end

  #
  # process each xml file and create a set of unique (external) ids
  #
  def build_id_set( files )

    ids = {}

    files.each do |f|
      bc = barcode_from_filename( f )
      id = id_from_barcode( bc )
      next if id.nil?
      if ids[ id ].nil?
        ids[ id ] = [ asset_filename_from_metadata_filename( f ) ]
      else
        ids[ id ] << asset_filename_from_metadata_filename( f )
      end
    end

    return ids
  end

  #
  # create workset file using the provided metadata and asset file names
  #
  def create_workset( dirname, metadata_name, asset_names )

    bc = barcode_from_filename( metadata_name )
    f = File.join( dirname, "#{bc}.workset" )
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
  def create_all_worksets( dirname, files, ids )

    files.each do|f|
      bc = barcode_from_filename( f )
      id = id_from_barcode( bc )
      if id.nil?
        puts "IGNORING #{f}!!!"
        next
      end
      assets = ids[ id ]

      if assets.length == 1
        puts "Creating workset file for #{f} with 1 asset"
        create_workset( dirname, f, assets )
      else
        if f == metadata_filename_from_asset_filename( assets.last )
          puts "Creating workset file for #{f} with #{assets.length} assets"
          create_workset( dirname, f, assets )
        end
      end
    end
  end

  #
  # main entry point
  #
  if __FILE__ == $PROGRAM_NAME

    # check arguments
    working_dir = ARGV[ 0 ]
    if working_dir.nil?
      puts "use: ruby #{$PROGRAM_NAME} <work directory>"
      exit( 0 )
    end

    if Dir.exists?( working_dir ) == false
      puts "ERROR: directory #{working_dir} does not exist"
      exit( 1 )
    end

    # get a list of XML files
    files = get_file_list( working_dir, /^.*\.xml$/ )

    # build a list of id's to handle multi-volumes
    ids = build_id_set( files )

    #ids.each do |k, v|
    #  puts "==> #{k} -> #{v}"
    #end
    # create the workset files
    create_all_worksets( working_dir, files, ids )

  end

  exit( 0 )