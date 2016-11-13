require 'json'

class Place
  include ActiveModel::Model
  attr_accessor :id, :formatted_address, :location, :address_components

  def self.mongo_client
    Mongoid::Clients.default
  end

  def self.collection
    self.mongo_client[:places]
  end
  
  def self.load_all(f)
    h = JSON.parse(f.read)
    collection.insert_many(h)
  end

  def initialize(params)
    @id = params[:_id].to_s
    @address_components = []
    if params[:address_components]
      @address_components = params[:address_components].map{ |ac| AddressComponent.new(ac) }
    end
    @formatted_address = params[:formatted_address]
    @location = Point.new(params[:geometry][:geolocation])
  end

  def self.find_by_short_name(s)
    Place.collection.find({ "address_components.short_name" => s })
  end

  def self.to_places mcv
    mcv.map{ |v| Place.new(v) }
  end

  def self.find id
    _id = BSON::ObjectId.from_string(id)
    pl = collection.find(:_id => _id).first
    Place.new(pl) if pl
  end

  def self.all(offset=0, limit=nil)
    if limit
      docs = collection.find.skip(offset).limit(limit)
    else
      docs = collection.find.skip(offset)
    end
    docs.map { |doc| Place.new(doc) }
  end

  def destroy
    self.class.collection.find(:_id => BSON::ObjectId.from_string(@id)).delete_one
  end

  def self.get_address_components(sort=nil, offset=0, limit=nil)
    query = [
      { :$unwind  => '$address_components' },
      { :$project => { :_id=>1, :address_components=>1, :formatted_address=>1, :geometry => {:geolocation => 1} } }
    ]
    query << {:$sort  => sort} if sort
    query << {:$skip  => offset}
    query << {:$limit => limit} if limit
    Place.collection.aggregate(query)
  end

  def self.get_country_names
    Place.collection.aggregate([
      { :$unwind  => '$address_components'}, 
      { :$project => { :_id=>0, :address_components=> {:long_name => 1, :types => 1} } }, 
      { :$match   => { 'address_components.types' => "country" } },
      { :$group   => { :_id=>'$address_components.long_name', :count=>{:$sum=>1} } }
    ]).to_a.map {|h| h[:_id]}
  end

  def self.find_ids_by_country_code(code)
    Place.collection.aggregate([
      { :$unwind  => '$address_components' }, 
      { :$project => { :_id=>1, :address_components => {:short_name => 1, :types => 1} } }, 
      { :$match   => { 'address_components.short_name' =>  code} }
    ]).map {|h| h[:_id].to_s}
  end

  def self.create_indexes
    Place.collection.indexes.create_one({'geometry.geolocation' => Mongo::Index::GEO2DSPHERE})
  end

  def self.remove_indexes
    Place.collection.indexes.drop_one('geometry.geolocation_2dsphere')
  end

  def self.near(point, max_meters=nil)
    Place.collection.find(
      {'geometry.geolocation' => { '$near' => point.to_hash}.merge( max_meters ? {:$maxDistance => max_meters.to_i} : {} ) }
    )
  end

  def near(max_meters=nil)
    self.class.near(@location, max_meters).map{ |place| Place.new(place) }
  end

  def photos(offset=0, limit=0)
    self.class.mongo_client.database.fs.find(
      { "metadata.place" => BSON::ObjectId.from_string(@id) }
    ).map{ |photo| Photo.new(photo) }
  end
  
  def persisted?
    @id
  end

end