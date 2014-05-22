require 'spec_helper'

def storage
  Vines::Storage::Mongomapper.new do
    host 'localhost', 27017
    database 'vines_mongo_rails_test'
    username 'test'
    password 'test123'
  end
end

def fibered
  EM.run do
    Fiber.new do
      yield
      EM.stop
    end.resume
  end
end

describe 'User' do


  it 'should save a user' do

    fibered do
      db = storage
      user = Vines::User.new(
          jid: 'saved_user@domain.tld/resource1',
          name: 'Save User',
          user_name:'saved_user',
          password: 'secret')
      user.roster << Vines::Contact.new(
          jid: 'contact1@domain.tld/resource2',
          name: 'Contact 1')

      user.save!
      user = db.find_user('saved_user@domain.tld')
      expect(user.jid.to_s).to eq 'saved_user@domain.tld'
      expect(user.name).to eq('Save User')
      expect(user.user_name).to eq('saved_user')


      # user.roster.length.must_equal 1
      # user.roster[0].jid.to_s.must_equal 'contact1@domain.tld'
      # user.roster[0].name.must_equal 'Contact 1'
    end

  end


  it 'should auth a user' do

    fibered do
      db = storage
      Vines::User.create({jid: 'empty@wonderland.lit',user_name:'empty'})
      Vines::User.create({jid: 'no_password@wonderland.lit',user_name:'no_password', 'foo' => 'bar'})
      Vines::User.create({jid: 'clear_password@wonderland.lit',user_name:'clear_password', password:'secret'})
      Vines::User.create({jid: 'bcrypt_password@wonderland.lit',user_name:'bcrypt_password',name:'a good user', password: BCrypt::Password.create('secret')})

      expect(db.authenticate(nil, nil)).to be_nil
      expect(db.authenticate(nil,'secret' )).to be_nil
      expect(db.authenticate('bogus', nil)).to be_nil
      expect(db.authenticate('bogus', 'secret')).to be_nil
      expect(db.authenticate('empty@wonderland.lit', 'secret')).to be_nil
      expect(db.authenticate('no_password@wonderland.lit', 'secret')).to be_nil
      expect(db.authenticate('clear_password@wonderland.lit', 'secret')).to be_nil

      user = db.authenticate('bcrypt_password@wonderland.lit', 'secret')
      expect(user.name).to eq('a good user')
      expect(user.jid.to_s).to eq 'bcrypt_password@wonderland.lit'

    end
  end
end