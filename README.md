
# Welcome to Vines-Mongompper

Vines is a scalable XMPP chat server, using EventMachine for asynchronous IO.

This gem is inspired by another mongo storage for Vines: [vines-mongodb](https://github.com/negativecode/vines-mongodb.git).

And provides more:

1. Use MongoMapper to model Resources.
2. Use BOSN ObjectID to id a resource instead of using a JID. This makes integration with frameworks like Rails much easier.
3. Test with real Mongodb, instead of Mock, this makes it more flexible to develop and extend


## Assumptions

This storage has few assumptions:

1. User is identified by his BSON id and user name, keyed by _id and user_name respectively.
2. User can use _id@domain and user_name@domain as jid to login.

## Usage

```
$ gem install vines vines-mongomapper
$ vines init wonderland.lit
$ cd wonderland.lit && vines start
```

## Configuration

Add the following configuration block to a virtual host definition in
the server's `conf/config.rb` file.

```ruby
storage 'mongomapper' do
  host 'localhost', 27017
  host 'localhost', 27018 # optional, connects to replica set
  database 'xmpp'
  tls true
  username ''
  password ''
  pool 5
end
```

## Development

```
$ bundle install
$ bundle exec rspec spec
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request


## Contact

* Sawyer ZHANG <sawyerzhangdev@gmeil.com>

## License

Vines is released under the MIT license. Check the LICENSE file for details.


