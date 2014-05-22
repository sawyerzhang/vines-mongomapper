require_relative 'model/user'


module Vines
  class Storage
    class Mongomapper < Storage
      register :mongomapper

      %w[database tls username password pool].each do |name|
        define_method(name) do |*args|
          if args.first
            @config[name.to_sym] = args.first
          else
            @config[name.to_sym]
          end
        end
      end

      def initialize(&block)
        @config, @hosts = {}, []
        instance_eval(&block)
        raise "Must provide database" unless @config[:database]
        raise "Must provide at least one host connection" if @hosts.empty?
        connect
      end

      def host(name, port)
        pair = [name, port]
        raise "duplicate hosts not allowed: #{name}:#{port}" if @hosts.include?(pair)
        @hosts << pair
      end

      def find_user(jid)


        jid = JID.new(jid).bare.to_s
        return if jid.empty?

        #find a usr by it's bson id
        u = Vines::User.where(:_id=>jid_to_bson_id(jid)).first

        # find a user by it's name
        user_name = jid.split('@')[0]
        u = Vines::User.where(:user_name=>user_name).first unless u
        u.jid = JID.new(jid)if u
        u.roster=[] if u
        u

      end
      #
      # def save_user(user)
      #
      #   jid = user.jid.bare.to_s
      #   user_name = user.user_name
      #
      #   #find a user by name create a new if failed
      #   u = Vines::User.where(:user_name=>user_name).first
      #   u = Vines::User.new(jid:user.jid) unless u
      #
      #
      #   u.email = jid
      #   u.name = user.name
      #   u.user_name = user_name
      #   u.password = user.password
      #
      #   # doc['roster'] = {}
      #   # user.roster.each do |contact|
      #   #   doc['roster'][contact.jid.bare.to_s] = contact.to_h
      #   # end
      #   save(u)
      #
      #
      #
      #
      #
      #
      # end

      def find_vcard(jid)

      end

      def save_vcard(jid, card)

      end

      def find_fragment(jid, node)

      end

      def save_fragment(jid, node)

      end


      def get

      end


      def save(model)
        model.save!
      end

      private

      def fragment_id(jid, node)
        id = Digest::SHA1.hexdigest("#{node.name}:#{node.namespace.href}")
        "#{jid}:#{id}"
      end


      defer :get


      defer :save




      def jid_to_bson_id(jid)
        id = jid.split('@')[0]
        BSON::ObjectId(id) rescue nil
      end

      def connect

        opts = {
            pool_timeout: 5,
            pool_size: @config[:pool] || 5,
            ssl: @config[:tls]
        }



        conn = if @hosts.size == 1
                 Mongo::Connection.new(@hosts.first[0], @hosts.first[1], opts)
               else
                 Mongo::ReplSetConnection.new(*@hosts, opts)
               end

        conn.db(@config[:database]).tap do |db|
          user = @config[:username] || ''
          pass = @config[:password] || ''
          db.authenticate(user, pass) unless user.empty? || pass.empty?
        end
        MongoMapper.connection = conn
        MongoMapper.database = @config[:database]
      end

    end
  end
end
