module Vines
  class User


    include MongoMapper::Document
    set_collection_name "users"
    key :name, String #display name
    key :user_name,String # jid node
    key :password,String



    attr_accessor :jid,:roster


    def initialize(args={})
      @name = args[:name]
      @user_name = args[:user_name]
      @password = args[:password]
      @roster = args[:roster] || []
    end

  end
end