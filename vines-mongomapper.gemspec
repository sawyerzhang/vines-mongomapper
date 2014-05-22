# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "vines-mongomapper"
  spec.version       = "0.1.1"
  spec.authors       = ["sawyerzhang"]
  spec.email         = ["sawyerzhangdev@gmail.com"]
  spec.summary      = %q[Provides a MongoMapper storage adapter for the Vines XMPP chat server.]
  spec.description  = %q[Stores Vines user data in MongoMapper.]

  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'mongo_mapper'
  spec.add_dependency 'bson_ext'
  spec.add_dependency 'vines', '>= 0.4.5'

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.required_ruby_version = '>= 1.9.3'
end
